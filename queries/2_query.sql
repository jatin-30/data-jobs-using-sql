-- What are the skills associated with the top-paying data analyst/data scientist roles from the previous query?

WITH ranked_jobs AS (
    SELECT
        job_id,
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
        AND job_title_short IN ('Data Scientist','Data Analyst')
        AND salary_year_avg IS NOT NULL
)

SELECT
    company_name,
    job_title,
    job_title_short,
    avg_year_salary_usd,
    skills
FROM ranked_jobs
INNER JOIN skills_job_dim
    ON ranked_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE rn <= 5
ORDER BY 
    job_title_short,
    avg_year_salary_usd;
