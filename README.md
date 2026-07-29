# Nova Bank Credit Risk Analytics
## Executive Summary
Nova Bank's loan portfolio, 25,000 loans, $232M across the USA, UK, and Canada, carries a 22.9% overall default rate, but risk is far from evenly spread. Three things matter most: **loan grade** is the strongest and most actionable predictor, climbing from 10.37% at Grade A to 97.67% at Grade G, with default becoming the majority outcome the moment a loan crosses into Grade D. The single sharpest risk combination is **renters with a loan-to-income ratio ≥0.40**, who default 100% of the time across 682 loans — a segment current underwriting doesn't isolate. And **geography is not a risk driver**: income, debt burden, and default rates are nearly identical across all three countries (22.6%–23.1%), meaning one underwriting policy can safely apply across every market instead of three separate ones.

<img width="1920" height="1110" alt="created" src="https://github.com/user-attachments/assets/0156a9f3-86c2-4717-b3c8-9022ad0d5de6" />

An overview of the PowerBI dashboard is shown below, with further examples provided in the report. You can explore the full interactive dashboard [here](https://app.powerbi.com/view?r=eyJrIjoiZmEzOTliYWMtNmMzZS00YTAzLTlkNWQtOTFlZGM5YjI2ODNiIiwidCI6IjRkYTk4NTcxLWRjZWEtNDgzOS04ZmIxLTBiZGQ1ZGM5NjlmOSIsImMiOjEwfQ%3D%3D).

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

The Power BI dashboard (.pbix) used to explore borrower risk and default trends can be found [here](dashboard/Nova_Bank_Credit_Risk_Dashboard.pbix).

## Insights Deep Dive

### Executive

Grade is the strongest, most reliable predictor of default. Default rate climbs steadily from 10.37% at Grade A to 97.67% at Grade G, but the real break isn't gradual — it's a cliff at Grade D (62.36% vs. 21.12% at Grade C). Below D, most loans get repaid; at D and above, most don't, and since the bank already grades every loan, this is a rule it can enforce immediately.

Loan purpose adds a second layer on top of grade. Overall, purposes split into a high-risk group (Debt Consolidation, Home Improvement, Medical) and a low-risk group (Personal, Education, Venture), with rates ranging from 28.74% down to 16.45%. But that overall ranking doesn't hold within the safer grades: within A–C, Home Improvement — not Debt Consolidation — is the riskiest purpose, meaning purpose interacts with grade rather than ranking independently of it.

Age shows the same kind of interaction. Risk is U-shaped, not linear — both the youngest borrowers (18–25: 25.18%) and the oldest (51–80: 26.07%) default more than those in prime earning years, so a flat "young = risky" or "old = safe" rule would fail at either end.

Geography, by contrast, holds no signal at all. Default rate, income, and debt burden are nearly identical across Canada, USA, and UK, a spread of just 0.33 percentage points, meaning one underwriting policy can apply across all three markets without adjustment.

### Who Defaults

Prior default and home ownership are the strongest individual risk signals. Prior defaulters default again at 39.08% — 1.7× the portfolio average — and the split by ownership is even sharper: renters default at 31.76% vs. 8.66% for owners, because homeowners already passed a financial vetting step (mortgage qualification) that filters out risk before the bank even sees them.

Job tenure behaves similarly, but only up to a point. Default falls steadily from 27.40% at 0–2 years to 15.20% at 10+ years — until it doesn't: tenure's protection breaks down for Debt Consolidation, which stays above benchmark even at 10+ years, and for Medical, the only purpose that reverses course and rises again late in tenure. A stable job doesn't erase existing debt or prevent a medical emergency, and the matrix's single highest cell — Home Improvement at 0–2 years (38.02%) — looks like new employees hit with large, urgent expenses before they've built a cushion.

Credit history length shows the same U-shape seen in age: both short (2–4 yrs) and long (18+ yrs) histories carry more risk than the middle, so length alone isn't a clean signal either. Employment type and education level, meanwhile, turn out not to matter at all — both stay flat near the portfolio average across every category, a genuine null finding on par with geography.

### Why They Default

The sharpest finding on the dashboard sits at the intersection of two variables that looked moderate on their own: renters who become over-leveraged. High-LTI (≥0.40) renters default at 100% — 682 loans, a near-certainty — while high-LTI mortgage holders and homeowners default more too (29.78% and 28.10%), but nowhere near as absolutely, because home equity gives them a cushion renters lack.

DTI on its own is a real signal, just not a replacement for grade — high-DTI borrowers default at 40.77%, and plotting each grade's average DTI against its default rate shows a clean upward trend from Grade A to Grade G. Loan purpose confirms what the Executive page hinted at: the overall ranking (Debt Consolidation riskiest) doesn't hold within safer grades, where Home Improvement is riskier at every level through Grade C, before Debt Consolidation and Medical take over and dominate at Grade D and beyond.

Interest rate tracks default closely as well, climbing from 10.00% to 60.58% — but this isn't a new, independent signal. Since the bank already prices risk into the rate, it's really grade and DTI showing up again in a different form. Loan size is the opposite case: it holds up as an independent driver even after controlling for purpose, because average LTI climbs with size (0.09 → 0.18 → 0.26), so bigger loans genuinely strain income more, not just correlate with riskier purposes.

Two variables show nothing: loan term stays flat across all four options, and so do open account count and past delinquency count. Both sit within 1.5 percentage points of the portfolio average no matter how you slice them — a sharp contrast to the strong, defensible separation grade and DTI both show.

## Recommendations

These findings point to one clear starting move: **make Grade D the hard line for standard approval.** The jump to majority-default at Grade D isn't a gradual slide from Grade C — it's a cliff, and the bank can turn that into an actual approval gate rather than just a pricing input.

The renter-LTI finding demands its own rule: **cap loan-to-income ratio specifically for renters**, since a flat LTI threshold for everyone would miss the fact that renters at high LTI default with near-certainty while equivalent homeowners don't. Alongside that, **prior default and home ownership should become core scoring inputs**, not secondary flags — both are cheap to check and highly predictive on their own.

The grade-purpose interaction seen twice now (Executive and Why They Default) means purpose-level pricing can't stay flat either: **Home Improvement loans need re-pricing within Grades A–C specifically**, where it's the actual riskiest purpose despite Debt Consolidation's higher overall number. And since loan term showed no real signal while loan size did, **sizing should be capped against income, not term length** — dropping a rule that doesn't work in favor of one that does.

Tenure's blind spots also need a policy fix: **don't treat job tenure as a safety net for Debt Consolidation or Medical loans**, since both stay elevated regardless of how long someone's been employed. And everything that came back flat — country, employment type, education level — should stay flat in policy too: **keep underwriting uniform across these three**, since using non-predictive attributes would only add fair-lending risk without improving accuracy.

Finally, the four strongest thresholds surfaced across this analysis — DTI ≥ 0.40, prior default on file, interest rate > 15%, and renter with LTI ≥ 0.40 — don't have to live only at origination. **Combined into a single early-warning score**, they could flag existing accounts for proactive outreach before default happens, not just filter new applications.

## Methodology
### Data Structure & Initial Checks
Nova Bank's data originated as a single flat file of 32,581 records, which was cleaned and modeled into a star schema consisting of four tables: Fact_CreditRisk, Dim_Borrower, Dim_Geography, and Dim_Loan_Type, with a total row count of 24,738 records after cleaning.

<img width="2280" height="3270" alt="1" src="https://github.com/user-attachments/assets/155011e5-0bf6-47a9-be31-799e3ba6dc34" />

Prior to modeling, a variety of checks were conducted for quality control and familiarization with the dataset. The SQL script used to inspect data can be found in [here](sql/02_inspection.sql).

### Measures Matrix
### Measures Matrix

**Base Measures**

| Measure | Description | DAX |
|---|---|---|
| Total Loans | Core count of all loan records in the portfolio | `COUNTROWS('Fact_CreditRisk')` |
| Total Defaults | Count of loans that ended in default | `CALCULATE([Total Loans], 'Fact_CreditRisk'[loan_status] = 1)` |
| Total Loan Amount | Sum of all loan principal issued | `SUM('Fact_CreditRisk'[loan_amount])` |
| Average Income | Average reported borrower income | `AVERAGE('Dim_Borrower'[person_income])` |
| borrower count | Distinct count of borrowers in the portfolio | `COUNT('Dim_Borrower'[client_ID])` |

**Analytical Measures (Ratios)**

| Measure | Description | DAX |
|---|---|---|
| Default Rate | The core risk metric — share of loans that defaulted | `VAR _Defaults = [Total Defaults]`<br>`VAR _Total = [Total Loans]`<br>`RETURN DIVIDE(_Defaults, _Total, 0)` |
| Average DTI | Average debt-to-income ratio across loans | `AVERAGE('Fact_CreditRisk'[debt_to_income_ratio])` |
| Average LTI | Average loan-to-income ratio across loans | `AVERAGE('Fact_CreditRisk'[loan_to_income_ratio])` |
| Total Debt Burden | Combined loan amount plus other outstanding debt | `SUMX('Fact_CreditRisk', 'Fact_CreditRisk'[loan_amount] + 'Fact_CreditRisk'[other_debt])` |
| Average Debt Burden | Average per-loan debt burden (loan + other debt) | `AVERAGEX('Fact_CreditRisk', 'Fact_CreditRisk'[loan_amount] + 'Fact_CreditRisk'[other_debt])` |
| Average Credit History | Average length of borrower credit history, in years | `AVERAGE('Dim_Borrower'[cb_person_cred_hist_length])` |
| Average Interest Rate | Average interest rate across loans | `AVERAGE('Fact_CreditRisk'[loan_int_rate])` |

**Contextual Filters (Targeted Business Questions)**

| Measure | Description | DAX |
|---|---|---|
| Default Rate (Prior Default) | Default rate isolated to borrowers with a prior default on file | `DIVIDE(COUNTROWS(FILTER('Fact_CreditRisk', RELATED('Dim_Borrower'[cb_person_default_on_file]) = TRUE() && 'Fact_CreditRisk'[loan_status] = 1)), COUNTROWS(FILTER('Fact_CreditRisk', RELATED('Dim_Borrower'[cb_person_default_on_file]) = TRUE())))` |
| Default Rate (High DTI) | Default rate isolated to loans with DTI above 40% | `CALCULATE([Default Rate], 'Fact_CreditRisk'[debt_to_income_ratio] > 0.40)` |

**Advanced Segments (Safe vs. Risky Profiles)**

| Measure | Description | DAX |
|---|---|---|
| Default Rate (High Risk Profile) | Default rate for borrowers with both a prior default and DTI above 40% | `CALCULATE([Default Rate], 'Dim_Borrower'[cb_person_default_on_file] = TRUE(), 'Fact_CreditRisk'[debt_to_income_ratio] > 0.40)` |
| Total Loans (Safe Profile) | Count of loans to the "ideal" borrower: homeowner/mortgage-holder with Grade A | `CALCULATE([Total Loans], 'Dim_Borrower'[person_home_ownership] = "MORTGAGE" \|\| 'Dim_Borrower'[person_home_ownership] = "OWN", 'Dim_Loan_Type'[loan_grade] = "A")` |

**Portfolio Benchmarks (Unfiltered Overall Values)**

| Measure | Description | DAX |
|---|---|---|
| Overall Default Rate | Portfolio-wide default rate, ignoring any active slicers — used as the benchmark line | `CALCULATE([Default Rate], REMOVEFILTERS())` |
| Overall Total Loans | Portfolio-wide loan count, ignoring active slicers | `CALCULATE([Total Loans], REMOVEFILTERS())` |
| Overall Total Loan Amount | Portfolio-wide loan volume, ignoring active slicers | `CALCULATE([Total Loan Amount], REMOVEFILTERS())` |
| Overall Total Defaults | Portfolio-wide default count, ignoring active slicers | `CALCULATE([Total Defaults], REMOVEFILTERS())` |
| Overall Default Rate (High Risk Profile) | Portfolio-wide High Risk Profile default rate, ignoring active slicers | `CALCULATE([Default Rate (High Risk Profile)], REMOVEFILTERS())` |

### Assumptions and Caveats
#### Data Cleaning Decisions

- Missing interest rates (9.5%): imputed with the average rate *per loan grade*, not the dataset-wide average — avoids underpricing Grade G risk or over-penalizing Grade A.
- Missing employment length (2.7%): imputed with 0 — conservative default for a risk dashboard.
- Borrowers over age 80: excluded (max value was 144; clearly bad data, and outside standard lending age criteria).
- Employment length exceeding a plausible working life (> age − 18, or > 60 years): excluded as impossible.
- `cb_person_default_on_file`: converted from Y/N text to TRUE/FALSE for reliable DAX logic.

#### Modeling Assumptions

- Single-direction cross-filtering (dimension → fact) — standard star schema practice, avoids ambiguous filter propagation.
- `Dim_Geography` and `Dim_Loan_Type` use surrogate keys (index columns) since the source data had no natural unique ID for location or loan-type combinations.

#### Analytical Assumptions

- No documented default-rate target existed in the brief, so the portfolio's own average (22.9%) was used as the benchmark for every segment comparison, instead of an arbitrary fixed threshold.
- Credit history buckets (2–4, 5–9, 10–17, 18+ yrs) aren't arbitrary — they came from actually checking the data first. The real distribution of credit history values and their default rates was examined, and the buckets were drawn where the data itself showed a genuine shift in risk, not at evenly-spaced cutoffs.

#### Sample Size Caveats

- OTHER home ownership (n=84): shown for completeness, excluded from firm conclusions.
- 18+ year credit history bucket (n=280): included but flagged as smaller than the other buckets.
- OTHER × High LTI (n=5): excluded entirely — too small to support any claim.

#### Scope Limitations

- Nova Bank is fictional; findings describe this dataset only, not real-world lending behavior.
- Single snapshot of 25,000 loans ($232M) — shows recorded outcomes, not how risk evolves over a loan's life.
- Geography shows no meaningful default differentiation *in this portfolio* — reported as a genuine finding, not a general claim about geography and credit risk.
  
#### Tools & Pipeline

- **Neon (Postgres)** — data warehouse
- **Google Colab (Python)** — data ingestion pipeline
- **SQL** — data cleaning and view creation
- **Power Query** — star schema data modeling
- **Power BI (DAX)** — dashboard and measures

Pipeline: raw Excel → Colab (`notebooks/`) → Neon staging table → SQL cleaning (`sql/`) → Power Query (star schema modeling) → Power BI (dashboard/DAX)
