' Projek-2 EViews template
' Usage:
' 1) Replace __DATASET__ and __OUTDIR__ paths.
' 2) Run from EViews command window: run "path\to\this_file.prg"

%dataset = "__DATASET__"
%outdir = "__OUTDIR__"

wfload(page=raw) {%dataset}
pagestruct firm_id year
smpl @all

' Interaction terms
series roa_aid = roa*aid
series der_aid = der*aid
series eps_aid = eps*aid
series roa_dgenai = roa*dgenai
series der_dgenai = der*dgenai
series eps_dgenai = eps*dgenai

' Baseline models
equation eq_price_base.ls price c roa roe npm cr der tato eps size growth age vol
equation eq_ret_base.ls ret c roa roe npm cr der tato eps size growth age vol
equation eq_tq_base.ls tq c roa roe npm cr der tato eps size growth age vol

' AID moderation
equation eq_price_aid.ls price c roa der eps aid roa_aid der_aid eps_aid size growth age vol
equation eq_ret_aid.ls ret c roa der eps aid roa_aid der_aid eps_aid size growth age vol
equation eq_tq_aid.ls tq c roa der eps aid roa_aid der_aid eps_aid size growth age vol

' Structural break (post-2023)
equation eq_price_break.ls price c roa der eps dgenai roa_dgenai der_dgenai eps_dgenai size growth age vol
equation eq_ret_break.ls ret c roa der eps dgenai roa_dgenai der_dgenai eps_dgenai size growth age vol
equation eq_tq_break.ls tq c roa der eps dgenai roa_dgenai der_dgenai eps_dgenai size growth age vol

freeze(tab_eq_price_base) eq_price_base.output
tab_eq_price_base.save(t=txt) {%outdir + "\eq_price_base.txt"}

freeze(tab_eq_ret_base) eq_ret_base.output
tab_eq_ret_base.save(t=txt) {%outdir + "\eq_ret_base.txt"}

freeze(tab_eq_tq_base) eq_tq_base.output
tab_eq_tq_base.save(t=txt) {%outdir + "\eq_tq_base.txt"}

freeze(tab_eq_price_aid) eq_price_aid.output
tab_eq_price_aid.save(t=txt) {%outdir + "\eq_price_aid.txt"}

freeze(tab_eq_ret_aid) eq_ret_aid.output
tab_eq_ret_aid.save(t=txt) {%outdir + "\eq_ret_aid.txt"}

freeze(tab_eq_tq_aid) eq_tq_aid.output
tab_eq_tq_aid.save(t=txt) {%outdir + "\eq_tq_aid.txt"}

freeze(tab_eq_price_break) eq_price_break.output
tab_eq_price_break.save(t=txt) {%outdir + "\eq_price_break.txt"}

freeze(tab_eq_ret_break) eq_ret_break.output
tab_eq_ret_break.save(t=txt) {%outdir + "\eq_ret_break.txt"}

freeze(tab_eq_tq_break) eq_tq_break.output
tab_eq_tq_break.save(t=txt) {%outdir + "\eq_tq_break.txt"}
