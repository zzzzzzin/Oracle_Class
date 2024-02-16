-- ex14_sequence.sql

/*
    시퀀스, Sequence
    - 데이터베이스 객체 중 하나(테이블, 제약사항, 시퀀스)
    - 오라클 전용 객체(다른 DBMS 제품에는 없음)
    - 일련 번호를 생성하는 객체(*****)  
    - 주로 식별자를 만드는 데 사용된다. > PK 값으로 사용한다.
    
    시퀀스 객체 생성하기
    - create sequence 시퀀스명;
    
    시퀀스 객체 삭제하기
    - drop sequence 시퀀스명;
    
    시퀀스 객체 사용하기
    - 시퀀스명.nextVal > 함수 > 호출 시 일련 번호 반환 (거의 이거 많이 사용)
    - 시퀀스명.currVal (거의 사용 x)
    
    
*/

-- DB Object > 헝가리안 표기법
-- tblXXX
-- seqXXX
drop sequence seqNum;
create sequence seqNum;

select seqNum.nextVal from dual;

create sequence seqMemo;

drop table tblMemo;

create table tblMemo(
    seq number constraint tblmemo_seq_pk primary key,
    name varchar2(30),
    memo varchar2(1000),
    regdate date
);
insert into tblMemo (seq, name, memo, regdate) values (seqMemo.nextVal, '홍길동', '메모', sysdate);

select * from tblMemo;
delete from tblMemo;


-- 쇼핑몰 > 상품 번호 > ABC101
select 'ABC' || seqNum.nextVal from dual;
select 'ABC' || lpad(seqNum.nextVal, 3, 0) from dual;

--ORA-08002: 시퀀스 SEQNUM.CURRVAL은 이 세션에서는 정의 되어 있지 않습니다 > sql developer를 끄고 키니까 안 됨
select seqNum.currVal from dual;


/*
    시퀀스 객체 생성하기
    
    create sequence 시퀀스명
                increment by n      --증감치   > 기본 값 1에서 n만큼 증가(n이 음수일 경우, -1에서 n만큼 감소)
                start with n        --시작값
                maxvalue n          --최댓값
                minvalue n          --최솟값
                cycle               -- 순환 유무
                cache n;            -- 임시 저장
                                    -- 오라클은 데이터 종료와 동시에 저장 > 의도치않은 종료가 발생하면 저장을 못해서 cache의 n만큼 임시 저장이 됨
*/

drop sequence seqTest;

create sequence seqTest
               -- increment by -1
               -- start with 10
               -- maxvalue 10
               -- minvalue 1
               -- cycle 
                cache 20
                ;

select seqTest.nextVal from dual;











