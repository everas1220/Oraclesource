--employees (scott 의 emp 동일개념)
--first_name, last_name, job_id 조회
SELECT e.FIRST_NAME, e.LAST_NAME, e.JOB_ID 
FROM EMPLOYEES e;

--job_id 중복제외 후 조회
SELECT DISTINCT JOB_ID
FROM EMPLOYEES e;

