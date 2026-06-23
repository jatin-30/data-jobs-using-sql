-- What are the top skills for the role of Data Analyst based on average salary in India?
SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_year_salary_usd
FROM job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_country = 'India' AND
    salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY avg_year_salary_usd DESC
LIMIT 10;