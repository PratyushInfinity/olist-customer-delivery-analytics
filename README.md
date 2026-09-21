# Olist Customer & Delivery Analytics

SQL-based analysis of the Brazilian e-commerce Olist dataset, focused on customer segmentation and delivery performance, visualized in Tableau.

## Overview

This project analyzes ~99,000 orders from Olist, a Brazilian e-commerce marketplace, to answer three business questions:
- Which product categories drive the most revenue?
- Which customers are most valuable, and how should they be segmented for retention efforts?
- Does late delivery measurably hurt customer satisfaction?

## Tools

- **MySQL 8.0** — data modeling, querying, analysis
- **Python (pandas, SQLAlchemy)** — one-time data loading pipeline (see note below)
- **Tableau Public** — dashboard visualization

## Dataset

[Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle), covering 2016–2018. Nine relational tables covering orders, customers, order items, payments, reviews, products, sellers, geolocation, and category name translations.

## Schema

8 tables imported into a MySQL `olist` schema, joined primarily on `order_id`, `customer_id`, and `product_id`:

- `orders` — order status and timestamps (purchase, approval, delivery, estimated delivery)
- `customers` — customer IDs and location (note: `customer_id` is order-specific; `customer_unique_id` identifies the actual person across orders)
- `order_items` — line items, price, freight value
- `payments` — payment type, installments, value
- `reviews` — review score, comments, timestamps
- `products` — product category, dimensions, weight
- `sellers` — seller location
- `category_translation` — maps Portuguese category names to English

## Analysis

### 1. Revenue by Product Category (`01_revenue_by_category.sql`)
Joins order items → products → category translations to rank the top 15 categories by total revenue and order count.

### 2. RFM Customer Segmentation (`02_rfm_segmentation.sql`)
Computes Recency, Frequency, and Monetary value per customer using window functions (`NTILE`), then buckets customers into segments (Champions, At Risk, New/Promising, Lost, Needs Attention) using CASE logic.

**Data quality note:** `NTILE(4)` was initially used for all three RFM dimensions, but produced inconsistent scores for customers with tied `frequency` values — a large majority of Olist customers are one-time buyers, and NTILE's equal-bucket-size logic split this tied group arbitrarily across quartiles. Fixed by replacing frequency scoring with explicit CASE thresholds instead of quantile ranking, since frequency has low cardinality and doesn't benefit from quartile splitting.

### 3. Delivery Delay vs. Review Score (`03_delivery_delay_reviews.sql`)
Buckets orders by days late (On Time, 1-3, 4-7, 8-14, 15+ days) and compares average review scores across buckets.

**Key finding:** average review score drops from **4.29** (on-time/early) to **2.27** (late overall), with a near-linear decline across delay buckets that plateaus around 1.7 stars for 15+ days late.

### 4. Monthly Revenue Trends (`04_monthly_trends.sql`)
Tracks order count, total revenue, and average order value by month. Note: 2016 data is sparse (platform pilot period) and the final month (2018-08) is a partial month due to data collection cutoff — both are excluded from trend interpretation.

## Data Loading

CSVs were loaded into MySQL via `LOAD DATA INFILE`, which failed silently across multiple configurations for unresolved environment-specific reasons. Data was instead loaded via a small Python/pandas/SQLAlchemy script (`load_data.py`, `load_geo.py`, `load_translation.py`) — used purely as a loading utility, not for analysis or cleaning, which was done entirely in SQL.

## Dashboard

[Tableau Public link — add once published]

## Files

```
├── 01_revenue_by_category.sql
├── 02_rfm_segmentation.sql
├── 03_delivery_delay_reviews.sql
├── 04_monthly_trends.sql
├── load_data.py
├── load_geo.py
├── load_translation.py
├── revenue_by_category.csv
├── rfm_segments.csv
├── delivery_delay_reviews.csv
└── monthly_trends.csv
```
