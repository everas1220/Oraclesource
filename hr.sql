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

--직업 ID가 SA_MAN인 사원들의 최대 연봉보다 높게 받는 사원들의 
-- LAST_NAME, JOB_ID, SALARY 조회 
SELECT e.EMPLOYEE_ID,e.LAST_NAME,e.SALARY FROM EMPLOYEES e WHERE e.salary >
(SELECT avg(e.SALARY) FROM EMPLOYEES e GROUP BY e.DEPARTMENT_ID); 



-- 커미션을 받는 사원들의 부서와 연봉이 동일한 사원들의 LAST_NAME,Department_id,SALARY 조회
SELECT 
FROM EMPLOYEES e 


--회사전체 평균 연봉보다 더버는 사원들 중 last_name에 u가 있는 사원들이 근무하는 부서와 같은 부서에 근무하는 사원들의 
-- 사번, last_name, salary, deptni, 해당부서의 평균연봏 조회 (부서멸 평균연봉을 기준으로 오름차순)
SELECT 
FROM EMPLOYEES e 


--last_name이 'Davies' 인 사람보다 나중에 고용된 사원들의 last_name, hire_date 조회 
SELECT 
FROM EMPLOYEES e


--last_name이 'King'인 사원을 매니저로 두고 있는 모든 사원들의 last_name,salary 조회
SELECT 
FROM EMPLOYEES e


--last_name이 'Kochhar'인 사원과 동일한 연봉및 커미션을 받는 사원들의 last_name,부서번호,연봉조회
--단 kochhar은 제외
SELECT 
FROM EMPLOYEES e

--last_name이 'Hall'인 사원과 동일한 연봉및 커미션을 받는 사원들의 last_name,부서번호,연봉조회
--단 Hall은 제외
SELECT 
FROM EMPLOYEES e


--last_name이 'Zlotkey'인 사원과 동일한 부서에서 근무하는 모든사원들의 사버,고용날짜 조회
--단 'Zlotkey' 은 제외


--부서가 위치한 지역의 국가 id 및 국가명을 조회한다
--Location 테이블, departments, countries 테이블을 사용한다
SELECT 
FROM EMPLOYEES e

--위치 ID가 1700인 사원들의 연봉과 커미션을 추출한뒤, 추출된 사원들의 연봉과 커미션이 동일한 사원정보 출력
-- 출력 : 사번, 이름(first_name + last_name), 부서번호,급여
SELECT 
FROM EMPLOYEES e


























































































