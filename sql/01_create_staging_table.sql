-- ============================================
-- STAGING TABLE CREATION SCRIPT
-- Purpose: Define the raw landing table structure in Neon (Postgres)
--          before loading data from the source Excel file.
-- ============================================

CREATE TABLE stg_LoanData (
    client_ID VARCHAR(50) PRIMARY KEY,
    person_age INTEGER,
    person_income NUMERIC,
    person_home_ownership VARCHAR(50),
    person_emp_length INTEGER,
    loan_intent VARCHAR(50),
    loan_grade VARCHAR(10),
    loan_amnt NUMERIC,
    loan_int_rate NUMERIC,
    loan_status INTEGER,
    loan_percent_income NUMERIC,
    cb_person_default_on_file VARCHAR(5),
    cb_person_cred_hist_length INTEGER,
    gender VARCHAR(20),
    marital_status VARCHAR(20),
    education_level VARCHAR(50),
    country VARCHAR(50),
    state VARCHAR(50),
    city VARCHAR(50),
    city_latitude NUMERIC,
    city_longitude NUMERIC,
    employment_type VARCHAR(50),
    loan_term_months INTEGER,
    loan_to_income_ratio NUMERIC,
    other_debt NUMERIC,
    debt_to_income_ratio NUMERIC,
    open_accounts INTEGER,
    credit_utilization_ratio NUMERIC,
    past_delinquencies INTEGER
);
