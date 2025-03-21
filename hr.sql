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


-- 부서별 직원 수 조회(부서번호 오름차순)
-- 부서번호 직원수
SELECT E.DEPARTMENT_ID,COUNT(E.EMPLOYEE_ID)
FROM EMPLOYEES e
GROUP BY E.DEPARTMENT_ID
ORDER BY E.DEPARTMENT_ID;
-- 부서별 평균연봉 조회(부서번호 오름차순)
-- 부서번호 평균연봉(2215.35 => 2215)
SELECT E.DEPARTMENT_ID,ROUND(AVG(E.SALARY))
FROM EMPLOYEES e
GROUP BY E.DEPARTMENT_ID
ORDER BY E.DEPARTMENT_ID;

-- 동일한 직무를 가진 사원의 수 조회
-- JOB_ID 인원수
SELECT E.JOB_ID ,COUNT(E.EMPLOYEE_ID)
FROM EMPLOYEES e
GROUP BY E.JOB_ID
ORDER BY E.JOB_ID;























