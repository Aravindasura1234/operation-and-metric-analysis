
CREATE DATABASE job;

use job;

CREATE TABLE job_data
(
    ds DATE,
    job_id INT NOT NULL,
    actor_id INT NOT NULL,
    event VARCHAR(15) NOT NULL,
    language VARCHAR(15) NOT NULL,
    time_spent INT NOT NULL,
    org CHAR(2)
);

INSERT INTO job_data (ds, job_id, actor_id, event, language, time_spent, org)
VALUES ('2020-11-30', 21, 1001, 'skip', 'English', 15, 'A'),
    ('2020-11-30', 22, 1006, 'transfer', 'Arabic', 25, 'B'),
    ('2020-11-29', 23, 1003, 'decision', 'Persian', 20, 'C'),
    ('2020-11-28', 23, 1005,'transfer', 'Persian', 22, 'D'),
    ('2020-11-28', 25, 1002, 'decision', 'Hindi', 11, 'B'),
    ('2020-11-27', 11, 1007, 'decision', 'French', 104, 'D'),
    ('2020-11-26', 23, 1004, 'skip', 'Persian', 56, 'A'),
    ('2020-11-25', 20, 1003, 'transfer', 'Italian', 45, 'C');

SELECT * FROM job_data;

	-- A.No of Jobs Reviewed
SELECT COUNT(distinct job_id)/(30*24) AS num_of_jobs_reviewed_per_hour_per_day
FROM job_data;

	-- B.Throughput
SELECT ds, job_reviewed, AVG(job_reviewed) OVER(ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS thorughput_7
FROM (SELECT ds,COUNT(DISTINCT job_id) AS job_reviewed
FROM job_data
GROUP BY ds
ORDER BY ds)a;

	-- C.Percentage Share of each Language 
SELECT language, (num_jobs/total_jobs)*100 AS Percentage_Share_of_Language
FROM (SELECT language, COUNT(DISTINCT job_id) AS num_jobs
FROM job_data
GROUP BY language)a
CROSS JOIN
(SELECT COUNT(distinct job_id) AS total_jobs
FROM job_data)b;

	-- D.Duplicate rows
SELECT * 
FROM(SELECT *, ROW_NUMBER() OVER(PARTITION BY job_id) AS row_num
FROM job_data)a WHERE row_num>1