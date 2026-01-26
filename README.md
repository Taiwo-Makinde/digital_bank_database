# Digital Bank Database

A Comprehensive PostgreSQL database schema for a modern digital banking system with support for multi-currrency operations, loan management, investments and compliance tracking.  

## Table of Contents 
- [Overview](#Overview)
- [Architecture](#Architecture)
- [Design Principles](#Design-principles)
- [Features](#Features)
- [Schema Structure](#Schema_structure)
- [key Tables](#Key-tables)
- [Partitioning Strategy](#Partitioned-strategy)
- [Security Features](#Security-features)
- [Feature-Enhancement](#Future-enhancement)
- [Contribution Guidelines](#Contribution-guidelines)
- [Acknowkledgement](#Acknowledgement)
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

## Architecture

-- **Database Type**: Postgres 18

-- **Schema Design**: Snowflake schema(highly normalized)

-- **Optimization**: OLTP (Online Transaction Processing)

-- **Normalization Level**: 3NF (Third Normal Form)

## Design-principles

-- **Transactional Integrity**: ACID compliance for reliable concurrent operations. 

-- **Data Consistency**: Normalization eliminates update anomalies and redundancy.

-- **Scalability**: Optimized for frequent INSERT, UPDATE, and DELETE operations.

-- **Referential Integrity**: Foreign key constraints maintain relationship consistency


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
- ✅ Fraud detection alertsw with risk scoring 
- ✅ Session management with device tracking 
- ✅ Login attempt monitoring 
- ✅ Transaction approval workflows 

### Multinational Support
- ✅ Multi-currency operations
- ✅ Exchange rate tracking with historical data
- ✅ Cross border transfer to foreign banks 
- ✅ SWIFT/routing number support 

### Performance
- ✅ **Nomarlization** of the database
- ✅ **Partitioned tables** for high volumn data (transactions ledger, account statements)
- ✅ **Strategic Indexing** for coomon query questions 
- ✅ Optimized for millions of transaction


## Schema_structure

## Key-tables

## Partitioned-strategy

## Security-features

## Future-enhancement

## Contribution-guidelines

## Acknowledgement

## Version-history
