-- 오라클 관리자
-- system, sys(최고 권한)

-- 사용자 이름 : sys as sysdba
-- 비밀번호 : 엔터

-- 오라클 12c 버전부터 사용자 계성 생성시 접두어(c##)를 붙히도록 변경됌
-- c##hr
-- c##을 사용하지 않을때
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
-- 비밀번호 변경
-- 비밀번호만 대소문자를 구별함
ALTER USER hr IDENTIFIED BY hr;

-- 계정 잠금 해제 
-- ALTER USER hr account nulock;

-- 데이터사전 DBA_USERS를 사용하여 사용자 정보 조회
SELECT * FROM dba_users WHERE username='SCOTT';

-- scott view 생성 권한 부여 
GRANT CREATE VIEW TO scott;