# Olist E-Commerce Sales & Performance Dashboard

End-to-end data analytics project: raw relational data → cleaned SQL database → interactive dashboard.
Analysis of **98,199 orders** (~₹13.5M in revenue) from a real Brazilian e-commerce marketplace.

**[View the live dashboard →](https://vedant01111.github.io/Olist-ecommerce-dashboard/dashboard.html)

## Overview
This project models a 9-table relational e-commerce database from scratch, writes SQL to answer real business questions, and visualizes the results in an interactive dashboard — covering revenue trends, category performance, delivery logistics, and customer satisfaction.

## Tools
- **SQL (SQLite)** — schema design, data cleaning, business-question queries
- **Python (pandas)** — CSV → database loading pipeline
- **Chart.js / HTML** — interactive dashboard

## Project Structure
```
olist-project/
├── data/                        # raw CSVs (Kaggle source, not committed)
├── sql/
│   ├── 01_schema.sql            # 9-table relational schema
│   ├── 02_load_data.py          # loads CSVs into SQLite
│   ├── 03_data_quality_checks.sql
│   └── 04_business_queries.sql  # 8 core business questions
├── docs/
│   ├── dax_measures.md
│   └── dashboard_design.md
├── dashboard.html               # interactive dashboard (open in browser)
└── README.md
```

## Key Insights

1. **Delivery speed is the strongest driver of customer satisfaction found in the data.** Orders delivered on time or early average a **4.29★** review. Orders delivered 4+ days late average just **1.94★** — a 2.35-star swing across 96K+ reviews analyzed.

2. **Repeat customer rate is low: 3.04%** of ~95,000 unique customers placed more than one order. Nearly all revenue comes from first-time buyers — a clear retention opportunity for the business.

3. **Delivery times vary sharply by geography.** Northern/Northeastern states (RR, AP, AM) average 26-29 days for delivery, vs. under 9 days in São Paulo — pointing to a logistics/fulfillment gap that likely compounds the satisfaction problem above.

4. **Health & Beauty (₹1.26M), Watches/Gifts (₹1.20M), and Bed/Bath/Table (₹1.04M)** are the top 3 revenue categories, together accounting for roughly 26% of total revenue.

5. **Credit card dominates payments** — 76,795 of ~103,900 transactions (74%), with an average of 3.5 installments, suggesting a price-sensitive customer base that relies on installment plans.

6. **Revenue grew consistently from late 2016 through 2018**, with a sharp spike in November 2017 (₹1.0M, vs. ~₹660K the month before) — likely a seasonal promotional event.

## Recommendation
Given the strong link between delivery delay and review score, prioritizing logistics improvements in slow-delivery states (starting with RR, AP, AM) would likely have an outsized impact on customer satisfaction and, by extension, repeat purchase rate — currently the business's weakest metric.

## How to Reproduce
1. Download the dataset from [Kaggle: Olist Brazilian E-Commerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce), place CSVs in `/data`
2. `pip install pandas`
3. `cd sql && python 02_load_data.py`
4. Open `olist.db` in DB Browser for SQLite, run `03_data_quality_checks.sql` then `04_business_queries.sql`
5. Open `dashboard.html` directly in any browser — no server needed

## Author
[Vedant Chidrawar] · [LinkedIn](https://www.linkedin.com/in/vedant-chidrawar/) · [Portfolio](https://vedant01111.github.io/about-me/)
