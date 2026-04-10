--
-- PostgreSQL database dump
--

\restrict 8YYtFLD9bwme7MiCKxm1aXQR7RpxPaArjmdiBaHILpdbAKaTHhbEP9VaSy0NxIk

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: account_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.account_status AS ENUM (
    'ACTIVE',
    'FROZEN',
    'DORMANT',
    'CLOSED',
    'PENDING_ACTIVATION'
);


ALTER TYPE public.account_status OWNER TO postgres;

--
-- Name: employment_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.employment_type AS ENUM (
    'Student',
    'Unemployed',
    'Employed',
    'Self_Employed',
    'Retired'
);


ALTER TYPE public.employment_type OWNER TO postgres;

--
-- Name: gender_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.gender_status AS ENUM (
    'Male',
    'Female',
    'Other',
    'Prefer Not to Say'
);


ALTER TYPE public.gender_status OWNER TO postgres;

--
-- Name: loan_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.loan_status AS ENUM (
    'PENDING',
    'APPROVED',
    'DISBURSED',
    'ACTIVE',
    'OVERDUE',
    'PAID_OFF',
    'DEFAULTED',
    'WRITTEN_OFF'
);


ALTER TYPE public.loan_status OWNER TO postgres;

--
-- Name: marital_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.marital_type AS ENUM (
    'Single',
    'Married',
    'Separated',
    'Divorced',
    'Widowed'
);


ALTER TYPE public.marital_type OWNER TO postgres;

--
-- Name: race_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.race_type AS ENUM (
    'Black/African',
    'White',
    'Asian',
    'Native American',
    'Pacific Islander',
    'Hispanic',
    'Biracial'
);


ALTER TYPE public.race_type OWNER TO postgres;

--
-- Name: religion_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.religion_type AS ENUM (
    'Christian',
    'Muslim',
    'Jewish',
    'Hindu',
    'Buddhist',
    'Taiost',
    'Atheist',
    'Agnostic',
    'Other'
);


ALTER TYPE public.religion_type OWNER TO postgres;

--
-- Name: risk_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.risk_type AS ENUM (
    'LOW',
    'MEDIUM',
    'HIGH'
);


ALTER TYPE public.risk_type OWNER TO postgres;

--
-- Name: savings_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.savings_status AS ENUM (
    'ACTIVE',
    'MATURED',
    'CLOSED',
    'WITHDRAWN'
);


ALTER TYPE public.savings_status OWNER TO postgres;

--
-- Name: transaction_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.transaction_status AS ENUM (
    'PENDING',
    'PROCESSING',
    'COMPLETED',
    'FAILED',
    'REVERSED',
    'CANCELED'
);


ALTER TYPE public.transaction_status OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account_fees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_fees (
    fee_id bigint NOT NULL,
    fee_code character varying(10) NOT NULL,
    fee_name character varying(100) NOT NULL,
    fee_type character varying(50) NOT NULL,
    account_class_id bigint,
    transaction_class_id bigint,
    fixed_amount numeric(19,4),
    percentage numeric(5,2),
    minimum_fee numeric(19,4),
    maximum_fee numeric(19,4),
    currency_id bigint,
    frequency character varying(20),
    applies_after_count integer,
    threshold_amount numeric(19,4),
    effective_from date DEFAULT CURRENT_DATE NOT NULL,
    effective_to date,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT check_fee_calculation CHECK ((((fixed_amount IS NOT NULL) AND (percentage IS NULL)) OR ((fixed_amount IS NULL) AND (percentage IS NOT NULL)) OR ((fixed_amount IS NOT NULL) AND (percentage IS NOT NULL))))
);


ALTER TABLE public.account_fees OWNER TO postgres;

--
-- Name: account_fees_fee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.account_fees_fee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.account_fees_fee_id_seq OWNER TO postgres;

--
-- Name: account_fees_fee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.account_fees_fee_id_seq OWNED BY public.account_fees.fee_id;


--
-- Name: account_statements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_statements (
    statement_id bigint NOT NULL,
    account_id bigint NOT NULL,
    customer_id bigint NOT NULL,
    statement_year integer NOT NULL,
    statement_month integer NOT NULL,
    opening_balance numeric(19,4) NOT NULL,
    closing_balance numeric(19,4) NOT NULL,
    total_credits numeric(19,4) DEFAULT 0.00 NOT NULL,
    total_debits numeric(19,4) DEFAULT 0.00 NOT NULL,
    transaction_count integer DEFAULT 0 NOT NULL,
    generated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT check_valid_month CHECK (((statement_month >= 1) AND (statement_month <= 12)))
)
PARTITION BY RANGE (statement_year);


ALTER TABLE public.account_statements OWNER TO postgres;

--
-- Name: account_statements_statement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.account_statements_statement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.account_statements_statement_id_seq OWNER TO postgres;

--
-- Name: account_statements_statement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.account_statements_statement_id_seq OWNED BY public.account_statements.statement_id;


--
-- Name: account_statements_2024; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_statements_2024 (
    statement_id bigint DEFAULT nextval('public.account_statements_statement_id_seq'::regclass) CONSTRAINT account_statements_statement_id_not_null NOT NULL,
    account_id bigint CONSTRAINT account_statements_account_id_not_null NOT NULL,
    customer_id bigint CONSTRAINT account_statements_customer_id_not_null NOT NULL,
    statement_year integer CONSTRAINT account_statements_statement_year_not_null NOT NULL,
    statement_month integer CONSTRAINT account_statements_statement_month_not_null NOT NULL,
    opening_balance numeric(19,4) CONSTRAINT account_statements_opening_balance_not_null NOT NULL,
    closing_balance numeric(19,4) CONSTRAINT account_statements_closing_balance_not_null NOT NULL,
    total_credits numeric(19,4) DEFAULT 0.00 CONSTRAINT account_statements_total_credits_not_null NOT NULL,
    total_debits numeric(19,4) DEFAULT 0.00 CONSTRAINT account_statements_total_debits_not_null NOT NULL,
    transaction_count integer DEFAULT 0 CONSTRAINT account_statements_transaction_count_not_null NOT NULL,
    generated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP CONSTRAINT account_statements_generated_at_not_null NOT NULL,
    CONSTRAINT check_valid_month CHECK (((statement_month >= 1) AND (statement_month <= 12)))
);


ALTER TABLE public.account_statements_2024 OWNER TO postgres;

--
-- Name: account_statements_2025; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_statements_2025 (
    statement_id bigint DEFAULT nextval('public.account_statements_statement_id_seq'::regclass) CONSTRAINT account_statements_statement_id_not_null NOT NULL,
    account_id bigint CONSTRAINT account_statements_account_id_not_null NOT NULL,
    customer_id bigint CONSTRAINT account_statements_customer_id_not_null NOT NULL,
    statement_year integer CONSTRAINT account_statements_statement_year_not_null NOT NULL,
    statement_month integer CONSTRAINT account_statements_statement_month_not_null NOT NULL,
    opening_balance numeric(19,4) CONSTRAINT account_statements_opening_balance_not_null NOT NULL,
    closing_balance numeric(19,4) CONSTRAINT account_statements_closing_balance_not_null NOT NULL,
    total_credits numeric(19,4) DEFAULT 0.00 CONSTRAINT account_statements_total_credits_not_null NOT NULL,
    total_debits numeric(19,4) DEFAULT 0.00 CONSTRAINT account_statements_total_debits_not_null NOT NULL,
    transaction_count integer DEFAULT 0 CONSTRAINT account_statements_transaction_count_not_null NOT NULL,
    generated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP CONSTRAINT account_statements_generated_at_not_null NOT NULL,
    CONSTRAINT check_valid_month CHECK (((statement_month >= 1) AND (statement_month <= 12)))
);


ALTER TABLE public.account_statements_2025 OWNER TO postgres;

--
-- Name: account_statements_2026; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_statements_2026 (
    statement_id bigint DEFAULT nextval('public.account_statements_statement_id_seq'::regclass) CONSTRAINT account_statements_statement_id_not_null NOT NULL,
    account_id bigint CONSTRAINT account_statements_account_id_not_null NOT NULL,
    customer_id bigint CONSTRAINT account_statements_customer_id_not_null NOT NULL,
    statement_year integer CONSTRAINT account_statements_statement_year_not_null NOT NULL,
    statement_month integer CONSTRAINT account_statements_statement_month_not_null NOT NULL,
    opening_balance numeric(19,4) CONSTRAINT account_statements_opening_balance_not_null NOT NULL,
    closing_balance numeric(19,4) CONSTRAINT account_statements_closing_balance_not_null NOT NULL,
    total_credits numeric(19,4) DEFAULT 0.00 CONSTRAINT account_statements_total_credits_not_null NOT NULL,
    total_debits numeric(19,4) DEFAULT 0.00 CONSTRAINT account_statements_total_debits_not_null NOT NULL,
    transaction_count integer DEFAULT 0 CONSTRAINT account_statements_transaction_count_not_null NOT NULL,
    generated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP CONSTRAINT account_statements_generated_at_not_null NOT NULL,
    CONSTRAINT check_valid_month CHECK (((statement_month >= 1) AND (statement_month <= 12)))
);


ALTER TABLE public.account_statements_2026 OWNER TO postgres;

--
-- Name: account_statements_2027; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_statements_2027 (
    statement_id bigint DEFAULT nextval('public.account_statements_statement_id_seq'::regclass) CONSTRAINT account_statements_statement_id_not_null NOT NULL,
    account_id bigint CONSTRAINT account_statements_account_id_not_null NOT NULL,
    customer_id bigint CONSTRAINT account_statements_customer_id_not_null NOT NULL,
    statement_year integer CONSTRAINT account_statements_statement_year_not_null NOT NULL,
    statement_month integer CONSTRAINT account_statements_statement_month_not_null NOT NULL,
    opening_balance numeric(19,4) CONSTRAINT account_statements_opening_balance_not_null NOT NULL,
    closing_balance numeric(19,4) CONSTRAINT account_statements_closing_balance_not_null NOT NULL,
    total_credits numeric(19,4) DEFAULT 0.00 CONSTRAINT account_statements_total_credits_not_null NOT NULL,
    total_debits numeric(19,4) DEFAULT 0.00 CONSTRAINT account_statements_total_debits_not_null NOT NULL,
    transaction_count integer DEFAULT 0 CONSTRAINT account_statements_transaction_count_not_null NOT NULL,
    generated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP CONSTRAINT account_statements_generated_at_not_null NOT NULL,
    CONSTRAINT check_valid_month CHECK (((statement_month >= 1) AND (statement_month <= 12)))
);


ALTER TABLE public.account_statements_2027 OWNER TO postgres;

--
-- Name: account_statements_2028; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_statements_2028 (
    statement_id bigint DEFAULT nextval('public.account_statements_statement_id_seq'::regclass) CONSTRAINT account_statements_statement_id_not_null NOT NULL,
    account_id bigint CONSTRAINT account_statements_account_id_not_null NOT NULL,
    customer_id bigint CONSTRAINT account_statements_customer_id_not_null NOT NULL,
    statement_year integer CONSTRAINT account_statements_statement_year_not_null NOT NULL,
    statement_month integer CONSTRAINT account_statements_statement_month_not_null NOT NULL,
    opening_balance numeric(19,4) CONSTRAINT account_statements_opening_balance_not_null NOT NULL,
    closing_balance numeric(19,4) CONSTRAINT account_statements_closing_balance_not_null NOT NULL,
    total_credits numeric(19,4) DEFAULT 0.00 CONSTRAINT account_statements_total_credits_not_null NOT NULL,
    total_debits numeric(19,4) DEFAULT 0.00 CONSTRAINT account_statements_total_debits_not_null NOT NULL,
    transaction_count integer DEFAULT 0 CONSTRAINT account_statements_transaction_count_not_null NOT NULL,
    generated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP CONSTRAINT account_statements_generated_at_not_null NOT NULL,
    CONSTRAINT check_valid_month CHECK (((statement_month >= 1) AND (statement_month <= 12)))
);


ALTER TABLE public.account_statements_2028 OWNER TO postgres;

--
-- Name: account_statements_2029; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_statements_2029 (
    statement_id bigint DEFAULT nextval('public.account_statements_statement_id_seq'::regclass) CONSTRAINT account_statements_statement_id_not_null NOT NULL,
    account_id bigint CONSTRAINT account_statements_account_id_not_null NOT NULL,
    customer_id bigint CONSTRAINT account_statements_customer_id_not_null NOT NULL,
    statement_year integer CONSTRAINT account_statements_statement_year_not_null NOT NULL,
    statement_month integer CONSTRAINT account_statements_statement_month_not_null NOT NULL,
    opening_balance numeric(19,4) CONSTRAINT account_statements_opening_balance_not_null NOT NULL,
    closing_balance numeric(19,4) CONSTRAINT account_statements_closing_balance_not_null NOT NULL,
    total_credits numeric(19,4) DEFAULT 0.00 CONSTRAINT account_statements_total_credits_not_null NOT NULL,
    total_debits numeric(19,4) DEFAULT 0.00 CONSTRAINT account_statements_total_debits_not_null NOT NULL,
    transaction_count integer DEFAULT 0 CONSTRAINT account_statements_transaction_count_not_null NOT NULL,
    generated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP CONSTRAINT account_statements_generated_at_not_null NOT NULL,
    CONSTRAINT check_valid_month CHECK (((statement_month >= 1) AND (statement_month <= 12)))
);


ALTER TABLE public.account_statements_2029 OWNER TO postgres;

--
-- Name: account_statements_2030; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_statements_2030 (
    statement_id bigint DEFAULT nextval('public.account_statements_statement_id_seq'::regclass) CONSTRAINT account_statements_statement_id_not_null NOT NULL,
    account_id bigint CONSTRAINT account_statements_account_id_not_null NOT NULL,
    customer_id bigint CONSTRAINT account_statements_customer_id_not_null NOT NULL,
    statement_year integer CONSTRAINT account_statements_statement_year_not_null NOT NULL,
    statement_month integer CONSTRAINT account_statements_statement_month_not_null NOT NULL,
    opening_balance numeric(19,4) CONSTRAINT account_statements_opening_balance_not_null NOT NULL,
    closing_balance numeric(19,4) CONSTRAINT account_statements_closing_balance_not_null NOT NULL,
    total_credits numeric(19,4) DEFAULT 0.00 CONSTRAINT account_statements_total_credits_not_null NOT NULL,
    total_debits numeric(19,4) DEFAULT 0.00 CONSTRAINT account_statements_total_debits_not_null NOT NULL,
    transaction_count integer DEFAULT 0 CONSTRAINT account_statements_transaction_count_not_null NOT NULL,
    generated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP CONSTRAINT account_statements_generated_at_not_null NOT NULL,
    CONSTRAINT check_valid_month CHECK (((statement_month >= 1) AND (statement_month <= 12)))
);


ALTER TABLE public.account_statements_2030 OWNER TO postgres;

--
-- Name: account_statements_default; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_statements_default (
    statement_id bigint DEFAULT nextval('public.account_statements_statement_id_seq'::regclass) CONSTRAINT account_statements_statement_id_not_null NOT NULL,
    account_id bigint CONSTRAINT account_statements_account_id_not_null NOT NULL,
    customer_id bigint CONSTRAINT account_statements_customer_id_not_null NOT NULL,
    statement_year integer CONSTRAINT account_statements_statement_year_not_null NOT NULL,
    statement_month integer CONSTRAINT account_statements_statement_month_not_null NOT NULL,
    opening_balance numeric(19,4) CONSTRAINT account_statements_opening_balance_not_null NOT NULL,
    closing_balance numeric(19,4) CONSTRAINT account_statements_closing_balance_not_null NOT NULL,
    total_credits numeric(19,4) DEFAULT 0.00 CONSTRAINT account_statements_total_credits_not_null NOT NULL,
    total_debits numeric(19,4) DEFAULT 0.00 CONSTRAINT account_statements_total_debits_not_null NOT NULL,
    transaction_count integer DEFAULT 0 CONSTRAINT account_statements_transaction_count_not_null NOT NULL,
    generated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP CONSTRAINT account_statements_generated_at_not_null NOT NULL,
    CONSTRAINT check_valid_month CHECK (((statement_month >= 1) AND (statement_month <= 12)))
);


ALTER TABLE public.account_statements_default OWNER TO postgres;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts (
    account_id bigint NOT NULL,
    account_number character varying(100) NOT NULL,
    account_type_id bigint NOT NULL,
    currency_id bigint NOT NULL,
    balance numeric(19,4) DEFAULT 0.00 NOT NULL,
    available_balance numeric(19,4) DEFAULT 0.00 NOT NULL,
    overdraft_limit numeric(19,4) DEFAULT 0.00,
    interest_rate numeric(5,2),
    status public.account_status DEFAULT 'PENDING_ACTIVATION'::public.account_status NOT NULL,
    opened_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    closed_at timestamp with time zone,
    last_transaction_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT account_number_length CHECK ((char_length((account_number)::text) <= 10)),
    CONSTRAINT check_available_balance CHECK ((available_balance <= balance)),
    CONSTRAINT check_balance_within_limit CHECK ((balance >= (- COALESCE(overdraft_limit, (0)::numeric))))
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- Name: TABLE accounts; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.accounts IS 'Core accounts table with balance tracking and overdraft support';


--
-- Name: COLUMN accounts.available_balance; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.accounts.available_balance IS 'Balance available for withdrawal after pending transaction and holds';


--
-- Name: accounts_account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accounts_account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.accounts_account_id_seq OWNER TO postgres;

--
-- Name: accounts_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_account_id_seq OWNED BY public.accounts.account_id;


--
-- Name: accounts_classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts_classes (
    account_class_id bigint NOT NULL,
    account_class_code character varying(10) NOT NULL,
    account_class_name character varying(100) NOT NULL,
    description text,
    minimum_balance numeric(19,4) DEFAULT 0.00,
    has_maximum_restriction boolean DEFAULT false,
    maximum_balance numeric(19,4),
    allows_overdraft boolean DEFAULT false,
    overdraft_limit numeric(19,4),
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.accounts_classes OWNER TO postgres;

--
-- Name: accounts_classes_account_class_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accounts_classes_account_class_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.accounts_classes_account_class_id_seq OWNER TO postgres;

--
-- Name: accounts_classes_account_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_classes_account_class_id_seq OWNED BY public.accounts_classes.account_class_id;


--
-- Name: accounts_transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts_transactions (
    ledger_id bigint NOT NULL,
    transaction_id bigint NOT NULL,
    account_id bigint NOT NULL,
    debit_amount numeric(19,4),
    credit_amount numeric(19,4),
    ledger_type character varying(20),
    description character varying(255),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    balance_before numeric(19,4) NOT NULL,
    balance_after numeric(19,4) NOT NULL,
    posted_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT check_debit_or_credit CHECK ((((debit_amount IS NOT NULL) AND (credit_amount IS NULL)) OR ((credit_amount IS NOT NULL) AND (debit_amount IS NULL)))),
    CONSTRAINT check_positive_amounts CHECK ((((debit_amount IS NULL) OR (debit_amount > (0)::numeric)) AND ((credit_amount IS NULL) OR (credit_amount > (0)::numeric))))
);


ALTER TABLE public.accounts_transactions OWNER TO postgres;

--
-- Name: TABLE accounts_transactions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.accounts_transactions IS 'Junction table implementing double-entry bookkeeping for all transaction';


--
-- Name: COLUMN accounts_transactions.ledger_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.accounts_transactions.ledger_type IS 'Identifies the role of this account in the transaction: SOURCE, DESTINATION, FEE, COMMISSION';


--
-- Name: accounts_transactions_ledger_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accounts_transactions_ledger_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.accounts_transactions_ledger_id_seq OWNER TO postgres;

--
-- Name: accounts_transactions_ledger_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_transactions_ledger_id_seq OWNED BY public.accounts_transactions.ledger_id;


--
-- Name: applied_fees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applied_fees (
    applied_fee_id bigint NOT NULL,
    account_id bigint NOT NULL,
    transaction_id bigint,
    fee_id bigint NOT NULL,
    amount_charged numeric(19,4) NOT NULL,
    calculation_basis numeric(19,4),
    waived boolean DEFAULT false,
    waived_by bigint,
    waived_at timestamp with time zone,
    waiver_reason text,
    applied_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT check_positive_fee CHECK ((amount_charged >= (0)::numeric))
);


ALTER TABLE public.applied_fees OWNER TO postgres;

--
-- Name: applied_fees_applied_fee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.applied_fees_applied_fee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.applied_fees_applied_fee_id_seq OWNER TO postgres;

--
-- Name: applied_fees_applied_fee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.applied_fees_applied_fee_id_seq OWNED BY public.applied_fees.applied_fee_id;


--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    audit_id bigint NOT NULL,
    table_name character varying(100) NOT NULL,
    record_id bigint NOT NULL,
    action character varying(20) NOT NULL,
    old_values jsonb,
    new_values jsonb,
    changed_by bigint,
    changed_by_type character varying(20),
    ip_address inet,
    user_agent text,
    changed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT check_valid_action CHECK (((action)::text = ANY ((ARRAY['INSERT'::character varying, 'UPDATE'::character varying, 'DELETE'::character varying])::text[])))
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- Name: TABLE audit_logs; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.audit_logs IS 'Comprehensive audit trail for all critical data changes';


--
-- Name: audit_logs_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_logs_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_logs_audit_id_seq OWNER TO postgres;

--
-- Name: audit_logs_audit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_logs_audit_id_seq OWNED BY public.audit_logs.audit_id;


--
-- Name: beneficiaries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.beneficiaries (
    beneficiary_id bigint NOT NULL,
    customer_id bigint NOT NULL,
    bank_id bigint NOT NULL,
    account_name character varying(255) NOT NULL,
    account_number character varying(100) NOT NULL,
    nickname character varying(100),
    bank_name character varying(200),
    is_verified boolean DEFAULT false,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone,
    CONSTRAINT account_number_length CHECK ((char_length((account_number)::text) <= 10))
);


ALTER TABLE public.beneficiaries OWNER TO postgres;

--
-- Name: beneficiaries_beneficiary_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.beneficiaries_beneficiary_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.beneficiaries_beneficiary_id_seq OWNER TO postgres;

--
-- Name: beneficiaries_beneficiary_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.beneficiaries_beneficiary_id_seq OWNED BY public.beneficiaries.beneficiary_id;


--
-- Name: branches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.branches (
    branch_id bigint NOT NULL,
    branch_code character varying(10) NOT NULL,
    branch_name character varying(255) NOT NULL,
    branch_address character varying(700) NOT NULL,
    city character varying(100),
    state_name character varying(100),
    postal_code character varying(20),
    phone_number character varying(25),
    email character varying(255),
    manager_name character varying(255),
    is_active boolean DEFAULT true,
    established_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE public.branches OWNER TO postgres;

--
-- Name: branches_branch_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.branches_branch_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.branches_branch_id_seq OWNER TO postgres;

--
-- Name: branches_branch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.branches_branch_id_seq OWNED BY public.branches.branch_id;


--
-- Name: cards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cards (
    card_id bigint NOT NULL,
    card_number character varying(20) NOT NULL,
    card_class_id bigint NOT NULL,
    cardholder_name character varying(255),
    country_id bigint NOT NULL,
    cvv_hash character varying(255) NOT NULL,
    pin_hash character varying(255) NOT NULL,
    issue_date date NOT NULL,
    expiry_date date NOT NULL,
    status character varying(20) DEFAULT 'ACTIVE'::character varying,
    daily_withdrawal_limit numeric(19,4),
    daily_transaction_limit numeric(19,4),
    is_contactless boolean DEFAULT true,
    is_international boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT check_expiry_after_issue CHECK ((expiry_date > issue_date))
);


ALTER TABLE public.cards OWNER TO postgres;

--
-- Name: cards_accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cards_accounts (
    card_account_id bigint NOT NULL,
    card_id bigint NOT NULL,
    account_id bigint NOT NULL,
    is_primary boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.cards_accounts OWNER TO postgres;

--
-- Name: cards_accounts_card_account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cards_accounts_card_account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cards_accounts_card_account_id_seq OWNER TO postgres;

--
-- Name: cards_accounts_card_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cards_accounts_card_account_id_seq OWNED BY public.cards_accounts.card_account_id;


--
-- Name: cards_card_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cards_card_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cards_card_id_seq OWNER TO postgres;

--
-- Name: cards_card_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cards_card_id_seq OWNED BY public.cards.card_id;


--
-- Name: cards_classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cards_classes (
    card_class_id bigint NOT NULL,
    card_class_code character varying(6),
    card_class_name character varying(100),
    currency_id bigint NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.cards_classes OWNER TO postgres;

--
-- Name: cards_classes_card_class_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cards_classes_card_class_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cards_classes_card_class_id_seq OWNER TO postgres;

--
-- Name: cards_classes_card_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cards_classes_card_class_id_seq OWNED BY public.cards_classes.card_class_id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    country_id bigint NOT NULL,
    country_code character varying(2) NOT NULL,
    country_name character varying(255) NOT NULL,
    currency_code character varying(3),
    phone_code character varying(5),
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- Name: countries_country_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.countries_country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.countries_country_id_seq OWNER TO postgres;

--
-- Name: countries_country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.countries_country_id_seq OWNED BY public.countries.country_id;


--
-- Name: currencies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.currencies (
    currency_id bigint NOT NULL,
    currency_code character varying(3) NOT NULL,
    currency_name character varying(100) NOT NULL,
    currency_symbol character varying(5) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.currencies OWNER TO postgres;

--
-- Name: currencies_currency_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.currencies_currency_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.currencies_currency_id_seq OWNER TO postgres;

--
-- Name: currencies_currency_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.currencies_currency_id_seq OWNED BY public.currencies.currency_id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id bigint NOT NULL,
    customer_number character varying(30) NOT NULL,
    first_name character varying(255) NOT NULL,
    middle_name character varying(255),
    last_name character varying(255) NOT NULL,
    gender public.gender_status NOT NULL,
    date_of_birth date NOT NULL,
    marital_status public.marital_type NOT NULL,
    religion public.religion_type,
    race public.race_type,
    employment_status public.employment_type NOT NULL,
    employer_name character varying(255),
    occupation character varying(100),
    annual_income numeric(19,4),
    state_of_origin bigint,
    country_nationality bigint NOT NULL,
    email character varying(255) NOT NULL,
    email_verified boolean DEFAULT false,
    username character varying(50) NOT NULL,
    password_hash character varying(100) NOT NULL,
    phone_number character varying(25) NOT NULL,
    phone_verified boolean DEFAULT false,
    address character varying(500) NOT NULL,
    city character varying(100),
    postal_code character varying(20),
    state_of_residence bigint,
    country_residence bigint NOT NULL,
    id_type character varying(50),
    id_number character varying(50),
    id_expiry_date date,
    tax_id_number character varying(50),
    mothers_maiden_name character varying(255) NOT NULL,
    next_of_kin character varying(255) NOT NULL,
    next_of_kin_relationship character varying(50),
    email_next_of_kin character varying(255),
    contact_next_of_kin character varying(25) NOT NULL,
    branch_id bigint,
    customer_status character varying(20),
    kyc_status character varying(20) DEFAULT 'PENDING'::character varying,
    kyc_verified_at timestamp with time zone,
    accounts_locked boolean DEFAULT false,
    failed_login_attempts integer DEFAULT 0,
    last_login_attempt timestamp with time zone,
    last_login_ip inet,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT check_adult CHECK ((date_of_birth <= (CURRENT_DATE - '18 years'::interval))),
    CONSTRAINT check_valid_email CHECK (((email)::text ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text))
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: TABLE customers; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.customers IS 'Stores customer information including personnel details, KYC data and account status';


--
-- Name: COLUMN customers.kyc_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.customers.kyc_status IS 'Know Your Customer verification status : PENDING, VERIFIED, or REJECTED';


--
-- Name: customers_accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers_accounts (
    customer_account_id bigint NOT NULL,
    customer_id bigint NOT NULL,
    account_id bigint NOT NULL,
    account_name character varying(500) NOT NULL,
    is_primary boolean DEFAULT true,
    relationship_type character varying(50) DEFAULT 'OWNER'::character varying,
    permissions text[],
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE public.customers_accounts OWNER TO postgres;

--
-- Name: customers_accounts_customer_account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_accounts_customer_account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customers_accounts_customer_account_id_seq OWNER TO postgres;

--
-- Name: customers_accounts_customer_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_accounts_customer_account_id_seq OWNED BY public.customers_accounts.customer_account_id;


--
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_customer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customers_customer_id_seq OWNER TO postgres;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;


--
-- Name: customers_investments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers_investments (
    customer_investments_id bigint NOT NULL,
    customer_id bigint NOT NULL,
    investments_id bigint NOT NULL,
    principal_contributed numeric(19,4) NOT NULL,
    ownership_percentage numeric(5,2) NOT NULL,
    units_owned numeric(15,4),
    returns_earned numeric(19,4) DEFAULT 0.00,
    customer_role character varying(20) DEFAULT 'PRIMARY'::character varying,
    joined_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    exited_at timestamp with time zone,
    exit_reason text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT check_positive_contributor CHECK ((principal_contributed > (0)::numeric)),
    CONSTRAINT check_valid_percentage CHECK (((ownership_percentage > (0)::numeric) AND (ownership_percentage <= (100)::numeric)))
);


ALTER TABLE public.customers_investments OWNER TO postgres;

--
-- Name: customers_investments_customer_investments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_investments_customer_investments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customers_investments_customer_investments_id_seq OWNER TO postgres;

--
-- Name: customers_investments_customer_investments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_investments_customer_investments_id_seq OWNED BY public.customers_investments.customer_investments_id;


--
-- Name: exchange_rates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exchange_rates (
    rate_id bigint NOT NULL,
    from_currency_id bigint NOT NULL,
    to_currency_id bigint NOT NULL,
    rate numeric(15,6) NOT NULL,
    effective_from timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    effective_to timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT check_different_currencies CHECK ((from_currency_id <> to_currency_id)),
    CONSTRAINT check_positive_rate CHECK ((rate > (0)::numeric))
);


ALTER TABLE public.exchange_rates OWNER TO postgres;

--
-- Name: exchange_rates_rate_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.exchange_rates_rate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.exchange_rates_rate_id_seq OWNER TO postgres;

--
-- Name: exchange_rates_rate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exchange_rates_rate_id_seq OWNED BY public.exchange_rates.rate_id;


--
-- Name: foreign_banks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.foreign_banks (
    foreign_bank_id bigint NOT NULL,
    foreign_bank_code character varying(5) NOT NULL,
    foreign_bank_name character varying(200) NOT NULL,
    country_id bigint,
    swift_code character varying(11),
    routing_number character varying(20),
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.foreign_banks OWNER TO postgres;

--
-- Name: foreign_banks_foreign_bank_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.foreign_banks_foreign_bank_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.foreign_banks_foreign_bank_id_seq OWNER TO postgres;

--
-- Name: foreign_banks_foreign_bank_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.foreign_banks_foreign_bank_id_seq OWNED BY public.foreign_banks.foreign_bank_id;


--
-- Name: fraud_alerts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fraud_alerts (
    alerts_id bigint NOT NULL,
    customer_id bigint NOT NULL,
    account_id bigint NOT NULL,
    transaction_id bigint,
    alert_type character varying(50) NOT NULL,
    risk_score numeric(5,2),
    description text,
    status character varying(20) DEFAULT 'OPEN'::character varying,
    resolved_by bigint,
    resolved_at timestamp with time zone,
    resolution_notes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.fraud_alerts OWNER TO postgres;

--
-- Name: TABLE fraud_alerts; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.fraud_alerts IS 'Security monitoring and fraud detection alerts';


--
-- Name: fraud_alerts_alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fraud_alerts_alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fraud_alerts_alerts_id_seq OWNER TO postgres;

--
-- Name: fraud_alerts_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fraud_alerts_alerts_id_seq OWNED BY public.fraud_alerts.alerts_id;


--
-- Name: investments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.investments (
    investments_id bigint NOT NULL,
    investment_number character varying(20) NOT NULL,
    customer_id bigint,
    investment_type bigint NOT NULL,
    is_joint boolean DEFAULT false,
    total_principal_amount numeric(19,4) NOT NULL,
    current_value numeric(19,4) NOT NULL,
    total_returns_earned numeric(19,4) DEFAULT 0.00,
    currency_id bigint NOT NULL,
    expected_return_rate numeric(5,2),
    units numeric(15,4),
    unit_price numeric(19,4),
    start_date date DEFAULT CURRENT_DATE NOT NULL,
    maturity_date date,
    status character varying(20) DEFAULT 'ACTIVE'::character varying,
    last_valuation_date timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT check_positive_investment CHECK ((total_principal_amount > (0)::numeric))
);


ALTER TABLE public.investments OWNER TO postgres;

--
-- Name: investments_classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.investments_classes (
    investment_class_id bigint NOT NULL,
    investment_class_code character varying(10) NOT NULL,
    investment_class_name character varying(255) NOT NULL,
    description text,
    expected_return_rate numeric(5,2),
    risk_level public.risk_type NOT NULL,
    minimum_amount numeric(19,4),
    maximum_amount numeric(19,4),
    minimum_tenure_months integer,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.investments_classes OWNER TO postgres;

--
-- Name: investments_classes_investment_class_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.investments_classes_investment_class_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.investments_classes_investment_class_id_seq OWNER TO postgres;

--
-- Name: investments_classes_investment_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.investments_classes_investment_class_id_seq OWNED BY public.investments_classes.investment_class_id;


--
-- Name: investments_investments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.investments_investments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.investments_investments_id_seq OWNER TO postgres;

--
-- Name: investments_investments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.investments_investments_id_seq OWNED BY public.investments.investments_id;


--
-- Name: loan_repayments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loan_repayments (
    repayment_id bigint NOT NULL,
    loan_id bigint NOT NULL,
    transaction_id bigint,
    payment_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    due_date date NOT NULL,
    amount_paid numeric(19,4) NOT NULL,
    principal_paid numeric(19,4) NOT NULL,
    interest_paid numeric(19,4) NOT NULL,
    penalty_paid numeric(19,4) DEFAULT 0.00 NOT NULL,
    outstanding_before numeric(19,4) NOT NULL,
    outstanding_after numeric(19,4) NOT NULL,
    payment_method character varying(50),
    is_early_payment boolean DEFAULT false,
    is_late_payment boolean DEFAULT false,
    days_overdue integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT check_payment_breakdown CHECK ((amount_paid >= ((principal_paid + interest_paid) + penalty_paid))),
    CONSTRAINT check_positive_payment CHECK ((amount_paid > (0)::numeric))
);


ALTER TABLE public.loan_repayments OWNER TO postgres;

--
-- Name: TABLE loan_repayments; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loan_repayments IS 'Tracks individual loan repayments installments with breakdown of principal, interest and penalties';


--
-- Name: loan_repayments_repayment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.loan_repayments_repayment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.loan_repayments_repayment_id_seq OWNER TO postgres;

--
-- Name: loan_repayments_repayment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.loan_repayments_repayment_id_seq OWNED BY public.loan_repayments.repayment_id;


--
-- Name: loans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loans (
    loan_id bigint NOT NULL,
    loan_number character varying(20) NOT NULL,
    customer_id bigint NOT NULL,
    loan_type bigint NOT NULL,
    principal_amount numeric(19,4) NOT NULL,
    outstanding_amount numeric(19,4) NOT NULL,
    interest_amount numeric(19,4) DEFAULT 0.00 NOT NULL,
    total_amount numeric(19,4) NOT NULL,
    currency_id bigint NOT NULL,
    interest_rate numeric(5,2) NOT NULL,
    tenure_months integer NOT NULL,
    monthly_payment numeric(19,4) NOT NULL,
    application_date date DEFAULT CURRENT_DATE NOT NULL,
    approval_date date,
    disbursement_date date,
    first_payment_date date,
    maturity_date date,
    status public.loan_status DEFAULT 'PENDING'::public.loan_status NOT NULL,
    collateral_type character varying(100),
    collateral_value numeric(19,4),
    collateral_description text,
    disbursement_account_id bigint,
    repayment_account_id bigint,
    approved_by bigint,
    rejection_reason text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone,
    closed_at timestamp with time zone,
    CONSTRAINT check_maturity_after_disbursement CHECK (((maturity_date IS NULL) OR (disbursement_date IS NULL) OR (maturity_date > disbursement_date))),
    CONSTRAINT check_outstanding_valid CHECK (((outstanding_amount >= (0)::numeric) AND (outstanding_amount <= total_amount))),
    CONSTRAINT check_positive_principal CHECK ((principal_amount > (0)::numeric)),
    CONSTRAINT check_positive_tenure CHECK ((tenure_months > 0))
);


ALTER TABLE public.loans OWNER TO postgres;

--
-- Name: TABLE loans; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loans IS 'Loan management with repayment tracking and collateral information';


--
-- Name: loans_classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loans_classes (
    loan_class_id bigint NOT NULL,
    loan_class_code character varying(10) NOT NULL,
    loan_class_name character varying(255) NOT NULL,
    description text,
    base_interest_rate numeric(5,2) NOT NULL,
    maximum_tenure_months integer,
    minimum_amount numeric(19,4),
    maximum_amount numeric(19,4),
    processing_fee_percent numeric(5,2),
    requires_collateral boolean DEFAULT true,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.loans_classes OWNER TO postgres;

--
-- Name: loans_classes_loan_class_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.loans_classes_loan_class_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.loans_classes_loan_class_id_seq OWNER TO postgres;

--
-- Name: loans_classes_loan_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.loans_classes_loan_class_id_seq OWNED BY public.loans_classes.loan_class_id;


--
-- Name: loans_loan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.loans_loan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.loans_loan_id_seq OWNER TO postgres;

--
-- Name: loans_loan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.loans_loan_id_seq OWNED BY public.loans.loan_id;


--
-- Name: login_attempts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.login_attempts (
    attempt_id bigint NOT NULL,
    customer_id bigint,
    imputed_email character varying(255),
    imputed_username character varying(50),
    imputed_password character varying(100),
    ip_address inet NOT NULL,
    user_agent text,
    success boolean NOT NULL,
    failure_reason character varying(100),
    attempted_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.login_attempts OWNER TO postgres;

--
-- Name: login_attempts_attempt_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.login_attempts_attempt_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.login_attempts_attempt_id_seq OWNER TO postgres;

--
-- Name: login_attempts_attempt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.login_attempts_attempt_id_seq OWNED BY public.login_attempts.attempt_id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    notification_id bigint NOT NULL,
    customer_id bigint NOT NULL,
    notification_type character varying(50) NOT NULL,
    channel character varying(20) NOT NULL,
    subject character varying(255),
    message_info text NOT NULL,
    is_read boolean DEFAULT false,
    read_at timestamp with time zone,
    sent_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: notifications_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_notification_id_seq OWNER TO postgres;

--
-- Name: notifications_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_notification_id_seq OWNED BY public.notifications.notification_id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.regions (
    region_id bigint NOT NULL,
    region_code character varying(3) NOT NULL,
    region_name character varying(100) NOT NULL,
    country_id bigint NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.regions OWNER TO postgres;

--
-- Name: regions_region_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.regions_region_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.regions_region_id_seq OWNER TO postgres;

--
-- Name: regions_region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.regions_region_id_seq OWNED BY public.regions.region_id;


--
-- Name: savings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.savings (
    savings_id bigint NOT NULL,
    savings_number character varying(30) NOT NULL,
    customer_id bigint NOT NULL,
    savings_type bigint NOT NULL,
    currency_id bigint NOT NULL,
    savings_name text,
    principal_amount numeric(19,4) NOT NULL,
    interest_rate numeric(5,2) NOT NULL,
    tenure_months integer,
    start_date date DEFAULT CURRENT_DATE NOT NULL,
    maturity_date date,
    interest_earned numeric(19,4) DEFAULT 0.00,
    current_balance numeric(19,4) NOT NULL,
    status public.savings_status DEFAULT 'ACTIVE'::public.savings_status NOT NULL,
    auto_renew boolean DEFAULT false,
    last_interest_calculation timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone,
    closed_at timestamp with time zone,
    CONSTRAINT check_maturity_after_start CHECK (((maturity_date IS NULL) OR (maturity_date > start_date))),
    CONSTRAINT check_positive_principal CHECK ((principal_amount > (0)::numeric))
);


ALTER TABLE public.savings OWNER TO postgres;

--
-- Name: savings_classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.savings_classes (
    savings_class_id bigint NOT NULL,
    savings_class_code character varying(10) NOT NULL,
    savings_class_name character varying(255) NOT NULL,
    description text,
    interest_rate numeric(5,2) NOT NULL,
    min_amount numeric(19,4),
    maximum_amount numeric(19,4),
    minimum_tenure_months integer,
    early_withdrawal_penalty numeric(5,2),
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.savings_classes OWNER TO postgres;

--
-- Name: savings_classes_savings_class_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.savings_classes_savings_class_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.savings_classes_savings_class_id_seq OWNER TO postgres;

--
-- Name: savings_classes_savings_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.savings_classes_savings_class_id_seq OWNED BY public.savings_classes.savings_class_id;


--
-- Name: savings_savings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.savings_savings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.savings_savings_id_seq OWNER TO postgres;

--
-- Name: savings_savings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.savings_savings_id_seq OWNED BY public.savings.savings_id;


--
-- Name: session_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.session_tokens (
    session_id bigint NOT NULL,
    customer_id bigint NOT NULL,
    token_hash character varying(255) NOT NULL,
    device_info text,
    ip_address inet,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    last_activity timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_active boolean DEFAULT true,
    CONSTRAINT check_expires_after_created CHECK ((expires_at > created_at))
);


ALTER TABLE public.session_tokens OWNER TO postgres;

--
-- Name: session_tokens_session_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.session_tokens_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.session_tokens_session_id_seq OWNER TO postgres;

--
-- Name: session_tokens_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.session_tokens_session_id_seq OWNED BY public.session_tokens.session_id;


--
-- Name: standing_order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.standing_order (
    standing_order_id bigint NOT NULL,
    customer_id bigint NOT NULL,
    from_account_id bigint NOT NULL,
    beneficiary_id bigint,
    amount numeric(19,4) NOT NULL,
    frequency character varying(20) NOT NULL,
    start_date date NOT NULL,
    end_date date,
    next_execution_date date NOT NULL,
    status character varying(20) DEFAULT 'ACTIVE'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.standing_order OWNER TO postgres;

--
-- Name: standing_order_standing_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.standing_order_standing_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.standing_order_standing_order_id_seq OWNER TO postgres;

--
-- Name: standing_order_standing_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.standing_order_standing_order_id_seq OWNED BY public.standing_order.standing_order_id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    transaction_id bigint NOT NULL,
    transaction_reference character varying(50) NOT NULL,
    transaction_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    transaction_type bigint NOT NULL,
    description character varying(255) NOT NULL,
    reference_number character varying(255),
    amount numeric(19,4) NOT NULL,
    currency_id bigint,
    status public.transaction_status DEFAULT 'PENDING'::public.transaction_status NOT NULL,
    initiated_by bigint,
    external_references character varying(255),
    external_bank_id bigint,
    exchange_rate numeric(15,6),
    reversal_of_transaction_id bigint,
    reversed_by_transaction_id bigint,
    reversal_reason text,
    completed_at timestamp with time zone,
    reversed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT check_positive_amount CHECK ((amount > (0)::numeric)),
    CONSTRAINT check_reversal_integrity CHECK ((((reversal_of_transaction_id IS NOT NULL) AND (reversed_by_transaction_id IS NULL)) OR ((reversal_of_transaction_id IS NULL) AND (reversed_by_transaction_id IS NOT NULL)) OR ((reversal_of_transaction_id IS NULL) AND (reversed_by_transaction_id IS NULL))))
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- Name: TABLE transactions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.transactions IS 'Master transaction records with status tracking and external references';


--
-- Name: COLUMN transactions.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.transactions.status IS 'Transaction lifecycle status: PENDING, PROCESSING, COMPLETED, FAILED, REVERSED, CANCELLED';


--
-- Name: transactions_classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions_classes (
    transaction_class_id bigint NOT NULL,
    transaction_class_code character varying(10) NOT NULL,
    transaction_class_name character varying(100) NOT NULL,
    transaction_category character varying(50),
    description text,
    is_reversible boolean DEFAULT true,
    requires_approval boolean DEFAULT false,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.transactions_classes OWNER TO postgres;

--
-- Name: transactions_classes_transaction_class_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transactions_classes_transaction_class_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transactions_classes_transaction_class_id_seq OWNER TO postgres;

--
-- Name: transactions_classes_transaction_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transactions_classes_transaction_class_id_seq OWNED BY public.transactions_classes.transaction_class_id;


--
-- Name: transactions_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transactions_transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transactions_transaction_id_seq OWNER TO postgres;

--
-- Name: transactions_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transactions_transaction_id_seq OWNED BY public.transactions.transaction_id;


--
-- Name: account_statements_2024; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_statements ATTACH PARTITION public.account_statements_2024 FOR VALUES FROM (2024) TO (2025);


--
-- Name: account_statements_2025; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_statements ATTACH PARTITION public.account_statements_2025 FOR VALUES FROM (2025) TO (2026);


--
-- Name: account_statements_2026; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_statements ATTACH PARTITION public.account_statements_2026 FOR VALUES FROM (2026) TO (2027);


--
-- Name: account_statements_2027; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_statements ATTACH PARTITION public.account_statements_2027 FOR VALUES FROM (2027) TO (2028);


--
-- Name: account_statements_2028; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_statements ATTACH PARTITION public.account_statements_2028 FOR VALUES FROM (2028) TO (2029);


--
-- Name: account_statements_2029; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_statements ATTACH PARTITION public.account_statements_2029 FOR VALUES FROM (2029) TO (2030);


--
-- Name: account_statements_2030; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_statements ATTACH PARTITION public.account_statements_2030 FOR VALUES FROM (2030) TO (2031);


--
-- Name: account_statements_default; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_statements ATTACH PARTITION public.account_statements_default DEFAULT;


--
-- Name: account_fees fee_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_fees ALTER COLUMN fee_id SET DEFAULT nextval('public.account_fees_fee_id_seq'::regclass);


--
-- Name: account_statements statement_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_statements ALTER COLUMN statement_id SET DEFAULT nextval('public.account_statements_statement_id_seq'::regclass);


--
-- Name: accounts account_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts ALTER COLUMN account_id SET DEFAULT nextval('public.accounts_account_id_seq'::regclass);


--
-- Name: accounts_classes account_class_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_classes ALTER COLUMN account_class_id SET DEFAULT nextval('public.accounts_classes_account_class_id_seq'::regclass);


--
-- Name: accounts_transactions ledger_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_transactions ALTER COLUMN ledger_id SET DEFAULT nextval('public.accounts_transactions_ledger_id_seq'::regclass);


--
-- Name: applied_fees applied_fee_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applied_fees ALTER COLUMN applied_fee_id SET DEFAULT nextval('public.applied_fees_applied_fee_id_seq'::regclass);


--
-- Name: audit_logs audit_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN audit_id SET DEFAULT nextval('public.audit_logs_audit_id_seq'::regclass);


--
-- Name: beneficiaries beneficiary_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beneficiaries ALTER COLUMN beneficiary_id SET DEFAULT nextval('public.beneficiaries_beneficiary_id_seq'::regclass);


--
-- Name: branches branch_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branches ALTER COLUMN branch_id SET DEFAULT nextval('public.branches_branch_id_seq'::regclass);


--
-- Name: cards card_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards ALTER COLUMN card_id SET DEFAULT nextval('public.cards_card_id_seq'::regclass);


--
-- Name: cards_accounts card_account_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards_accounts ALTER COLUMN card_account_id SET DEFAULT nextval('public.cards_accounts_card_account_id_seq'::regclass);


--
-- Name: cards_classes card_class_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards_classes ALTER COLUMN card_class_id SET DEFAULT nextval('public.cards_classes_card_class_id_seq'::regclass);


--
-- Name: countries country_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries ALTER COLUMN country_id SET DEFAULT nextval('public.countries_country_id_seq'::regclass);


--
-- Name: currencies currency_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currencies ALTER COLUMN currency_id SET DEFAULT nextval('public.currencies_currency_id_seq'::regclass);


--
-- Name: customers customer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);


--
-- Name: customers_accounts customer_account_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers_accounts ALTER COLUMN customer_account_id SET DEFAULT nextval('public.customers_accounts_customer_account_id_seq'::regclass);


--
-- Name: customers_investments customer_investments_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers_investments ALTER COLUMN customer_investments_id SET DEFAULT nextval('public.customers_investments_customer_investments_id_seq'::regclass);


--
-- Name: exchange_rates rate_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchange_rates ALTER COLUMN rate_id SET DEFAULT nextval('public.exchange_rates_rate_id_seq'::regclass);


--
-- Name: foreign_banks foreign_bank_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foreign_banks ALTER COLUMN foreign_bank_id SET DEFAULT nextval('public.foreign_banks_foreign_bank_id_seq'::regclass);


--
-- Name: fraud_alerts alerts_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fraud_alerts ALTER COLUMN alerts_id SET DEFAULT nextval('public.fraud_alerts_alerts_id_seq'::regclass);


--
-- Name: investments investments_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.investments ALTER COLUMN investments_id SET DEFAULT nextval('public.investments_investments_id_seq'::regclass);


--
-- Name: investments_classes investment_class_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.investments_classes ALTER COLUMN investment_class_id SET DEFAULT nextval('public.investments_classes_investment_class_id_seq'::regclass);


--
-- Name: loan_repayments repayment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan_repayments ALTER COLUMN repayment_id SET DEFAULT nextval('public.loan_repayments_repayment_id_seq'::regclass);


--
-- Name: loans loan_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans ALTER COLUMN loan_id SET DEFAULT nextval('public.loans_loan_id_seq'::regclass);


--
-- Name: loans_classes loan_class_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans_classes ALTER COLUMN loan_class_id SET DEFAULT nextval('public.loans_classes_loan_class_id_seq'::regclass);


--
-- Name: login_attempts attempt_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_attempts ALTER COLUMN attempt_id SET DEFAULT nextval('public.login_attempts_attempt_id_seq'::regclass);


--
-- Name: notifications notification_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN notification_id SET DEFAULT nextval('public.notifications_notification_id_seq'::regclass);


--
-- Name: regions region_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions ALTER COLUMN region_id SET DEFAULT nextval('public.regions_region_id_seq'::regclass);


--
-- Name: savings savings_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.savings ALTER COLUMN savings_id SET DEFAULT nextval('public.savings_savings_id_seq'::regclass);


--
-- Name: savings_classes savings_class_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.savings_classes ALTER COLUMN savings_class_id SET DEFAULT nextval('public.savings_classes_savings_class_id_seq'::regclass);


--
-- Name: session_tokens session_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_tokens ALTER COLUMN session_id SET DEFAULT nextval('public.session_tokens_session_id_seq'::regclass);


--
-- Name: standing_order standing_order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standing_order ALTER COLUMN standing_order_id SET DEFAULT nextval('public.standing_order_standing_order_id_seq'::regclass);


--
-- Name: transactions transaction_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions ALTER COLUMN transaction_id SET DEFAULT nextval('public.transactions_transaction_id_seq'::regclass);


--
-- Name: transactions_classes transaction_class_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions_classes ALTER COLUMN transaction_class_id SET DEFAULT nextval('public.transactions_classes_transaction_class_id_seq'::regclass);


--
-- Data for Name: account_fees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_fees (fee_id, fee_code, fee_name, fee_type, account_class_id, transaction_class_id, fixed_amount, percentage, minimum_fee, maximum_fee, currency_id, frequency, applies_after_count, threshold_amount, effective_from, effective_to, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: account_statements_2024; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_statements_2024 (statement_id, account_id, customer_id, statement_year, statement_month, opening_balance, closing_balance, total_credits, total_debits, transaction_count, generated_at) FROM stdin;
\.


--
-- Data for Name: account_statements_2025; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_statements_2025 (statement_id, account_id, customer_id, statement_year, statement_month, opening_balance, closing_balance, total_credits, total_debits, transaction_count, generated_at) FROM stdin;
\.


--
-- Data for Name: account_statements_2026; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_statements_2026 (statement_id, account_id, customer_id, statement_year, statement_month, opening_balance, closing_balance, total_credits, total_debits, transaction_count, generated_at) FROM stdin;
\.


--
-- Data for Name: account_statements_2027; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_statements_2027 (statement_id, account_id, customer_id, statement_year, statement_month, opening_balance, closing_balance, total_credits, total_debits, transaction_count, generated_at) FROM stdin;
\.


--
-- Data for Name: account_statements_2028; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_statements_2028 (statement_id, account_id, customer_id, statement_year, statement_month, opening_balance, closing_balance, total_credits, total_debits, transaction_count, generated_at) FROM stdin;
\.


--
-- Data for Name: account_statements_2029; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_statements_2029 (statement_id, account_id, customer_id, statement_year, statement_month, opening_balance, closing_balance, total_credits, total_debits, transaction_count, generated_at) FROM stdin;
\.


--
-- Data for Name: account_statements_2030; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_statements_2030 (statement_id, account_id, customer_id, statement_year, statement_month, opening_balance, closing_balance, total_credits, total_debits, transaction_count, generated_at) FROM stdin;
\.


--
-- Data for Name: account_statements_default; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_statements_default (statement_id, account_id, customer_id, statement_year, statement_month, opening_balance, closing_balance, total_credits, total_debits, transaction_count, generated_at) FROM stdin;
\.


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accounts (account_id, account_number, account_type_id, currency_id, balance, available_balance, overdraft_limit, interest_rate, status, opened_at, closed_at, last_transaction_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: accounts_classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accounts_classes (account_class_id, account_class_code, account_class_name, description, minimum_balance, has_maximum_restriction, maximum_balance, allows_overdraft, overdraft_limit, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: accounts_transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accounts_transactions (ledger_id, transaction_id, account_id, debit_amount, credit_amount, ledger_type, description, created_at, balance_before, balance_after, posted_at) FROM stdin;
\.


--
-- Data for Name: applied_fees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.applied_fees (applied_fee_id, account_id, transaction_id, fee_id, amount_charged, calculation_basis, waived, waived_by, waived_at, waiver_reason, applied_at) FROM stdin;
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_logs (audit_id, table_name, record_id, action, old_values, new_values, changed_by, changed_by_type, ip_address, user_agent, changed_at) FROM stdin;
\.


--
-- Data for Name: beneficiaries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.beneficiaries (beneficiary_id, customer_id, bank_id, account_name, account_number, nickname, bank_name, is_verified, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: branches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.branches (branch_id, branch_code, branch_name, branch_address, city, state_name, postal_code, phone_number, email, manager_name, is_active, established_at, updated_at) FROM stdin;
\.


--
-- Data for Name: cards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cards (card_id, card_number, card_class_id, cardholder_name, country_id, cvv_hash, pin_hash, issue_date, expiry_date, status, daily_withdrawal_limit, daily_transaction_limit, is_contactless, is_international, created_at) FROM stdin;
\.


--
-- Data for Name: cards_accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cards_accounts (card_account_id, card_id, account_id, is_primary, created_at) FROM stdin;
\.


--
-- Data for Name: cards_classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cards_classes (card_class_id, card_class_code, card_class_name, currency_id, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.countries (country_id, country_code, country_name, currency_code, phone_code, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: currencies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.currencies (currency_id, currency_code, currency_name, currency_symbol, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, customer_number, first_name, middle_name, last_name, gender, date_of_birth, marital_status, religion, race, employment_status, employer_name, occupation, annual_income, state_of_origin, country_nationality, email, email_verified, username, password_hash, phone_number, phone_verified, address, city, postal_code, state_of_residence, country_residence, id_type, id_number, id_expiry_date, tax_id_number, mothers_maiden_name, next_of_kin, next_of_kin_relationship, email_next_of_kin, contact_next_of_kin, branch_id, customer_status, kyc_status, kyc_verified_at, accounts_locked, failed_login_attempts, last_login_attempt, last_login_ip, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: customers_accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers_accounts (customer_account_id, customer_id, account_id, account_name, is_primary, relationship_type, permissions, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: customers_investments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers_investments (customer_investments_id, customer_id, investments_id, principal_contributed, ownership_percentage, units_owned, returns_earned, customer_role, joined_at, exited_at, exit_reason, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: exchange_rates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exchange_rates (rate_id, from_currency_id, to_currency_id, rate, effective_from, effective_to, created_at) FROM stdin;
\.


--
-- Data for Name: foreign_banks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.foreign_banks (foreign_bank_id, foreign_bank_code, foreign_bank_name, country_id, swift_code, routing_number, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: fraud_alerts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fraud_alerts (alerts_id, customer_id, account_id, transaction_id, alert_type, risk_score, description, status, resolved_by, resolved_at, resolution_notes, created_at) FROM stdin;
\.


--
-- Data for Name: investments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.investments (investments_id, investment_number, customer_id, investment_type, is_joint, total_principal_amount, current_value, total_returns_earned, currency_id, expected_return_rate, units, unit_price, start_date, maturity_date, status, last_valuation_date, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: investments_classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.investments_classes (investment_class_id, investment_class_code, investment_class_name, description, expected_return_rate, risk_level, minimum_amount, maximum_amount, minimum_tenure_months, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: loan_repayments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.loan_repayments (repayment_id, loan_id, transaction_id, payment_date, due_date, amount_paid, principal_paid, interest_paid, penalty_paid, outstanding_before, outstanding_after, payment_method, is_early_payment, is_late_payment, days_overdue, created_at) FROM stdin;
\.


--
-- Data for Name: loans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.loans (loan_id, loan_number, customer_id, loan_type, principal_amount, outstanding_amount, interest_amount, total_amount, currency_id, interest_rate, tenure_months, monthly_payment, application_date, approval_date, disbursement_date, first_payment_date, maturity_date, status, collateral_type, collateral_value, collateral_description, disbursement_account_id, repayment_account_id, approved_by, rejection_reason, created_at, updated_at, closed_at) FROM stdin;
\.


--
-- Data for Name: loans_classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.loans_classes (loan_class_id, loan_class_code, loan_class_name, description, base_interest_rate, maximum_tenure_months, minimum_amount, maximum_amount, processing_fee_percent, requires_collateral, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: login_attempts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.login_attempts (attempt_id, customer_id, imputed_email, imputed_username, imputed_password, ip_address, user_agent, success, failure_reason, attempted_at) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (notification_id, customer_id, notification_type, channel, subject, message_info, is_read, read_at, sent_at, created_at) FROM stdin;
\.


--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.regions (region_id, region_code, region_name, country_id, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: savings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.savings (savings_id, savings_number, customer_id, savings_type, currency_id, savings_name, principal_amount, interest_rate, tenure_months, start_date, maturity_date, interest_earned, current_balance, status, auto_renew, last_interest_calculation, created_at, updated_at, closed_at) FROM stdin;
\.


--
-- Data for Name: savings_classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.savings_classes (savings_class_id, savings_class_code, savings_class_name, description, interest_rate, min_amount, maximum_amount, minimum_tenure_months, early_withdrawal_penalty, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: session_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.session_tokens (session_id, customer_id, token_hash, device_info, ip_address, created_at, expires_at, last_activity, is_active) FROM stdin;
\.


--
-- Data for Name: standing_order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.standing_order (standing_order_id, customer_id, from_account_id, beneficiary_id, amount, frequency, start_date, end_date, next_execution_date, status, created_at) FROM stdin;
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (transaction_id, transaction_reference, transaction_date, transaction_type, description, reference_number, amount, currency_id, status, initiated_by, external_references, external_bank_id, exchange_rate, reversal_of_transaction_id, reversed_by_transaction_id, reversal_reason, completed_at, reversed_at, created_at) FROM stdin;
\.


--
-- Data for Name: transactions_classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions_classes (transaction_class_id, transaction_class_code, transaction_class_name, transaction_category, description, is_reversible, requires_approval, is_active, created_at) FROM stdin;
\.


--
-- Name: account_fees_fee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.account_fees_fee_id_seq', 1, false);


--
-- Name: account_statements_statement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.account_statements_statement_id_seq', 1, false);


--
-- Name: accounts_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_account_id_seq', 1, false);


--
-- Name: accounts_classes_account_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_classes_account_class_id_seq', 1, false);


--
-- Name: accounts_transactions_ledger_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_transactions_ledger_id_seq', 1, false);


--
-- Name: applied_fees_applied_fee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.applied_fees_applied_fee_id_seq', 1, false);


--
-- Name: audit_logs_audit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_logs_audit_id_seq', 1, false);


--
-- Name: beneficiaries_beneficiary_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.beneficiaries_beneficiary_id_seq', 1, false);


--
-- Name: branches_branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.branches_branch_id_seq', 1, false);


--
-- Name: cards_accounts_card_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cards_accounts_card_account_id_seq', 1, false);


--
-- Name: cards_card_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cards_card_id_seq', 1, false);


--
-- Name: cards_classes_card_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cards_classes_card_class_id_seq', 1, false);


--
-- Name: countries_country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.countries_country_id_seq', 1, false);


--
-- Name: currencies_currency_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.currencies_currency_id_seq', 1, false);


--
-- Name: customers_accounts_customer_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_accounts_customer_account_id_seq', 1, false);


--
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 1, false);


--
-- Name: customers_investments_customer_investments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_investments_customer_investments_id_seq', 1, false);


--
-- Name: exchange_rates_rate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exchange_rates_rate_id_seq', 1, false);


--
-- Name: foreign_banks_foreign_bank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.foreign_banks_foreign_bank_id_seq', 1, false);


--
-- Name: fraud_alerts_alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fraud_alerts_alerts_id_seq', 1, false);


--
-- Name: investments_classes_investment_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.investments_classes_investment_class_id_seq', 1, false);


--
-- Name: investments_investments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.investments_investments_id_seq', 1, false);


--
-- Name: loan_repayments_repayment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.loan_repayments_repayment_id_seq', 1, false);


--
-- Name: loans_classes_loan_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.loans_classes_loan_class_id_seq', 1, false);


--
-- Name: loans_loan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.loans_loan_id_seq', 1, false);


--
-- Name: login_attempts_attempt_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.login_attempts_attempt_id_seq', 1, false);


--
-- Name: notifications_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_notification_id_seq', 1, false);


--
-- Name: regions_region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.regions_region_id_seq', 1, false);


--
-- Name: savings_classes_savings_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.savings_classes_savings_class_id_seq', 1, false);


--
-- Name: savings_savings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.savings_savings_id_seq', 1, false);


--
-- Name: session_tokens_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.session_tokens_session_id_seq', 1, false);


--
-- Name: standing_order_standing_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.standing_order_standing_order_id_seq', 1, false);


--
-- Name: transactions_classes_transaction_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transactions_classes_transaction_class_id_seq', 1, false);


--
-- Name: transactions_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transactions_transaction_id_seq', 1, false);


--
-- Name: account_fees account_fees_fee_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_fees
    ADD CONSTRAINT account_fees_fee_code_key UNIQUE (fee_code);


--
-- Name: account_fees account_fees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_fees
    ADD CONSTRAINT account_fees_pkey PRIMARY KEY (fee_id);


--
-- Name: account_statements account_statements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_statements
    ADD CONSTRAINT account_statements_pkey PRIMARY KEY (statement_id, statement_year);


--
-- Name: account_statements_2024 account_statements_2024_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_statements_2024
    ADD CONSTRAINT account_statements_2024_pkey PRIMARY KEY (statement_id, statement_year);


--
-- Name: account_statements_2025 account_statements_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_statements_2025
    ADD CONSTRAINT account_statements_2025_pkey PRIMARY KEY (statement_id, statement_year);


--
-- Name: account_statements_2026 account_statements_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_statements_2026
    ADD CONSTRAINT account_statements_2026_pkey PRIMARY KEY (statement_id, statement_year);


--
-- Name: account_statements_2027 account_statements_2027_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_statements_2027
    ADD CONSTRAINT account_statements_2027_pkey PRIMARY KEY (statement_id, statement_year);


--
-- Name: account_statements_2028 account_statements_2028_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_statements_2028
    ADD CONSTRAINT account_statements_2028_pkey PRIMARY KEY (statement_id, statement_year);


--
-- Name: account_statements_2029 account_statements_2029_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_statements_2029
    ADD CONSTRAINT account_statements_2029_pkey PRIMARY KEY (statement_id, statement_year);


--
-- Name: account_statements_2030 account_statements_2030_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_statements_2030
    ADD CONSTRAINT account_statements_2030_pkey PRIMARY KEY (statement_id, statement_year);


--
-- Name: account_statements_default account_statements_default_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_statements_default
    ADD CONSTRAINT account_statements_default_pkey PRIMARY KEY (statement_id, statement_year);


--
-- Name: accounts accounts_account_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_account_number_key UNIQUE (account_number);


--
-- Name: accounts_classes accounts_classes_account_class_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_classes
    ADD CONSTRAINT accounts_classes_account_class_code_key UNIQUE (account_class_code);


--
-- Name: accounts_classes accounts_classes_account_class_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_classes
    ADD CONSTRAINT accounts_classes_account_class_name_key UNIQUE (account_class_name);


--
-- Name: accounts_classes accounts_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_classes
    ADD CONSTRAINT accounts_classes_pkey PRIMARY KEY (account_class_id);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (account_id);


--
-- Name: accounts_transactions accounts_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_transactions
    ADD CONSTRAINT accounts_transactions_pkey PRIMARY KEY (ledger_id);


--
-- Name: applied_fees applied_fees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applied_fees
    ADD CONSTRAINT applied_fees_pkey PRIMARY KEY (applied_fee_id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (audit_id);


--
-- Name: beneficiaries beneficiaries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beneficiaries
    ADD CONSTRAINT beneficiaries_pkey PRIMARY KEY (beneficiary_id);


--
-- Name: branches branches_branch_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branches
    ADD CONSTRAINT branches_branch_code_key UNIQUE (branch_code);


--
-- Name: branches branches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branches
    ADD CONSTRAINT branches_pkey PRIMARY KEY (branch_id);


--
-- Name: cards_accounts cards_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards_accounts
    ADD CONSTRAINT cards_accounts_pkey PRIMARY KEY (card_account_id);


--
-- Name: cards cards_card_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_card_number_key UNIQUE (card_number);


--
-- Name: cards_classes cards_classes_card_class_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards_classes
    ADD CONSTRAINT cards_classes_card_class_code_key UNIQUE (card_class_code);


--
-- Name: cards_classes cards_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards_classes
    ADD CONSTRAINT cards_classes_pkey PRIMARY KEY (card_class_id);


--
-- Name: cards cards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (card_id);


--
-- Name: countries countries_country_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_country_code_key UNIQUE (country_code);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (country_id);


--
-- Name: currencies currencies_currency_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currencies
    ADD CONSTRAINT currencies_currency_code_key UNIQUE (currency_code);


--
-- Name: currencies currencies_currency_symbol_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currencies
    ADD CONSTRAINT currencies_currency_symbol_key UNIQUE (currency_symbol);


--
-- Name: currencies currencies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currencies
    ADD CONSTRAINT currencies_pkey PRIMARY KEY (currency_id);


--
-- Name: customers_accounts customers_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers_accounts
    ADD CONSTRAINT customers_accounts_pkey PRIMARY KEY (customer_account_id);


--
-- Name: customers customers_customer_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_customer_number_key UNIQUE (customer_number);


--
-- Name: customers customers_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_email_key UNIQUE (email);


--
-- Name: customers_investments customers_investments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers_investments
    ADD CONSTRAINT customers_investments_pkey PRIMARY KEY (customer_investments_id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- Name: customers customers_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_username_key UNIQUE (username);


--
-- Name: exchange_rates exchange_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchange_rates
    ADD CONSTRAINT exchange_rates_pkey PRIMARY KEY (rate_id);


--
-- Name: foreign_banks foreign_banks_foreign_bank_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foreign_banks
    ADD CONSTRAINT foreign_banks_foreign_bank_code_key UNIQUE (foreign_bank_code);


--
-- Name: foreign_banks foreign_banks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foreign_banks
    ADD CONSTRAINT foreign_banks_pkey PRIMARY KEY (foreign_bank_id);


--
-- Name: fraud_alerts fraud_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fraud_alerts
    ADD CONSTRAINT fraud_alerts_pkey PRIMARY KEY (alerts_id);


--
-- Name: investments_classes investments_classes_investment_class_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.investments_classes
    ADD CONSTRAINT investments_classes_investment_class_code_key UNIQUE (investment_class_code);


--
-- Name: investments_classes investments_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.investments_classes
    ADD CONSTRAINT investments_classes_pkey PRIMARY KEY (investment_class_id);


--
-- Name: investments investments_investment_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.investments
    ADD CONSTRAINT investments_investment_number_key UNIQUE (investment_number);


--
-- Name: investments investments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.investments
    ADD CONSTRAINT investments_pkey PRIMARY KEY (investments_id);


--
-- Name: loan_repayments loan_repayments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan_repayments
    ADD CONSTRAINT loan_repayments_pkey PRIMARY KEY (repayment_id);


--
-- Name: loans_classes loans_classes_loan_class_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans_classes
    ADD CONSTRAINT loans_classes_loan_class_code_key UNIQUE (loan_class_code);


--
-- Name: loans_classes loans_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans_classes
    ADD CONSTRAINT loans_classes_pkey PRIMARY KEY (loan_class_id);


--
-- Name: loans loans_loan_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_loan_number_key UNIQUE (loan_number);


--
-- Name: loans loans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_pkey PRIMARY KEY (loan_id);


--
-- Name: login_attempts login_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_attempts
    ADD CONSTRAINT login_attempts_pkey PRIMARY KEY (attempt_id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (notification_id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (region_id);


--
-- Name: regions regions_region_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_region_code_key UNIQUE (region_code);


--
-- Name: savings_classes savings_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.savings_classes
    ADD CONSTRAINT savings_classes_pkey PRIMARY KEY (savings_class_id);


--
-- Name: savings_classes savings_classes_savings_class_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.savings_classes
    ADD CONSTRAINT savings_classes_savings_class_code_key UNIQUE (savings_class_code);


--
-- Name: savings savings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.savings
    ADD CONSTRAINT savings_pkey PRIMARY KEY (savings_id);


--
-- Name: savings savings_savings_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.savings
    ADD CONSTRAINT savings_savings_number_key UNIQUE (savings_number);


--
-- Name: session_tokens session_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_tokens
    ADD CONSTRAINT session_tokens_pkey PRIMARY KEY (session_id);


--
-- Name: session_tokens session_tokens_token_hash_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_tokens
    ADD CONSTRAINT session_tokens_token_hash_key UNIQUE (token_hash);


--
-- Name: standing_order standing_order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standing_order
    ADD CONSTRAINT standing_order_pkey PRIMARY KEY (standing_order_id);


--
-- Name: transactions_classes transactions_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions_classes
    ADD CONSTRAINT transactions_classes_pkey PRIMARY KEY (transaction_class_id);


--
-- Name: transactions_classes transactions_classes_transaction_class_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions_classes
    ADD CONSTRAINT transactions_classes_transaction_class_code_key UNIQUE (transaction_class_code);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id);


--
-- Name: transactions transactions_transaction_reference_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_transaction_reference_key UNIQUE (transaction_reference);


--
-- Name: beneficiaries unique_beneficiary; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beneficiaries
    ADD CONSTRAINT unique_beneficiary UNIQUE (customer_id, bank_id, account_number);


--
-- Name: cards_accounts unique_card_account; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards_accounts
    ADD CONSTRAINT unique_card_account UNIQUE (card_id, account_id);


--
-- Name: customers_accounts unique_customer_account; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers_accounts
    ADD CONSTRAINT unique_customer_account UNIQUE (customer_id, account_id);


--
-- Name: customers_investments unique_customer_investment; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers_investments
    ADD CONSTRAINT unique_customer_investment UNIQUE (customer_id, investments_id);


--
-- Name: index_statements_account_statements; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_statements_account_statements ON ONLY public.account_statements USING btree (account_id, statement_year DESC, statement_month DESC);


--
-- Name: account_statements_2024_account_id_statement_year_statement_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_statements_2024_account_id_statement_year_statement_idx ON public.account_statements_2024 USING btree (account_id, statement_year DESC, statement_month DESC);


--
-- Name: index_statements_account_statements_year; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_statements_account_statements_year ON ONLY public.account_statements USING btree (customer_id, statement_year DESC);


--
-- Name: account_statements_2024_customer_id_statement_year_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_statements_2024_customer_id_statement_year_idx ON public.account_statements_2024 USING btree (customer_id, statement_year DESC);


--
-- Name: account_statements_2025_account_id_statement_year_statement_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_statements_2025_account_id_statement_year_statement_idx ON public.account_statements_2025 USING btree (account_id, statement_year DESC, statement_month DESC);


--
-- Name: account_statements_2025_customer_id_statement_year_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_statements_2025_customer_id_statement_year_idx ON public.account_statements_2025 USING btree (customer_id, statement_year DESC);


--
-- Name: account_statements_2026_account_id_statement_year_statement_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_statements_2026_account_id_statement_year_statement_idx ON public.account_statements_2026 USING btree (account_id, statement_year DESC, statement_month DESC);


--
-- Name: account_statements_2026_customer_id_statement_year_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_statements_2026_customer_id_statement_year_idx ON public.account_statements_2026 USING btree (customer_id, statement_year DESC);


--
-- Name: account_statements_2027_account_id_statement_year_statement_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_statements_2027_account_id_statement_year_statement_idx ON public.account_statements_2027 USING btree (account_id, statement_year DESC, statement_month DESC);


--
-- Name: account_statements_2027_customer_id_statement_year_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_statements_2027_customer_id_statement_year_idx ON public.account_statements_2027 USING btree (customer_id, statement_year DESC);


--
-- Name: account_statements_2028_account_id_statement_year_statement_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_statements_2028_account_id_statement_year_statement_idx ON public.account_statements_2028 USING btree (account_id, statement_year DESC, statement_month DESC);


--
-- Name: account_statements_2028_customer_id_statement_year_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_statements_2028_customer_id_statement_year_idx ON public.account_statements_2028 USING btree (customer_id, statement_year DESC);


--
-- Name: account_statements_2029_account_id_statement_year_statement_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_statements_2029_account_id_statement_year_statement_idx ON public.account_statements_2029 USING btree (account_id, statement_year DESC, statement_month DESC);


--
-- Name: account_statements_2029_customer_id_statement_year_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_statements_2029_customer_id_statement_year_idx ON public.account_statements_2029 USING btree (customer_id, statement_year DESC);


--
-- Name: account_statements_2030_account_id_statement_year_statement_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_statements_2030_account_id_statement_year_statement_idx ON public.account_statements_2030 USING btree (account_id, statement_year DESC, statement_month DESC);


--
-- Name: account_statements_2030_customer_id_statement_year_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_statements_2030_customer_id_statement_year_idx ON public.account_statements_2030 USING btree (customer_id, statement_year DESC);


--
-- Name: account_statements_default_account_id_statement_year_statem_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_statements_default_account_id_statement_year_statem_idx ON public.account_statements_default USING btree (account_id, statement_year DESC, statement_month DESC);


--
-- Name: account_statements_default_customer_id_statement_year_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_statements_default_customer_id_statement_year_idx ON public.account_statements_default USING btree (customer_id, statement_year DESC);


--
-- Name: index_accounts_balance; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_accounts_balance ON public.accounts USING btree (balance) WHERE (balance > (0)::numeric);


--
-- Name: index_accounts_currency; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_accounts_currency ON public.accounts USING btree (currency_id);


--
-- Name: index_accounts_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_accounts_number ON public.accounts USING btree (account_number);


--
-- Name: index_accounts_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_accounts_status ON public.accounts USING btree (status) WHERE (status = 'ACTIVE'::public.account_status);


--
-- Name: index_accounts_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_accounts_type ON public.accounts USING btree (account_type_id);


--
-- Name: index_audit_log_changed_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_audit_log_changed_at ON public.audit_logs USING btree (changed_at DESC);


--
-- Name: index_audit_log_table_record; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_audit_log_table_record ON public.audit_logs USING btree (table_name, record_id);


--
-- Name: index_beneficiaries_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_beneficiaries_active ON public.beneficiaries USING btree (customer_id) WHERE (is_active = true);


--
-- Name: index_beneficiaries_customer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_beneficiaries_customer ON public.beneficiaries USING btree (customer_id);


--
-- Name: index_customers_accounts_account; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_customers_accounts_account ON public.customers_accounts USING btree (account_id);


--
-- Name: index_customers_accounts_customer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_customers_accounts_customer ON public.customers_accounts USING btree (customer_id);


--
-- Name: index_customers_accounts_primary; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_customers_accounts_primary ON public.customers_accounts USING btree (customer_id, is_primary) WHERE (is_primary = true);


--
-- Name: index_customers_branch; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_customers_branch ON public.customers USING btree (branch_id);


--
-- Name: index_customers_country; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_customers_country ON public.customers USING btree (country_residence);


--
-- Name: index_customers_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_customers_created ON public.customers USING btree (created_at DESC);


--
-- Name: index_customers_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_customers_email ON public.customers USING btree (email);


--
-- Name: index_customers_investments; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_customers_investments ON public.customers_investments USING btree (investments_id);


--
-- Name: index_customers_investments_customer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_customers_investments_customer ON public.customers_investments USING btree (customer_id);


--
-- Name: index_customers_kyc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_customers_kyc ON public.customers USING btree (kyc_status) WHERE ((kyc_status)::text = 'PENDING'::text);


--
-- Name: index_customers_phone; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_customers_phone ON public.customers USING btree (phone_number);


--
-- Name: index_customers_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_customers_status ON public.customers USING btree (customer_status) WHERE ((customer_status)::text = 'ACTIVE'::text);


--
-- Name: index_customers_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_customers_username ON public.customers USING btree (username);


--
-- Name: index_fraud_alerts_customer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_fraud_alerts_customer ON public.fraud_alerts USING btree (customer_id, created_at DESC);


--
-- Name: index_fraud_alerts_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_fraud_alerts_status ON public.fraud_alerts USING btree (status) WHERE ((status)::text = 'OPEN'::text);


--
-- Name: index_investments_investment_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_investments_investment_type ON public.investments USING btree (investment_type);


--
-- Name: index_investments_maturity_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_investments_maturity_date ON public.investments USING btree (maturity_date DESC);


--
-- Name: index_ledger_account; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_ledger_account ON public.accounts_transactions USING btree (account_id);


--
-- Name: index_ledger_account_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_ledger_account_date ON public.accounts_transactions USING btree (account_id, created_at DESC);


--
-- Name: index_ledger_posted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_ledger_posted ON public.accounts_transactions USING btree (posted_at DESC);


--
-- Name: index_ledger_transaction; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_ledger_transaction ON public.accounts_transactions USING btree (transaction_id);


--
-- Name: index_loans_customer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_loans_customer ON public.loans USING btree (customer_id);


--
-- Name: index_loans_maturity; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_loans_maturity ON public.loans USING btree (maturity_date) WHERE (status = 'ACTIVE'::public.loan_status);


--
-- Name: index_loans_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_loans_status ON public.loans USING btree (status) WHERE (status = ANY (ARRAY['ACTIVE'::public.loan_status, 'OVERDUE'::public.loan_status]));


--
-- Name: index_loans_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_loans_type ON public.loans USING btree (loan_type);


--
-- Name: index_login_attempts_customer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_login_attempts_customer ON public.login_attempts USING btree (customer_id, attempted_at DESC);


--
-- Name: index_login_attempts_ip; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_login_attempts_ip ON public.login_attempts USING btree (ip_address, attempted_at DESC);


--
-- Name: index_notifications_customer_unread; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_notifications_customer_unread ON public.notifications USING btree (customer_id, is_read);


--
-- Name: index_notifications_sent_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_notifications_sent_at ON public.notifications USING btree (sent_at DESC);


--
-- Name: index_savings_customer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_savings_customer ON public.savings USING btree (customer_id);


--
-- Name: index_savings_maturity; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_savings_maturity ON public.savings USING btree (maturity_date) WHERE (status = 'ACTIVE'::public.savings_status);


--
-- Name: index_savings_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_savings_status ON public.savings USING btree (status) WHERE (status = 'ACTIVE'::public.savings_status);


--
-- Name: index_session_tokens_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_session_tokens_active ON public.session_tokens USING btree (token_hash) WHERE (is_active = true);


--
-- Name: index_session_tokens_customer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_session_tokens_customer ON public.session_tokens USING btree (customer_id);


--
-- Name: index_transactions_customer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_transactions_customer ON public.transactions USING btree (initiated_by);


--
-- Name: index_transactions_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_transactions_date ON public.transactions USING btree (transaction_date DESC);


--
-- Name: index_transactions_reference; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_transactions_reference ON public.transactions USING btree (transaction_reference);


--
-- Name: index_transactions_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_transactions_status ON public.transactions USING btree (status);


--
-- Name: index_transactions_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_transactions_type ON public.transactions USING btree (transaction_type);


--
-- Name: account_statements_2024_account_id_statement_year_statement_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.index_statements_account_statements ATTACH PARTITION public.account_statements_2024_account_id_statement_year_statement_idx;


--
-- Name: account_statements_2024_customer_id_statement_year_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.index_statements_account_statements_year ATTACH PARTITION public.account_statements_2024_customer_id_statement_year_idx;


--
-- Name: account_statements_2024_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.account_statements_pkey ATTACH PARTITION public.account_statements_2024_pkey;


--
-- Name: account_statements_2025_account_id_statement_year_statement_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.index_statements_account_statements ATTACH PARTITION public.account_statements_2025_account_id_statement_year_statement_idx;


--
-- Name: account_statements_2025_customer_id_statement_year_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.index_statements_account_statements_year ATTACH PARTITION public.account_statements_2025_customer_id_statement_year_idx;


--
-- Name: account_statements_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.account_statements_pkey ATTACH PARTITION public.account_statements_2025_pkey;


--
-- Name: account_statements_2026_account_id_statement_year_statement_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.index_statements_account_statements ATTACH PARTITION public.account_statements_2026_account_id_statement_year_statement_idx;


--
-- Name: account_statements_2026_customer_id_statement_year_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.index_statements_account_statements_year ATTACH PARTITION public.account_statements_2026_customer_id_statement_year_idx;


--
-- Name: account_statements_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.account_statements_pkey ATTACH PARTITION public.account_statements_2026_pkey;


--
-- Name: account_statements_2027_account_id_statement_year_statement_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.index_statements_account_statements ATTACH PARTITION public.account_statements_2027_account_id_statement_year_statement_idx;


--
-- Name: account_statements_2027_customer_id_statement_year_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.index_statements_account_statements_year ATTACH PARTITION public.account_statements_2027_customer_id_statement_year_idx;


--
-- Name: account_statements_2027_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.account_statements_pkey ATTACH PARTITION public.account_statements_2027_pkey;


--
-- Name: account_statements_2028_account_id_statement_year_statement_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.index_statements_account_statements ATTACH PARTITION public.account_statements_2028_account_id_statement_year_statement_idx;


--
-- Name: account_statements_2028_customer_id_statement_year_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.index_statements_account_statements_year ATTACH PARTITION public.account_statements_2028_customer_id_statement_year_idx;


--
-- Name: account_statements_2028_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.account_statements_pkey ATTACH PARTITION public.account_statements_2028_pkey;


--
-- Name: account_statements_2029_account_id_statement_year_statement_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.index_statements_account_statements ATTACH PARTITION public.account_statements_2029_account_id_statement_year_statement_idx;


--
-- Name: account_statements_2029_customer_id_statement_year_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.index_statements_account_statements_year ATTACH PARTITION public.account_statements_2029_customer_id_statement_year_idx;


--
-- Name: account_statements_2029_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.account_statements_pkey ATTACH PARTITION public.account_statements_2029_pkey;


--
-- Name: account_statements_2030_account_id_statement_year_statement_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.index_statements_account_statements ATTACH PARTITION public.account_statements_2030_account_id_statement_year_statement_idx;


--
-- Name: account_statements_2030_customer_id_statement_year_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.index_statements_account_statements_year ATTACH PARTITION public.account_statements_2030_customer_id_statement_year_idx;


--
-- Name: account_statements_2030_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.account_statements_pkey ATTACH PARTITION public.account_statements_2030_pkey;


--
-- Name: account_statements_default_account_id_statement_year_statem_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.index_statements_account_statements ATTACH PARTITION public.account_statements_default_account_id_statement_year_statem_idx;


--
-- Name: account_statements_default_customer_id_statement_year_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.index_statements_account_statements_year ATTACH PARTITION public.account_statements_default_customer_id_statement_year_idx;


--
-- Name: account_statements_default_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.account_statements_pkey ATTACH PARTITION public.account_statements_default_pkey;


--
-- Name: account_fees account_fees_account_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_fees
    ADD CONSTRAINT account_fees_account_class_id_fkey FOREIGN KEY (account_class_id) REFERENCES public.accounts_classes(account_class_id);


--
-- Name: account_fees account_fees_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_fees
    ADD CONSTRAINT account_fees_currency_id_fkey FOREIGN KEY (currency_id) REFERENCES public.currencies(currency_id) ON DELETE RESTRICT;


--
-- Name: account_fees account_fees_transaction_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_fees
    ADD CONSTRAINT account_fees_transaction_class_id_fkey FOREIGN KEY (transaction_class_id) REFERENCES public.transactions_classes(transaction_class_id);


--
-- Name: account_statements account_statements_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.account_statements
    ADD CONSTRAINT account_statements_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(account_id) ON DELETE CASCADE;


--
-- Name: account_statements account_statements_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.account_statements
    ADD CONSTRAINT account_statements_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) ON DELETE CASCADE;


--
-- Name: accounts accounts_account_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_account_type_id_fkey FOREIGN KEY (account_type_id) REFERENCES public.accounts_classes(account_class_id) ON DELETE RESTRICT;


--
-- Name: accounts accounts_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_currency_id_fkey FOREIGN KEY (currency_id) REFERENCES public.currencies(currency_id) ON DELETE RESTRICT;


--
-- Name: accounts_transactions accounts_transactions_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_transactions
    ADD CONSTRAINT accounts_transactions_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(account_id) ON DELETE RESTRICT;


--
-- Name: accounts_transactions accounts_transactions_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts_transactions
    ADD CONSTRAINT accounts_transactions_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(transaction_id) ON DELETE RESTRICT;


--
-- Name: applied_fees applied_fees_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applied_fees
    ADD CONSTRAINT applied_fees_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(account_id) ON DELETE CASCADE;


--
-- Name: applied_fees applied_fees_fee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applied_fees
    ADD CONSTRAINT applied_fees_fee_id_fkey FOREIGN KEY (fee_id) REFERENCES public.account_fees(fee_id) ON DELETE RESTRICT;


--
-- Name: applied_fees applied_fees_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applied_fees
    ADD CONSTRAINT applied_fees_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(transaction_id) ON DELETE SET NULL;


--
-- Name: applied_fees applied_fees_waived_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applied_fees
    ADD CONSTRAINT applied_fees_waived_by_fkey FOREIGN KEY (waived_by) REFERENCES public.customers(customer_id) ON DELETE SET NULL;


--
-- Name: audit_logs audit_logs_changed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES public.customers(customer_id) ON DELETE SET NULL;


--
-- Name: beneficiaries beneficiaries_bank_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beneficiaries
    ADD CONSTRAINT beneficiaries_bank_id_fkey FOREIGN KEY (bank_id) REFERENCES public.foreign_banks(foreign_bank_id) ON DELETE SET NULL;


--
-- Name: beneficiaries beneficiaries_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beneficiaries
    ADD CONSTRAINT beneficiaries_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) ON DELETE CASCADE;


--
-- Name: cards_accounts cards_accounts_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards_accounts
    ADD CONSTRAINT cards_accounts_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(account_id) ON DELETE CASCADE;


--
-- Name: cards_accounts cards_accounts_card_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards_accounts
    ADD CONSTRAINT cards_accounts_card_id_fkey FOREIGN KEY (card_id) REFERENCES public.cards(card_id) ON DELETE CASCADE;


--
-- Name: cards cards_card_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_card_class_id_fkey FOREIGN KEY (card_class_id) REFERENCES public.cards_classes(card_class_id);


--
-- Name: cards_classes cards_classes_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards_classes
    ADD CONSTRAINT cards_classes_currency_id_fkey FOREIGN KEY (currency_id) REFERENCES public.currencies(currency_id) ON DELETE RESTRICT;


--
-- Name: cards cards_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(country_id) ON DELETE RESTRICT;


--
-- Name: customers_accounts customers_accounts_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers_accounts
    ADD CONSTRAINT customers_accounts_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(account_id) ON DELETE RESTRICT;


--
-- Name: customers_accounts customers_accounts_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers_accounts
    ADD CONSTRAINT customers_accounts_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) ON DELETE RESTRICT;


--
-- Name: customers customers_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(branch_id);


--
-- Name: customers customers_country_nationality_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_country_nationality_fkey FOREIGN KEY (country_nationality) REFERENCES public.countries(country_id) ON DELETE RESTRICT;


--
-- Name: customers customers_country_residence_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_country_residence_fkey FOREIGN KEY (country_residence) REFERENCES public.countries(country_id) ON DELETE RESTRICT;


--
-- Name: customers_investments customers_investments_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers_investments
    ADD CONSTRAINT customers_investments_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) ON DELETE RESTRICT;


--
-- Name: customers_investments customers_investments_investments_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers_investments
    ADD CONSTRAINT customers_investments_investments_id_fkey FOREIGN KEY (investments_id) REFERENCES public.investments(investments_id) ON DELETE RESTRICT;


--
-- Name: customers customers_state_of_origin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_state_of_origin_fkey FOREIGN KEY (state_of_origin) REFERENCES public.regions(region_id) ON DELETE SET NULL;


--
-- Name: customers customers_state_of_residence_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_state_of_residence_fkey FOREIGN KEY (state_of_residence) REFERENCES public.regions(region_id) ON DELETE SET NULL;


--
-- Name: exchange_rates exchange_rates_from_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchange_rates
    ADD CONSTRAINT exchange_rates_from_currency_id_fkey FOREIGN KEY (from_currency_id) REFERENCES public.currencies(currency_id) ON DELETE CASCADE;


--
-- Name: exchange_rates exchange_rates_to_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchange_rates
    ADD CONSTRAINT exchange_rates_to_currency_id_fkey FOREIGN KEY (to_currency_id) REFERENCES public.currencies(currency_id) ON DELETE CASCADE;


--
-- Name: foreign_banks foreign_banks_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foreign_banks
    ADD CONSTRAINT foreign_banks_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(country_id) ON DELETE SET NULL;


--
-- Name: fraud_alerts fraud_alerts_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fraud_alerts
    ADD CONSTRAINT fraud_alerts_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(account_id) ON DELETE CASCADE;


--
-- Name: fraud_alerts fraud_alerts_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fraud_alerts
    ADD CONSTRAINT fraud_alerts_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) ON DELETE CASCADE;


--
-- Name: fraud_alerts fraud_alerts_resolved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fraud_alerts
    ADD CONSTRAINT fraud_alerts_resolved_by_fkey FOREIGN KEY (resolved_by) REFERENCES public.customers(customer_id) ON DELETE SET NULL;


--
-- Name: fraud_alerts fraud_alerts_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fraud_alerts
    ADD CONSTRAINT fraud_alerts_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(transaction_id) ON DELETE SET NULL;


--
-- Name: investments investments_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.investments
    ADD CONSTRAINT investments_currency_id_fkey FOREIGN KEY (currency_id) REFERENCES public.currencies(currency_id) ON DELETE RESTRICT;


--
-- Name: investments investments_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.investments
    ADD CONSTRAINT investments_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) ON DELETE RESTRICT;


--
-- Name: investments investments_investment_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.investments
    ADD CONSTRAINT investments_investment_type_fkey FOREIGN KEY (investment_type) REFERENCES public.investments_classes(investment_class_id) ON DELETE CASCADE;


--
-- Name: loan_repayments loan_repayments_loan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan_repayments
    ADD CONSTRAINT loan_repayments_loan_id_fkey FOREIGN KEY (loan_id) REFERENCES public.loans(loan_id) ON DELETE CASCADE;


--
-- Name: loan_repayments loan_repayments_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan_repayments
    ADD CONSTRAINT loan_repayments_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(transaction_id) ON DELETE SET NULL;


--
-- Name: loans loans_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.customers(customer_id) ON DELETE SET NULL;


--
-- Name: loans loans_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_currency_id_fkey FOREIGN KEY (currency_id) REFERENCES public.currencies(currency_id) ON DELETE RESTRICT;


--
-- Name: loans loans_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) ON DELETE CASCADE;


--
-- Name: loans loans_disbursement_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_disbursement_account_id_fkey FOREIGN KEY (disbursement_account_id) REFERENCES public.accounts(account_id) ON DELETE SET NULL;


--
-- Name: loans loans_loan_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_loan_type_fkey FOREIGN KEY (loan_type) REFERENCES public.loans_classes(loan_class_id) ON DELETE RESTRICT;


--
-- Name: loans loans_repayment_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_repayment_account_id_fkey FOREIGN KEY (repayment_account_id) REFERENCES public.accounts(account_id) ON DELETE SET NULL;


--
-- Name: login_attempts login_attempts_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_attempts
    ADD CONSTRAINT login_attempts_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) ON DELETE CASCADE;


--
-- Name: notifications notifications_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) ON DELETE CASCADE;


--
-- Name: regions regions_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(country_id) ON DELETE CASCADE;


--
-- Name: savings savings_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.savings
    ADD CONSTRAINT savings_currency_id_fkey FOREIGN KEY (currency_id) REFERENCES public.currencies(currency_id) ON DELETE RESTRICT;


--
-- Name: savings savings_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.savings
    ADD CONSTRAINT savings_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) ON DELETE RESTRICT;


--
-- Name: savings savings_savings_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.savings
    ADD CONSTRAINT savings_savings_type_fkey FOREIGN KEY (savings_type) REFERENCES public.savings_classes(savings_class_id) ON DELETE RESTRICT;


--
-- Name: session_tokens session_tokens_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_tokens
    ADD CONSTRAINT session_tokens_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) ON DELETE CASCADE;


--
-- Name: standing_order standing_order_beneficiary_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standing_order
    ADD CONSTRAINT standing_order_beneficiary_id_fkey FOREIGN KEY (beneficiary_id) REFERENCES public.beneficiaries(beneficiary_id);


--
-- Name: standing_order standing_order_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standing_order
    ADD CONSTRAINT standing_order_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: standing_order standing_order_from_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standing_order
    ADD CONSTRAINT standing_order_from_account_id_fkey FOREIGN KEY (from_account_id) REFERENCES public.accounts(account_id);


--
-- Name: transactions transactions_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_currency_id_fkey FOREIGN KEY (currency_id) REFERENCES public.currencies(currency_id) ON DELETE RESTRICT;


--
-- Name: transactions transactions_external_bank_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_external_bank_id_fkey FOREIGN KEY (external_bank_id) REFERENCES public.foreign_banks(foreign_bank_id) ON DELETE SET NULL;


--
-- Name: transactions transactions_initiated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_initiated_by_fkey FOREIGN KEY (initiated_by) REFERENCES public.customers(customer_id) ON DELETE RESTRICT;


--
-- Name: transactions transactions_reversal_of_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_reversal_of_transaction_id_fkey FOREIGN KEY (reversal_of_transaction_id) REFERENCES public.transactions(transaction_id) ON DELETE SET NULL;


--
-- Name: transactions transactions_reversed_by_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_reversed_by_transaction_id_fkey FOREIGN KEY (reversed_by_transaction_id) REFERENCES public.transactions(transaction_id) ON DELETE SET NULL;


--
-- Name: transactions transactions_transaction_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_transaction_type_fkey FOREIGN KEY (transaction_type) REFERENCES public.transactions_classes(transaction_class_id) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict 8YYtFLD9bwme7MiCKxm1aXQR7RpxPaArjmdiBaHILpdbAKaTHhbEP9VaSy0NxIk

