# Task 23 — SQL Aggregation Basics: Query Results

All results below were executed against the included sample database. Monetary values are in INR (₹). NULL values are shown explicitly where applicable.

## Q1 Total orders

| total_orders |
| --- |
| 8 |

## Q2 Total sales

| total_sales |
| --- |
| 14160.0 |

## Q3 Average order value

| average_order_value |
| --- |
| 1770.0 |

## Q4 Minimum and maximum order

| minimum_order_value | maximum_order_value |
| --- | --- |
| 800 | 3900 |

## Q5 Sales by region

| region | order_count | total_sales |
| --- | --- | --- |
| NULL | 1 | 800.0 |
| East | 1 | 900.0 |
| North | 3 | 7290.0 |
| South | 2 | 3970.0 |
| West | 1 | 1200.0 |

## Q6 Orders by status

| status | order_count |
| --- | --- |
| Cancelled | 1 |
| Completed | 5 |
| Pending | 2 |

## Q7 Product price statistics by category

| category | average_product_price | minimum_price | maximum_price |
| --- | --- | --- | --- |
| Accessories | 925.0 | 650 | 1200 |
| Electronics | 1200.0 | 900 | 1500 |
| Stationery | 100.0 | 80 | 120 |

## Q8 Units and sales by product

| product_name | units_sold | sales_value |
| --- | --- | --- |
| Keyboard | 3 | 4500.0 |
| Wireless Mouse | 6 | 3900.0 |
| Laptop Stand | 2 | 2400.0 |
| USB Hub | 3 | 1800.0 |
| Notebook | 15 | 1200.0 |
| Pen Set | 3 | 360.0 |

## Q9 Monthly sales

| sales_month | monthly_sales |
| --- | --- |
| 2026-10 | 7390.0 |
| 2026-11 | 6770.0 |

## Q10 NULL check

| customers_with_missing_email | items_with_missing_price | non_null_item_prices | total_item_rows |
| --- | --- | --- | --- |
| 1 | 1 | 13 | 14 |

