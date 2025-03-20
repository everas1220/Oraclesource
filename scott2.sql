-- 오라클 함수
 -- 내장함수 
 -- 1) 문자 함수
 -- 대소문자를 바꿔주는 함수 : upper(), lower(),inticap()
 --문자의 길이를 구하는 함수
 --문자열 일부를 추출하는 함수






--LPAD(데이터, 데이터 자릿수, 채울문자)
--RPAD(데이터, 데이터 자릿수, 채울문자)

--Oracle => 10 자리로 표현
SELECT 
	'Oracle',
	LPAD('Oracle', 10, '#'),
	RPAD('Oracle', 10, '*'),
	LPAD('Oracle', 10),
	RPAD('Oracle', 10)
FROM dual;



SELECT e.SAL, TO_CHAR(e.sal, '$999,999'), TO_CHAR(e.sal, '%000,999,999')
FROM EMP e;

SELECT 1300-'1500', 1300 +'1500'
FROM dual;

SELECT '1300' - '1500'
FROM dual;

SELECT '1,300' - '1,500'
FROM dual;

SELECT TO_NUMBER('1300','999,999') - TO_NUMBER('1,500','999,999')
FROM dual;

SELECT 
TO_DATE('2025-03-20', 'YYYY-MM-DD') AS DATE1,
TO_DATE('2025-03-20', 'YYYY/MM/DD') AS DATE2
FROM 
	dual;


--NULL
--산술연산이나 비교연산자가 제대로 수행되지않음
--1) NVL(널 여부를 검사할 데이터,널일때 반환할 데이터)
--2) NVL2(널 여부를 검사할 데이터,널이 아닐때 반환할 데이터 ,널일때 반환할 데이터)

SELECT e.EMPNO, e.DNAME, e.comm, e.sal*e.comm, NVL(e.COMM,0), e.SAL + NVL(e.COMM,0)
FROM EMP e;

SELECT 
	e.EMPNO,
	e.DNAME,
	e.sal,
	e.comm
	e.SAL + e.COMM,
	NVL2(e.comm, 'O','X'),
	NVL2(e.comm, e.sal *12 +e.COMM, e.sal*12) AS 연봉
FROM 
 EMP e;

--자바의 if, switch 구문과 유사
--DECODE
--DECODE(검사대상이 될 데이터, 
--			조건1,조건1 만족시 반환할 결과,
--			조건1,조건1 만족시 반환할 결과,
--			조건1~조건n 일치하지않을때 반환할 결과,
--)
--CASE

-- 직책이 MANAGER인 사원은 급여의 10%인상
-- 직책이 SALESMAN인 사원은 급여의 5%인상
-- 직책이 ANALYST인 사원은 동결
-- 나머지는 3%인상

SELECT 
	e.EMPNO,
	e.DNAME,
	e.LOB,
	e.SAL,
	DECODE(e.LOB, 'MANAGER', e.SAL *1.1,
	'SALESMAN', e.sal * e.sal * 1.05,
	'ANALYST', e.sal,
	e.sal * 1.03
	) AS upsal
FROM 
	EMP e;



SELECT 
	e.EMPNO,
	e.DNAME,
	e.LOB,
	e.SAL,
	CASE 
		e.lob 
	WHEN 'MANAGER' THEN e.SAL *1.1
		WHEN 'SALESMAN' THEN e.sal * 1.05,
		WHEN 'ANALYST' THEN e.sal,
		ELSE e.sal * 1.03
	END AS upsal
FROM 
	EMP e;

--comm이 null인 경우 '해당사항없음'
--comm이 0인 경우 '수당없음'
--comm > 0인 경우 수당 :'800'

SELECT 
	e.EMPNO,
	e.DNAME,
	e.LOB,
	e.SAL,
	CASE 
	WHEN e.comm IS NULL THEN '해당사항없음'
		WHEN e.comm = 0 THEN  '수당없음'
		WHEN e.COMM > 0 THEN  '수당 :' || e.COMM	
	END AS comm_TEXT
FROM 
	EMP e;

-- [실습]
-- 1. empno 7369 => 73**, ename SMITH => S****
-- empno, 마스킹 처리 empno, ename, 마스킹 처리 ename

SELECT REPLACE('7369',SUBSTR('7369',3),'**')
FROM dual;

SELECT 
	e.EMPNO,
	REPLACE(e.EMPNO, SUBSTR(e.empno,3)'**') AS masking_empno,
	E.DNAME,
	REPLACE(e.dname, SUBSTR(e.dname,2)'**') AS masking_dname,
FROM 
	emp e;

--RPAD(열이름,자릿수,채울문자)
	SELECT 
	e.empno,
	RPAD(SUBSTR(e.empno,1,2),4,'*') AS masking_empno,
	E.DNAME,
	RPAD(SUBSTR(e.dname, 1,1),5,'*') AS masking_dname
FROM 
	emp e;

--2. emp 테이블에서 사원의 월평균 근무일수는 21일이다.
-- 하루 근무 시간을 8시간으로 보았을 때 사원의 하루급여(day_pay)와 시급(time_pay)를
-- 계산하여 출력한다.(단, 하루급여는 소수 셋째자리에서 버리고, 시급은 둘째자리에서 반올림한다)
SELECT 
	E.EMPNO,
	E.DNAME,
	E.SAL,
	TRUNC(E.SAL/21) AS day_pay,
	TRUNC(e.SAL/21/8,1) AS time_pay
FROM 
	EMP e;

--3. 입사일을 기준으로 3개월이 지난후 첫 월요일에 정직원이 된다.
-- 사원이 정직원이 되는 날짜(R_JOB)을 YYYY-MM-DD 형식으로 출력한다/
-- 단, 추가수당이 없는 사원의 추가수당은 N/A로 출력 
-- 출력형태 ) EMPNO, ENAME, HIRE DATE, R_JOB, COMM
SELECT
	E.EMPNO,
	E.DNAME,
	E.HIREDATE,
	NEXT_DAY(ADD_MONTHS(E.HIREDATE, 3), '월요일') AS R_LOB
	NVL(TO_CHAR(E.COMM),'N/A') AS COMM
FROM 
	EMP e;


--4. 직속상관의 사원번호가 없을때 : 0000
-- 직속상관의 사원번호 앞 두자리가 75일때 : 5555
-- 직속상관의 사원번호 앞 두자리가 76일때 : 6666
-- 직속상관의 사원번호 앞 두자리가 77일때 : 7777
-- 직속상관의 사원번호 앞 두자리가 78일때 : 8888
-- 그 외 직속강관 사원번호일때 : 본래 직속상관 사원본호 그대로 출력 
-- 출력 형태) EMPNO, ENAME, MGR, CHG_MGR
SELECT
	E.EMPNO,
	E.DNAME,
	E.MGR,
	CASE
		WHEN E.MGR IS NULL THEN '0000'
		WHEN SUBSTR(TO_CHAR(E.MGR),1,2) ='75' THEN '5555'
		WHEN SUBSTR(TO_CHAR(E.MGR),1,2) ='76' THEN '6666'
		WHEN SUBSTR(TO_CHAR(E.MGR),1,2) ='77' THEN '7777'
		WHEN SUBSTR(TO_CHAR(E.MGR),1,2) ='78' THEN '8888'
		ELSE TO_CHAR(E.MGR) 
	END AS CHG_MGR
FROM
	EMP E;

-- 하나의 열에 출력결과를 담는 다중행 함수
-- 1. SUM()/ 2.COUNT()/3.MAX()/ 4. MIN() / 5. AVG()

-- 전체사원 급여합
SELECT sum(e.sal) FROM emp e;

--중복된 급여는 제외한 합
SELECT sum(e.sal), sum(DISTINCT E.SAL), sum(ALL E.SAL) FROM emp e;


--사원수
SELECT COUNT(e.empno), COUNT(e.COMM)
FROM EMP e;

--급여의 최대값과 최소값
SELECT MAX(e.sal),MIN(e.sal)
FROM EMP e;

--10번부서의 사원중 급여 최대값
SELECT max(e.sal), MIN(e.sal)
FROM EMP e
WHERE e.DEPTNO = 10;

--20번 부서의 입사일 중 최근 입사일 출력
SELECT MAX(e.hiredate), MIN(e.hiredate)
FROM EMP e 
WHERE e.DEPTNO = 20

--부서번호가 30번인 사원의 평균 급여
SELECT 




























