-- ex23_alter.sql

/*
    DDL > 객체 조작
    - 객체 생성: create
    - 객체 수정: alter
    - 객체 삭제: drop
    
    DML > 데이터 조작
    - 데이터 생성: insert
    - 데이터 수정: update
    - 데이터 삭제: delete
    
    테이블 수정하기
    - 테이블 수정 > 테이블 정의 수정 > 스키마 수정 > 컬럼 수정
        > 컬럼명 or 자료형(길이) or 제약사항 등등을 변경
    - 테이블을 수정하는 상황을 발생시키지 않도록 유의
    
    테이블 수정 방법
    1. 테이블 삭제(drop) > 테이블 DDL(create) 수정 > 수정된 DDL로 다시 테이블 생성
        a. 기존 테이블에 데이터가 없었을 경우 > 아무 문제 없음
        b. 기존 테이블에 데이터가 있었을 경우 > 미리 데이터 백업 > 테이블 삭제
            > 수정된 테이블 생성 > 데이터 복구
            - 개발 중에 사용 가능
            - 공부할 때 사용 가능
            - 서비스 운영 중에는 많이 부담되는 방법
            
    2. alter 명령어 사용 > 기존 테이블의 구조 변경
        a. 기존 테이블에 데이터가 없었을 경우 > 아무 문제 없음
        b. 기존 테이블에 데이터가 있었을 경우 > 상황에 따라 비용 차이 발생
            - 개발 중에 사용 가능
            - 공부할 때 사용 가능
            - 서비스 운영 중에는 많이 부담되는 방법
            
*/
drop table tblEdit;
create table tblEdit(
    seq number primary key,
    data varchar2(20) not null
);

insert into tblEdit values (1, '마우스');
insert into tblEdit values (2, '키보드');
insert into tblEdit values (3, '모니터');

-- Case 1. 새로운 컬럼을 추가하기
alter table tblEdit
    add (컬럼정의);

alter table tblEdit
    add (price number);

-- ORA-01758: 테이블은 필수 열을 추가하기 위해 (NOT NULL) 비어 있어야 합니다.
alter table tblEdit
    add (qty number not null);
-- 위 명령문 에러 해결 > 1. 데이터 삭제 후 위 명령문 다시 실행 > 해결
delete from tblEdit;

select * from tblEdit;

insert into tblEdit values (1, '마우스', 1000, 1);
insert into tblEdit values (2, '키보드', 2000, 1);
insert into tblEdit values (3, '모니터', 3000, 2);

desc tblEdit;

-- 아래 명령문 에러 해결 > 2. default 제약사항
alter table tblEdit
    add(color varchar2(30) default 'white' not null);


-- Case 2. 컬럼 삭제하기
-- 위 방법으로 삭제한 컬럼은 복구 불가능하다고 생각하기
alter table tblEdit
    drop column 컬럼명;

alter table tblEdit
    drop column color;

alter table tblEdit
    drop column qty;
    
alter table tblEdit
    drop column seq;    -- PK 삭제 > 절대 금지!
    
select * from tblEdit;

-- Case 3. 컬럼 수정하기

--SQL 오류: ORA-12899: "HR"."TBLEDIT"."DATA" 열에 대한 값이 너무 큼(실제: 31, 최대값: 20)
insert into tblEdit values(4, '맥북 M2 프로 2023 고급형');

-- Case 3.1 컬럼 길이 수정(확장/수정)
alter table tblEdit
    modity(컬럼정의);

alter table tblEdit
    modify(data varchar2(100)); --확장

alter table tblEdit
    modify(data varchar2(20));  --축소

-- Case 3.2 컬럼의 제약사항 수정(not null)
alter table tblEdit
    modify (data varchar2(100) null);   --not null > null

alter table tblEdit
    modify (data varchar2(100) not null);   --null > not null

alter table tblEdit
    modify (data varchar2(100) unique);   -- 다른 구문으로 대체해서 사용

-- Case 3.3 컬럼의 자료형 바꾸기
alter table tblEdit
    modify (data number);
    
delete from tblEdit;

-- Case 4. 제약사항 조작

drop table tblEdit;
create table tblEdit(
    seq number,
    data varchar2(20)
);

alter table tblEdit
    add constraint tbledit_seq_pk primary key(seq);

alter table tblEdit
    add constraint tbledit_data_uq unique(data);

alter table tblEdit
    drop constraint tbledit_data_uq;
    
insert into tblEdit values (1, '강아지');
insert into tblEdit values (2, '고양이');
insert into tblEdit values (3, '고양이');
insert into tblEdit values (3, null);
insert into tblEdit values (4, '고양이');

desc tblEdit;

select * from tblEdit;




















