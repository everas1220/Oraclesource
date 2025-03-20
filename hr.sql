--employees (scott 의 emp 동일개념)
--first_name, last_name, job_id 조회
SELECT e.FIRST_NAME, e.LAST_NAME, e.JOB_ID 
FROM EMPLOYEES e;

--job_id 중복제외 후 조회
SELECT DISTINCT JOB_ID
FROM EMPLOYEES e;






--회사내의 최대연봉과 최소연봉의 차이 조회
SELECT MAX(e.SALARY)-MIN(e.SALARY) AS gap
FROM EMPLOYEES e ;


--매니저로 근무 하는 사원들숫자 조회
SELECT COUNT(DISTINCT e.MANAGER_ID)
FROM EMPLOYEES e ;


