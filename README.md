# online_Sales_Project-github.io



# 📊 Sales Trend Analysis Using SQL

## 🎯 Objective
The project analyzes **monthly revenue** and **order volume** from an online sales dataset.  
It demonstrates the use of **SQL aggregation, grouping, and sorting** for business insights.

---

## 📂 Dataset
- **Table**: `online_sales`
- **Columns**:
  - `order_id`: unique ID of each order
  - `order_date`: date of the order
  - `amount`: sales revenue of the order
  - `product_id`: ID of the product

---

## 🛠 Tools Used
- PostgreSQL (queries also work on MySQL/SQLite with small syntax changes)

---

## 📌 Key Steps
1. **Extract month & year** from `order_date`
2. **Group data** by month & year
3. **Calculate aggregates**:
   - Monthly Revenue → `SUM(amount)`
   - Monthly Orders → `COUNT(DISTINCT order_id)`
4. **Sort** results in chronological order
5. **Find Top 3 months** by revenue
6. **Handle NULLs** using `COALESCE`

---

## 📈 Example Output

| Year | Month | Total Revenue | Total Orders |
|------|-------|---------------|--------------|
| 2024 | 1     | 350.50        | 2            |
| 2024 | 2     | 720.00        | 2            |
| 2024 | 3     | 250.00        | 1            |

---

## 💡 Learnings
- Use of **aggregate functions** (`SUM`, `COUNT`)  
- Difference between **COUNT(*)** and **COUNT(DISTINCT col)**  
- Importance of **GROUP BY** and **ORDER BY**  
- How to find **top-performing months**  

---

## 📤 Submission
Upload the following:
- SQL Script
- Results screenshot
- README.md
