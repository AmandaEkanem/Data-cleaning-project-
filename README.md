# ðŸ“Š Layoffs Data Cleaning Project

## ðŸ§¼ Introduction

Welcome to the data cleaning phase! This project explores a series of steps to clean up messy data and make it good enough for accurate and insightful analysis.

> ðŸ“‚ **File Reference**:  
> - `LAYFOFFS DATA CLEANING PROJECT.sql`: Contains the full sequence of SQL cleaning operations.



## ðŸ” Background

This project tackles the problem of messy, inconsistent data in a dataset about global layoffs. The goal was to:

- Remove duplicate entries  
- Standardize categorical fields (e.g., industry, location)  
- Convert data types appropriately (e.g., date formats)  
- Handle `NULL` and blank values  
- Drop irrelevant rows and columns

Each step improves the reliability and usability of the data for future analysis.



## ðŸ› ï¸ Tools Used

- **SQL**: The core tool for querying, transforming, and cleaning the data.  
- **MySQL**: Chosen database system for managing and manipulating the dataset.  
- **GitHub**: Essential for version control, collaboration, and tracking project progress.



## ðŸ“ˆ The Analysis

Each SQL query in this project was focused on identifying and correcting issues in the dataset. The key steps were:

1. **Removing Duplicates**  
   Used `ROW_NUMBER()` and CTEs to identify and delete redundant rows.

2. **Standardizing Data**  
   - Trimmed whitespace in fields like `company` and `location`  
   - Corrected inconsistencies in categories (e.g., 'crpto' to 'crypto')  
   - Harmonized country names (e.g., 'United States.' to 'United States')

3. **Fixing Data Types**  
   - Converted `date` from text to proper `DATE` format using `STR_TO_DATE()`

4. **Handling Missing Values**  
   - Populated missing `industry` values by referencing other entries with the same company and location  
   - Removed rows where both `total_laid_off` and `percentage_laid_off` were missing

5. **Cleaning Final Schema**  
   - Dropped temporary and helper columns (e.g., `row_num`)



## ðŸ’¡ What I Learned

Throughout this adventure, Iâ€™ve turbocharged my SQL toolkit and gained:

- ðŸ§  Stronger **data transformation** logic with CTEs and `ROW_NUMBER()`  
- ðŸ› ï¸ Practical experience with **changing data types**:  
  - E.g., `ALTER TABLE` to change the `date` column from `TEXT` to `DATE`  
- ðŸŽ¯ Skills in **identifying useful data** and removing noise from large datasets



## âœ… Conclusion

By the end of this project, I transformed a messy and inconsistent dataset into a clean, standardized, and reliable one. This cleaned dataset is now ready for detailed analysis, visualization, and reporting in any data science or business intelligence workflow.
