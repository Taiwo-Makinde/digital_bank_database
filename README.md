# Digital Bank Database

A Comprehensive PostgreSQL database schema for a modern digital banking system with support for multi-currrency operations, loan management, investments and compliance tracking.  

## Table of Contents 
- [Overview](#Overview)
- [Architecture](#Architecture)
- [General Design Principles](#General-Design-principles)
- [Features](#Features)
- [Schema Structure](#Schema_structure)
- [key Tables](#Key-tables)
- [Partitioning Strategy](#Partitioning-strategy)
- [Security Features](#Security-features)
- [Feature-Enhancement](#Future-enhancement)
- [Database Statistics](#Database-Statistics )
- [Version History](#Version-history)










## Overview

This database schema is designed for digital-first banking platform supporting:
- Multi-currency accounts
- Personal and joint accounts
- Loan management and repayment tracking
- Saving products with interest calculations
- Card issuance and management
- Comprehensive audit trails
- Fraud-detection and monitoring
- Real-time transaction processing with double-entry bookkeeping 

**Target Markets**: Digital banks, Fintech apps, Microfinance institutions, Neobanks


--- 

## Architecture

-- **Database Type**: Postgres 18

-- **Schema Design**: Snowflake schema(highly normalized)

-- **Optimization**: OLTP (Online Transaction Processing)

-- **Normalization Level**: 3NF (Third Normal Form)

---

## General-Design-principles

- **Snowflake normalization** - Dimension tables normalized to 3NF
- **Data Consistency**: Normalization eliminates update anomalies and redundancy.
- **OLTP Optimizations** - Write-heavy transaction workloads
- **Scalability**: Optimized for frequent INSERT, UPDATE, and DELETE operations.
- **Transactional Integrity**: ACID compliance for reliable concurrent operations.
- **Partitioned high-volume table** - Monthly/Yearly for scalabilty
- **Referential Integrity** - Foreign key constraints maintain relationship consistency
- **Database-level validation** - ENUMs and CHECKs constraints
- **Comprehensive auditing** - Full change tracking
- **Security by design** - Hashing, session management, fraud detection


--- 

## Features

### Core banking 

- ✅ Multi-currency account management
- ✅ Double-entry bookkeeping via partitioned ledger
- ✅ Real-time balance tracking
- ✅ Overdraft support
- ✅ Transaction reversal with full audit trail
- ✅ Fee management and application

### Product & Services
- ✅ **Accounts**: savings, checking and current accounts 
- ✅ **Loans**: personal, business, mortgage with collateral tracking
- ✅ **Investments**: Individual and joint investments with ownership tracking 
- ✅ **Savings**:Fixed deposit with maturity tracking 
- ✅ **Cards**: Debit/credits with PIN/CVV security
- ✅ **Standing Orders**: Recurring payments and transfer

### Compliance and Security

- ✅ KYC (Know Your Customer) verification tracking 
- ✅ Comprehensive audit logs (JSON old/new values)
- ✅ Fraud detection alerts with risk scoring 
- ✅ Session management with device tracking 
- ✅ Login attempt monitoring 
- ✅ Transaction approval workflows 

### Multinational Support
- ✅ Multi-currency operations
- ✅ Exchange rate tracking with historical data
- ✅ Cross-border transfer to foreign banks 
- ✅ SWIFT/routing number support 

### Performance
- ✅ **Nomarlization** of the database
- ✅ **Partitioned tables** for high-volumn data (transactions ledger, account statements)
- ✅ **Strategic Indexing** for coomon query questions 
- ✅ Optimized for millions of transactions


---

## Schema_structure

### Snowflake Schema 
A **Snowflake Schema** is a normalized data model where dimension tables are further broken down into sub-dimension tables. A snowflake schema is highly normalized and reduces redundancy. 

### Why Snowflake Schema for an OLTP Bank database

| Benefits | Description |
| ---------|-------------|
| **Storage Efficiency** | No duplicate data - reference values is stored once |
| **Data Consistency** | Single source of truth for all dimensions | 
| **Update Efficency** | Changes to reference data don't affect fact tables | 
| **Referential Integrity** | Foreign keys enforce relationships |
| **Scalability** | Optimized for write-heavy transactional workloads | 

**Tradeoff**: More JOINS in queries (acceptable for OLTP, mitigated with views) | 


---

### Schema Layers

1. **Lookup/Reference Tables**
   - countries, currencies, branches, *_classes tables, etc.
2. **Core Entity Tables**
   - customers, accounts, transactions, loans, savings, investments, etc.
3. **Junction Tables**
   - customers_account, customers_investment, cards_accounts, etc.
4. **Operational Tables**
   - accounts_transactions, loan_repayments, applied_Fees, etc.
5. **Monitoring and Compliance Tables**
    - audit_logs, login_attempts, session_tokens, fraud_alerts
6. **Notification and Communication Table**
   - notifications
6. **Partitioned Tables**
    - account_statements

#### Partitioning-strategy

##### Why Partition 

Partitioning improves query performance by:
- Reducing index size per partition
- Enabling partition pruning (only scan relevant partitions)
- Simplify data archival
- Improve maintenance operations (VACUUM, ANALYZE)

##### Reason for Partitioned Tables

###### 1. account_statements
**Partition Key**: 'statement_year' (yearly)
**Strategy**: RANGE partitioning
**Retention**: All years (statements are permanent records)
**Reason**: account_statements table is a pre-generated account statements for users. We anticipate that this table will be frequently queried by a large number of users.


---

## Security-features
### 1. Password Security
- Passwords to be stored as bcrypt/argon2hashes
- Minimum length enforcement to be included at the application layer
- Failed login tracking with account lockout

### 2. Session Management
- session_tokens table to manage sessions
- sessions expire after inactivity
- Track device info and IP for security

### 3. Audit Trail 
- Every critical change is logged with old/new values
- Audit trail includes IP of users or administrators who effect change

### 4. Fraud Detection
- Real-time alert for suspicious activity

### 5. Card Security
- Daily transaction/withdrawal limits ]
- Card status tracking (ACTIVE, BLOCKED, LOST, STOLEN) 


---

## Future-enhancement

### Planned Features
- [ ] Cypto-currency wallet integration
- [ ] Bill payment integration
- [ ] Cheque management

### Performance optimization  
- [ ] Partition accounts_trasactions by date 
- [ ] Implement materialized views for reporting
- [ ] Functions and triggers

---


## Database-Statistics 

| Metric | Count|
| -------|--------| 
| Tables | 40+    |
| Partitioned Tables | 1 |
| Indexes | 60+ |
| Foreign Keys | 80+ |
| CHECK Constraints | 50+ |
| ENUM Types | 10| 


---

## Version-history

### Version 1.0.0 (January 2026)

- Initial Release
- Core banking features
- Partitioned account_statements
- Multi-currency support
- Investment tracking
- Loan Management
- Compliance Tables  


---

**Built with ❤️ for the fintech community**

