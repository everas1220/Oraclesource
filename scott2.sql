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
SELECT AVG(E.SAL)
FROM EMP E
WHERE E.DEPTNO = 30;

-- 결과값을 원하는 열로 묶어 출력 : GROUP BY 

-- 부서별 평균 급여 조회
SELECT E.DEPTNO, AVG(E.SAL) 
FROM EMP E
GROUP BY E.DEPTNO;

-- 부서별, 직책별 평균 급여 조회
SELECT E.DEPTNO, E.LOB ,AVG(E.SAL) 
FROM EMP E
GROUP BY E.DEPTNO, E.LOB
ORDER BY E.DEPTNO;

--결과값을 우너하는 열로 묶어 출력할 때 조건 추가 : GROUP BY + HAVING

--부서별, 직책별 평균 급여 조회 + 평균급여 >= 2000
SELECT E.DEPTNO, E.LOB ,AVG(E.SAL) 
FROM EMP E
GROUP BY E.DEPTNO, E.LOB HAVING AVG(E.SAL) >= 2000
ORDER BY E.DEPTNO;


SELECT E.DEPTNO, E.LOB ,AVG(E.SAL) 
FROM EMP E
WHERE AVG(E.SAL) >= 2000
GROUP BY E.DEPTNO, E.LOB 
ORDER BY E.DEPTNO;

--SQL Error [934] [42000]: ORA-00934: 그룹 함수는 허가되지 않습니다
-- WHERE 절 그룹함수 안됨
--SELECT E.DEPTNO, E.LOB ,AVG(E.SAL) 
--FROM EMP E
--WHERE AVG(E.SAL) >= 2000
--GROUP BY E.DEPTNO, E.LOB 
--ORDER BY E.DEPTNO;

-- 같은 직무에 종사하는 사원이 3명 이상인 직책과 인원수 출력
-- SALESMAN 4
SELECT E.LOB,COUNT(E.EMPNO)
FROM EMP e 
GROUP BY E.LOB HAVING COUNT(E.EMPNO) >= 3;

-- 사원들의 입사연도를 기준으로 부서별로 몇명이 입사했는지 출력
-- 1987 20 2
-- 1987 30 1
SELECT TO_CHAR(E.HIREDATE, 'YYYY'), e.DEPTNO, COUNT(E.EMPNO)
FROM EMP e 
GROUP BY TO_CHAR(E.HIREDATE, 'YYYY'), e.DEPTNO;

-- 조인(JOIN)
-- 여러 종류의 데이터를 다양한 테이블에 나누어 저장하기 때문에 여러 테이블의 데이터를 조합하여
-- 출력할때가 많다. 이떄 사용하는 방식을 조인으로 추천함
-- 종류

-- 내부조인(연결이 안되어있는 데이터는 제외됨)
-- 1. 등가 조인 : 각테이블의 특정열과 일치하는 데이터를 기준으로 추출
-- 2. 비등가조인 : 등가조인 외의 방식
-- 3. 자체(self) : 같은 테이블끼리 조인

-- 외부조인 : 연결 안되는 데이터보기 - OUTER JOIN
 -- 1. 왼쪽외부조인(LEFT OUTER JOIN) : 오른쪽 테이블의 데이터 존재 여부와 상관없이 왼쪽 테이블 기준으로 출력
 -- 2. 오른쪽외부조인(RIGHT OUTER JOIN) : 왼쪽 테이블의 데이터 존재 여부와 상관없이 오른쪽 테이블 기준으로 출력

-- 사원별 부서정보 조회
SELECT * 
FROM EMP E, DEPT d 
WHERE E.DEPTNO = D.DEPTNO;

SELECT E.EMPNO, E.DEPTNO, E.DNAME, D.LOC
FROM EMP E, DEPT d 
WHERE E.DEPTNO = D.DEPTNO;

-- 나올수 있는 모든 조합 출력
SELECT E.EMPNO, E.DEPTNO, E.DNAME, D.LOC
FROM EMP E, DEPT d;

-- 사원별 부서정보 조회 + 사원별 급여 >= 3000
SELECT E.EMPNO, E.DEPTNO,E.SAL , E.DNAME, D.LOC
FROM EMP E, DEPT d 
WHERE E.DEPTNO = D.DEPTNO AND E.SAL >= 3000;

-- 사원별 부서정보 조회 + 사원별 급여 <= 2500 + 사원번호 9999이하
SELECT E.EMPNO, E.DEPTNO,E.SAL , E.DNAME, D.LOC
FROM EMP E, DEPT d 
WHERE E.DEPTNO = D.DEPTNO AND E.SAL <= 2500
AND E.EMPNO <=9999;

-- 비등가조인
--사원별 정보 + SALGRADE GRADE
SELECT *
FROM EMP e, SALGRADE s 
WHERE E.SAL >= S.LOSAL AND E.SAL <= S.HISAL;
 
 
SELECT *
FROM EMP e, SALGRADE s 
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL;

--자체조인(self)
--사원정보 + 직속상관 정보
SELECT E1.EMPNO, E1.DNAME, E1.MGR, E2.DNAME AS MGR_DNAME FROM EMP e1, EMP E2
WHERE E1.MGR = E2.EMPNO;

--LEFT OUTER JOIN
SELECT E1.EMPNO, E1.DNAME, E1.MGR, E2.DNAME AS MGR_DNAME
FROM EMP e1, EMP E2
WHERE E1.MGR = E2.EMPNO(+);

--RIGHT OUTER JOIN
SELECT E1.EMPNO, E1.DNAME, E1.MGR, E2.DNAME AS MGR_DNAME
FROM EMP e1, EMP E2
WHERE E1.MGR(+) = E2.EMPNO;

-- 표준 문법을 사용한 조인
--JOIN~ON
SELECT e.EMPNO, E.DEPTNO,D.DNAME , D.LOC
FROM EMP e JOIN DEPT d ON E.DEPTNO = D.DEPTNO;

SELECT *

FROM EMP E 
JOIN SALGRADE s ON E.SAL BETWEEN S.LOSAL AND S.HISAL;

-- LEFT OUTER JOIN 테이블명 ON 조인조건
SELECT
	e1.EMPNO,
	E1.DNAME,
	E1.MGR,
	E2.DNAME AS MGR_DNAME
FROM
	EMP e1
LEFT OUTER JOIN EMP e2
ON 
	E1.MGR = E2.EMPNO;


SELECT
	e1.EMPNO,
	E1.DNAME,
	E1.MGR,
	E2.DNAME AS MGR_DNAME
FROM
	EMP e1
LEFT OUTER JOIN EMP e2
ON 
	E1.MGR = E2.EMPNO;

SELECT *
FROM 
	EMP E
INNER JOIN SALGRADE s
ON
	E.SAL BETWEEN S.LOSAL AND S.HISAL;



SELECT
	*
FROM
	EMP e1
JOIN EMP e2 ON
	E1.EMPNO = E2.EMPNO
JOIN EMP E3 ON
	E2.EMPNO = E3.EMPNO;


--급여가 2000을 초과한 사원의 부서정보, 사원정보출력
--출력) 부서번호,부서명,사원번호,사원명,급여
SELECT E.DEPTNO, D.DNAME, E.EMPNO, E.DNAME, E.SAL
FROM EMP E JOIN DEPT d ON E.DEPTNO = D.DEPTNO
WHERE E.SAL > 2000
ORDER BY E.DEPTNO;


--모든 부서정보와 사원정보를 부서번호,사원번호 순서로 정렬하여 출력
--츨력) 부서번호, 부서명, 사원번호, 사원명, 직무, 급여
SELECT E.DEPTNO, D.DNAME, E.EMPNO, E.DNAME, E.SAL 
FROM EMP E JOIN DEPT D ON E.DEPTNO = D.DEPTNO
ORDER BY E.DEPTNO, E.EMPNO;


-- 모든 부서정보,사원정보,급여등급정보, 각 사원의 직속상관 정보를 
-- 부서번호,사원번호 순서로 정렬하여 출력
-- 출력) 부서번호,부서명,사원번호,사원명,매니저번호,급여,LOSAL,HISAL,GRADE,매니저EMPNO,매니저이름
SELECT
	E1.DEPTNO,
	D.DNAME,
	E1.EMPNO,
	E1.DNAME,
	E1.MGR,
	E1.SAL,
	E2.EMPNO AS MGR_EMPNO,
	E2.DNAME AS MGR_DNAME
FROM
	EMP e1
LEFT OUTER JOIN EMP E2 ON
	E1.MGR = E2.EMPNO
JOIN DEPT D ON
	E1.DEPTNO = D.DEPTNO
JOIN SALGRADE s ON
	E1.SAL BETWEEN S.LOSAL AND S.HISAL
ORDER BY
	E1.DEPTNO,
	E1.EMPNO;


-- 부서별 평균급여, 최대급여, 최소급여, 사원수 출력
-- 부서번호,부서명, avg_sal, min_sal, cnt 
SELECT
	E.DEPTNO,
	D.DNAME ,
	AVG(E.SAL) AS AVG_SAL,
	MAX(E.SAL) AS MAX_SAL,
	MIN(E.SAL) AS MIN_SAL,
	COUNT(E.EMPNO) AS CNT
FROM
	EMP E
JOIN DEPT d ON
	E.DEPTNO = D.DEPTNO
GROUP BY
	E.DEPTNO,
	D.DNAME;


-- 서브쿼리 : SQL 구문을 실행하는데 필요한 데이터를 추가로 조회하고자 SQL구문 내부에서 사용하는 SELECT 문
-- 연산자등의 비교 또는 조회 대상오른쪽에 두며 괄호로 묶어서사용을 해야함
-- 특수한 몇몇 경우를 제외한 대부분의 서브쿼리에서는 ORDER BY절을 사용할수있다
-- 서브쿼리의 SELECT 절에 명시한 열은 메인쿼리의 비교 대상과 같은 자료형과 같은 갯수로 지정
-- 서브쿼리에 있는 SELECT문의 결과 행 수는 함께 사용하는 메인 쿼리의 연산자 종류와 어울려야한다
-- 1) 단일행 서브쿼리 : 실행결과가 행하나인 서브쿼리
--		연산자 : >, >=, =, <=, <>, ^=, !=
-- 2) 다중행 서브쿼리 : 실행결과가 여러갱의 행인 서브쿼리
--		연산자 : IN, ANY(SOME), ALL, EXISTS
-- 3) 다중열 서브 쿼리 : 서브쿼리의 SELECT 문의 



-- 이름이 JONES인 사원의 급여보다 높은 급여를 받는 사원 조회

--JONES의 급여 조회
SELECT SAL FROM EMP e WHERE E.DNAME = 'JONES';

--JONES보다 높은 급여를 받는 사원 조회
SELECT * FROM EMP E WHERE E.SAL > 2975;

-- 서브 쿼리로 변경
SELECT * FROM EMP E WHERE E.SAL > (SELECT SAL FROM EMP e WHERE E.DNAME = 'JONES');

-- ALLEN 보다 빨리 입사한 사원 조회 
SELECT * FROM EMP E WHERE E.HIREDATE > (SELECT E.HIREDATE FROM EMP e WHERE E.DNAME = 'ALLEN');

-- 20번 부서에 속한 사원중 전체 사원의 평균급여보다 높은 급여를 받은 사원정보(사번, 이름, 직무, 급여)

SELECT
	E.EMPNO,E.DNAME,E.DEPTNO,D.DNAME,D.LOC
FROM
	EMP E JOIN DEPT d ON E.DEPTNO = D.DEPTNO
WHERE
	E.DEPTNO = 20
	AND E.SAL > (
	SELECT
		AVG(E.SAL)
		FROM EMP E);

-- 전체 사원의 평균급여보다 적거나 같은 급여를 받는 20번 부서의 정보 조회 

SELECT
	E.EMPNO,E.DNAME,E.DEPTNO,D.DNAME,D.LOC
FROM
	EMP E JOIN DEPT d ON E.DEPTNO = D.DEPTNO
WHERE
	E.DEPTNO = 20
	AND E.SAL <= (
	SELECT
		AVG(E.SAL)
		FROM EMP E);
-- 다중행 서브쿼리

-- 부서별 최고 급여와 같은 급여를 받는 사원 조회
-- 1) 부서별 최소 급여
SELECT MAX(E.SAL)
FROM EMP E GROUP BY E.DEPTNO

SELECT * FROM EMP E WHERE  E.SAL IN (3000, 2850, 5000);

-- 서브 쿼리 사용
SELECT * FROM EMP E
WHERE E.SAL IN (SELECT MAX(E.SAL) FROM EMP E GROUP BY E.DEPTNO);

-- ANY, SOME : 서브쿼리가 반환한 여러결과값 중 메인쿼리와 조건식을 사용한 결과가 하나라도 TRUE라면
--			   메인쿼리 조건식을 TRUE로 반환 


SELECT * FROM EMP E WHERE
E.SAL= ANY(
SELECT
	MAX(E.SAL)
FROM
	EMP e
WHERE
	E.DEPTNO);


-- < ANY, <SOME

-- 30번 부서의 급여보다 적은 급여를 받는 사원 조회 (단일행)
SELECT
	*
FROM
	EMP E
WHERE
	E.SAL = ANY(SELECT E.SAL FROM EMP E WHERE  E.DEPTNO = 30)
ORDER BY E.SAL, E.EMPNO; 

-- 30번 부서의 급여보다 적은 급여를 받는 사원 조회 (다중행)

 SELECT * FROM EMP E WHERE E.SAL < ANY(SELECT E.SAL FROM EMP E WHERE E.DEPTNO =30)
 ORDER BY E.SAL, E.EMPNO;

-- ALL : 서브쿼리의 모든 결과가 조건식에 맞아 떨어져야만 메인쿼리의 조건식이 TRUE 
 
 
 -- 30번 부서의 최소급여보다 적은 급여를 받는 사원 조회(단일행)
SELECT * FROM EMP E WHERE E.SAL < (SELECT MIN(E.SAL) FROM EMP E WHERE E.DEPTNO = 30); 

 -- 30번 부서의 급여보다 적은 급여를 받는 사원 조회(다중행)
SELECT * FROM EMP E WHERE E.SAL < ALL(SELECT E.SAL FROM EMP E WHERE E.DEPTNO = 30); 

-- EXISTS : 서브쿼리에 결과값이 하나 이상 있으면 조건식이 모드 TRUE, 없으면 FALSE
SELECT * FROM EMP WHERE EXISTS (SELECT DNAME FROM DEPT WHERE DEPTNO = 10);

SELECT * FROM EMP WHERE EXISTS (SELECT DNAME FROM DEPT WHERE DEPTNO = 50);


-- 비교할 열이 여러개인 다중열 서브쿼리

-- 부서별 최고 급여와 같은 급여를 받는 사원 조회 
SELECT * FROM EMP e WHERE (E.DEPTNO, E.SAL) IN(SELECT E.DEPTNO, MAX(E.SAL)FROM EMP e GROUP BY E.DEPTNO)

--SELECT 절에 사용하는 서브쿼리(결과가 반드시 하나만 반환)
--사원정보,급여등급, 부서명 (조인)

SELECT
	E.EMPNO,E.LOB,E.SAL,
	(SELECT S.GRADE FROM SALGRADE S WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL) AS SALGRADE,
	E.DEPTNO,
	(SELECT D.DNAME FROM DEPT D WHERE E.DEPTNO = D.DEPTNO) AS DNAME
FROM
	EMP E;

-- 10번 부서에 근무하는 사원중 30번 부서에 없는 직책인 사원의 사원 정보(사번,이름,직무)
-- 부서정보(부서번호,부서명,위치) 조회 
SELECT
	E.EMPNO,
	E.DNAME,
	E.LOB
FROM
	EMP E JOIN DEPT D ON E.DEPTNO = D.DEPTNO
WHERE
	E.LOB 
NOT IN (
	SELECT
		E.LOB
	FROM
		EMP E
	WHERE
		E.DEPTNO = 30);
--직책이 SALESMAN 인 사람의 최고급여보다 많이 받는 사람의 사원정보, 급여등급정보를 조회 
-- 다중행 함수를 사용하는 방법과 사용하지않는 방법 2가지로 작성(사번기준으로 오름차순)
-- 출력 : 사번, 이름, 급여, 등급
SELECT
	E.EMPNO,
	E.DNAME,
	E.LOB,
	E.DEPTNO,
	E.DNAME,
	D.LOC
FROM
	EMP E JOIN DEPT D ON E.DEPTNO = D.DEPTNO
WHERE
	E.LOB 
NOT IN (
	SELECT
		E.LOB
	FROM
		EMP E
	WHERE
		E.DEPTNO = 30) AND E.DEPTNO  =10;


--직책이 SALESMAN 인 사람의 최고급여보다 많이 받는 사람의 사원정보, 급여등급정보를 조회 
-- 다중행 함수를 사용하는 방법과 사용하지않는 방법 2가지로 작성(사번기준으로 오름차순)
-- 출력 : 사번, 이름, 급여, 등급
--다중행을 사용하지않는방법
SELECT
	E.EMPNO,
	E.DNAME,
	E.SAL
	(
	SELECT
		S.GRADE
	FROM 
		SALGRADE S
	WHERE 
		E.SAL BETWEEN S.LOSAL AND S.HISAL) AS SALGRADE
FROM
	EMP e
WHERE
	E.SAL
> (
	SELECT
		MAX(E.SAL)
	FROM
		EMP E
	WHERE
		E.LOB = 'SALESMAN')
ORDER BY
	E.EMPNO;


----------------------------------------------------------
-- 다중행 함수로 바꾸면

SELECT
	E.EMPNO,
	E.DNAME,
	E.SAL
	(
	SELECT
		S.GRADE
	FROM 
		SALGRADE S
	WHERE 
		E.SAL BETWEEN S.LOSAL AND S.HISAL) AS SALGRADE
FROM
	EMP e
WHERE
	E.SAL
> ALL (
	SELECT
		E.SAL
	FROM
		EMP E
	WHERE
		E.LOB = 'SALESMAN')
ORDER BY
	E.EMPNO;

-- C(insert) : 삽입

--INSERT INTO 테이블명(필드명,필드명,....)
--value(값1,값2...)

-- 기존 테이블 복사 
CREATE TABLE dept_temp AS SELECT * FROM dept;

INSERT INTO DEPT_TEMP(deptno, dname, loc)
VALUES(50,'DATABASE','SEOUL');


INSERT INTO DEPT_TEMP
VALUES(60,'NETWORK','BUSAN');


INSERT INTO DEPT_TEMP
VALUES(60,'NETWORK','BUSAN');

--값의 수가 너무 많습니다
--값의 수가 충분하지 않습니다
INSERT INTO DEPT_TEMP(deptno, dname, loc)
VALUES('NETWORK','BUSAN');

--이 열에 대해 지정된 전체 자릿수보다 큰 값이 허용됩니다.
--Number(2,0)
INSERT INTO DEPT_TEMP
VALUES(600,'NETWORK','BUSAN');

-- null 
INSERT INTO DEPT_TEMP
VALUES(80,'NETWORK',null);

INSERT INTO DEPT_TEMP(deptno, dname)
VALUES(90,'NETWORK');

-- 열구조만 복사후 새테이블 생성
CREATE TABLE EMP_TEMP AS SELECT * FROM emp WHERE 1<>1;

-- 날짜데이터 삽입 : 'YYYY/MM/DD'
INSERT INTO EMP_TEMP(empno, DNAME, lob,mgr,HIREDATE,sal,COMM,deptno)
VALUES(9999,'홍길동','PRESIDENT', NULL,'2020-12-13',5000,1000,10);

INSERT INTO EMP_TEMP(empno, DNAME, lob,mgr,HIREDATE,sal,COMM,deptno)
VALUES(3111,'이춘향','MANAGER',9999,sysdate,4000,NULL,30);

-- emp, salgrade 급여등급이 1인 사원들만 emp_temp 추가하기

SELECT INTO EMP_TEMP(empno, DNAME, lob, mgr, HIREDATE, sal, COMm, deptno)
SELECT e.* FROM emp e JOIN salgreade

-- u(Update)
-- update 테이블명
-- set 변경할 열 = 값, 변경할열=값....
-- where(선택)데이터를 변경할대상행을 선별하는 조건나열 

--90번 부서의 loc SEOUL 변경
UPDATE DEPT_TEMP
SET LOC ='SEOUL'
WHERE DEPTNO = 90;

UPDATE DEPT_TEMP
SET LOC ='SEOUL'

--COMMIT;
--ROLLBACK

-- 40번 부서의 부서명 변경
-- dept 테이블 40번 부서랑 동일 
UPDATE DEPT_TEMP 
SET (dname, LOC) = (SELECT dname, loc FROM DEPT WHERE deptno =40)
WHERE DEPTNO = 40;



--50번 부서의 dname,loc 변경
UPDATE DEPT_TEMP
SET LOC = 'BUSAN', DNAME='SALES'
WHERE DEPTNO = 50;

-- Delete : 삭제
-- DELETE FROM 테이블명
-- WHERE 삭제할조건

-- DELETE 테이블명
-- WHERE 삭제할조건


--70번 부서 삭제
DELETE FROM DEPT_TEMP
WHERE deptno = 70;

--loc가 SEOUL 데이터 삭제 
DELETE DEPT_TEMP
WHERE LOC = 'SEOUL';

DELETE EMP_TEMP
WHERE SAL >= 3000;

DELETE EMP_TEMP;

CREATE TABLE EXAM_EMP AS SELECT * FROM EMP;
CREATE TABLE EXAM_DEPT AS SELECT * FROM DEPT;
CREATE TABLE EXAM_SALGRADE AS SELECT * FROM SALGRADE;

-- DEPT 테이블에 다음 데이터를 삽입하기
-- 50, ORACLE, BUSAN
-- 60, SQL, ILSAN
-- 70 , SELECT, INCHEON
-- 80, DML, BUNDANG


-- EXAM_EMP 테이블에 다음 데이터 삽입하기
-- 7201, USER1, MANEGER, 7788 , 2016-02-01, 4500, NULL,50
-- 7201, USER2, CLERK, 7201 , 2016-02-16, 1800, NULL,50
-- 7201, USER1, ANALYST, 7201 , 2016-04-11, 3400, NULL,60
-- 7201, USER1, SALESMAN, 7788 , 2016-05-31, 2700, 300, 60
-- 7201, USER1, CLERK, 7201 , 2016-07-20, 2600, NULL,70
-- 7201, USER1, CLERK, 7201 , 2016-09-08, 2600, NULL,70
-- 7201, USER1, LECTURER, 7201 , 2016-10-28, 2300, NULL,80
-- 7201, USER1, STUDENT, 7201 , 2018-03-09, 1200, NULL,80

--EXAM_EMP 에서 50번 부서에서 근무하는 사원의 평균급여보다 많이 받는 사원을 
--70번 부서로 옮기는 SQL 구문 작성


--EXAM_EMP 에서 입사일이 가장 빠른 60번 부서사원보다 늦게 입사한 사원의
--급여를 10%인상하고 80번 부서로 옮기는 sql 구문작성

--EXAM_EMP 에서 급여등급이 5인 사원을 삭제하는 SQL 구문작성






















































































