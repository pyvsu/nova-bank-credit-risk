# Nova Bank Credit Risk Analytics
## Executive Summary
Nova Bank's loan portfolio, 25,000 loans, $232M across the USA, UK, and Canada, carries a 22.9% overall default rate, but risk is far from evenly spread. Three things matter most: **loan grade** is the strongest and most actionable predictor, climbing from 10.37% at Grade A to 97.67% at Grade G, with default becoming the majority outcome the moment a loan crosses into Grade D. The single sharpest risk combination is **renters with a loan-to-income ratio ≥0.40**, who default 100% of the time across 682 loans — a segment current underwriting doesn't isolate. And **geography is not a risk driver**: income, debt burden, and default rates are nearly identical across all three countries (22.6%–23.1%), meaning one underwriting policy can safely apply across every market instead of three separate ones.

<img width="1920" height="1110" alt="created" src="https://github.com/user-attachments/assets/0156a9f3-86c2-4717-b3c8-9022ad0d5de6" />

An overview of the PowerBI dashboard is shown below, with further examples provided in the report. You can download the full interactive dashboard [here](dashboard/Nova_Bank_Credit_Risk_Dashboard.pbix).


## Project Background
Nova Bank is a financial institution serving borrowers across the USA, UK, and Canada, offering personal, medical, education, and business loans to a wide range of customers.

Balancing risk and accessibility are central to how the bank operates — approve too many risky loans and profits erode, get too conservative and good customers walk away. Nova Bank has a dataset of loan records covering borrower profiles, financial ratios, and repayment history that hasn't been fully explored. This project digs into that data to uncover what actually drives default risk, with the goal of helping Nova Bank lend smarter — protecting the bottom line without shutting out borrowers who deserve a chance.

**Primary Audience:** Underwriting and lending policy teams — the people who set approval criteria and risk thresholds and would act directly on these findings. Risk committee/leadership is a secondary audience, reviewing portfolio-level risk from the Executive Summary.

**Business Questions This Dashboard Answers:**

- Which types of borrowers are more likely to default?
- Do certain loan purposes (education, medical, personal, debt consolidation) carry more risk?
- How do loan-to-income and debt-to-income ratios relate to repayment?
- Does employment type or home ownership make a difference?
- How do past defaults or longer credit histories affect loan outcomes?
- Are there clear differences between borrowers in the USA, UK, and Canada?
- Which loan grades or terms seem safer, and which are riskier?
- Can groups of borrowers be identified that look "safe" versus "risky"?

Insights and recommendations are provided on the following key areas:

- **Executive Overview** — portfolio-level snapshot (loan grade, geography, purpose, home ownership)
- **Who Defaults** — borrower attributes (home ownership, employment, credit history, education)
- **Why They Default** — DTI/LTI, loan term, grade × intent, LTI-segmented home ownership
- **Borrower Detail** — the drill-through page findings

The SQL script used to clean and prepare the data for this analysis can be found [here](sql/03_clean_and_create_view.sql).

The Power BI dashboard used to explore borrower risk and default trends can be found [here](dashboard/Nova_Bank_Credit_Risk_Dashboard.pbix).

## Data Structure & Initial Checks
Nova Bank's data originated as a single flat file of 32,581 records, which was cleaned and modeled into a star schema consisting of four tables: Fact_CreditRisk, Dim_Borrower, Dim_Geography, and Dim_Loan_Type, with a total row count of 24,738 records after cleaning.

<img width="2280" height="3270" alt="1" src="https://github.com/user-attachments/assets/155011e5-0bf6-47a9-be31-799e3ba6dc34" />

Prior to modeling, a variety of checks were conducted for quality control and familiarization with the dataset. The SQL script used to inspect data can be found in [here](sql/02_inspection.sql).

## Insights Deep Dive
### Executive

- **Loan grade is the strongest, most reliable predictor of default.** Default rate climbs steadily from 10.37% at Grade A to 97.67% at Grade G, with a sharp jump at Grade D (62.36%, vs. 21.12% at Grade C). Below Grade D, most loans get repaid; at D and above, most don't. Grade G runs at ~4.3× the 22.9% portfolio benchmark. Since the bank already grades every loan, it can act immediately with stricter rules at Grade D and up.
- **Loan purpose adds a second risk layer on top of the overall rate.** Rates range from 28.74% (Debt Consolidation) to 16.45% (Venture), splitting into a high-risk group (Debt Consolidation, Home Improvement, Medical — above the 22.9% benchmark) and a low-risk group (Personal, Education, Venture — at or below it). But within the safest grades (A–C), Home Improvement — not Debt Consolidation — is the riskiest purpose, showing purpose interacts with grade rather than ranking independently.
- **Default risk is U-shaped by age, not linear.** Both the youngest (18–25: 25.18%) and oldest (51–80: 26.07%) borrowers default more than those in prime earning years (26–35: 21.48%, 36–50: 20.47%). A simple "young = risky" or "old = safe" rule would fail at either end.
- **Geography is a non-factor.** Default rate, average income, and average debt burden are nearly identical across Canada (23.07%), USA (22.88%), and UK (22.74%) — a spread of just 0.33 percentage points, with income (~65K) and debt burden (~21K) also flat across all three. One underwriting policy can apply across all three markets without adjustment.

### Who Defaults
- **Prior default and home ownership are the strongest individual risk signals.** Prior defaulters default again at 39.08% (1.7× the 22.9% benchmark). Home ownership splits even sharper: renters default at 31.76% vs. 8.66% for owners — homeowners already passed a financial vetting step (mortgage qualification) that filters out risk. Both are simple, reliable, and worth heavy weight in approval decisions.
- **Job stability reduces risk overall, but not universally.** Default rate falls steadily with tenure, from 27.40% (0–2 yrs) to 15.20% (10+ yrs) — a smooth decline, unlike loan grade's sharper cliffs.
- **Tenure's protection breaks down for Debt Consolidation and Medical loans.** Debt Consolidation stays above benchmark even at 10+ yrs (24.73%). Medical is the only purpose that reverses course — dipping to 22.68% at 6–9 yrs, then rising to 25.78% at 10+ yrs. The matrix's single highest cell is Home Improvement at 0–2 yrs (38.02%), likely new employees hit with large, urgent expenses. A stable job doesn't erase existing debt or prevent a medical emergency.
- **Credit history length is U-shaped, not linear.** Both short (2–4 yrs: 24.69%) and long (18+ yrs: 26.07%, n=280) histories carry more risk than the middle (5–9 yrs: 21.47%; 10–17 yrs: 20.59%) — mirroring the same pattern seen in age.
- **Employment type and education level are not meaningful risk factors.** Default rates are nearly flat across employment types (22.63%–23.57%) and education levels (21.94%–23.60%), both hovering near the 22.9% benchmark — a genuine null finding, like geography on Executive page.

## Why They Default
- **Renters who become over-leveraged default at a near-certain rate.** High-LTI (≥0.40) renters default at 100% — 682 loans, the most reliable, highest-severity finding on the dashboard. High-LTI mortgage holders (29.78%) and homeowners (28.10%) also default more than low-LTI peers, but far from certainty, since home equity gives them a cushion renters lack. (OTHER + High LTI also hits 100%, but only 5 loans — too small to count.)
- **DTI is a real but supporting risk signal, not a standalone replacement for grade.** High-DTI borrowers default at 40.77% — 1.8× the 22.9% benchmark. Plotting each grade's average DTI against its default rate shows a clear upward trend (Grade A ~10% at DTI ~0.30, up to Grade G ~98% at DTI ~0.42), with a small reversal between Grades B and C.
- **Loan purpose's riskiness depends on loan grade — in Executive page's ranking doesn't hold within safer grades.** Executive page ranked Debt Consolidation riskiest overall (28.74%), but within Grades A–C, Home Improvement is riskier at every level (e.g., Grade C: 25.72% vs. 23.80%). This flips at Grade D+, where Debt Consolidation and Medical dominate, both hitting 100% by Grade E.
- **Interest rate strongly tracks default, largely as a proxy for grade and DTI.** Default rate climbs from 10.00% (Low, <8%) to 60.58% (High, >15%), with a steep jump between Medium and High. Since the bank already prices risk into the rate, this reads as a downstream signal of grade/DTI rather than an independent driver.
- **Loan size is an independent risk driver, confirmed even after controlling for purpose.** Large loans (>$15K) default more than Small/Medium loans within nearly every purpose, ruling out "size as a proxy for risky purpose." Exception: Home Improvement, where Small loans (36.73%) are riskiest — likely unplanned repairs vs. deliberate renovations. Mechanism: average LTI rises with size — Small (0.09), Medium (0.18), Large (0.26) — so bigger loans strain income more.
- **Loan term shows no meaningful risk pattern.** Default rate is nearly flat across all four terms (20.80%–23.54%), with no clean pattern — shortest isn't safest, longest isn't riskiest.
- **Open account count and past delinquency count show no meaningful relationship with default risk.** Default rate stays within ~1.5 percentage points of the 22.9% benchmark across every bucket of both variables — no trend, no threshold effect. Contrasts sharply with grade and DTI, which show strong, defensible separation.


## Recommendations
- **Make Grade D the hard line for standard approval.** Default jumps to majority at Grade D (62.36%), not a gradual slide — Grade C is only 21.12%. Standard approval should apply to Grades A–C, while D–G require collateral, a co-signer, or manual review instead of approval on the same terms. This turns a strong signal into an actual approval gate, not just a pricing input.
- **Cap loan-to-income ratio specifically for renters.** Renters with LTI ≥ 0.40 default at 100% (n=682) — the strongest finding in the analysis. Mortgage holders and owners at the same LTI default far less (29.78% and 28.10%), since home equity gives them a cushion renters lack. A hard LTI ceiling for renters (e.g., decline or manual review above 0.35–0.40) makes sense, paired with a more lenient threshold for homeowners, since a flat LTI rule for everyone misses this split.
- **Weight prior default and home ownership as core scoring inputs.** Both are cheap to check and highly predictive — prior default (39.08%), renting vs. owning (31.76% vs. 8.66%). They should be first-class inputs in the scoring model rather than secondary flags, with renters who have a prior default requiring a co-signer or larger down payment.
- **Re-price Home Improvement loans within Grades A–C.** Debt Consolidation looks riskiest overall (28.74%), but within safer grades (A–C), Home Improvement is actually riskier at every level (e.g., Grade C: 25.72% vs. 23.80%) — grade and purpose interact. Purpose-specific rate adjustments within each grade tier would capture this, rather than one flat purpose-level pricing table.
- **Size loans against income, not term length.** Loan term shows almost no default separation (20.80%–23.54%) — it's not a real risk driver. Loan size is: loans >$15K default more in nearly every purpose, as average LTI climbs with size (0.09 → 0.18 → 0.26). Term-based restrictions should be dropped in favor of capping approved loan size against income (an LTI-based sizing rule), especially for Debt Consolidation, Education, Medical, Personal, and Venture loans.
- **Don't treat job tenure as a safety net for Debt Consolidation or Medical loans.** Longer tenure lowers risk almost everywhere (27.40% → 15.20%), except these two purposes, which stay elevated regardless of tenure — Debt Consolidation never drops below benchmark even at 10+ years. Tenure should be excluded as a mitigating factor for these two purposes specifically, underwriting them on DTI/LTI instead.
- **Keep underwriting policy uniform across country, employment type, and education level.** All three are non-factors — default rates stay flat within roughly 1–2 percentage points (geography: 22.74%–23.07%; employment type: 22.63%–23.57%; education: 21.94%–23.60%). Country- or demographic-specific pricing or approval rules aren't warranted here, which also supports the fair-lending side of the brief: since these attributes carry no real predictive signal, using them as underwriting factors would only introduce disparate impact risk without improving accuracy.
- **Build a composite early-warning score from the four verified thresholds.** Four independently confirmed signals are already captured in the data — DTI ≥ 0.40 (40.77%), prior default on file (39.08%), interest rate > 15% (60.58%), and renter with LTI ≥ 0.40 (100%, n=682). Combining them into a single risk-monitoring score for the existing portfolio would flag accounts for proactive outreach or collections review before default, not just at origination.

## Assumptions and Caveats
### Data Cleaning Decisions

- Missing interest rates (9.5%): imputed with the average rate *per loan grade*, not the dataset-wide average — avoids underpricing Grade G risk or over-penalizing Grade A.
- Missing employment length (2.7%): imputed with 0 — conservative default for a risk dashboard.
- Borrowers over age 80: excluded (max value was 144; clearly bad data, and outside standard lending age criteria).
- Employment length exceeding a plausible working life (> age − 18, or > 60 years): excluded as impossible.
- `cb_person_default_on_file`: converted from Y/N text to TRUE/FALSE for reliable DAX logic.

### Modeling Assumptions

- Single-direction cross-filtering (dimension → fact) — standard star schema practice, avoids ambiguous filter propagation.
- `Dim_Geography` and `Dim_Loan_Type` use surrogate keys (index columns) since the source data had no natural unique ID for location or loan-type combinations.

### Analytical Assumptions

- No documented default-rate target existed in the brief, so the portfolio's own average (22.9%) was used as the benchmark for every segment comparison, instead of an arbitrary fixed threshold.
- Credit history buckets (2–4, 5–9, 10–17, 18+ yrs) aren't arbitrary — they came from actually checking the data first. The real distribution of credit history values and their default rates was examined, and the buckets were drawn where the data itself showed a genuine shift in risk, not at evenly-spaced cutoffs.

### Sample Size Caveats

- OTHER home ownership (n=84): shown for completeness, excluded from firm conclusions.
- 18+ year credit history bucket (n=280): included but flagged as smaller than the other buckets.
- OTHER × High LTI (n=5): excluded entirely — too small to support any claim.

### Scope Limitations

- Nova Bank is fictional; findings describe this dataset only, not real-world lending behavior.
- Single snapshot of 25,000 loans ($232M) — shows recorded outcomes, not how risk evolves over a loan's life.
- Geography shows no meaningful default differentiation *in this portfolio* — reported as a genuine finding, not a general claim about geography and credit risk.
  
## Tools & Pipeline

- **Neon (Postgres)** — data warehouse
- **Google Colab (Python)** — data ingestion pipeline
- **SQL** — data cleaning and view creation
- **Power Query** — star schema data modeling
- **Power BI (DAX)** — dashboard and measures

Pipeline: raw Excel → Colab (`notebooks/`) → Neon staging table → SQL cleaning (`sql/`) → Power Query (star schema modeling) → Power BI (dashboard/DAX)
