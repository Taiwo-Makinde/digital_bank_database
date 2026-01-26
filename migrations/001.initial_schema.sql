-- ====================================================================================================
-- DIGITAL BANKING DATABASE SCHEMA 
-- ====================================================================================================
-- This schema defines a comprehensive database for digital banking with support for:
-- Customer on-boarding and account creation
-- Account management for global users and multi-currency support
-- Transaction processing with doublre-entry book-keeping
-- Financial accounting & general ledger
-- Loan management system with interest tracking.
-- Savings and investments with maturity tracking
-- Security, compliance and risk management
-- Audit trails and activity logging
-- ====================================================================================================	


-- ===================================================================================================
-- ENUM TYPE 
--We should create custom data types that enumerate the sort of information we want contained in our columns.
-- Custom datat types that enumerate valid values for columns 
-- This is a neccesary data validation process
-- ====================================================================================================


CREATE TYPE marital_type AS ENUM ('Single', 'Married', 'Separated', 'Divorced', 'Widowed');

CREATE TYPE gender_status AS ENUM ('Male', 'Female', 'Other', 'Prefer Not to Say');

CREATE TYPE employment_type AS ENUM ('Student','Unemployed', 'Employed', 'Self_Employed', 'Retired');

CREATE TYPE religion_type AS ENUM ('Christian', 'Muslim', 'Jewish', 'Hindu','Buddhist', 'Taiost', 'Atheist', 'Agnostic', 'Other');

CREATE TYPE race_type AS ENUM ('Black/African', 'White', 'Asian', 'Native American', 'Pacific Islander', 'Hispanic', 'Biracial'); 

CREATE TYPE account_status AS ENUM ('ACTIVE', 'FROZEN', 'DORMANT', 'CLOSED', 'PENDING_ACTIVATION');

CREATE TYPE transaction_status AS ENUM ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED', 'REVERSED', 'CANCELED');

CREATE TYPE loan_status AS ENUM ('PENDING', 'APPROVED', 'DISBURSED', 'ACTIVE', 'OVERDUE', 'PAID_OFF', 'DEFAULTED', 'WRITTEN_OFF');

CREATE TYPE savings_status AS ENUM ('ACTIVE', 'MATURED', 'CLOSED', 'WITHDRAWN');

CREATE TYPE risk_type AS ENUM ('LOW', 'MEDIUM', 'HIGH'); 

-- ====================================================================================================
-- LOOKUP/REFRENCE TABLES 
-- These tables provide standardized reference data
-- It is standard practice to begin with lookup/reference tables as theSE tables do not have dependencies. 
-- ====================================================================================================

CREATE TABLE countries(
			country_id BIGSERIAL PRIMARY KEY, 
			country_code VARCHAR(2) NOT NULL UNIQUE,
			country_name VARCHAR(255) NOT NULL,
			currency_code VARCHAR(3),
			phone_code VARCHAR(5),
			is_active BOOLEAN DEFAULT TRUE,
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
			);	

CREATE TABLE branches(
			branch_id BIGSERIAL PRIMARY KEY,
			branch_code VARCHAR(10) NOT NULL UNIQUE, 
			branch_name VARCHAR(255) NOT NULL,
			branch_address VARCHAR(700) NOT NULL,
			city VARCHAR(100),
			state_name VARCHAR(100),
			postal_code VARCHAR(20),
			phone_number VARCHAR(25),
			email VARCHAR(255),
			manager_name VARCHAR(255),
			is_active BOOLEAN DEFAULT TRUE,
			established_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
			updated_at TIMESTAMPTZ
			);

CREATE TABLE accounts_classes (
			account_class_id BIGSERIAL PRIMARY KEY,
			account_class_code VARCHAR(10) NOT NULL UNIQUE,
			account_class_name VARCHAR(100) NOT NULL UNIQUE,
			description TEXT,
			minimum_balance DECIMAL(19,4) DEFAULT 0.00,
			has_maximum_restriction BOOLEAN DEFAULT FALSE,
			maximum_balance DECIMAL(19,4),
			allows_overdraft BOOLEAN DEFAULT FALSE, 
			overdraft_limit DECIMAL (19,4),
			is_active BOOLEAN DEFAULT TRUE,
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP 
			);

CREATE TABLE savings_classes (
			savings_class_id  BIGSERIAL PRIMARY KEY,
			savings_class_code VARCHAR(10) NOT NULL UNIQUE,
			savings_class_name VARCHAR(255) NOT NULL,
			description TEXT,
			interest_rate DECIMAL (5,2) NOT NULL,
			min_amount DECIMAL(19,4),
			maximum_amount DECIMAL(19,4),
			minimum_tenure_months INT,
			early_withdrawal_penalty DECIMAL(5,2),
			is_active BOOLEAN DEFAULT TRUE,
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
			);
			
CREATE TABLE investments_classes (
			investment_class_id BIGSERIAL PRIMARY KEY,
			investment_class_code VARCHAR(10) NOT NULL UNIQUE,
			investment_class_name VARCHAR(255) NOT NULL,
			description TEXT,
			expected_return_rate DECIMAL(5,2),
			risk_level risk_type NOT NULL,
			minimum_amount DECIMAL (19,4),
			maximum_amount DECIMAL (19,4),
			minimum_tenure_months INT,
			is_active BOOLEAN DEFAULT TRUE,
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
			);

CREATE TABLE loans_classes(
			loan_class_id BIGSERIAL PRIMARY KEY,
			loan_class_code VARCHAR(10) NOT NULL UNIQUE,
			loan_class_name VARCHAR(255) NOT NULL,
			description TEXT,
			base_interest_rate DECIMAL (5,2) NOT NULL,
			maximum_tenure_months INT,
			minimum_amount DECIMAL (19,4),
			maximum_amount DECIMAL (19,4),
			processing_fee_percent DECIMAL(5,2),
			requires_collateral BOOLEAN DEFAULT TRUE,
			is_active BOOLEAN DEFAULT TRUE,
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
			);

CREATE TABLE transactions_classes(
			transaction_class_id BIGSERIAL PRIMARY KEY,
			transaction_class_code VARCHAR(10) NOT NULL UNIQUE,
			transaction_class_name VARCHAR(100) NOT NULL,
			transaction_category VARCHAR(50),
			description TEXT,
			is_reversible BOOLEAN DEFAULT TRUE,
			requires_approval BOOLEAN DEFAULT FALSE,
			--fee_amount DECIMAL(19,4),
			--fee_percent DECIMAL(5,2),
			is_active BOOLEAN DEFAULT TRUE,
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP 
			);

CREATE TABLE foreign_banks (
			foreign_bank_id BIGSERIAL PRIMARY KEY,
			foreign_bank_code VARCHAR(5) NOT NULL UNIQUE,
			foreign_bank_name VARCHAR(200) NOT NULL,
			country_id BIGINT REFERENCES countries(country_id) ON DELETE SET NULL,
			swift_code VARCHAR(11),
			routing_number VARCHAR(20),
			is_active BOOLEAN DEFAULT TRUE,
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
			);

CREATE TABLE currencies(
			currency_id BIGSERIAL PRIMARY KEY,
			currency_code VARCHAR(3) NOT NULL UNIQUE,
			currency_name VARCHAR(100) NOT NULL,
			currency_symbol VARCHAR(5) NOT NULL UNIQUE,
			is_active BOOLEAN DEFAULT TRUE,
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
			);

CREATE TABLE exchange_rates (
			rate_id BIGSERIAL PRIMARY KEY,
			from_currency_id BIGINT NOT NULL REFERENCES currencies(currency_id) ON DELETE CASCADE,
			to_currency_id BIGINT NOT NULL REFERENCES currencies(currency_id) ON DELETE CASCADE,
			rate DECIMAL (15,6) NOT NULL,
			effective_from TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			effective_to TIMESTAMPTZ,
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			-- CONSTRAINTS
			CONSTRAINT check_different_currencies CHECK (from_currency_id != to_currency_id),
			CONSTRAINT check_positive_rate CHECK (rate > 0)
			);

CREATE TABLE cards_classes(
			card_class_id BIGSERIAL PRIMARY KEY,
			card_class_code VARCHAR(6) UNIQUE,
			card_class_name VARCHAR(100),
			currency_id BIGINT NOT NULL REFERENCES currencies(currency_id) ON DELETE RESTRICT, 
			is_active BOOLEAN DEFAULT TRUE,
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
			);

-- =====================================================================================================
-- CORE ENTITY TABLES
-- These tables are the core entity tables that form the basis of nexus poins of the schema
-- Entity tables are the building blocks for junction tables
-- =====================================================================================================
CREATE TABLE regions(
			region_id BIGSERIAL PRIMARY KEY,
			region_code VARCHAR(3) NOT NULL UNIQUE, 
			region_name VARCHAR(100) NOT NULL,
			country_id BIGINT NOT NULL REFERENCES countries(country_id) ON DELETE CASCADE,
			is_active BOOLEAN DEFAULT TRUE,
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP 
			);

CREATE TABLE customers(
			customer_id BIGSERIAL PRIMARY KEY,
			customer_number VARCHAR(30) NOT NULL UNIQUE, 
			first_name VARCHAR(255) NOT NULL, 
			middle_name VARCHAR(255),
			last_name VARCHAR(255) NOT NULL,
			gender gender_status NOT NULL,
			date_of_birth DATE NOT NULL,
			marital_status marital_type NOT NULL,
			religion religion_type,
			race race_type,
			-- EMPLOYMENT SECTION
			employment_status employment_type NOT NULL,
			employer_name VARCHAR(255),
			occupation VARCHAR(100),
			annual_income DECIMAL(19,4),
			-- BIODATA 
			state_of_origin BIGINT REFERENCES regions(region_id) ON DELETE SET NULL, -- Some countries have no regiuon
			country_nationality BIGINT NOT NULL REFERENCES countries(country_id) ON DELETE RESTRICT,
			-- DATA FOR APP LOGIN 
			email VARCHAR(255) NOT NULL UNIQUE,
			email_verified BOOLEAN DEFAULT FALSE,
			username VARCHAR(50) NOT NULL UNIQUE,
			password_hash VARCHAR(100) NOT NULL,
			-- OTHER CONTACT INFORMATION
			phone_number VARCHAR(25) NOT NULL,
			phone_verified BOOLEAN DEFAULT FALSE,
			address VARCHAR(500) NOT NULL, 
			city VARCHAR(100),
			postal_code VARCHAR(20),
			state_of_residence BIGINT REFERENCES regions(region_id) ON DELETE SET NULL,
			country_residence BIGINT NOT NULL REFERENCES countries(country_id) ON DELETE RESTRICT,
			-- IDENTIFICATIONS DOCUMENTS 
			id_type VARCHAR(50), 
			id_number VARCHAR(50),
			id_expiry_date DATE,
			tax_id_number VARCHAR(50),
			-- NEXT OF KIN DETAILS
			mothers_maiden_name VARCHAR(255) NOT NULL,
			next_of_kin VARCHAR(255) NOT NULL,
			next_of_kin_relationship VARCHAR(50),
			email_next_of_kin VARCHAR(255),
			contact_next_of_kin VARCHAR(25) NOT NULL,
			-- CUSTOMER MANAGEMENT AND RELATIONSHIP DATA
			branch_id BIGINT REFERENCES branches(branch_id), -- Since it is a digital banking database, a customer might not be aligned with a physical branch
			customer_status VARCHAR(20),
			kyc_status VARCHAR(20) DEFAULT 'PENDING',
			kyc_verified_at TIMESTAMPTZ,
			-- ACCOUNTS STATUS 
			accounts_locked BOOLEAN DEFAULT FALSE,
			failed_login_attempts INT DEFAULT 0,
			last_login_attempt TIMESTAMPTZ, 
			last_login_ip INET,
			-- TIMESERIES DATA
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			-- CONSTRAINTS
			CONSTRAINT check_adult CHECK(date_of_birth <= CURRENT_DATE - INTERVAL '18 years' ),
			CONSTRAINT check_valid_email CHECK(email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
			);

CREATE TABLE accounts(
			account_id BIGSERIAL PRIMARY KEY,
			account_number VARCHAR(100) NOT NULL UNIQUE,
			account_type_id BIGINT NOT NULL REFERENCES accounts_classes(account_class_id) ON DELETE RESTRICT,
			currency_id BIGINT NOT NULL REFERENCES currencies(currency_id) ON DELETE RESTRICT,
			balance DECIMAL (19,4) NOT NULL DEFAULT 0.00, 
			available_balance DECIMAL(19,4) NOT NULL DEFAULT 0.00,
			overdraft_limit DECIMAL(19,4) DEFAULT 0.00,
			interest_rate DECIMAL(5,2),
			status account_status NOT NULL DEFAULT 'PENDING_ACTIVATION',
			opened_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			closed_at TIMESTAMPTZ,
			last_transaction_at TIMESTAMPTZ,
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			updated_at TIMESTAMPTZ,
			-- CONSTRAINTS			
			CONSTRAINT account_number_length CHECK (char_length(account_number) <= 10),
			/* All account numbers in Nigeria at the present are 10 characters. 
			But this limit is expected to increase as the population grows.
			 10 characters is not a data requirement but a business rule subject to change. 
			This is why I think the 10 character limit should be a constraint not a length specifier. 
			*/
			CONSTRAINT check_balance_within_limit CHECK ( balance >= -(COALESCE(overdraft_limit,0))),
			CONSTRAINT check_available_balance CHECK (available_balance <= balance)
			);

CREATE TABLE transactions(
			transaction_id BIGSERIAL PRIMARY KEY,
			transaction_reference VARCHAR(50) NOT NULL UNIQUE,
 			transaction_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			transaction_type BIGINT NOT NULL REFERENCES transactions_classes(transaction_class_id) ON DELETE RESTRICT,
			description VARCHAR(255) NOT NULL,
			reference_number VARCHAR(255),
			-- ADDITIONAL METADATA
			amount DECIMAL(19,4) NOT NULL,
			currency_id BIGINT REFERENCES currencies(currency_id) ON DELETE RESTRICT,
			--STATUS TRACKING
			status transaction_status NOT NULL DEFAULT 'PENDING',
			initiated_by BIGINT REFERENCES customers(customer_id) ON DELETE RESTRICT,
			--EXTERNAL REFERENCES
			external_references VARCHAR(255),
			external_bank_id BIGINT REFERENCES foreign_banks(foreign_bank_id) ON DELETE SET NULL,
			exchange_rate DECIMAL (15,6),
			--REVERSAL TRACKING 
			--Reversal transactions : This is a new transaction that reversies an earlier transaction
			reversal_of_transaction_id BIGINT REFERENCES transactions(transaction_id) ON DELETE SET NULL,
			--Reversed transactions : This is a transaction that confirms a reversal
			reversed_by_transaction_id BIGINT REFERENCES transactions(transaction_id) ON DELETE SET NULL,
			reversal_reason TEXT,
			--TIMESTAMPS
			completed_at TIMESTAMPTZ,
			reversed_at TIMESTAMPTZ,
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			-- CONSTRAINTS
			CONSTRAINT check_positive_amount CHECK (amount > 0),
			CONSTRAINT check_reversal_integrity CHECK (
			--REVERSALS MUST REFERENCE AN ORIGINAL TRANSACTION
			(reversal_of_transaction_id IS NOT NULL AND reversed_by_transaction_id IS NULL) OR 
			--REVERSED TRANSACTIONS MUST REFERENCE THE RESERVAL TRANSACTION
			(reversal_of_transaction_id IS NULL AND reversed_by_transaction_id IS NOT NULL ) OR 
			--WE COULD HAVE A TRANSACTION THAT IS NEITHER REVERSAL TRANSACTION NOR A REVERSED TRANSACTION
			(reversal_of_transaction_id IS NULL AND reversed_by_transaction_id IS NULL)
			)
			); 

CREATE TABLE beneficiaries(
			beneficiary_id BIGSERIAL PRIMARY KEY, 
			customer_id BIGINT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
			bank_id BIGINT NOT NULL REFERENCES foreign_banks(foreign_bank_id) ON DELETE SET NULL,
			account_name VARCHAR(255) NOT NULL,
			account_number VARCHAR(100) NOT NULL,
			nickname VARCHAR(100),
			bank_name VARCHAR(200),
			is_verified BOOLEAN DEFAULT FALSE,
			is_active BOOLEAN DEFAULT TRUE,
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			updated_at TIMESTAMP,
			-- CONSTRAINTS
			CONSTRAINT account_number_length CHECK (char_length(account_number) <= 10),
			CONSTRAINT unique_beneficiary UNIQUE (customer_id, bank_id, account_number)
			);

CREATE TABLE savings(
			savings_id BIGSERIAL PRIMARY KEY,
			savings_number VARCHAR(30) NOT NULL UNIQUE,
			customer_id BIGINT NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
			savings_type BIGINT NOT NULL REFERENCES savings_classes(savings_class_id) ON DELETE RESTRICT,
			currency_id BIGINT NOT NULL REFERENCES currencies(currency_id) ON DELETE RESTRICT,
			savings_name TEXT,
			-- SAVING DETAILS
			principal_amount DECIMAL(19,4) NOT NULL,
			interest_rate DECIMAL(5,2) NOT NULL,
			tenure_months INT,
			start_date DATE NOT NULL DEFAULT CURRENT_DATE,
			maturity_date DATE,
			interest_earned DECIMAL(19,4) DEFAULT 0.00,
			current_balance DECIMAL (19,4) NOT NULL,	
			status savings_status NOT NULL DEFAULT 'ACTIVE',
			auto_renew BOOLEAN DEFAULT FALSE,
			last_interest_calculation TIMESTAMPTZ,
			-- TIME SERIES DATA
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			updated_at TIMESTAMPTZ,
			closed_at TIMESTAMPTZ,
			-- CONSTRAINTS
			CONSTRAINT check_positive_principal CHECK (principal_amount > 0),
			CONSTRAINT check_maturity_after_start CHECK (maturity_date IS NULL OR maturity_date > start_date)	 
			);
			
CREATE TABLE investments(
			investments_id BIGSERIAL PRIMARY KEY,
			investment_number VARCHAR(20) NOT NULL UNIQUE,
			customer_id BIGINT REFERENCES customers(customer_id) ON DELETE RESTRICT, 
			investment_type BIGINT NOT NULL REFERENCES investments_classes(investment_class_id) ON DELETE CASCADE,
			is_joint BOOLEAN DEFAULT FALSE, 
			--TOTAL INVESTEMENTS AMOUNT COMBINED FROM ALL INVESTORS
			total_principal_amount DECIMAL(19,4) NOT NULL,
			current_value DECIMAL(19,4) NOT NULL,
			total_returns_earned DECIMAL(19,4) DEFAULT 0.00,
			currency_id BIGINT NOT NULL REFERENCES currencies(currency_id) ON DELETE RESTRICT,
			expected_return_rate DECIMAL(5,2),
			units DECIMAL(15,4),
			unit_price DECIMAL(19,4),
			start_date DATE NOT NULL DEFAULT CURRENT_DATE,
			maturity_date DATE,
			status VARCHAR(20) DEFAULT 'ACTIVE',
			last_valuation_date TIMESTAMPTZ,
			--OTHER TIMESERIES DATA
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			updated_at TIMESTAMPTZ,
			-- CONSTRAINTS			
			CONSTRAINT check_positive_investment CHECK (total_principal_amount > 0)
			); 

CREATE TABLE loans(
			loan_id BIGSERIAL PRIMARY KEY,
			loan_number VARCHAR(20) NOT NULL UNIQUE,
			customer_id BIGINT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
			loan_type BIGINT NOT NULL REFERENCES loans_classes(loan_class_id) ON DELETE RESTRICT,
			--LOAN AMOUNTS
			principal_amount DECIMAL(19,4) NOT NULL,
			outstanding_amount DECIMAL(19,4) NOT NULL,
			interest_amount DECIMAL(19,4) NOT NULL DEFAULT 0.00,
			total_amount DECIMAL(19,4) NOT NULL,
			currency_id BIGINT NOT NULL REFERENCES currencies(currency_id) ON DELETE RESTRICT,
			--INTEREST AND TENURE 
			interest_rate DECIMAL(5,2) NOT NULL,
			tenure_months INT NOT NULL,
			monthly_payment DECIMAL(19,4) NOT NULL,	
			--DATES
			application_date DATE NOT NULL DEFAULT CURRENT_DATE,
			approval_date  DATE,
			disbursement_date DATE,
			first_payment_date DATE,
			maturity_date DATE,
			--STATUS
			status loan_status NOT NULL DEFAULT 'PENDING',
			--COLLATERAL
			collateral_type VARCHAR(100),
			collateral_value DECIMAL(19,4),
			collateral_description TEXT, 
			--ACCOUNTS FOR DISPBURSEMENT AND PAYMENT
			disbursement_account_id BIGINT REFERENCES accounts(account_id) ON DELETE SET NULL,
			repayment_account_id BIGINT REFERENCES accounts(account_id) ON DELETE SET NULL,
			--APPROVAL
			approved_by BIGINT REFERENCES customers(customer_id) ON DELETE SET NULL,
			rejection_reason TEXT,	
			--TIMESTAMP
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			updated_at TIMESTAMPTZ,
			closed_at TIMESTAMPTZ,
			-- CONSTRAINTS
			CONSTRAINT check_positive_principal CHECK (principal_amount > 0),
			CONSTRAINT check_positive_tenure CHECK (tenure_months > 0),
			CONSTRAINT check_outstanding_valid CHECK(outstanding_amount >= 0 AND outstanding_amount <= total_amount),
			CONSTRAINT check_maturity_after_disbursement CHECK(
			maturity_date IS NULL OR 
			disbursement_date IS NULL OR
			maturity_date > disbursement_date
			)
			);

CREATE TABLE loan_repayments (
			repayment_id BIGSERIAL PRIMARY KEY,
			loan_id BIGINT NOT NULL REFERENCES loans(loan_id) ON DELETE CASCADE,
			transaction_id BIGINT REFERENCES transactions(transaction_id) ON DELETE SET NULL,
			payment_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			due_date DATE NOT NULL,
			amount_paid DECIMAL(19,4) NOT NULL,
			principal_paid DECIMAL(19,4) NOT NULL,
			interest_paid DECIMAL(19,4) NOT NULL,
			penalty_paid DECIMAL(19,4) NOT NULL DEFAULT 0.00,
			outstanding_before DECIMAL(19,4) NOT NULL, 
			outstanding_after DECIMAL(19,4) NOT NULL, 
			payment_method VARCHAR(50),
			is_early_payment BOOLEAN DEFAULT FALSE, 
			is_late_payment BOOLEAN DEFAULT FALSE, 
			days_overdue INT DEFAULT 0,
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			-- CONSTRAINTS
			CONSTRAINT check_positive_payment CHECK (amount_paid > 0),
			CONSTRAINT check_payment_breakdown CHECK (amount_paid >= principal_paid + interest_paid + penalty_paid)
			);


CREATE TABLE cards(
			card_id BIGSERIAL PRIMARY KEY, 
			card_number VARCHAR(20) NOT NULL UNIQUE, 
			card_class_id BIGINT NOT NULL REFERENCES cards_classes(card_class_id), 
			cardholder_name VARCHAR(255),
			country_id BIGINT NOT NULL REFERENCES countries(country_id) ON DELETE RESTRICT,
			cvv_hash VARCHAR(255) NOT NULL,
			pin_hash VARCHAR(255) NOT NULL,
			issue_date DATE NOT NULL,
			expiry_date DATE NOT NULL, 
			status VARCHAR(20) DEFAULT 'ACTIVE',
			daily_withdrawal_limit DECIMAL(19,4),
			daily_transaction_limit DECIMAL (19,4),
			is_contactless BOOLEAN DEFAULT TRUE,
			is_international BOOLEAN DEFAULT FALSE, 
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			-- CONSTRAINTS
			CONSTRAINT check_expiry_after_issue CHECK (expiry_date > issue_date)
			); 


-- ======================================================================================================
-- JUNCTION TABLES
-- ======================================================================================================

CREATE TABLE customers_accounts(
			customer_account_id BIGSERIAL PRIMARY KEY,
			customer_id BIGINT NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
			account_id BIGINT NOT NULL REFERENCES accounts(account_id) ON DELETE RESTRICT,
			account_name VARCHAR(500) NOT NULL,
			is_primary BOOLEAN DEFAULT TRUE,  
			relationship_type VARCHAR(50) DEFAULT 'OWNER', -- We could have 'OWNER', 'JOINT', 
			permissions TEXT[], -- We can have 'VIEW', 'WITHDRAWAL', 'TRANSFER', 'CLOSE'
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			updated_at TIMESTAMPTZ,
			-- CONSTRAINTS
			CONSTRAINT unique_customer_account UNIQUE(customer_id, account_id)
			);


CREATE TABLE accounts_transactions (
			ledger_id BIGSERIAL PRIMARY KEY,
			transaction_id BIGINT NOT NULL REFERENCES transactions(transaction_id) ON DELETE RESTRICT,
			account_id BIGINT NOT NULL REFERENCES accounts(account_id) ON DELETE RESTRICT,
			debit_amount DECIMAL(19,4),
			credit_amount DECIMAL(19,4),
			ledger_type VARCHAR(20), -- We could have 'FEE', 'COMMISSION', 'TRANSFER' 
			description VARCHAR(255),
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			balance_before DECIMAL (19,4) NOT NULL, 
			balance_after DECIMAL (19,4) NOT NULL, 
			posted_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			--CONSTRAINTS
			CONSTRAINT check_debit_or_credit CHECK (
			(debit_amount IS NOT NULL AND credit_amount IS NULL) OR
			(credit_amount IS NOT NULL AND debit_amount IS NULL)
			),
			CONSTRAINT check_positive_amounts CHECK (
			(debit_amount IS NULL OR debit_amount > 0 ) AND 
			(credit_amount IS NULL OR credit_amount > 0)
			)
			);

CREATE TABLE customers_investments(
			customer_investments_id BIGSERIAL PRIMARY KEY,
			customer_id BIGINT NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
			investments_id BIGINT NOT NULL REFERENCES investments(investments_id) ON DELETE RESTRICT,
			--INDIVIDUAL CUSTOMER'S STAKE IN INVESTMENT
			principal_contributed DECIMAL (19,4) NOT NULL,
			ownership_percentage DECIMAL (5,2) NOT NULL,
			units_owned DECIMAL(15,4),
			--INDIVIDUAL RETURNS
			returns_earned DECIMAL(19,4) DEFAULT 0.00,
			--RELATIONSHIP TYPE
			customer_role VARCHAR(20) DEFAULT 'PRIMARY',
			--JOINED/EXITED TRACKING
			joined_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			exited_at TIMESTAMPTZ,
			exit_reason TEXT,
			--TIMESERIES
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			updated_at TIMESTAMPTZ,
			--CONSTRAINT
			CONSTRAINT check_positive_contributor CHECK (principal_contributed > 0),
			CONSTRAINT check_valid_percentage CHECK (ownership_percentage > 0  AND ownership_percentage <= 100),
			CONSTRAINT unique_customer_investment UNIQUE (customer_id, investments_id)
			);
		

CREATE TABLE cards_accounts(
			card_account_id BIGSERIAL PRIMARY KEY,
			card_id BIGINT NOT NULL REFERENCES cards(card_id) ON DELETE CASCADE,
			account_id BIGINT NOT NULL REFERENCES accounts(account_id) ON DELETE CASCADE,
			is_primary BOOLEAN DEFAULT FALSE,
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			-- CONSTRAINTS			
			CONSTRAINT unique_card_account UNIQUE(card_id, account_id)
			);


-- ======================================================================================================
-- FEE STRUCTURE 
-- ======================================================================================================

CREATE TABLE account_fees(
			fee_id BIGSERIAL PRIMARY KEY, 
			fee_code VARCHAR(10) NOT NULL UNIQUE, 
			fee_name VARCHAR(100) NOT NULL,
			fee_type VARCHAR(50) NOT NULL, 
			account_class_id BIGINT REFERENCES accounts_classes(account_class_id),
			transaction_class_id BIGINT REFERENCES transactions_classes(transaction_class_id),
			-- CALCULATION FEES
			fixed_amount DECIMAL(19,4),
			percentage DECIMAL (5,2),
			minimum_fee DECIMAL (19,4),
			maximum_fee DECIMAL (19,4), 
			currency_id BIGINT REFERENCES currencies(currency_id) ON DELETE RESTRICT,
			frequency VARCHAR(20),
			-- CONDITIONS
			applies_after_count INT, 
			threshold_amount DECIMAL (19,4),
			effective_from DATE NOT NULL DEFAULT CURRENT_DATE,
			effective_to DATE,
			is_active BOOLEAN DEFAULT TRUE,
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			-- CONSTRAINTS
			CONSTRAINT check_fee_calculation CHECK (
			(fixed_amount IS NOT NULL AND percentage IS NULL ) OR
			(fixed_amount IS NULL AND percentage IS NOT NULL ) OR 
			(fixed_amount IS NOT NULL AND percentage IS NOT NULL)	
			)
			);

CREATE TABLE applied_fees (
			applied_fee_id BIGSERIAL PRIMARY KEY, 
			account_id BIGINT NOT NULL REFERENCES accounts(account_id) ON DELETE CASCADE, 
			transaction_id BIGINT REFERENCES transactions(transaction_id) ON DELETE SET NULL,
			fee_id BIGINT NOT NULL REFERENCES account_fees(fee_id) ON DELETE RESTRICT, 

			amount_charged DECIMAL(19,4) NOT NULL, 
			calculation_basis DECIMAL (19,4),

			waived BOOLEAN DEFAULT FALSE, 
			waived_by BIGINT REFERENCES customers(customer_id) ON DELETE SET NULL,
			waived_at TIMESTAMPTZ, 
			waiver_reason TEXT, 

			applied_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			-- CONSTRAINTS
			CONSTRAINT check_positive_fee CHECK (amount_charged >= 0)
			);

-- Reoccuring payments
CREATE TABLE standing_order (
			standing_order_id BIGSERIAL PRIMARY KEY,
			customer_id BIGINT NOT NULL REFERENCES customers(customer_id),
			from_account_id BIGINT NOT NULL REFERENCES accounts(account_id),
			beneficiary_id BIGINT REFERENCES beneficiaries(beneficiary_id),
			amount DECIMAL(19,4) NOT NULL,
			frequency VARCHAR(20) NOT NULL, 
			start_date DATE NOT NULL, 
			end_date DATE, 
			next_execution_date DATE NOT NULL, 
			status VARCHAR(20) DEFAULT 'ACTIVE',
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
			);


-- =======================================================================================================
-- MONITORING AND COMPLIANCE TABLES 
-- =======================================================================================================

CREATE TABLE audit_logs (
			audit_id BIGSERIAL PRIMARY KEY,
			table_name VARCHAR(100) NOT NULL,
			record_id BIGINT NOT NULL, 
			action VARCHAR(20) NOT NULL,
			old_values JSONB,
			new_values JSONB,
			changed_by BIGINT REFERENCES customers(customer_id) ON DELETE SET NULL, 
			changed_by_type VARCHAR(20), --We could have any of the authorised persons 'USER', 'ADM,INISTRATOR'
			ip_address INET,
			user_agent TEXT,
			changed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			-- CONSTRAINTS
			CONSTRAINT check_valid_action CHECK (action IN ('INSERT', 'UPDATE', 'DELETE'))
			);

CREATE TABLE login_attempts (
			attempt_id BIGSERIAL PRIMARY KEY,
			customer_id BIGINT REFERENCES customers(customer_id) ON DELETE CASCADE,
			imputed_email VARCHAR(255),
			imputed_username VARCHAR(50),
			imputed_password VARCHAR(100),
			ip_address INET NOT NULL, 
			user_agent TEXT,
			success BOOLEAN NOT NULL,
			failure_reason VARCHAR(100),
			attempted_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
			);

CREATE TABLE session_tokens(
			session_id BIGSERIAL PRIMARY KEY,
			customer_id BIGINT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE, 
			token_hash VARCHAR(255) NOT NULL UNIQUE,
			device_info TEXT,
			ip_address INET,
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			expires_at TIMESTAMPTZ NOT NULL, 
			last_activity TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP, 
			is_active BOOLEAN DEFAULT TRUE, 
			-- CONSTRAINTS
			CONSTRAINT check_expires_after_created CHECK(expires_at > created_at)
			);

CREATE TABLE fraud_alerts (
			alerts_id BIGSERIAL PRIMARY KEY, 
			customer_id BIGINT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
			account_id BIGINT NOT NULL REFERENCES accounts(account_id) ON DELETE CASCADE, 
			transaction_id BIGINT REFERENCES transactions(transaction_id) ON DELETE SET NULL, 
			alert_type VARCHAR(50) NOT NULL, 
			risk_score DECIMAL(5,2),
			description TEXT, 
			status VARCHAR(20) DEFAULT 'OPEN',
			resolved_by BIGINT REFERENCES customers(customer_id) ON DELETE SET NULL, 
			resolved_at TIMESTAMPTZ, 
			resolution_notes TEXT, 
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
			);



-- =======================================================================================================
-- NOTIFICATION AND COMMUNICATION 
-- ========================================================================================================

CREATE TABLE notifications (
			notification_id BIGSERIAL PRIMARY KEY, 
			customer_id BIGINT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE, 
			notification_type VARCHAR(50) NOT NULL, 
			channel VARCHAR(20) NOT NULL, 
			subject VARCHAR(255),
			message_info TEXT NOT NULL,
			is_read BOOLEAN DEFAULT FALSE, 
			read_at TIMESTAMPTZ, 
			sent_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
			created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
			);


-- ==========================================================================================================
-- PARTITIONED TABLE 
-- ==========================================================================================================
-- ACCOUNT BALANCE PARTITIONED TABLE 
-- It is now common for users to request for account statement online. Perhaps, we should have a table for that

CREATE TABLE account_statements (
			statement_id BIGSERIAL, 
			account_id BIGINT NOT NULL, 
			customer_id BIGINT NOT NULL, 
			--OUR PARTITION KEYS
			statement_year INT NOT NULL, 
			statement_month INT NOT NULL, 
			--OUR BALANCE
			opening_balance DECIMAL(19,4) NOT NULL,
			closing_balance DECIMAL(19,4) NOT NULL, 
			total_credits DECIMAL(19,4) NOT NULL DEFAULT 0.00,
			total_debits DECIMAL(19,4) NOT NULL DEFAULT 0.00,
			transaction_count INT NOT NULL DEFAULT 0,
			generated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

			PRIMARY KEY(statement_id, statement_year),

			FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE,
			FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE, 
			-- CONSTRAINTS
			CONSTRAINT check_valid_month CHECK(statement_month >= 1 AND statement_month <= 12 )
			)
			PARTITION BY RANGE (statement_year);


-- PARTITION BY YEAR

CREATE TABLE account_statements_2024 PARTITION OF account_statements 
			FOR VALUES FROM (2024) TO (2025);

CREATE TABLE account_statements_2025 PARTITION OF account_statements
			FOR VALUES FROM (2025) TO (2026);

CREATE TABLE account_statements_2026 PARTITION OF account_statements 
			FOR VALUES FROM (2026) TO (2027);

CREATE TABLE account_statements_2027 PARTITION OF account_statements
			FOR VALUES FROM (2027) TO (2028);

CREATE TABLE account_statements_2028 PARTITION OF account_statements 
			FOR VALUES FROM (2028) TO (2029);

CREATE TABLE account_statements_2029 PARTITION OF account_statements 
			FOR VALUES FROM (2029) TO (2030);

CREATE TABLE account_statements_2030 PARTITION OF account_statements 
			FOR VALUES FROM (2030) TO (2031);

-- PARTITION TO ACCOMMODATE OTHER YEAR PARTTIONS NOT DEFINED

CREATE TABLE account_statements_default PARTITION OF account_statements DEFAULT; 

-- ========================================================================================================
-- INDEXES FOR PERFORMANCE OPTIMIZATION AND COMMON ACCESS PATTERNS
-- Indexes optimize our database query.
-- Indexes should be created for columns we anticipate would be frequently queried. 
-- ========================================================================================================

-- Customer Index

CREATE INDEX index_customers_email ON customers(email);
CREATE INDEX index_customers_username ON customers(username);
CREATE INDEX index_customers_phone ON customers(phone_number);
CREATE INDEX index_customers_country ON customers(country_residence);
CREATE INDEX index_customers_branch ON customers(branch_id);
CREATE INDEX index_customers_status ON customers(customer_status) WHERE customer_status = 'ACTIVE';
CREATE INDEX index_customers_kyc ON customers(kyc_status) WHERE kyc_status = 'PENDING';
CREATE INDEX index_customers_created ON customers(created_at DESC);


-- Account Indexes

CREATE INDEX index_accounts_number ON accounts(account_number);
CREATE INDEX index_accounts_type ON accounts(account_type_id);
CREATE INDEX index_accounts_status ON accounts(status) WHERE status = 'ACTIVE';
CREATE INDEX index_accounts_balance ON accounts(balance) WHERE balance > 0;
CREATE INDEX index_accounts_currency ON accounts(currency_id);

-- Transaction Indexes 

CREATE INDEX index_transactions_date ON transactions(transaction_date DESC);
CREATE INDEX index_transactions_type ON transactions(transaction_type);
CREATE INDEX index_transactions_status ON transactions(status);
CREATE INDEX index_transactions_reference ON transactions(transaction_reference);
CREATE INDEX index_transactions_customer ON transactions(initiated_by);


-- Account_transaction (ledger) Index
CREATE INDEX index_ledger_transaction ON accounts_transactions(transaction_id);
CREATE INDEX index_ledger_account ON accounts_transactions(account_id);
CREATE INDEX index_ledger_account_date ON accounts_transactions(account_id, created_at DESC);
CREATE INDEX index_ledger_posted ON accounts_transactions(posted_at DESC);

-- Loan Index 

CREATE INDEX index_loans_customer ON loans(customer_id);
CREATE INDEX index_loans_status ON loans(status) WHERE status IN ('ACTIVE', 'OVERDUE');
CREATE INDEX index_loans_type ON loans(loan_type);
CREATE INDEX index_loans_maturity ON loans(maturity_date) WHERE status = 'ACTIVE';

-- Savings Index 

CREATE INDEX index_savings_customer ON savings(customer_id);
CREATE INDEX index_savings_status ON savings(status) WHERE status = 'ACTIVE';
CREATE INDEX index_savings_maturity ON savings(maturity_date) WHERE status = 'ACTIVE';

-- Investment index

CREATE INDEX index_investments_maturity_date ON investments(maturity_date DESC);
CREATE INDEX index_investments_investment_type ON investments(investment_type);


-- Beneficiary Index

CREATE INDEX index_beneficiaries_customer ON beneficiaries(customer_id);
CREATE INDEX index_beneficiaries_active ON beneficiaries(customer_id) WHERE is_active = TRUE;

-- Junction Table Index

-- Customers_Investment Index 

CREATE INDEX index_customers_investments_customer ON customers_investments(customer_id);
CREATE INDEX index_customers_investments ON customers_investments(investments_id);

-- Junction Table Queries

CREATE INDEX index_customers_accounts_customer ON customers_accounts(customer_id);
CREATE INDEX index_customers_accounts_account ON customers_accounts(account_id);
CREATE INDEX index_customers_accounts_primary ON customers_accounts(customer_id, is_primary) WHERE is_primary = TRUE;

-- Monitoring and Compliance Tables Index

CREATE INDEX index_audit_log_table_record ON audit_logs(table_name, record_id);
CREATE INDEX index_audit_log_changed_at ON audit_logs(changed_at DESC);

CREATE INDEX index_login_attempts_customer ON login_attempts(customer_id, attempted_at DESC);
CREATE INDEX index_login_attempts_ip ON login_attempts(ip_address, attempted_at DESC);

CREATE INDEX index_session_tokens_customer ON session_tokens(customer_id);
CREATE INDEX index_session_tokens_active ON session_tokens(token_hash) WHERE is_active = TRUE;

CREATE INDEX index_fraud_alerts_customer ON fraud_alerts(customer_id, created_at DESC);
CREATE INDEX index_fraud_alerts_status ON fraud_alerts(status) WHERE status = 'OPEN';

-- Notifications 

CREATE INDEX index_notifications_customer_unread  ON notifications(customer_id, is_read);
CREATE INDEX index_notifications_sent_at ON notifications(sent_at DESC);


-- PARTITION TABLE INDEX 

CREATE INDEX index_statements_account_statements ON account_statements(account_id, statement_year DESC, statement_month DESC);
CREATE INDEX index_statements_account_statements_year ON account_statements(customer_id, statement_year DESC);

-- ========================================================================================================
-- COMMENT ON TABLES FOR DOCUMENTATIONS
-- ========================================================================================================

COMMENT ON TABLE customers IS 'Stores customer information including personnel details, KYC data and account status';
COMMENT ON TABLE accounts IS 'Core accounts table with balance tracking and overdraft support';
COMMENT ON TABLE transactions IS 'Master transaction records with status tracking and external references';
COMMENT ON TABLE accounts_transactions IS 'Junction table implementing double-entry bookkeeping for all transaction';
COMMENT ON TABLE loans IS 'Loan management with repayment tracking and collateral information';
COMMENT ON TABLE loan_repayments IS 'Tracks individual loan repayments installments with breakdown of principal, interest and penalties';
COMMENT ON TABLE audit_logs IS 'Comprehensive audit trail for all critical data changes';
COMMENT ON TABLE fraud_alerts IS 'Security monitoring and fraud detection alerts';

COMMENT ON COLUMN customers.kyc_status IS 'Know Your Customer verification status : PENDING, VERIFIED, or REJECTED';
COMMENT ON COLUMN accounts.available_balance IS 'Balance available for withdrawal after pending transaction and holds';
COMMENT ON COLUMN transactions.status IS 'Transaction lifecycle status: PENDING, PROCESSING, COMPLETED, FAILED, REVERSED, CANCELLED'; 
COMMENT ON COLUMN accounts_transactions.ledger_type IS 'Identifies the role of this account in the transaction: SOURCE, DESTINATION, FEE, COMMISSION';	


-- ===========================================================================================================
-- END OF SCHEMA
-- ===========================================================================================================
