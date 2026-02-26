# R Setup Script for Thesis Analysis
# Installs all required packages for panel data regression analysis

packages <- c(
  "plm",        # Panel data models (FE/RE/GMM)
  "lmtest",     # Diagnostic tests (Breusch-Pagan, etc.)
  "sandwich",   # Robust standard errors (HAC, HC)
  "stargazer",  # Publication-quality regression tables
  "readxl",     # Read Excel files
  "tidyverse",  # Data wrangling + ggplot2
  "car",        # VIF (multicollinearity)
  "tseries",    # Jarque-Bera test
  "foreign",    # Read Stata/SPSS files
  "writexl",    # Write Excel files
  "corrplot",   # Correlation matrix visualization
  "DescTools",  # Winsorize function
  "pdftools",   # PDF text extraction (for AI disclosure index)
  "quantmod",   # Financial data download (Yahoo Finance)
  "broom",      # Tidy regression output
  "knitr",      # Report generation
  "kableExtra"  # Table formatting
)

install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cat(paste0("Installing: ", pkg, "\n"))
    install.packages(pkg, repos = "https://cloud.r-project.org")
  } else {
    cat(paste0("Already installed: ", pkg, "\n"))
  }
}

invisible(sapply(packages, install_if_missing))

cat("\n--- All packages ready ---\n")
cat("Usage:\n")
cat("  library(plm)       # Panel regression\n")
cat("  library(lmtest)    # Diagnostic tests\n")
cat("  library(sandwich)  # Robust SE\n")
cat("  library(stargazer) # Tables\n")
cat("  library(tidyverse) # Data wrangling\n")
