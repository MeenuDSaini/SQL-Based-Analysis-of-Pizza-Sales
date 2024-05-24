# Title:
## SQL-Based Analysis of Pizza Sales: Insights into Customer Preferences and Sales Trends

# Aim:
The aim of this project is to utilize SQL for analyzing a year's worth of pizza sales data, to uncover trends, customer preferences, and operational insights, which can aid in decision-making and business optimization.

# Objectives:

### Data Preparation:

Import and structure the data in a relational database.
Ensure data integrity and consistency through normalization and constraints.

### Sales and Revenue Analysis:
- Retrieve the total number of orders placed.
- Total revenue generated from pizza sale.
- Identify the highest price pizza.
- Identify the best-selling pizzas by type, size, and category by quantity.
- Identify best seller pizza on the base of revenue.
- List the 5 most ordered types along with their quantity.
- Identify the total quantity of each pizza category ordered.
- Find categorywise distribution of pizzas.
- calculate the average number of pizzas ordered per day/ per week / per month.
- Determine the distribution of orders by hours of the day or peak sales hours.
- Determine day of the week with the highest number of orders.
- Determine the top 3 most ordered pizza types based on revenue.
- Calculate the percentage contribution of each pizza type to total revenue.
-  Analyze cumulative revenue generated over time.
-  Determine the top 3 most ordered pizza types based on revenue for each pizza category.
- Compare revenue across different pizza names, sizes, and categories.

### Customer Preferences:

- Identify the most popular pizza ingredients of each category.
- Analyze customer preferences for pizza size and type.

### Operational Insights:

- Determine the average order size and quantity of pizzas ordered.
- Analyze order patterns to optimize kitchen operations and inventory management.

### Reporting and Visualization:

Create SQL queries to extract key insights and metrics.
Use SQL reporting tools or BI tools like Power BI for visualizations.

## Dataset Description:
The dataset downloaded from Kaggle, contains detailed records of pizza sales over a year, including the date and time of each order, types and sizes of pizzas ordered, quantities, prices, and ingredients.

### Tables and Fields:
## Table: orders
- **order_id**:
  - Unique identifier for each order.
  
- **order_date**:
  - Date the order was placed.
  
- **order_time**:
  - Time the order was placed.

## Table: order_details
- **order_details_id**:
  - Unique identifier for each pizza within an order.
  
- **order_id**:
  - Foreign key linking to the order.
  
- **pizza_id**:
  - Foreign key linking to the pizza details.
  
- **quantity**:
  - Quantity of each pizza type and size ordered.

## Table: pizzas
- **pizza_id**:
  - Unique identifier for each pizza.
  
- **pizza_type_id**:
  - Foreign key linking to the pizza type.
  
- **size**:
  - Size of the pizza (Small, Medium, Large, X Large, XX Large).
  
- **price**:
  - Price of the pizza.

## Table: pizza_types
- **pizza_type_id**:
  - Unique identifier for each pizza type.
  
- **name**:
  - Name of the pizza.
  
- **category**:
  - Category of the pizza (Classic, Chicken, Supreme, Veggie).
  
- **ingredients**:
  - Comma-delimited list of ingredients.

## Methodology:
### Database Setup:

-  Create a relational database: Used MySQL, a SQL database management system (DBMS) to create the relational database.
-  Define the schema for the tables (orders, order_details, pizzas, pizza_types).
-  Import the dataset into the respective tables in MySQL.

## Data Preprocessing:

- Set up primary keys and foreign keys to maintain referential integrity.
- Normalize the data to reduce redundancy and improve data integrity.

## SQL queries for Analysis:
- Create SQL queries for analysis using MYSQL workbench.
- Detailed SQL queries can be found in the SQL Analysis file.

## Conclusion
This project provides a comprehensive analysis of pizza sales data using SQL. By setting up a relational database, ensuring data integrity, and performing detailed analysis through SQL queries, we gain valuable insights into sales trends, customer preferences, and operational efficiency.


