# Dashboard Design Guide

Build 3 pages. Keep each to 5-6 visuals max — recruiters judge clarity, not clutter.

## Page 1: Executive Summary
- **Card visuals (top row):** Total Revenue, Total Orders, Average Order Value, Repeat Customer Rate
- **Line chart:** Monthly Revenue Trend (with MoM Growth % as a secondary line or tooltip)
- **Bar chart:** Top 10 Product Categories by Revenue
- **Slicer:** Date range (month/year)

## Page 2: Geographic & Category View
- **Map visual:** Revenue by customer state (use `customer_state` + Total Revenue)
- **Bar chart:** Average Delivery Days by State
- **Treemap:** Revenue by Category (drill into subcategories if available)
- **Slicer:** State, Category

## Page 3: Customer Experience
- **KPI cards:** Average Review Score, On-Time Delivery %, % 1-2 Star Reviews
- **Bar chart:** Average Review Score by Delivery Bucket (on-time / slightly late / very late) — this is your standout insight
- **Line chart:** On-Time Delivery % trend by month
- **Table:** Payment method breakdown (transactions, total value, avg installments)

## Design tips
- Use a consistent color: one accent color for "good" metrics, red/orange only for problem areas (late deliveries, low reviews)
- Title each page clearly; add a one-line subtitle stating the "so what" (e.g. "Late deliveries are costing ~1.8 stars in review score")
- Export each page as an image for your README, and export the full report as PDF for non-Power-BI viewers
