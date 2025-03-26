-- RDBMS
-- 기본단위 : 테이블


-- EMP(사원정보 테이블)
-- empno(사번), ename(사원명), job(직책), mgr(직속상관사번), hiredate(입사일), sal(급여), comm(추가수당), deptno(부서번호)
-- NUMBER(4,0) : 전체 자릿수는 4자리 소수점 자릿수0
-- VARCHAZ2(10) : 문자열 10Byte (VAR : 가변 -7Byte 문자열 저장했다면 7byte 공간만 사용)
--                영어 10문자, 한글 2byte, utf-8 3byte 할당
-- DATE : 날짜

-- DEPT (부서테이블)
-- deptno(부서번호), dname(부서명), loc(부서위치)

--SALGRADE(급여테이블)
--grade(급여등급), losal(최저급여), hisal(최대급여)

-- 개발자들 : C(insert) R(Read) U(Update) D(Delete)
-- SQL(Structured Query Language : 구조질의언어) : RDNMS 데이터를 다루는 언어 


--sql 구문 실행 순서 
-- 1.select
-- 2.from
-- 3.where
-- 4.group by
-- 5.having
-- 6.





-- 1. 조회(SELECT)-Read
-- 사원정보조회
SELECT * FROM EMP e;

-- 특정열 조회
SELECT e.EMPNO, e.ENAME, e.JOB FROM EMP e;

-- 사원번호, 부서번호만 조회
SELECT e.EMPNO, e.DEPTNO FROM EMP e;

-- 중복 데이터는 제외하고 조회 DISTINCT를 명령어 사이에 넣으면 됌
SELECT DISTINCT deptno FROM emp;

SELECT DISTINCT job, deptno FROM emp;

--별칭
SELECT ename, sal, sal * 12 + comm annsal, comm
FROM EMP;

SELECT ename, sal, sal * 12 + comm AS annsal, comm
FROM EMP;

SELECT ename, sal, sal * 12 + comm AS "annsal", comm FROM EMP;

SELECT ename, sal, sal * 12 + comm AS annsal, comm FROM EMP;

SELECT ename, sal, sal * 12 + comm AS 연봉, comm FROM EMP;

SELECT ename 사원명, sal 급여, sal * 12 + comm AS "연 봉", comm 수당 FROM EMP;

-- 원하는 순서대로 출력 데이터를 정렬(오름, 내림)
-- emp 테이블의 모든열을 급여 기준으로 오름차순 조회
-- emp 테이블의 모든 열을 급여 기준으로 오름차순 조회 
SELECT * FROM EMP e ORDER BY e.sal ASC;
SELECT * FROM EMP e ORDER BY e.sal;
--내림차순
SELECT * FROM EMP e ORDER BY e.sal DESC;
--사번, 이름, 직무만 급여기준으로 내림차순 조회
SELECT e.EMPNO, e.ENAME, e.JOB FROM EMP e ORDER BY e.sal DESC;

SELECT e.EMPNO employees_no,
	   e.ENAME employees_name,
	   e.mgr manager,
	   e.sal saLary,
	   e. comm commission,
	   e.deptno depaltment_no
FROM 
	EMP e;

SELECT
	*
FROM
	EMP e
ORDER BY
	e.DEPTNO DESC,
	e.ename ASC;

-- where : 조회 시 조건부여
-- 부서번호가 30번인 사원 조회
SELECT *
FROM EMP e
WHERE e.DEPTNO = 30;

-- 사번이 7782인 사원 조회 
SELECT
	*
FROM
	EMP e
WHERE
	e.EMPNO = 7782;

--부서 번호가 30이고 직책이 SALESMAN 사원 조회
--  오라클에서 문자는 '' 만 허용
SELECT
	*
FROM
	EMP e
WHERE
	e.deptno = 30 AND e.job = 'SALESMAM';

--사번이 7499 이고 부서번호가 30 사원조회
SELECT
	*
FROM
	EMP e
WHERE
	e.EMPNO = 7499 OR e.DEPTNO = 30;

-- 연산자
-- 1) 산술연산자 : +,-,*,/
-- 2) 비교연산자 : >,<,>=,<=,=
-- 3) 등가비교연산자 : =, 같지않다(!=,<>, ^= )
-- 4) 논리부정연산자 : NOT
-- 5)            : IN
-- 6) 범위 : BETWEEN A AND B 
-- 7) 검색 : LIKE 연산자와 와일드 카드(_,%)
-- 8) IS NULL : 널과 같다 

-- 연봉이 (SAL *12) 36000 인 사원 조회 
SELECT * 
FROM EMP e 
WHERE e.SAL*12 = 36000;

--급여가 3000이상인 사원 조회 
SELECT * 
FROM EMP e 
WHERE e.SAL >= 3000;

-- 급여가 2500이상이고 직업이 ANALYST 사원 조회 
SELECT * 
FROM EMP e 
WHERE e.SAL >= 2500 AND e.JOB = 'ANALYST'

-- 문자 대소문자 비교 
-- 사원명의 첫 문자가 F와 같거나 F보다 뒤에 있는 사원 조회
SELECT *
FROM EMP e 
WHERE e.DNAME >= 'F';

--급여가 3000이 아닌 사원 조회 
SELECT * 
FROM EMP e 
WHERE e.SAL != 3000;

SELECT * 
FROM EMP e 
WHERE e.SAL <> 3000;

SELECT * 
FROM EMP e 
WHERE e.SAL ^= 3000;


-- 사원이 176인 사원의 last_name과 부서번호 조회
SELECT e.LAST_NAME, e.DEPARTMENT_ID
FROM EMPLOYEES e 
WHERE e.EMPLOYEE_ID = 176;

-- 연봉이 12000이상되는 사원의 last_name 과 급여를 조회
SELECT e.LAST_NAME, e.SALARY
FROM EMPLOYEES e 
WHERE e.SALARY >= 12000;

-- 급여가 5000 ~ 12000 범위가 아닌 사원의 last_name과 급여를 조회
SELECT e.LAST_NAME, e.SALARY
FROM EMPLOYEES e 
WHERE NOT(e.SALARY >= 5000 AND e.e.SALARY <= 12000);

SELECT e.LAST_NAME, e.SALARY
FROM EMPLOYEES e 
WHERE NOT(e.SALARY < 5000 OR .e.SALARY > 12000);

-- job이 MANAGER이거나, SALESMAN이거나, CLERK 사원 조회
SELECT *
FROM EMP e
WHERE e.JOB = 'MANAGER' OR e.JOB = 'SALESMAN' OR e.JOB ='CLERK'

-- in 연산자로 변경
SELECT * FROM EMP e WHERE e.job IN ('MANAGER','SALESMAN','CLERK');

SELECT * FROM EMP e WHERE e.job NOT IN ('MANAGER','SALESMAN','CLERK');

-- BETWEEN A AND B 

-- 급여 2000이상 3000이하 
SELECT * FROM EMP E WHERE E.SAL >=2000 AND E.SAL <=3000;

SELECT * FROM EMP E WHERE E.SAL BETWEEN 2000 AND 3000;

-- 급여 2000이상 3000이하가 아닌 사원 조회
SELECT * FROM EMP E WHERE E.SAL NOT BETWEEN 2000 AND 3000;

-- LIKE 
-- _ : 어떤 값이든 상관없이 한 개의 문자열 데이터를 의미
-- % : 길이와 상관없이(문자 없는 경우도 포함) 모든 문자열 데이터를 의미

-- 사원명이 S로 시작하는 사원 조회 
SELECT * FROM EMP E WHERE E.DNAME LIKE 'S%';

-- 사원이름의 두번쨰 글자가 L인 사원 조회
SELECT * FROM EMP E WHERE E.DNAME LIKE '_L%'


-- 사원명에 AM이 포함된 사원 조회 
SELECT * FROM EMP E WHERE E.DNAME LIKE 'AM%'

-- 사원명에 AM이 포함되지않은 사원 조회 

SELECT * FROM EMP E WHERE E.DNAME NOT LIKE 'AM%'

-- IS NULL
-- COMM이 NULL 인 사원 조회
SELECT * FROM EMP e WHERE e.COMM IS NULL; 

-- MGR이 NULL인 사원 조회
SELECT * FROM EMP e WHERE e.MGR IS NULL;

--직속상관이 있는 사원 조회 
SELECT *
FROM EMP e 
WHERE e.MGR IS NOT NULL;




-- BETWEEN A AND B 

SELECT e.LAST_NAME, e.SALARY
FROM EMPLOYEES e 
WHERE e.SALARY NOT BETWEEN 5000 OR .e.SALARY > 12000);



SELECT e.LAST_NAME, e.SALARY
FROM EMPLOYEES e 
WHERE NOT(e.SALARY < 5000 OR .e.SALARY > 12000);


-- IN / NOT IN
-- 20,50 번 부서에 근무하는 사원 조회(LAST_NAME, 부서번호), LAST_NAME 오름차순
SELECT e.LAST_NAME, e.DEPARTMENT_ID 
FROM EMPLOYEES e WHERE e.DEPARTMENT_ID IN (20,50) ORDER BY e.LAST_NAME ASC;


-- SALARY가 2500,3500,7000이 아니며, 직무가 SA_REP< ST_CLERK가 아닌 사원조회
SELECT *
FROM
	EMPLOYEES e
WHERE e.SALARY NOT IN (2500, 3500, 7000) AND e.JON_IN NOT IN ('AS_REP','ST_CLERK');

-- 날짜데이터 '사용'
-- 고용일이 2014년 사원 조회(2014-01-01~ 2014-12-31)
SELECT *
FROM EMPLOYEES e
WHERE e.HIRE_DATE >= '2014-01-01' AND e.HIRE_DATE <= '2014-12-31';

SELECT *
FROM EMPLOYEES e
WHERE e.HIRE_DATE BETWEEN '2014-01-01' AND '2014-12-31';

-- LIKE 
-- LAST_NAME 에 u가 포함되는 사원들의 사번, last_name 조회
SELECT e.
FROM EMPLOYEES e
WHERE e.LAST_NAME LIKE '%u%';

-- LAST_NAME의 4번째글자가 a 인 사원들의 사번, last_name 조회
SELECT e.
FROM EMPLOYEES e
WHERE e.LAST_NAME LIKE '___a%';

-- LAST_NAME에 a 혹은 e글자가 있는 사원들의 사번, last_name 조회(last_name 내림차순)
SELECT e.EMPLOYEE_ID, e.LAST_NAME
FROM EMPLOYEES e
WHERE e.LAST_NAME LIKE '%a%' OR e.LAST_NAME LIKE '%e%' ORDER BY e.LAST_NAME DESC;

-- LAST_NAME에 a 와 e글자가 있는 사원들의 사번, last_name 조회(last_name 내림차순)
SELECT e.EMPLOYEE_ID, e.LAST_NAME
FROM EMPLOYEES e
WHERE e.LAST_NAME LIKE '%a%e%' OR e.LAST_NAME LIKE '%e%a%' ORDER BY e.LAST_NAME DESC;

-- IS NULL 
-- 매니저가 없는 사원들의 LAST_NAME, JOB_ID 조회
SELECT E.LAST_NAME,E.JOB_ID
FROM EMPLOYEES e
WHERE E.MANAGER_ID IS NULL;

--ST_CLERK인 직업을 가진 사원이 없는 부서 번호 조회(단, 부서번호가 널값인 부서 제외)
SELECT E.LAST_NAME,E.JOB_ID
FROM EMPLOYEES e
WHERE E.JOB_ID != 'ST_CLERK' AND E.DEPARTMENT_ID IS NOT NULL;

-- COMMISSION_PCT가 NULL이 아닌 사원들 중에서 COMMISSION=SALARY * COMMISSION_PCT 를 구한다
-- 계산결과와 함께 사번,FIRST_NAME,JOB_ID 출력
SELECT E.EMPLOYEES_ID,E.FIRST_NAME,E.JOB_ID, E.SALARY* E.COMMISSION_PCT AS COMMISION
FROM EMPLOYEES e
WHERE E.COMMISSION_PCT IS NOT NULL;











