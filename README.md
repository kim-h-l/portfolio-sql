# SQL Portfolio

## Stack Overflow Data

I did initial analysis using the Stack Overflow data set in Google BigQuery.

All SQL links can be found [here](https://github.com/kim-h-l/portfolio-sql/tree/main/stackoverflow)

### Understanding the Data

I went to Stack Overflow and found the [top user of all time](https://stackoverflow.com/users/22656/jon-skeet). Using the id in the URL and the schema available in BigQuery, I did a [basic check](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/001_user_data_exploration.sql) to get an understanding of what the user table looks like.

### Data Quality Checks

I then did some basic data quality checks to make sure I understood where I might find null values or duplication (to check for a primary key). I did also did a check to see if my assumption was valid that reputation couldn't be negative or zero.

1. [What is the min and max reputation? So that I can understand the range of values.](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/002_dq_reputation_min_max.sql)
2. [Can reputation be null?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/003_dq_reputation_null.sql)
3. [What values are nullable in the user table?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/004_dq_user_table_nulls.sql)
4. [Are there any duplicate ids in the user table?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/005_dq_user_id_dupe_check.sql)

### Exploratory Data Analysis

I then did some exploratory data analysis to determine some initial insights from the data.

1. [What years had the highest reputation, by year the user created their account?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/006_eda_reputation_by_year.sql)
2. [What years had the highest reputation per user, by year the user created their account?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/007_eda_avg_user_reputation.sql)
3. [Who were the top 5 users by reputation in the top 5 years by reputation, by year the user created their account?](https://github.com/kim-h-l/portfolio-sql/blob/main/stackoverflow/008_eda_top_users_top_years.sql)
