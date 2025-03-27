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

INSERT INTO EMP_TEMP(empno, DNAME, lob,mgr,HIREDATE,sal,COMM,deptno)
VALUES(3231,'김강석','MANAGER',9123,sysdate,5000,NULL,50);

INSERT INTO EMP_TEMP(empno, DNAME, lob,mgr,HIREDATE,sal,COMM,deptno)
VALUES(5511,'동동이','PRESIDENT',9915,sysdate,1235,NULL,30);

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
INSERT INTO EXAM_DEPT(DEPTNO, DNAME,loc)
values(50,'oracle','busan');


-- EXAM_EMP 테이블에 다음 데이터 삽입하기
-- 7201, USER1, MANEGER, 7788 , 2016-02-01, 4500, NULL,50
-- 7201, USER2, CLERK, 7201 , 2016-02-16, 1800, NULL,50
-- 7201, USER3, ANALYST, 7201 , 2016-04-11, 3400, NULL,60
-- 7201, USER4, SALESMAN, 7788 , 2016-05-31, 2700, 300, 60
-- 7201, USER5, CLERK, 7201 , 2016-07-20, 2600, NULL,70
-- 7201, USER6, CLERK, 7201 , 2016-09-08, 2600, NULL,70
-- 7201, USER7, LECTURER, 7201 , 2016-10-28, 2300, NULL,80
-- 7201, USER8, STUDENT, 7201 , 2018-03-09, 1200, NULL,80

INSERT INTO EXAM_EMP 
values(7201,'USER1','MANAGER', 7788, 2016-02-01, 4500, NULL, 50);




--EXAM_EMP 에서 50번 부서에서 근무하는 사원의 평균급여보다 많이 받는 사원을 
--70번 부서로 옮기는 SQL 구문 작성
UPDATE EXAM_EMP 
SET DEPTNO=70
WHERE sal >(SELECT avg(sal) FROM EXAM_EMP WHERE deptno =50);

--EXAM_EMP 에서 입사일이 가장 빠른 60번 부서사원보다 늦게 입사한 사원의
--급여를 10%인상하고 80번 부서로 옮기는 sql 구문작성
UPDATE EXAM_EMP 
SET sal = sal *1.1, DEPTNO=80
WHERE hiredate >(SELECT min(hiredate) FROM EXAM_EMP WHERE deptno =60);



--EXAM_EMP 에서 급여등급이 5인 사원을 삭제하는 SQL 구문작성
DELETE
FROM
	EXAM_EMP
WHERE
	empno IN (
	SELECT
		empno
	FROM
		exam_emp e
	JOIN EXAM_SALGRADE s ON
		e.sal BETWEEN s.losal AND s.HISAL
		AND s.grade = 5);

-- 트랜잭션 : ALL or NOTHING (전부실행 OR 전부취소)
-- DML(데이터 조작어) - INSERT, UPDATE, DELETE

-- COMMIT(전부실행) /ROLLBACK (전부취소)
INSERT INTO DEPT_TEMP VALUES(30,'DATABASE', 'SEOUL');
UPDATE DEPT_TEMP set loc = 'busan' WHERE deptno=30;
DELETE FROM DEPT_TEMP WHERE Dname = 'research';

COMMIT;

ROLLBACK;

--세션 : 데이터베이스 접속후 작업을 수행한 후 접속을 종료하는 전체기간

SELECT * FROM EMP e;

DELETE FROM DEPT_TEMP WHERE DEPTNO=30;

COMMIT;


--DDL(데이터 정의어) : 객체를 생성,변경,삭제
-- 1. 테이블 생성 : CREATE
-- 2.      변경 : ALTER
-- 3.      삭제 : DROP
-- 4. 테이블 전체 데이터 삭제 : TRUNCATE
-- 5. 테이블 이름 변경 : RENAME

--CREATE TABLE 테이블명(
--	컬럼명1 자료형,
--	컬럼명2 자료형,
--	컬럼명3 자료형,
--)

--테이블명 규칙
--문자로 시작(영문, 한글, 숫자 가능)
--테이블 이름은 30바이트 이하
--같은 사용자 안에서는 테이블명 중복불가
--SQL 예약어(SELECT,FROM...등등)는 테이블 이름으로 사용할 수 없음

-- VARCHAR2(14) : 영어14문자, 한글 4문자
-- NUMBER(7,2) : 전체자리수 7(소숫점2자리 포함) 

CREATE TABLE DEPT_DDL(
	DEPTNO NUMBER(2,0),
	DNAME VARCHAR2(14),
	LOC VARCHAR2(13)
);

CREATE TABLE EMP_DDL(
	EMPNO NUMBER(4,0),
	DNAME VARCHAR2(14),
	LOB VARCHAR2(9),
	MGR NUMBER(4,0),
	HIREDATE DATE,
	SAL NUMBER(7,2),
	COMM NUMBER(7,2),
	DEPTNO NUMBER(2,0)
);

-- 기존 테이블 구조와 데이터를 이용한 새테이블 생성
CREATE TABLE EXAM_EMP AS SELECT * FROM EMP;

-- 기존 테이블 구조만 이용한 새테이블 생성
CREATE TABLE EXAM_EMP AS SELECT * FROM EMP WHERE 1<>1;

-- ALTER : 테이블 변경
-- 1) 열추가 
-- 2) 열 이름 변경
-- 3) 열 자료형 변경
-- 4) 특정 열 삭제

--HP 열 추가 
ALTER TABLE EMP_DDL ADD HP VARCHAR2(20);

--HP => TEL 변경
ALTER TABLE EMP_DDL RENAME COLUMN HP TO TEL;

--EMPNO 자리수 4 => 5
ALTER TABLE EMP_DDL MODIFY EMPNO NUMBER(5);

ALTER TABLE EMP_DDL MODIFY DNAME VARCHAR2(8);
ALTER TABLE EMP_DDL MODIFY EMPNO NUMBER(3);

--정도 또는 자리수를 축소할 열은 비어 있어야 합니다
--ALTER TABLE EMP_TEMP MODIFY EMPNO NUMBER(3);

-- 특정 열 삭제 
ALTER TABLE EMP_DDL DROP COLUMN TEL;

-- 테이블 이름 변경
RENAME EMP_DDL TO EMP_RENAME;

-- 테이블 데이터 삭제 
-- DELECT FROM EMP_RENAME

--ROLLBACK 안됨
TRUNCATE TABLE EMP_RENAME;

-- 테이블 제거 
DROP TABLE EMP_RENAME;


--MEMBER 테이블 생성하기
--ID VARCHAR2(8) /name 10 // addr(varchar2) 50/ email 30 / age number(4)

CREATE TABLE MEMBER_TABLE(
	ID VARCHAR2(8),
	name VARCHAR2(10),
	addr varchar2(50),
	email VARCHAR2(30),
	AgeNumber NUMBER(4)
);

--insert(remark X)
INSERT INTO MEMBER_TABLE(id,name,addr,email,AGENUMBER)
VALUES('hong123', '홍길동', '서울시 종로구', 'hong123@naver.com',24);

--member 테이블 열추가
--bigo 열 추가(문자열,20)
ALTER TABLE MEMBER_TABLE ADD bigo VARCHAR2(20);

--bigo 열 크기를 30으로 변경
ALTER TABLE MEMBER_TABLE MODIFY bigo varchar2(30);

--bigo 열 이름을 remark로 변경
ALTER TABLE MEMBER_TABLE RENAME COLUMN BIGO TO REMARK;

--오라클 객체 
--오라클 데이터베이스 테이블
--1) 사용자 테이블
--2) 데이터 사전 - 중요한 데이터(사용자,권한,메모리,성능...) : 일반 사용자가 접근하는곳이 아님
--		user_*,all_*,dba_,v$_*
-- 2.인덱스 : 검색을 빠르게 처리
--		1) FULL SCAN
--		2) INDEX SCAN
-- 3. view : 가상 테이블
--		 믈리적으로 저장된 테이블은 아님
-- 4. 시퀀스 : 규칙에 따라 순번을 생성


SELECT * FROM dict;

--scott 계정이 가진 table 조회
SELECT table_name
FROM user_tables;


-- 인덱스 조회 
SELECT * FROM USER_INDEXES;

--인덱스 생성
--CREATE INDEX 인덱스명 ON 테이블명(열이름 ASC OR DESC, 열이름..)

CREATE INDEX IDX_EMP_TEMP_SAL ON EMP_TEMP(SAL);

--인덱스 삭제 
DROP INDEX IDX_EMP_TEMP_SAL;


SELECT * FROM EMP e;

-- 뷰
-- 권한을 가진 사용자만 생성 가능
-- 보안성 : 특정 열을 노출하고 싶지않을때 
-- 편리성 : select 문의 복잡도 완화 
--CREATE VIEW 뷰이름(열이름1, 열이름2...) AS (저장할 SELECT 구문)

CREATE VIEW vw_emp20 AS (
SELECT
	e.empno,
	e.DNAME,
	e.LOB,
	e.DEPTNO
FROM
	emp e
WHERE
	e.DEPTNO = 20);

DROP VIEW VW_EMP20;

-- 시퀀스 : 오라클 데이터베이스에서 특정규칙에 따른 연속숫자를 생성하는 객체
-- 게시판 번호,멤버 번호...

-- CREATE SEQUENCE 시퀀스명;
CREATE SEQUENCE board_seq;

-- CREATE SEQUENCE SCOTT.BOARD_SEQ
-- INCREMENT BY 1 (시퀀스에서 생성할 번호의 증가값 : 기본값 1)
-- MINVALUE 1 (시퀀스에서 생성할 번호의 최소값 : 기본값 NOMINVALUE(1-오름차순))
-- MAXVALUE 9999999999999999999999999999 (시퀀스에서 생성할 번호의 최댓값)
-- NOCYCLE ( 1 ~ MAXVALUE 번호가 다 발행된 후에 새로운 번호 요청시 에러발생시킴 
-- CYCLE ( 1 ~ MAXVALUE 번호가 다 발행된 후에 다시 처음(1)부터 발행시킴 )
-- CACHE 20 (시퀀스가 생성할 번호를 메모리에 미리 할당해 놓을 갯수를 지정) | NOCACHE
-- NOORDER ( )

-- Member 테이블에 no 컬럼(number) 추가 
ALTER TABLE MEMBER_TABLE ADD no number(20);

-- Member no 값은 시퀀스 값으로 입력하기
-- 사용할 시퀀스 생성
CREATE SEQUENCE member_seq;

INSERT INTO MEMBER_TABLE(no,id,name,addr,email,AGE)
VALUES(member_seq.nextval, 'hong123', '홍길동', '서울시 종로구', 'hong123@naver.com',24);

-- 시퀀스.currval : 가장 마지막으로 생성된 시퀀스 확인
-- 시퀀스.nextval : 시퀀스 발행
SELECT member_seq.currval
FROM dual;
 
CREATE SEQUENCE seq_dept_sequence
INCREMENT BY 10
START with 10
MAXVALUE 90
MINVALUE 0
nocycle cache 2;

CREATE TABLE dept_sequence AS SELECT * FROM dept WHERE 1<>1;


INSERT INTO dept_sequence values(seq_dept_sequence.nextbal, 'DATABASE' , 'SEOUL' );
SELECT * FROM DEPT_SEQUENCE;

--마지막 발생 시퀀스 확인
SELECT seq_dept_sequence.currval
FROM dual;

--시퀀스 수정 
ALTER SEQUENCE seq_dept_sequence 
INCREMENT BY 3
MAXVALUE 99
CYCLE;


-- 시퀀스 제거 
DROP SEQUENCE board_seq;
DROP SEQUENCE seq_dept_sequence;

-- 제약 조건 (★) : 테이블에 저장할 데이터를 제약하는 특수한 규칙 
-- 1) NOT NULL : 빈 값을 허용하지 않음
-- 2) UNIQUE : 중복 불가
-- 3) PRIMARY KEY(PK) : 유일하게 하나만 존재
-- 4) FOREIGN KEY(PK) : 다른테이블과 관계 맺기
-- 5) CHECK : 데이터 형태와 범위를 지정
-- 6) DEFAULT : 기본값 설정

CREATE TABLE tbl_notnull(
	LOGIN_ID VARCHAR2(20) NOT NULL,
	LOGIN_PWD VARCHAR2(20) NOT NULL,
	TEL VARCHAR2(20)
);

-- ORA-01400 : NULL을 ("SCOTT"."TBL_NOTNULL"."LOGIN_PWD") 안에 삽입할 수 없습니다
INSERT INTO TBL_NOTNULL (LOGIN_ID,LOGIN_PWD,TEL)
VALUES('HONG123',NULL,'010-1234-5678')

INSERT INTO TBL_NOTNULL (LOGIN_ID,LOGIN_PWD,TEL)
VALUES('HONG123','','010-1234-5678')

INSERT INTO TBL_NOTNULL (LOGIN_ID,LOGIN_PWD)
VALUES('HONG123','HONG123');

--제약조건 이름을 직접 지정
CREATE TABLE tbl_notnull2(
	LOGIN_ID VARCHAR2(20) CONSTRAINT TBLNN2_LOGIN_NN NOT NULL,
	LOGIN_PWD VARCHAR2(20) CONSTRAINT TBLNN2_LOGPWD_NN NOT NULL,
	TEL VARCHAR2(20)
);



--이미 생성된 테이블에 제약조건 지정은 가능하나 이미 삽입된 데이터가 
-- 제약조건을 무조건 만족해야 한다.
--TBL_NOTNULL TEL 컬럼을 NOT NULL 로 변경
ALTER TABLE TBL_NOTNULL MODIFY (TEL NOT NULL);

UPDATE TBL_NOTNULL tn 
SET TEL='010-1234-5678'
WHERE LOGIN_ID = 'HONG123';

ALTER TABLE TBL_NOTNULL2 MODIFY (TEL CONSTRAINT TBLNN2_TEL_NN NOT NULL);

--제약조건 이름 변경
ALTER TABLE TBL_NOTNULL2 RENAME CONSTRAINT TBLNN2_TEL_NN TO TBL_NN2_TEL_NN;

--제약조건 삭제
ALTER TABLE TBL_NOTNULL2 DROP CONSTRAINT TBL_NN2_TEL_NN;

-- UNIQUE : 데이터의 중복의 허용하지 않음
--			NULL은 중복대상에서 제외됨

CREATE TABLE tbl_UNIQUE(
	LOGIN_ID VARCHAR2(20) UNIQUE,
	LOGIN_PWD VARCHAR2(20) NOT NULL,
	TEL VARCHAR2(20)
);


-- 데이터 무결성 : 
-- 데이버베이스에 저장되는 데이터의 정확성과 일치성 보장
-- DML 과정에서 지켜야하는 규칙 


-- 무결성 제약 조건(SCOTT.SYS_C008367)에 위배됩니다
INSERT INTO TBL_UNIQUE (LOGIN_ID,LOGIN_PWD,TEL)
VALUES('HONG123','pw123','010-1234-5678');

INSERT INTO TBL_UNIQUE (LOGIN_ID,LOGIN_PWD,TEL)
VALUES(NULL,'pw123','010-1234-5678');

ALTER TABLE TBL_UNIQUE MODIFY (TEL UNIQUE);

UPDATE TBL_UNIQUE tu 
SET TEL = NULL;

-- 유일하게 하나만 있는 값 : PRIMARY KEY(PR)
-- PK : NOT NULL + UNIQUE
--		컬럼 하나만 지정 가능 
CREATE TABLE TBL_PK(
	LOGIN_ID VARCHAR2(20) PRIMARY KEY,
	LOGIN_PWD VARCHAR2(20) NOT NULL,
	TEL VARCHAR2(20)
);


CREATE TABLE TBL_PK(
	LOGIN_ID VARCHAR2(20) CONSTRAINT TBLPK2_LGN_ID_PK PRIMARY KEY,
	LOGIN_PWD VARCHAR2(20) NOT NULL,
	TEL VARCHAR2(20)
);

INSERT INTO TBL_PK (LOGIN_ID,LOGIN_PWD,TEL)
VALUES('hong123','pw123','010-1234-5678');

-- 다른 테이블과 관계를 맺는 키 : 외래키(FK)
-- JOIN 구문 EMP(deptno), DEPT(deptno)
-- emp 테이블에 deptno 는 dept 는 테이블의 deptno값을 참조해서 삽입

CREATE TABLE DEPT_FK(
	DEPTNO NUMBER(2) CONSTRAINT DEPTFK_DEPTNO_PK PRIMARY KEY,
	DNAME VARCHAR2(14),
	LOC VARCHAR2(13)
);

CREATE TABLE EMP_FK(
	EMPNO NUMBER(4) CONSTRAINT EMPFK_EMPNO_PK PRIMARY KEY,
	DNAME VARCHAR2(10) NOT NULL,
	LOB VARCHAR2(9) NOT NULL,
	MGR NUMBER(4),
	HIREDATE DATE,
	SAL NUMBER(7,2) NOT NULL,
	COMM NUMBER(7,2),
	DEPTNO NUMBER(2) CONSTRAINT EMPFK_DEPTNO_FK REFERENCES DEPT_DK(DEPTNO)	
);


INSERT INTO EMP_FK(EMPNO,DNAME,JOB,HIREDATE,SAL,DEPTNO)
VALUES(9999,'TEST1','PARTNER',SYSDATE,2500,10);

-- INSERT시 주의점
-- 1)참조 대상이 되는 테이블(부모)의 데이터 삽임
-- 2)참조하는 테이블의 데이터 삽입

INSERT INTO DEPT_FK VALUES(10,'DATABASE','SEOUL');
INSERT INTO EMP_FK VALUES(EMPNO,DNAME,JOB,HIREDATE,SAL,DEPTNO);
VALUES(9999,'TEST1','PARTNER',SYSDATE,2500,10);

--
DELETE FROM EMP_FK WHERE EMPNO = 9999;
DELETE FROM DEPT_FK WHERE DEPTNO = 10;

--DELETE 시 주의점 
-- 1) 참조하는 테이블 (자식)의 데이터 삭제
-- 2) 참조대상이 되는 테이블(부모)의 데이터 삭제


-- 옵션 설정
-- 1) ON DELETE CASCADE : 부모 삭제 시 자식도 같이 삭제
-- 2) ON DELETE SET NULL : 부모 삭제시 연결된 부모를 NULL로 변경

CREATE TABLE EMP_FK2(
	EMPNO NUMBER(4) CONSTRAINT EMPFK_EMPNO_PK2 PRIMARY KEY,
	DNAME VARCHAR2(10) NOT NULL,
	LOB VARCHAR2(9) NOT NULL,
	MGR NUMBER(4),
	HIREDATE DATE,
	SAL NUMBER(7,2) NOT NULL,
	COMM NUMBER(7,2),
	DEPTNO NUMBER(2) CONSTRAINT EMPFK_DEPTNO_FK2 REFERENCES DEPT_DK(DEPTNO)	
	ON DELETE CASCADE
);

INSERT INTO DEPT_FK VALUES(20,'NETWORK','BUSAN');
INSERT INTO EMP_FK2 VALUES(EMPNO,DNAME,JOB,HIREDATE,SAL,DEPTNO)
VALUES(9999,'TEST1','PARTNER',SYSDATE,2500,20);
-- 부모 삭제시 자식도 같이 삭제됨
DELETE FROM DEPT_FK WHERE DEPTNO = 20;


CREATE TABLE EMP_FK3(
	EMPNO NUMBER(4) CONSTRAINT EMPFK_EMPNO_PK3 PRIMARY KEY,
	DNAME VARCHAR2(10) NOT NULL,
	LOB VARCHAR2(9) NOT NULL,
	MGR NUMBER(4),
	HIREDATE DATE,
	SAL NUMBER(7,2) NOT NULL,
	COMM NUMBER(7,2),
	DEPTNO NUMBER(2) CONSTRAINT EMPFK_DEPTNO_FK3 REFERENCES DEPT_DK(DEPTNO)	
	ON DELETE SET NULL
);

INSERT INTO DEPT_FK VALUES(20,'NETWORK','BUSAN');
INSERT INTO EMP_FK3 VALUES(EMPNO,DNAME,JOB,HIREDATE,SAL,DEPTNO)
VALUES(9999,'TEST1','PARTNER',SYSDATE,2500,20);
-- 부모 삭제시 자식의 부서는 NULL 로 변경됨
DELETE FROM DEPT_FK WHERE DEPTNO = 20;













































































































































































