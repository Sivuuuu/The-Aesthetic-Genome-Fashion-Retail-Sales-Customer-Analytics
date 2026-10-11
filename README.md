# The Aesthetic Genome – Fashion Retail Sales Analytics

An end-to-end data analytics project using SQL, Python, Excel, Power BI, and DAX to analyse fashion retail sales, customer behaviour, product performance, discount patterns, and business trends.

## 📌 Project Overview

The Aesthetic Genome transforms raw fashion retail transaction data into actionable business insights through data cleaning, exploratory data analysis, statistical analysis, data visualization, and interactive dashboard development.

**Objective:** Understand sales performance, identify customer and product patterns, and support data-driven retail business decisions.

## 🛠️ Tools & Technologies

- **SQL (MySQL):** Data cleaning, validation, aggregations, joins, CTEs, subqueries, and window functions.
- **Python:** Data analysis, descriptive statistics, correlation analysis, and outlier detection.
- **Pandas & NumPy:** Data manipulation and numerical analysis.
- **Matplotlib & Seaborn:** Data visualization.
- **Excel & Power Query:** Data inspection and transformation.
- **Power BI:** Interactive dashboard development.
- **DAX:** KPI calculations and business metrics.
- **Git & GitHub:** Version control and project management.

## 📊 Dataset Overview

The project uses 2024 fashion retail transaction data.

| Metric | Value |
|---|---:|
| Raw Dataset Rows | 50,800 |
| Cleaned Dataset Rows | 50,000 |
| Valid Orders Analysed in Python | 49,850 |
| Distinct Customers | 8,969 |
| Valid Revenue | 15,428,005.95 |
| Valid Profit | 6,942,603.24 |
| Average Order Value (AOV) | 309.49 |
| Total Units Sold | 124,891 |

*Note: Python metrics exclude zero-quantity orders. Monetary values are reported in the dataset's units.*

## 🔄 Project Workflow

1. **Data Collection:** Load the raw fashion retail dataset.
2. **SQL Data Cleaning:** Handle missing values, standardize text, correct negative quantities, recalculate sales and profit, and remove duplicate orders.
3. **Data Validation:** Check null values, duplicate records, and unique order identifiers.
4. **Python Analysis:** Perform exploratory data analysis, descriptive statistics, correlation analysis, and outlier detection.
5. **Data Visualization:** Develop nine business-focused charts.
6. **Power BI Dashboard:** Build an interactive five-page dashboard with DAX measures and business KPIs.
7. **Business Insights:** Interpret results and propose data-driven recommendations.

## 🗄️ SQL Analysis

SQL was used to perform:

- Database and table creation.
- Data cleaning and deduplication using `ROW_NUMBER()`.
- Overall revenue, profit, order, customer, and AOV calculations.
- Product category and city-wise sales analysis.
- Customer spending segmentation.
- Discount-band and payment-method analysis.
- Monthly sales trends and month-over-month growth.
- High-value order identification.
- Category ranking using `DENSE_RANK()`.
- Cumulative revenue analysis and repeat-purchase intervals using `LAG()`.
- Advanced analysis using CTEs, joins, subqueries, and window functions.

## 🐍 Python Analysis

Python was used for data quality checks, statistical analysis, correlation analysis, outlier investigation, and visualization.

### Nine Business Visualizations

1. Monthly Revenue Trend
2. Revenue by Product Category
3. Revenue by City
4. Order Value Distribution
5. High-Value Order / Outlier Analysis
6. Observed Price–Demand Relationship
7. Discount vs Basket Volume / Order Value
8. Correlation Heatmap
9. Customer Segment Contribution

## 📈 Power BI Dashboard

The project includes five dashboard pages:

1. **Executive Overview** – Key performance indicators and overall business performance.
2. **Sales & Growth** – Revenue trends and geographical performance.
3. **Product, Pricing & Basket Economics** – Category performance, pricing, discounts, and order value.
4. **Customer & Action Center** – Customer segmentation, spending behaviour, and business actions.
5. **Detailed Analysis & Drilldown** – Detailed transaction analysis and interactive filtering.

The dashboard uses DAX measures, KPI cards, charts, slicers, and drilldown features to communicate business performance.

## 🔍 Key Findings

- **Revenue Trends:** Monthly revenue remained within approximately 1.23M–1.32M during 2024, indicating fluctuations without a sustained growth trend.
- **Product Categories:** Accessories generated the highest revenue, while Footwear generated the lowest; overall category revenue was relatively balanced.
- **Geographical Analysis:** New York led the named cities, while Austin recorded the lowest revenue among them.
- **Order Value:** The median order value was 247.46, compared with a mean of 309.49, indicating a right-skewed distribution.
- **High-Value Orders:** 534 valid orders exceeded the IQR upper fence, and all contained four units.
- **Discount Analysis:** Higher discount levels were associated with lower average order value, without a clear increase in average units per order.
- **Customer Segmentation:** The fixed 500 spending threshold classified too many customers as high-value VIPs, suggesting the need for improved segmentation.

## 💡 Business Recommendations

- Evaluate discount strategies using revenue, order value, and basket-size metrics.
- Investigate high-value orders to understand premium purchasing patterns.
- Improve customer segmentation using spending percentiles and repeat-purchase behaviour.
- Monitor monthly sales and category performance consistently.
- Improve data quality by investigating unknown categorical values and zero-quantity records.
- Use controlled experiments before making causal claims about pricing or discount effectiveness.

## ⚠️ Limitations

- The analysis is observational and does not establish causation.
- Profit is calculated as approximately 45% of sales in the supplied data.
- Python excludes zero-quantity records, so metrics may differ across tools.
- Unknown city and fabric values limit the precision of certain comparisons.
- The analysis does not include a validated forecasting model or causal experiment.

## 📁 Project Structure

```text
The-Aesthetic-Genome/
│
├── README.md
├── SQL/
│   ├── Data_Cleaning_using_SQL.sql
│   └── Data_Analysis_SQL.sql
├── Python/
│   └── python_data_visualization_9_charts.ipynb
├── PowerBI/
│   ├── major_project.pbix
│   └── cleaned_dataset.xlsx
├── Documentation/
│   └── Aesthiestic_Genomeo_Project_Documentation.pdf
└── Screenshots/
```

*Update the folder and file names above to match your actual GitHub repository.*

## 🚀 How to Run

1. Clone or download this repository.
2. Open the SQL scripts in MySQL Workbench.
3. Execute `Data_Cleaning_using_SQL.sql` to create the database and clean the data.
4. Execute `Data_Analysis_SQL.sql` to run the analytical queries.
5. Open the Python notebook in Jupyter Notebook or JupyterLab and configure the dataset path.
6. Open `major_project.pbix` in Power BI Desktop.
7. Update the data source path if required and refresh the dashboard.

## 👩‍💻 Author

**Sivani Paladugu**

B.Tech – Computer Science Engineering (AI & ML)

**Project:** The Aesthetic Genome – Fashion Retail Sales Analytics

## 📌 Conclusion

This project demonstrates an end-to-end data analytics workflow using SQL, Python, and Power BI to transform raw retail data into meaningful business insights. It showcases practical skills in data cleaning, statistical analysis, visualization, KPI development, and business intelligence reporting.

## 🎥 Project Presentation

Watch the complete project demonstration below:

[▶️ **Watch Project Presentation Video**](https://drive.google.com/file/d/1v8VRgHq557d_rZQIXk95pclLH5b2qMov/view?usp=sharing)
