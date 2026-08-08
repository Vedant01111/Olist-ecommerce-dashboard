# DAX Measures — Power BI

Paste these into Power BI: **Home → New Measure** (with `orders`, `order_items`, `order_payments`, `order_reviews`, `customers` tables loaded and relationships set).

## Core KPIs

```dax
Total Revenue =
SUM ( order_items[price] )
```

```dax
Total Orders =
DISTINCTCOUNT ( orders[order_id] )
```

```dax
Average Order Value =
DIVIDE ( [Total Revenue], [Total Orders] )
```

```dax
Total Freight Revenue =
SUM ( order_items[freight_value] )
```

## Growth

```dax
Revenue Last Month =
CALCULATE (
    [Total Revenue],
    DATEADD ( 'orders'[order_purchase_timestamp], -1, MONTH )
)
```

```dax
MoM Revenue Growth % =
DIVIDE ( [Total Revenue] - [Revenue Last Month], [Revenue Last Month] )
```

## Customer

```dax
Unique Customers =
DISTINCTCOUNT ( customers[customer_unique_id] )
```

```dax
Repeat Customers =
CALCULATE (
    DISTINCTCOUNT ( customers[customer_unique_id] ),
    FILTER (
        VALUES ( customers[customer_unique_id] ),
        CALCULATE ( DISTINCTCOUNT ( orders[order_id] ) ) > 1
    )
)
```

```dax
Repeat Customer Rate % =
DIVIDE ( [Repeat Customers], [Unique Customers] )
```

## Delivery Performance

```dax
Avg Delivery Days =
AVERAGEX (
    orders,
    DATEDIFF ( orders[order_purchase_timestamp], orders[order_delivered_customer_date], DAY )
)
```

```dax
On-Time Delivery % =
VAR OnTime =
    CALCULATE (
        COUNTROWS ( orders ),
        orders[order_delivered_customer_date] <= orders[order_estimated_delivery_date]
    )
VAR Total = COUNTROWS ( orders )
RETURN DIVIDE ( OnTime, Total )
```

## Reviews

```dax
Average Review Score =
AVERAGE ( order_reviews[review_score] )
```

```dax
% 1-2 Star Reviews =
DIVIDE (
    CALCULATE ( COUNTROWS ( order_reviews ), order_reviews[review_score] <= 2 ),
    COUNTROWS ( order_reviews )
)
```

---

### Notes
- Set `orders[order_purchase_timestamp]` as a proper **Date** column and mark it as the Date Table if you want built-in time intelligence (DATEADD, SAMEPERIODLASTYEAR).
- Build relationships: `orders[order_id] → order_items[order_id]`, `orders[order_id] → order_reviews[order_id]`, `orders[customer_id] → customers[customer_id]`, `order_items[product_id] → products[product_id]`, `products[product_category_name] → category_translation[product_category_name]`.
- Set cardinality to **One to Many** where the "one" side is the primary key table.
