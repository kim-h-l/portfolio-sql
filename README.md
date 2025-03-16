# SQL Portfolio

## Exploring Stack Overflow Data with BigQuery

Welcome to my SQL portfolio! This section highlights my exploratory analysis of the Stack Overflow dataset using **Google BigQuery**. Since this dataset was new to me, I started with some basic SQL queries to familiarize myself with its structure before diving into more complex analyses.

All SQL queries referenced can be found [here](https://github.com/kim-h-l/portfolio-sql/tree/main/stackoverflow).

---

## 🔍 Understanding the Data

To kick things off, I wanted to explore what the dataset could tell me about Stack Overflow’s top users. I started by looking up the [top user of all time](https://stackoverflow.com/users/22656/jon-skeet) and used their user ID, along with the available schema in BigQuery, to perform a [basic check](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/001_user_data_exploration.sql) on the `users` table. This gave me a better understanding of the table's structure and the kinds of insights I could extract.

---

## ✅ Data Quality Checks

Before diving deeper, I ran some **data quality checks** to identify potential issues such as null values, duplicates, or unexpected values. Here are the key questions I investigated:

1. [What is the minimum and maximum reputation?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/002_dq_reputation_min_max.sql) *(Understanding the range of values.)*
2. [Can reputation be null?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/003_dq_reputation_null.sql)
3. [Which columns in the user table allow null values?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/004_dq_user_table_nulls.sql)
4. [Are there any duplicate user IDs?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/005_dq_user_id_dupe_check.sql) *(Checking for a primary key.)*

---

## 📊 Exploratory Data Analysis

Once I had confidence in the data quality, I began **exploratory data analysis (EDA)** to uncover patterns and trends. Here are some key questions I explored:

1. [Which years had the highest total reputation, based on user account creation year?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/006_eda_reputation_by_year.sql)
2. [What is the average reputation per user, grouped by account creation year?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/007_eda_avg_user_reputation.sql)
3. [Who were the top 5 users by reputation in the top 5 years for reputation growth?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/008_eda_top_users_top_years.sql)

---

## 🤔 Digging Deeper: More Complex Questions

After getting a feel for the data through EDA, I wanted to push my analysis further by using CTEs and window functions to answer more nuanced questions. Here are some insights I explored:

1. [Looking at the top 100 users by reputation, what are some of their question and answer statistics?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/009_top_100_users_qa.sql) *(Are they just answering, or do they ask great questions too?)*
2. [What tags did each of the top 100 users use?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/010_top_100_users_tags.sql) *(Are they specialists in a few tags or active across a variety?)*

This analysis helped me build a stronger understanding of the Stack Overflow community and reputation system. More coming soon!

___

This project used the publicly available [Stack Overflow](https://console.cloud.google.com/marketplace/product/stack-exchange/stack-overflow) dataset in BigQuery. This project is licensed under CC-BY-SA 4.0. See the LICENSE file for details.
