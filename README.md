# Nova Bank Credit Risk Analytics

## Project Background
Nova Bank is a financial institution serving borrowers across the USA, UK, and Canada, offering personal, medical, education, and business loans to a wide range of customers.

Balancing risk and accessibility are central to how the bank operates — approve too many risky loans and profits erode, get too conservative and good customers walk away. Nova Bank has a dataset of loan records covering borrower profiles, financial ratios, and repayment history that hasn't been fully explored. This project digs into that data to uncover what actually drives default risk, with the goal of helping Nova Bank lend smarter — protecting the bottom line without shutting out borrowers who deserve a chance.

Insights and recommendations are provided on the following key areas:

- **Category 1: Executive Overview** — portfolio-level snapshot (loan grade, geography, purpose, home ownership)
- **Category 2: Who Defaults** — borrower attributes (home ownership, employment, credit history, education)
- **Category 3: Why They Default** — DTI/LTI, loan term, grade × intent, LTI-segmented home ownership
- **Category 4: Borrower Detail** — the drill-through page findings

The SQL script used to clean and prepare the data for this analysis can be found [here](sql/03_clean_and_create_view.sql).

The Power BI dashboard used to explore borrower risk and default trends can be found [here](dashboard/Nova_Bank_Credit_Risk_Dashboard.pbix).

## Data Structure & Initial Checks
Nova Bank's data originated as a single flat file of 32,581 records, which was cleaned and modeled into a star schema consisting of four tables: Fact_CreditRisk, Dim_Borrower, Dim_Geography, and Dim_Loan_Type, with a total row count of 24,738 records after cleaning.

<img width="2280" height="3313" alt="mermaid-diagram-1784833444144" src="https://github.com/user-attachments/assets/fc20601c-336c-42de-9d05-c77bf14621f3" />

Prior to modeling, a variety of checks were conducted for quality control and familiarization with the dataset. The SQL script used to inspect data can be found in [here](sql/02_inspection.sql).

## Executive Summary
Nova Bank's loan portfolio, 25,000 loans, $232M across the USA, UK, and Canada, carries a 22.9% overall default rate, but risk is far from evenly spread. Three things matter most: **loan grade** is the strongest and most actionable predictor, climbing from 10.37% at Grade A to 97.67% at Grade G, with default becoming the majority outcome the moment a loan crosses into Grade D. The single sharpest risk combination is **renters with a loan-to-income ratio ≥0.40**, who default 100% of the time across 682 loans — a segment current underwriting doesn't isolate. And **geography is not a risk driver**: income, debt burden, and default rates are nearly identical across all three countries (22.6%–23.1%), meaning one underwriting policy can safely apply across every market instead of three separate ones.

<img width="2075" height="1200" alt="Nova_Bank_Credit_Risk_Dashboard_page-0001" src="https://github.com/user-attachments/assets/3461c031-2a68-469f-8649-3d19cd9ecb08" />

An overview of the PowerBI dashboard is shown below, with further examples provided in the report. You can download the full interactive dashboard [here](dashboard/Nova_Bank_Credit_Risk_Dashboard.pbix).

## Insights Deep Dive
## Recommendations
## Assumptions and Caveats
## Tools & Pipeline
