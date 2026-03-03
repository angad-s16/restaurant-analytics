# 🍽️ Restaurant Performance Analytics — Q1 2023

An end-to-end data analytics project analyzing restaurant sales data using **MySQL** for data exploration and **Power BI** for interactive dashboard visualization.

---

## 📌 Project Overview

This project analyzes Q1 2023 (January–March) transactional data from a restaurant to uncover insights about menu performance, revenue trends, customer ordering behavior, and peak business hours.

The project covers the full analytics workflow:
- Database design and schema creation
- Data loading and foreign key constraints
- SQL-based business analysis and KPI calculation
- Interactive Power BI dashboard with 3 report pages

---

## 🗂️ Repository Structure

```
restaurant-analytics/
│
├── data/
│   ├── menu_items_exp.csv          # Menu items with categories and prices
│   └── order_details_exp.csv       # Q1 2023 order transactions
│
├── sql/
│   ├── create_schema_tables.sql    # Table creation scripts
│   ├── Assigning_Foreign_Key.sql   # Relationship constraints
│   ├── KPIs.sql                    # Core business KPIs
│   └── Business_Analysis.sql       # 9 business questions with findings
│
├── dashboard/
│   └── Restaurant_Dashboard_Q1_2023.pbix   # Power BI dashboard file
│
└── README.md
```

---

## 📊 Dataset

| File | Rows | Description |
|------|------|-------------|
| `menu_items_exp.csv` | 32 | Menu items across 4 categories with prices |
| `order_details_exp.csv` | 12,234 | Individual order line items for Q1 2023 |

**Categories:** American, Asian, Italian, Mexican

**Key columns:**
- `menu_items`: menu_item_id, item_name, category, price
- `order_details`: order_details_id, order_id, order_date, order_time, item_id

---

## 🛠️ Tools Used

| Tool | Purpose |
|------|---------|
| MySQL 8.0 | Database creation, querying, analysis |
| MySQL Workbench | SQL IDE and data export |
| Power BI Desktop | Dashboard and visualization |
| GitHub | Version control and portfolio |

---

## 🗄️ SQL — Database Setup

### Step 1 — Create Tables
Run `create_schema_tables.sql` to create the `menu_items` and `order_details` tables.

### Step 2 — Load Data
Import `menu_items_exp.csv` and `order_details_exp.csv` into their respective tables via MySQL Workbench Table Data Import Wizard.

### Step 3 — Assign Foreign Key
Run `Assigning_Foreign_Key.sql` to establish the relationship:
```sql
ALTER TABLE order_details 
ADD CONSTRAINT fk_item FOREIGN KEY (item_id) 
REFERENCES menu_items(menu_item_id);
```

---

## 📈 SQL Analysis — Business Questions

All analysis is in `Business_Analysis.sql`. The project answers 9 business questions across 3 themes:

### 🍔 About the Menu
| # | Question | Key Finding |
|---|----------|-------------|
| Q1 | Which items sell the most? | Edamame (596) and Hamburger (595) are the top sellers |
| Q2 | Which items make the most money? | Korean Beef Bowl leads at $10,554 — high price + high volume |
| Q3 | Which category is most popular? | Asian (28.2% of all orders) |
| Q4 | Which category makes the most money? | Italian ($49K) despite not being #1 in volume — highest avg price |

### ⏰ About Time
| # | Question | Key Finding |
|---|----------|-------------|
| Q5 | What time of day are we busiest? | Peak hours: 12, 13, 17, 18 — two clear rushes (Lunch & Dinner) |
| Q6 | Which day makes the most money? | Monday ($26,007) — weekdays outperform weekends |
| Q7 | Is revenue growing month over month? | Feb dips 5.6% (fewer days), March recovers +7.5% to highest month |

### 🧾 About Orders
| # | Question | Key Finding |
|---|----------|-------------|
| Q8 | Which items should we consider removing? | Chicken Tacos (123 orders) and Potstickers (201 orders) — low volume and low revenue |
| Q9 | How many items do people order at once? | 67.2% of orders contain just 1–2 items |

---

## 📉 KPIs — Q1 2023 Summary

| KPI | Value |
|-----|-------|
| Total Revenue | $159,217.90 |
| Total Orders | 5,370 |
| Average Order Value | $29.65 |
| Average Items Per Order | 2.28 |
| Best-Selling Item | Edamame (596 orders) |
| Top Revenue Item | Korean Beef Bowl ($10,554) |
| Top Revenue Category | Italian ($49,463) |
| Peak Hours | 12:00, 13:00, 17:00, 18:00 |
| Best Day | Monday ($26,007) |

---

## 📊 Power BI Dashboard

The `.pbix` file contains 3 report pages:

### Page 1 — KPI Overview
- 4 KPI cards: Total Revenue, Total Orders, AOV, Avg Items Per Order
- Total Revenue by Category (bar chart)
- Total Revenue by Month (line chart)
- Order share by Category (donut chart)

### Page 2 — Menu Performance
- Top 10 Best-Selling Items by volume
- Top 10 Highest Revenue Items
- Bottom 10 Items (candidates for removal)
- Category slicer for interactive filtering

### Page 3 — Time & Trends
- Orders by Hour of Day (peak hour analysis)
- Revenue by Day of Week (Mon–Sun ordered correctly)
- Monthly Revenue Trend (Jan–Mar)

### DAX Measures Used
```
Total Revenue = SUMX(order_details_exp, RELATED(menu_items_exp[price]))
Total Orders = DISTINCTCOUNT(order_details_exp[order_id])
Avg Order Value = DIVIDE([Total Revenue], [Total Orders])
Avg Items Per Order = DIVIDE(COUNTROWS(order_details_exp), [Total Orders])
```

## Dashboard Previews

### 1. Executive Overview
Comprehensive view of Q1 2023 performance, showing total revenue, order volume, and category breakdowns.

| Total Performance | Filtered View |
| :---: | :---: |
| ![Q1 Overview](Dashboard%201-1.png) | ![Filtered Metrics](Dashboard%201-2.png) |

### 2. Category & Item Analysis
Deep dive into specific cuisines and individual menu item performance by revenue and order volume.

| Top Items & Revenue | Italian Cuisine Deep Dive |
| :---: | :---: |
| ![Item Analysis](Dashboard%202-1.png) | ![Italian Category](Dashboard%202-2.png) |

### 3. Temporal Trends
Analysis of peak ordering hours and revenue fluctuations across days of the week and months.

| Global Time Trends | Thursday Specific Trends |
| :---: | :---: |
| ![Time Analysis](Dashboard%203-1.png) | ![Temporal Deep Dive](Dashboard%203-2.png) |

---

## 🚀 How to Run This Project

### SQL
1. Install MySQL 8.0 and MySQL Workbench
2. Create a new schema (e.g. `restaurant_db`)
3. Run `create_schema_tables.sql`
4. Import both CSV files using Table Data Import Wizard
5. Run `Assigning_Foreign_Key.sql`
6. Run `KPIs.sql` and `Business_Analysis.sql`

### Power BI
1. Install [Power BI Desktop](https://powerbi.microsoft.com/desktop) (free)
2. Open `Restaurant_Dashboard_Q1_2023.pbix`
3. If prompted to reconnect data, point to the CSV files in the `/data` folder
4. All visuals and measures will load automatically

---

## 💡 Key Business Insights

- **Italian is the hidden revenue champion** — it ranks 2nd in orders but 1st in revenue because its average item price ($16.78) is significantly higher than other categories
- **Korean Beef Bowl is the star item** — combines premium pricing ($17.95) with high volume (566 orders) for $10,554 in revenue
- **Dinner rush is longer than lunch** — lunch peaks for 2 hours (12–13), dinner spans 3 consecutive high-traffic hours (17–19)
- **Most customers order light** — 67.2% of orders are 1–2 items, indicating a strong upsell opportunity
- **Wednesday is consistently weak** — $6,105 gap vs Monday suggests a promotional opportunity mid-week

---


## 🔗 Data Source

- **Dataset:** [Restraunt Orders Analysis — Maven Analytics](https://mavenanalytics.io/guided-projects/restaurant-order-analysis)

---

## 📄 License

This project uses publicly available sample restaurant data for educational and portfolio purposes.
```
