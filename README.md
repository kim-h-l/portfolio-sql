# **SQL Portfolio**  

## **Exploring Stack Overflow Data with BigQuery**  

Welcome to my SQL portfolio! This section showcases my exploratory analysis of the Stack Overflow dataset using **Google BigQuery**. I began by writing basic SQL queries to explore the dataset’s structure before progressing to more complex analyses. 

All referenced SQL queries can be found in my [GitHub repository](https://github.com/kim-h-l/portfolio-sql/tree/main/stackoverflow).  

---

## **Understanding the Data**  

To get started, I explored what the dataset could reveal about Stack Overflow’s top users. I looked up the [top user of all time](https://stackoverflow.com/users/22656/jon-skeet) and used their user ID, along with the available BigQuery schema, to conduct a [basic check](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/001_user_data_exploration.sql) on the `users` table. This helped me understand the table’s structure and the types of insights I could extract.  

---

## **Ensuring Data Quality**  

Before performing deeper analysis, I conducted **data quality checks** to identify potential issues such as null values, duplicates, or unexpected data. Key questions I examined:  

1. [What is the minimum and maximum reputation?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/002_dq_reputation_min_max.sql) *(Assessing value ranges.)*  
2. [Can reputation be null?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/003_dq_reputation_null.sql)  
3. [Which columns in the `users` table allow null values?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/004_dq_user_table_nulls.sql)  
4. [Are there duplicate user IDs?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/005_dq_user_id_dupe_check.sql) *(Verifying primary key integrity.)*  

---

## **Exploratory Data Analysis (EDA)**  

Once I confirmed data quality, I conducted **exploratory data analysis (EDA)** to uncover patterns and trends. Some key questions I explored:  

1. [Which years had the highest total reputation, based on user account creation year?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/006_eda_reputation_by_year.sql)  
2. [What is the average reputation per user, grouped by account creation year?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/007_eda_avg_user_reputation.sql)  
3. [Who were the top 5 users by reputation in the top 5 years for reputation growth?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/008_eda_top_users_top_years.sql)  

---

## **Deeper Analysis: Advanced SQL Techniques**  

After initial EDA, I used **CTEs and window functions** to answer more complex questions and gain deeper insights:  

1. [What is the engagement pattern of the top 100 users by reputation?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/009_top_100_users_qa.sql) *(Do they predominantly answer questions, or do they also ask high-quality questions?)*  
2. [Which tags have the top 100 users used?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/010_top_100_users_tags.sql) *(Are they specialists or active across multiple topics?)*  
3. [What are the most popular tags among the top 100 users overall?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/011_top_100_users_top_tags.sql)  
4. [How have the top 10 users’ scores changed over rolling 5-year periods?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/012_top_10_users_rolling_scores.sql)  
5. [When did the top 10 users see the biggest year-over-year changes in question and answer scores?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/013_top_10_users_yoy_q_a_growth.sql)

___

This project used the publicly available [Stack Overflow](https://console.cloud.google.com/marketplace/product/stack-exchange/stack-overflow) dataset in BigQuery. This project is licensed under CC-BY-SA 4.0. See the [LICENSE](https://github.com/kim-h-l/portfolio-sql/blob/main/LICENSE) file for details.
