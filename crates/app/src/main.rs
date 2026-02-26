use std::collections::HashMap;
use std::fs;
use std::path::PathBuf;

use chrono::{DateTime, Datelike, Utc};
use clap::{Parser, Subcommand};
use serde::Deserialize;

#[derive(Parser)]
#[command(name = "projek-2", version, about = "Thesis analysis helper")]
struct Cli {
    #[command(subcommand)]
    command: Command,
}

#[derive(Subcommand)]
enum Command {
    /// Print a ready check message.
    Ready,
    /// Fetch SEC company facts and export a minimal CSV.
    SecFetch {
        /// SEC CIK (10 digits, leading zeros).
        #[arg(long)]
        cik: String,
        /// Output CSV path.
        #[arg(long, default_value = "sec_companyfacts.csv")]
        out: PathBuf,
        /// User-Agent string (name + email).
        #[arg(long)]
        user_agent: String,
        /// Optional cache directory to store raw JSON.
        #[arg(long, default_value = "data/sec_cache")]
        cache_dir: PathBuf,
        /// Optional ticker symbol (if provided, overrides cik).
        #[arg(long)]
        ticker: Option<String>,
        /// Optional path to cached SEC company_tickers.json.
        #[arg(long, default_value = "data/sec_cache/company_tickers.json")]
        tickers_path: PathBuf,
        /// Output ratios CSV path.
        #[arg(long, default_value = "sec_ratios.csv")]
        ratios_out: PathBuf,
        /// If set, only include FY values (10-K / 20-F).
        #[arg(long, default_value_t = true)]
        fy_only: bool,
        /// Optional price CSV path (columns: fy,price) for PBV.
        #[arg(long)]
        price_csv: Option<PathBuf>,
        /// Optional price ticker to fetch yearly close prices (Yahoo Finance).
        #[arg(long)]
        price_ticker: Option<String>,
        /// Start year for price fetch.
        #[arg(long, default_value_t = 2019)]
        price_start_year: i32,
        /// End year for price fetch.
        #[arg(long, default_value_t = 2025)]
        price_end_year: i32,
    },
    /// Download SEC company_tickers.json to a cache file.
    SecTickers {
        /// Output JSON path.
        #[arg(long, default_value = "data/sec_cache/company_tickers.json")]
        out: PathBuf,
        /// User-Agent string (name + email).
        #[arg(long)]
        user_agent: String,
    },
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let cli = Cli::parse();
    match cli.command {
        Command::Ready => {
            println!("projek-2 workspace is ready");
        }
        Command::SecFetch {
            cik,
            out,
            user_agent,
            cache_dir,
            ticker,
            tickers_path,
            ratios_out,
            fy_only,
            price_csv,
            price_ticker,
            price_start_year,
            price_end_year,
        } => {
            fs::create_dir_all(&cache_dir)?;
            let cik10 = if let Some(t) = ticker {
                let map = load_or_fetch_tickers(&tickers_path, &user_agent).await?;
                map.get(&t.to_uppercase())
                    .cloned()
                    .ok_or_else(|| anyhow::anyhow!("Ticker not found: {t}"))?
            } else {
                normalize_cik(&cik)?
            };
            let json_path = cache_dir.join(format!("companyfacts_{cik10}.json"));

            let body = if json_path.exists() {
                fs::read_to_string(&json_path)?
            } else {
                let url = format!(
                    "https://data.sec.gov/api/xbrl/companyfacts/CIK{cik10}.json"
                );
                let client = reqwest::Client::builder()
                    .user_agent(user_agent)
                    .build()?;
                let resp = client.get(url).send().await?.error_for_status()?;
                let text = resp.text().await?;
                fs::write(&json_path, &text)?;
                text
            };

            let facts: CompanyFacts = serde_json::from_str(&body)?;
            let rows = extract_minimal_rows(&facts);
            write_csv(&out, &rows)?;
            let price_map = if let Some(path) = price_csv.as_ref() {
                Some(read_price_csv(path)?)
            } else if let Some(ticker) = price_ticker.as_ref() {
                Some(fetch_price_map(
                    ticker,
                    *price_start_year,
                    *price_end_year,
                )
                .await?)
            } else {
                None
            };
            let ratio_rows = compute_ratios(&facts, fy_only, price_map.as_ref());
            write_ratio_csv(&ratios_out, &ratio_rows)?;
            println!(
                "Wrote {} rows to {}",
                rows.len(),
                out.to_string_lossy()
            );
            println!(
                "Wrote {} rows to {}",
                ratio_rows.len(),
                ratios_out.to_string_lossy()
            );
        }
        Command::SecTickers { out, user_agent } => {
            let text = fetch_company_tickers(&user_agent).await?;
            fs::create_dir_all(
                out.parent()
                    .unwrap_or_else(|| std::path::Path::new(".")),
            )?;
            fs::write(&out, text)?;
            println!("Saved company_tickers to {}", out.to_string_lossy());
        }
    }

    Ok(())
}

fn normalize_cik(input: &str) -> anyhow::Result<String> {
    let digits: String = input.chars().filter(|c| c.is_ascii_digit()).collect();
    if digits.is_empty() || digits.len() > 10 {
        anyhow::bail!("Invalid CIK. Provide up to 10 digits.");
    }
    Ok(format!("{:0>10}", digits))
}

async fn fetch_company_tickers(user_agent: &str) -> anyhow::Result<String> {
    let url = "https://data.sec.gov/files/company_tickers.json";
    let client = reqwest::Client::builder()
        .user_agent(user_agent)
        .build()?;
    let resp = client.get(url).send().await?.error_for_status()?;
    Ok(resp.text().await?)
}

async fn load_or_fetch_tickers(
    path: &PathBuf,
    user_agent: &str,
) -> anyhow::Result<HashMap<String, String>> {
    let text = if path.exists() {
        fs::read_to_string(path)?
    } else {
        let txt = fetch_company_tickers(user_agent).await?;
        fs::create_dir_all(
            path.parent()
                .unwrap_or_else(|| std::path::Path::new(".")),
        )?;
        fs::write(path, &txt)?;
        txt
    };
    parse_company_tickers(&text)
}

fn parse_company_tickers(text: &str) -> anyhow::Result<HashMap<String, String>> {
    #[derive(Deserialize)]
    struct TickerItem {
        cik_str: String,
        ticker: String,
    }
    let map: HashMap<String, TickerItem> = serde_json::from_str(text)?;
    let mut out = HashMap::new();
    for (_, item) in map {
        let cik10 = normalize_cik(&item.cik_str)?;
        out.insert(item.ticker.to_uppercase(), cik10);
    }
    Ok(out)
}

#[derive(Debug, Deserialize)]
struct CompanyFacts {
    cik: Option<u64>,
    entityName: Option<String>,
    facts: Facts,
}

#[derive(Debug, Deserialize)]
struct Facts {
    us-gaap: Option<HashMap<String, FactItem>>,
}

#[derive(Debug, Deserialize)]
struct FactItem {
    units: Option<HashMap<String, Vec<UnitValue>>>,
}

#[derive(Debug, Deserialize)]
struct UnitValue {
    val: Option<f64>,
    end: Option<String>,
    fy: Option<i32>,
    fp: Option<String>,
    form: Option<String>,
    filed: Option<String>,
}

#[derive(Debug)]
struct CsvRow {
    cik: String,
    entity_name: String,
    fact: String,
    unit: String,
    value: f64,
    fy: Option<i32>,
    fp: Option<String>,
    end: Option<String>,
    form: Option<String>,
    filed: Option<String>,
    fetched_at: DateTime<Utc>,
}

fn extract_minimal_rows(facts: &CompanyFacts) -> Vec<CsvRow> {
    let mut rows = Vec::new();
    let cik = facts
        .cik
        .map(|v| format!("{:0>10}", v))
        .unwrap_or_else(|| "0000000000".to_string());
    let entity = facts
        .entityName
        .clone()
        .unwrap_or_else(|| "UNKNOWN".to_string());
    let fetched_at = Utc::now();

    let Some(usgaap) = facts.facts.us-gaap.as_ref() else {
        return rows;
    };

    let whitelist = [
        "Assets",
        "Liabilities",
        "NetIncomeLoss",
        "Revenues",
        "RevenueFromContractWithCustomerExcludingAssessedTax",
        "SharesOutstanding",
    ];

    for fact_name in whitelist.iter() {
        let Some(item) = usgaap.get(*fact_name) else {
            continue;
        };
        let Some(units) = &item.units else {
            continue;
        };
        for (unit, values) in units.iter() {
            for v in values {
                let Some(val) = v.val else {
                    continue;
                };
                rows.push(CsvRow {
                    cik: cik.clone(),
                    entity_name: entity.clone(),
                    fact: fact_name.to_string(),
                    unit: unit.to_string(),
                    value: val,
                    fy: v.fy,
                    fp: v.fp.clone(),
                    end: v.end.clone(),
                    form: v.form.clone(),
                    filed: v.filed.clone(),
                    fetched_at,
                });
            }
        }
    }

    rows
}

#[derive(Debug)]
struct RatioRow {
    cik: String,
    entity_name: String,
    fy: i32,
    assets: Option<f64>,
    liabilities: Option<f64>,
    net_income: Option<f64>,
    revenue: Option<f64>,
    shares_outstanding: Option<f64>,
    roa: Option<f64>,
    roe: Option<f64>,
    der: Option<f64>,
    net_margin: Option<f64>,
    eps: Option<f64>,
    price: Option<f64>,
    book_value_per_share: Option<f64>,
    pbv: Option<f64>,
    fetched_at: DateTime<Utc>,
}

fn compute_ratios(
    facts: &CompanyFacts,
    fy_only: bool,
    price_map: Option<&HashMap<i32, f64>>,
) -> Vec<RatioRow> {
    let cik = facts
        .cik
        .map(|v| format!("{:0>10}", v))
        .unwrap_or_else(|| "0000000000".to_string());
    let entity = facts
        .entityName
        .clone()
        .unwrap_or_else(|| "UNKNOWN".to_string());
    let fetched_at = Utc::now();

    let mut by_fy: HashMap<i32, RatioRow> = HashMap::new();
    let Some(usgaap) = facts.facts.us-gaap.as_ref() else {
        return Vec::new();
    };

    let series = [
        ("Assets", |r: &mut RatioRow, v| r.assets = Some(v)),
        ("Liabilities", |r: &mut RatioRow, v| r.liabilities = Some(v)),
        ("NetIncomeLoss", |r: &mut RatioRow, v| r.net_income = Some(v)),
        (
            "Revenues",
            |r: &mut RatioRow, v| r.revenue = Some(v),
        ),
        (
            "RevenueFromContractWithCustomerExcludingAssessedTax",
            |r: &mut RatioRow, v| r.revenue = Some(v),
        ),
        (
            "SharesOutstanding",
            |r: &mut RatioRow, v| r.shares_outstanding = Some(v),
        ),
        (
            "WeightedAverageNumberOfDilutedSharesOutstanding",
            |r: &mut RatioRow, v| r.shares_outstanding = Some(v),
        ),
    ];

    for (fact_name, setter) in series.iter() {
        let Some(item) = usgaap.get(*fact_name) else {
            continue;
        };
        let Some(units) = &item.units else {
            continue;
        };
        for values in units.values() {
            for v in values {
                let Some(val) = v.val else {
                    continue;
                };
                let Some(fy) = v.fy else {
                    continue;
                };
                if fy_only {
                    if v.fp.as_deref() != Some("FY") {
                        continue;
                    }
                    if let Some(form) = v.form.as_deref() {
                        if form != "10-K" && form != "20-F" {
                            continue;
                        }
                    }
                }
                let row = by_fy.entry(fy).or_insert_with(|| RatioRow {
                    cik: cik.clone(),
                    entity_name: entity.clone(),
                    fy,
                    assets: None,
                    liabilities: None,
                    net_income: None,
                    revenue: None,
                    shares_outstanding: None,
                    roa: None,
                    roe: None,
                    der: None,
                    net_margin: None,
                    eps: None,
                    price: None,
                    book_value_per_share: None,
                    pbv: None,
                    fetched_at,
                });
                setter(row, val);
            }
        }
    }

    for row in by_fy.values_mut() {
        row.roa = match (row.net_income, row.assets) {
            (Some(ni), Some(a)) if a != 0.0 => Some(ni / a),
            _ => None,
        };
        row.roe = match (row.net_income, row.assets, row.liabilities) {
            (Some(ni), Some(a), Some(l)) if (a - l) != 0.0 => Some(ni / (a - l)),
            _ => None,
        };
        row.der = match (row.liabilities, row.assets) {
            (Some(l), Some(a)) if (a - l) != 0.0 => Some(l / (a - l)),
            _ => None,
        };
        row.net_margin = match (row.net_income, row.revenue) {
            (Some(ni), Some(r)) if r != 0.0 => Some(ni / r),
            _ => None,
        };
        row.eps = match (row.net_income, row.shares_outstanding) {
            (Some(ni), Some(s)) if s != 0.0 => Some(ni / s),
            _ => None,
        };
        row.book_value_per_share = match (row.assets, row.liabilities, row.shares_outstanding) {
            (Some(a), Some(l), Some(s)) if s != 0.0 => Some((a - l) / s),
            _ => None,
        };
        if let Some(map) = price_map {
            row.price = map.get(&row.fy).copied();
        }
        row.pbv = match (row.price, row.book_value_per_share) {
            (Some(p), Some(bvps)) if bvps != 0.0 => Some(p / bvps),
            _ => None,
        };
    }

    let mut rows: Vec<RatioRow> = by_fy.into_values().collect();
    rows.sort_by_key(|r| r.fy);
    rows
}

fn write_csv(path: &PathBuf, rows: &[CsvRow]) -> anyhow::Result<()> {
    let mut wtr = csv::Writer::from_path(path)?;
    wtr.write_record([
        "cik",
        "entity_name",
        "fact",
        "unit",
        "value",
        "fy",
        "fp",
        "end",
        "form",
        "filed",
        "fetched_at",
    ])?;
    for r in rows {
        wtr.write_record([
            r.cik.as_str(),
            r.entity_name.as_str(),
            r.fact.as_str(),
            r.unit.as_str(),
            &r.value.to_string(),
            &r.fy.map(|v| v.to_string()).unwrap_or_default(),
            r.fp.as_deref().unwrap_or(""),
            r.end.as_deref().unwrap_or(""),
            r.form.as_deref().unwrap_or(""),
            r.filed.as_deref().unwrap_or(""),
            &r.fetched_at.to_rfc3339(),
        ])?;
    }
    wtr.flush()?;
    Ok(())
}

fn write_ratio_csv(path: &PathBuf, rows: &[RatioRow]) -> anyhow::Result<()> {
    let mut wtr = csv::Writer::from_path(path)?;
    wtr.write_record([
        "cik",
        "entity_name",
        "fy",
        "assets",
        "liabilities",
        "net_income",
        "revenue",
        "shares_outstanding",
        "roa",
        "roe",
        "der",
        "net_margin",
        "eps",
        "price",
        "book_value_per_share",
        "pbv",
        "fetched_at",
    ])?;
    for r in rows {
        wtr.write_record([
            r.cik.as_str(),
            r.entity_name.as_str(),
            &r.fy.to_string(),
            &opt_to_string(r.assets),
            &opt_to_string(r.liabilities),
            &opt_to_string(r.net_income),
            &opt_to_string(r.revenue),
            &opt_to_string(r.shares_outstanding),
            &opt_to_string(r.roa),
            &opt_to_string(r.roe),
            &opt_to_string(r.der),
            &opt_to_string(r.net_margin),
            &opt_to_string(r.eps),
            &opt_to_string(r.price),
            &opt_to_string(r.book_value_per_share),
            &opt_to_string(r.pbv),
            &r.fetched_at.to_rfc3339(),
        ])?;
    }
    wtr.flush()?;
    Ok(())
}

fn opt_to_string(v: Option<f64>) -> String {
    v.map(|x| x.to_string()).unwrap_or_default()
}

#[derive(Deserialize)]
struct PriceRow {
    fy: i32,
    price: f64,
}

fn read_price_csv(path: &PathBuf) -> anyhow::Result<HashMap<i32, f64>> {
    let mut rdr = csv::Reader::from_path(path)?;
    let mut map = HashMap::new();
    for result in rdr.deserialize::<PriceRow>() {
        let row = result?;
        map.insert(row.fy, row.price);
    }
    Ok(map)
}

async fn fetch_price_map(
    ticker: &str,
    start_year: i32,
    end_year: i32,
) -> anyhow::Result<HashMap<i32, f64>> {
    let start = chrono::Utc
        .with_ymd_and_hms(start_year, 1, 1, 0, 0, 0)
        .single()
        .ok_or_else(|| anyhow::anyhow!("Invalid start year"))?;
    let end = chrono::Utc
        .with_ymd_and_hms(end_year, 12, 31, 23, 59, 59)
        .single()
        .ok_or_else(|| anyhow::anyhow!("Invalid end year"))?;

    let period1 = start.timestamp();
    let period2 = end.timestamp();
    let url = format!("https://query1.finance.yahoo.com/v7/finance/download/{ticker}?period1={period1}&period2={period2}&interval=1d&events=history&includeAdjustedClose=true");

    let client = reqwest::Client::builder().build()?;
    let resp = client.get(url).send().await?.error_for_status()?;
    let text = resp.text().await?;

    let mut rdr = csv::Reader::from_reader(text.as_bytes());
    let mut rows: Vec<(chrono::NaiveDate, f64)> = Vec::new();
    #[derive(Deserialize)]
    struct YahooRow {
        #[serde(rename = "Date")]
        date: String,
        #[serde(rename = "Close")]
        close: String,
    }
    for result in rdr.deserialize::<YahooRow>() {
        let r = result?;
        if r.close == "null" {
            continue;
        }
        let date = chrono::NaiveDate::parse_from_str(&r.date, "%Y-%m-%d")?;
        let close: f64 = r.close.parse()?;
        rows.push((date, close));
    }

    let mut by_year: HashMap<i32, (chrono::NaiveDate, f64)> = HashMap::new();
    for (date, close) in rows {
        let y = date.year();
        if y < start_year || y > end_year {
            continue;
        }
        let entry = by_year.entry(y).or_insert((date, close));
        if date > entry.0 {
            *entry = (date, close);
        }
    }

    let mut out = HashMap::new();
    for (y, (_, close)) in by_year {
        out.insert(y, close);
    }
    Ok(out)
}
