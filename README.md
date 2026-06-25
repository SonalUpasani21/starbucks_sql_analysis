# Starbucks Canada — SQL Analytics Portfolio Project

This project simulates a business analytics case study for a fictional Starbucks Canada operation across 10 store locations in BC and Alberta. Using a synthetically generated relational database of 9 tables and 500+ orders, I conducted end-to-end SQL analysis across five business areas to uncover insights on store performance, customer behaviour, product sales, loyalty program effectiveness, and store operations.

The dataset was designed to reflect realistic retail coffee chain patterns and was analysed entirely using MySQL. All findings are illustrative and intended to demonstrate analytical thinking and SQL proficiency.

---

## Tools Used

- **MySQL** — database design, data generation, and querying
- **MySQL Workbench** — query development and schema management
- **Claude AI (Anthropic)** — assisted in generating synthetic dataset
- **GitHub** — project hosting and version control

---

## Database Schema

The database consists of 9 tables simulating a retail coffee chain operation:

| Table | Description |
|---|---|
| `stores` | 10 Starbucks locations across BC and Alberta including store type, city, and opening date |
| `customers` | 50 customers with details including name, contact information, city, and signup date |
| `employees` | 30 employees across all stores including role type (Manager, Shift Supervisor, Barista), hourly wage, and active status |
| `orders` | 500 customer transactions recording store location, order total, timestamp, and order status |
| `order_items` | 800 line items breaking down each order by product, quantity, and unit price |
| `products` | 20 products with pricing, category, seasonal availability, and active status |
| `categories` | 8 product categories grouping the menu into drink and food types |
| `payments` | 500 payment records capturing payment method, amount, and payment status |
| `loyalty_rewards` | 35 loyalty program members segmented into Gold, Green, and Reserve tiers with stars earned and redeemed |

### Key Relationships
- `orders` connects to `customers` and `stores`
- `order_items` connects `orders` to `products`
- `products` belong to `categories`
- `payments` link to individual `orders`
- `loyalty_rewards` link to `customers`
- `employees` are assigned to `stores`

---

## Analysis Areas

### 1. Store Performance
**Queries:** 5  
**Concepts:** JOIN, CTE, Window Functions (RANK, LAG), DATE_FORMAT  
**Key Finding:** Alberta stores (3 locations) outperform BC stores (7 locations) on both total and average revenue, with Calgary Cafe generating the highest individual store revenue at 13.34% of company total.

### 2. Customer Behaviour
**Queries:** 5  
**Concepts:** CONCAT, Subquery, TIMESTAMPDIFF, CASE WHEN  
**Key Finding:** New customer acquisition effectively stalled after mid-2023. Zero new customers appeared in 2024 while returning customer orders remained consistent at 10-23 orders per month — indicating strong retention but a potential acquisition problem.

### 3. Product & Category Sales
**Queries:** 6  
**Concepts:** Three-table JOIN, HAVING, LEFT JOIN, COALESCE  
**Key Finding:** Cold Beverages leads all categories at $2,138 revenue despite having only 4 products. Pike Place Roast Whole Bean is the top individual product at $1,450. Two seasonal products (Pumpkin Spice Latte, Peppermint Mocha) show zero sales, confirmed as currently unavailable off-season items.

### 4. Loyalty Program
**Queries:** 4  
**Concepts:** LEFT JOIN, NULL check, AVG comparison, ratio calculation  
**Key Finding:** Loyalty members drive 71% of all orders but non-members spend more per order on average ($13.22 vs $11.93). Green tier members show the lowest redemption rate at 38.2% compared to Gold and Reserve at ~46% — a potential engagement gap.

### 5. Operations & Employees
**Queries:** 4  
**Concepts:** HOUR(), calculated columns, payment analysis  
**Key Finding:** The Starbucks App is the dominant payment method at 40.85% of completed transactions. Orders are distributed consistently from 7am to 8pm with no single peak hour — consistent with synthetic data generation patterns.

---

## Key Findings Summary

1. **Alberta outperforms BC** — 3 Alberta stores generate the highest individual revenues nationally despite BC having 7 stores.

2. **Customer acquisition stalled in 2024** — zero new customers appeared in 2024 while retention remained strong, signalling a potential marketing gap.

3. **Cold Beverages dominates category revenue** — $2,138 total with only 4 products, the highest revenue-per-product ratio of any category.

4. **Loyalty members are frequent but not high spenders** — members place 71% of orders but non-members spend 10.8% more per visit on average.

5. **Starbucks App is the preferred payment method** — 40.85% of transactions, nearly double Credit Card usage at 29.34%.

---

## Data Limitations

This project uses a synthetically generated dataset created to simulate a retail coffee chain environment. The following limitations were identified during analysis:

- **Order total discrepancies** — order totals in the `orders` table do not reconcile with line item calculations in `order_items`, reflecting independent data generation rather than a connected POS system.
- **Duplicate line items** — some orders contain the same product appearing multiple times as separate rows rather than a single row with an updated quantity.
- **Small dataset size** — with 50 customers and 500 orders, month-over-month volatility is extreme and not representative of real trading patterns.
- **Seasonal products** — two products (Pumpkin Spice Latte, Peppermint Mocha) are marked unavailable and show zero sales, consistent with being off-season items.

All SQL logic and analytical reasoning is valid regardless of these data limitations.

---

## How to Run This Project

### Requirements
- MySQL 8.0 or higher
- MySQL Workbench (or any MySQL client)

### Steps
1. Clone this repository
2. Open MySQL Workbench and connect to your local server
3. Run `schema/starbucks_schema.sql` to create the database and tables
4. Run `data/starbucks_data.sql` to load the sample data
5. Open any file in the `analysis/` folder and run the queries

### File Structure
```
starbucks-sql-analysis/
├── README.md
├── schema/
│   └── starbucks_schema.sql
├── data/
│   └── starbucks_data.sql
└── analysis/
    ├── 01_store_performance.sql
    ├── 02_customer_behaviour.sql
    ├── 03_product_sales.sql
    ├── 04_loyalty_program.sql
    └── 05_operations_employees.sql
```

---

## Author

Created as part of a personal analytics portfolio to demonstrate SQL proficiency and business analytical thinking.  
Tools: MySQL · MySQL Workbench · GitHub
