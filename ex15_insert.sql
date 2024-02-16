-- ex15_insert.sql

/*
    insert 문
    - DML
    - 테이블에 데이터를 추가하는 명령어
    
    - insert into 테이블명 (컬럼리스트) values (값리스트);
    
*/

drop table tblMemo;

create table tblMemo(
    seq number constraint tblmemo_seq_pk primary key,
    name varchar2(30) default '익명',
    memo varchar2(1000),
    regdate date default sysdate not null
);

drop sequence seqMemo;
create sequence seqMemo;

-- 1. 표준
-- : 원본 테이블의 정의된 컬럼 순서대로 컬럼리스트와 값리스트를 작성하는 방법
-- : 특별한 목적이 없으면 이 방식 사용
insert into tblMemo (seq, name, memo, regdate) values (seqMemo.nextVal, '홍길동', '메모입니다.', sysdate);

-- 2. 컬럼 리스트의 순서는 원본 테이블과 상관없다. 
-- : 컬럼 리스트와 값 리스트의 순서만 동일하면 된다. > 그럼에도 1번을 사용을 권장
insert into tblMemo (regdate, seq, name, memo) values (sysdate, seqMemo.nextVal, '홍길동', '메모입니다.');

-- 3. SQL 오류: ORA-00947: 값의 수가 충분하지 않습니다.
insert into tblMemo (seq, name, memo, regdate) values (seqMemo.nextVal, '메모입니다.', sysdate);

-- 4. SQL 오류: ORA-00913: 값의 수가 너무 많습니다
insert into tblMemo (seq, memo, regdate) values (seqMemo.nextVal, '홍길동', '메모입니다.', sysdate);

-- 5. null 컬럼 조작
-- 5.a null 상수 사용
insert into tblMemo (seq, name, memo, regdate) values (seqMemo.nextVal, '홍길동', null, sysdate);

-- 5.b 컬럼 생략
insert into tblMemo (seq, name, regdate) values (seqMemo.nextVal, '홍길동', sysdate);

-- 6. default 컬럼 조작
-- 6.a 컬럼 생략 > null 대입 > default 호출
insert into tblMemo (seq, memo, regdate) values (seqMemo.nextVal, '메모입니다.', sysdate);   

-- 6.b null 상수 > defualt 동작 안 함
insert into tblMemo (seq, name, memo, regdate) values (seqMemo.nextVal, null ,'메모입니다.', sysdate);   

-- 6.c default 상수
insert into tblMemo (seq, name, memo, regdate) values (seqMemo.nextVal, default, '메모입니다.', sysdate);


-- 7. 단축
-- 7.a 컬럼리스트 생략 가능 > 장기간 보관해야 하는 쿼리에는 사용 자제
insert into tblMemo values (seqMemo.nextVal, '홍길동', '메모입니다.', sysdate);

-- 7.b 컬럼리스트를 생략하면, 테이블의 원본 컬럼 순서대로 값리스트를 작성해야 한다.
-- SQL 오류: ORA-00932: 일관성 없는 데이터 유형: NUMBER이(가) 필요하지만 DATE임
insert into tblMemo values (sysdate, seqMemo.nextVal, '홍길동', '메모입니다.');

-- 7.c null 컬럼 생략 불가능
-- SQL 오류: ORA-00947: 값의 수가 충분하지 않습니다
insert into tblMemo values (seqMemo.nextVal, '홍길동', sysdate);
insert into tblMemo values (seqMemo.nextVal, '홍길동', null, sysdate); --null 상수를 넣고 싶다면 생략하지 않고 작성해야 함

-- 7.d default 컬럼 생략 불가능
insert into tblMemo values (seqMemo.nextVal, '메모입니다.', sysdate);
insert into tblMemo values (seqMemo.nextVal, default, '메모입니다.', sysdate);   --default를 넣고 싶다면 생략하지 않고 작성해야 함

-- 8. 
-- tblMemo 테이블 > 복사 > 새 테이블 생성(tblmemoCopy)

create table tblMemoCopy(
    seq number constraint tblmemocopy_seq_pk primary key,
    name varchar2(30) default '익명',
    memo varchar2(1000),
    regdate date default sysdate not null
);

insert into tblMemoCopy select * from tblMemo;  --Sub Query
insert into tblMemoCopy select * from tblMemo where name = '홍길동';

select * from tblMemo;
select * from tblMemoCopy;
delete from tblMemoCopy;

-- 9. 
-- tblMemo 테이블 > 복사 > 새 테이블 생성(tblmemoCopy)
-- 테이블 구조 복사(O)
-- 제약 사항 복사(X)
-- 임시 + 다량 데이터 용도 > 테스트용 데이터
drop table tblMemoCopy;

create table tblMemoCopy
as
select * from tblMemo;

select * from tblMemoCopy;

insert into tblMemoCopy (seq, name, memo, regdate) values (1, '홍길동', '메모입니다.', sysdate);































