-- ex13_ddl.sql

/*

    1. 초반 DML(ex01~ex12)
    2. DDL > 테이블(구조)
    3. 후반 DML
    4. 데이터 모델링
    5. PL/SQL
    
    
    DDL
    - Data Definition Languge
    - 데이터 정의어
    - 테이블, 뷰, 사용자, 인덱스 등의 데이터베이스 오브젝트를
        생성/수정/삭제하는 명령어
    - 구조를 생성/관리하는 명령어
    a. create: 생성
    b. drop: 삭제
    c. alter: 수정
    
    
    테이블 생성하기 > 스키마 정의하기 > 컬럼 정의하기 
        > 컬럼의 이름, 자료형, 제약사항 정의
    
    
    create table 테이블명
    (
        컬럼 정의,
        컬럼명 자료형(길이) null 제약사항
    );
    
    
    제약 사항, Constraint
    - 해당 컬럼에 들어갈 데이터(값)에 대한 조건
        1. 조건을 만족하면 > 대입
        2. 조건을 불만족하면 > 에러 발생
    - 데이터 무결성을 보장하는 위한 도구(***)
    
    1. NOT NULL
        - 해당 컬럼이 반드시 값을 가져야 한다.
        - 해당 컬럼에 값이 없으면 에러 발생
        - 필수값
    
    2. PRIMARY KEY, PK
        - 기본키
        - 테이블의 행을 구분하기 위한 제약 사항
        - 모든 테이블은 반드시 1개의 기본키가 존재해야 한다.(**********)        
    
    3. FOREIGN KEY
    
    4. UNIQUE
        - 유일하다. > 레코드간의 중복값을 가질 수 없다.
        - null 을 가질 수 있다. > 식별자가 될 수 없다.
        ex) 초등학교 교실
            - 학생(번호(PK), 이름(NN), 직책(UQ))
                1, 홍길동, 반장
                2, 아무개, null
                3, 하하하, 부반장
        - PK = UQ + NN            
    
    5. CHECK
        - 사용자 정의형
        - where절 조건 > 컬럼의 제약 사항으로 적용
    
    6. DEFAULT
        - 기본값 설정
        - insert/update 작업 시 > 컬럼에 값을 안넣으면 null 대신에
                                    미리 설정한 값을 대입
    

*/

-- 메모 테이블
create table tblMemo (
    --컬럼명 자료형(길이) null 제약사항
    seq number(3) null,         --메모번호
    name varchar2(30) null,     --작성자
    memo varchar2(1000) null,   --메모
    regdate date            --작성날짜
);

select * from tblMemo;

delete from tblMemo;

insert into tblMemo (seq, name, memo, regdate)
            values (1, '홍길동', '메모입니다.', '2024-02-15');

insert into tblMemo (seq, name, memo, regdate)
            values (1, '홍길동', '메모입니다.'
                    , to_date('2024-02-15 16:29:15', 'yyyy-mm-dd hh24:mi:ss'));

insert into tblMemo (seq, name, memo, regdate)
            values (1, '홍길동', '메모입니다.', sysdate);

insert into tblMemo (seq, name, memo, regdate)
            values (2, '아무개', '테스트입니다.', sysdate);
            
insert into tblMemo (seq, name, memo, regdate)
            values (3, '아무개', '테스트입니다.', null);

insert into tblMemo (seq, name, memo, regdate)
            values (4, '아무개', null, null);

insert into tblMemo (seq, name, memo, regdate)
            values (5, null, null, null);            
            
insert into tblMemo (seq, name, memo, regdate)
            values (null, null, null, null);               
            
select * from tblMemo;




drop table tblMemo;

create table tblMemo (
    seq number(3) not null,         --메모번호(NN)
    name varchar2(30) null,         --작성자
    memo varchar2(1000) not null,   --메모(NN)
    regdate date null               --작성날짜
);

insert into tblMemo (seq, name, memo, regdate)
            values (1, '홍길동', '메모입니다.', sysdate);

-- ORA-01400: NULL을 ("HR"."TBLMEMO"."MEMO") 안에 삽입할 수 없습니다
insert into tblMemo (seq, name, memo, regdate)
            values (2, '홍길동', null, sysdate);

insert into tblMemo (seq, name, memo, regdate)
            values (3, '홍길동', '', sysdate); --빈문자열('')도 null값으로 취급한다.

select * from tblMemo;





drop table tblMemo;

create table tblMemo (
    seq number(3) primary key,      --메모번호(PK)
    name varchar2(30) null,         --작성자
    memo varchar2(1000) not null,   --메모(NN)
    regdate date null               --작성날짜
);

insert into tblMemo (seq, name, memo, regdate)
            values (1, '홍길동', '메모입니다.', sysdate);

-- ORA-00001: 무결성 제약 조건(HR.SYS_C008619)에 위배됩니다
-- ORA-00001: unique constraint (HR.SYS_C007129) violated
insert into tblMemo (seq, name, memo, regdate)
            values (1, '홍길동', '메모입니다.', sysdate);

-- ORA-01400: NULL을 ("HR"."TBLMEMO"."SEQ") 안에 삽입할 수 없습니다
insert into tblMemo (seq, name, memo, regdate)
            values (null, '홍길동', '메모입니다.', sysdate);

insert into tblMemo (seq, name, memo, regdate)
            values (2, '홍길동', '메모입니다.', sysdate);


select * from tblMemo where seq = 2; -- PK > 검색 조건 사용





drop table tblMemo;

create table tblMemo (
    seq number(3) primary key,      --메모번호(PK)
    name varchar2(30) unique,       --작성자(UQ)
    memo varchar2(1000) not null,   --메모(NN)
    regdate date null               --작성날짜
);

insert into tblMemo (seq, name, memo, regdate)
            values (1, '홍길동', '메모입니다.', sysdate);

insert into tblMemo (seq, name, memo, regdate)
            values (2, '홍길동', '메모입니다.', sysdate);

insert into tblMemo (seq, name, memo, regdate)
            values (3, null, '메모입니다.', sysdate);

select * from tblMemo;






drop table tblMemo;

create table tblMemo (
    seq number(3) primary key,      --메모번호(PK)
    name varchar2(30),              --작성자
    memo varchar2(1000) not null,   --메모(NN)
    regdate date null,              --작성날짜
    
    --중요도(1(중요), 2(보통), 3(안중요))
    --priority number(1) check (priority >= 1 and priority <= 3)
    priority number(1) check (priority between 1 and 3),
    
    --카테고리(할일, 공부, 약속, 가족, 개인)
    --category varchar2(10) check (category = '할일' or category = '공부')
    category varchar2(10) check (category in ('할일', '공부', '약속'))
);

insert into tblMemo (seq, name, memo, regdate, priority, category)
            values (1, '홍길동', '메모입니다.', sysdate, 2, '공부');

insert into tblMemo (seq, name, memo, regdate, priority, category)
            values (2, '홍길동', '메모입니다.', sysdate, 5, '공부');            

insert into tblMemo (seq, name, memo, regdate, priority, category)
            values (2, '홍길동', '메모입니다.', sysdate, 1, '여행');             
            
select * from tblMemo;
            
            
            
            
            
drop table tblMemo;

create table tblMemo (
    seq number(3) primary key,              --메모번호(PK)
    name varchar2(30) default '익명',       --작성자(UQ)
    memo varchar2(1000),                    --메모(NN)
    regdate date default sysdate            --작성날짜
);

insert into tblMemo (seq, name, memo, regdate)
            values (1, '홍길동', '메모입니다.', sysdate);
            
insert into tblMemo (seq, name, memo, regdate)
            values (2, null, '메모입니다.', sysdate);

insert into tblMemo (seq, name, memo, regdate)
            values (3, '', '메모입니다.', sysdate);

insert into tblMemo (seq, memo, regdate)
            values (4, '메모입니다.', sysdate);

insert into tblMemo (seq, name, memo, regdate)
            values (5, default, '메모입니다.', sysdate);            

select * from tblMemo; --2		메모입니다.	24/02/15











