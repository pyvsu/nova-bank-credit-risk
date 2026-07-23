-- ============================================
-- DATA INSPECTION SCRIPT
-- Table: stg_LoanData
-- Purpose: Quality control checks prior to cleaning/modeling
-- ============================================

-- 1. Row count and basic table size
SELECT COUNT(*) AS total_rows
FROM "stg_LoanData";

-- 2. Column names and data types (structure check)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'stg_loandata'
ORDER BY ordinal_position;

-- 3. Null counts per column (flags missing values)
SELECT
    COUNT(*) FILTER (WHERE "client_ID" IS NULL)             AS null_client_id,
    COUNT(*) FILTER (WHERE person_age IS NULL)              AS null_person_age,
    COUNT(*) FILTER (WHERE person_income IS NULL)            AS null_person_income,
    COUNT(*) FILTER (WHERE person_home_ownership IS NULL)    AS null_home_ownership,
    COUNT(*) FILTER (WHERE person_emp_length IS NULL)        AS null_emp_length,
    COUNT(*) FILTER (WHERE loan_intent IS NULL)              AS null_loan_intent,
    COUNT(*) FILTER (WHERE loan_grade IS NULL)               AS null_loan_grade,
    COUNT(*) FILTER (WHERE loan_amnt IS NULL)                AS null_loan_amnt,
    COUNT(*) FILTER (WHERE loan_int_rate IS NULL)             AS null_int_rate,
    COUNT(*) FILTER (WHERE loan_status IS NULL)               AS null_loan_status
FROM "stg_LoanData";

-- 4. Duplicate check
SELECT "client_ID", COUNT(*) AS occurrences
FROM "stg_LoanData"
GROUP BY "client_ID"
HAVING COUNT(*) > 1;

-- 5. Range checks on key numeric columns (spot outliers)
SELECT
    MIN(person_age)        AS min_age,
    MAX(person_age)        AS max_age,
    AVG(person_age)        AS avg_age,
    MIN(person_emp_length) AS min_emp_length,
    MAX(person_emp_length) AS max_emp_length,
    AVG(person_emp_length) AS avg_emp_length,
    MIN(loan_amnt)         AS min_loan_amnt,
    MAX(loan_amnt)         AS max_loan_amnt,
    MIN(loan_int_rate)     AS min_int_rate,
    MAX(loan_int_rate)     AS max_int_rate
FROM "stg_LoanData";

-- 6. Logical consistency check (age vs employment length)
SELECT "client_ID", person_age, person_emp_length
FROM "stg_LoanData"
WHERE person_emp_length > (person_age - 18);

-- 7. Distinct values in categorical columns (checks for inconsistent labels)
SELECT DISTINCT loan_intent FROM "stg_LoanData" ORDER BY 1;
SELECT DISTINCT loan_grade FROM "stg_LoanData" ORDER BY 1;
SELECT DISTINCT person_home_ownership FROM "stg_LoanData" ORDER BY 1;
SELECT DISTINCT cb_person_default_on_file FROM "stg_LoanData" ORDER BY 1;
SELECT DISTINCT country FROM "stg_LoanData" ORDER BY 1;

-- 8. Check loan_status values are only 0 or 1
SELECT DISTINCT loan_status FROM "stg_LoanData";
