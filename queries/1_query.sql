-- What are the top-paying Jobs specifically for the roles of data analyst and data scientist?

WITH ranked_jobs AS (
    SELECT
        name AS company_name,
        job_title,
        job_title_short,
        job_location,
        salary_year_avg AS avg_year_salary_usd,
        ROW_NUMBER() OVER (
            PARTITION BY job_title_short
            ORDER BY salary_year_avg
        ) AS rn
    FROM job_postings_fact
    LEFT JOIN company_dim
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_country = 'India'
        AND job_title_short IN ('Data Analyst', 'Data Scientist')
        AND salary_year_avg IS NOT NULL
)

SELECT
    company_name,
    job_title,
    job_title_short,
    job_location,
    avg_year_salary_usd
FROM ranked_jobs
WHERE rn <= 5
ORDER BY job_title_short, avg_year_salary_usd;