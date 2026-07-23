-- ============================================
-- DATA CLEANING SCRIPT
-- Purpose: Create a cleaned view of stg_LoanData based on
--          findings from 02_inspection.sql
--
-- Action Plan:
-- 1. Impute missing person_emp_length with 0
-- 2. Impute missing loan_int_rate with the average rate for that loan_grade
-- 3. Filter out impossible ages (person_age > 80)
-- 4. Filter out impossible employment lengths (person_emp_length > 60,
--    or greater than person_age - 18)
-- ============================================

CREATE OR REPLACE VIEW "view_cleaned_credit_risk_data" AS

WITH "ImputedData" AS (
    SELECT
        "client_ID",
        "person_age",
        "person_income",
        "person_home_ownership",

        -- 1. Impute missing employment length with 0
        COALESCE("person_emp_length", 0) AS "person_emp_length",

        "loan_intent",
        "loan_grade",
        "loan_amnt",

        -- 2. Impute missing interest rate with the average of their specific loan_grade
        COALESCE(
            "loan_int_rate",
            ROUND(AVG("loan_int_rate") OVER (PARTITION BY "loan_grade")::numeric, 2)
        ) AS "loan_int_rate",

        "loan_status",
        "loan_percent_income",
        "cb_person_default_on_file",
        "cb_person_cred_hist_length",
        "gender",
        "marital_status",
        "education_level",
        "country",
        "state",
        "city",
        "city_latitude",
        "city_longitude",
        "employment_type",
        "loan_term_months",
        "loan_to_income_ratio",
        "other_debt",
        "debt_to_income_ratio",
        "open_accounts",
        "credit_utilization_ratio",
        "past_delinquencies"
    FROM
        "stg_LoanData"
)

SELECT *
FROM "ImputedData"
WHERE
    -- 3. Filter out impossible ages
    "person_age" <= 80

    -- 4. Filter out impossible employment lengths
    AND "person_emp_length" <= 60
    -- Note: Parentheses below are kept because they are doing mathematical grouping
    AND "person_emp_length" <= ("person_age" - 18);
