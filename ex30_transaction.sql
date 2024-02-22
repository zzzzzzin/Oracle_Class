-- ex30_transaction.sql

/*
    트랜잭션, Transaction
    - 데이터를 조작하는 업무의 물리적(시간적) 단위
    - 1개 이상의 명령어를 묶어 놓은 단위
    - **** 트랜잭션을 어떻게 처리할 것인가?
    
    트랜잭션 명령어 (DCL -> TCL)
    1. commit       > 잘 알아야 함
    2. rollback     > 잘 알아야 함
    3. savepoint    > 사람마다 쓰는지 안 쓰는지 다름
    
    
*/
create table tblTrans
as
select name, buseo, jikwi from tblInsa where city = '서울';

select * from tblTrans;

-- 우리가 하는 행동(SQL) > 시간 순으로 모두 기억하기(**************)
-- ex30은 위에서 아래로 시간 순서대로 작성됨

-- sql developer 종료
-- sql developer 로그인 직후(접속) > 트랜잭션이 시작됨
-- 트랜잭션 > 모든 명령어에 대한 감시 (X) > insert, update, delete 명령어만 트랜잭션에 포함된다.
-- insert, update, delete 작업 > 오라클(HDD)에 적용(X), 임시 메모리에 적용(O)

select * from tblTrans;

delete from tblTrans where name = '박문수';    --현재 트랜잭션에 포함

select * from tblTrans; -- 박문수 제거됨
                        --  > 실제 오라클이 아니라 임시로 저장된 메모리에서 박문수가 제거되고
                        --      그 임시 메모리의 값을 가져와서 접속된 개인 계정에서만 보여줌
                        -- cmd창에서는 박문수가 그대로 존재


------------------------------------------------------------------------------------- 트랜잭션 초기화
-- 박문수 되살리기
rollback;

select * from tblTrans;

delete from tblTrans where name = '박문수';

------------------------------------------------------------------------------------- 트랜잭션 초기화
rollback;

select * from tblTrans;

delete from tblTrans where name = '박문수';

commit; -- 이전 트랜잭션 모두 데이터에 반영
    
select * from tblTrans; -- cmd 창에서도 변경사항이 반영되어 나옴

------------------------------------------------------------------------------------- 트랜잭션 초기화
rollback;
insert into tblTrans values ('호호호', '기획부', '사원');
update tblTrans set jikwi = '상무' where name = '홍길동';

select * from tblTrans;

commit;
------------------------------------------------------------------------------------- 트랜잭션 초기화

/*
    트랜잭션이 언제 시작해서 언제 끝나는지 확실하게 알아야 함
    
    새로운 트랜잭션이 시작하는 시점
        1. 클라이언트 접속 직후
        2. commit 실행 직후
        3. rollback 실행 직후
    
    현재 트랜잭션이 종료되는 시점
        1. commit   > DB에 반영O
        2. rollback > DB에 반영X
        3. 클라이언트 접속 종료
            a. 정상 종료
                - 현재 트랜잭션에 반영이 안 된 명령어가 남아 있으면 > 질문?
            b. 비정상 종료
                - 트랜잭션을 처리할만한 시간적인 여유가 없는 경우
        4. DDL 실행(***주의!!)
            - create, alter, drop > 실행 > 즉시 commit 실행
            - DDL 성격 > 구조 변경 > 데이터에 영향 미침 > 사전에 미리 저장(commit)
    
*/

delete from tblTrans where name = '홍길동';
select * from tblTrans;

-- sql developer 종료 > 롤백 선택 후 종료 > 새 접속
select * from tblTrans; 

delete from tblTrans where name  = '홍길동';

select * from tblTrans; -- 홍길동 다시 복구됨

commit; -- commit 전에 데이터에 문제가 없으면 commit 실행
------------------------------------------------------------------------------------- 트랜잭션 초기화
update tblTrans set jikwi = '사장' where name = '홍길동';

select * from tblTrans;

-- 시퀀스 객체 생성

create sequence seqTrans;   -- commit 자동 호출(DDL)
------------------------------------------------------------------------------------- 트랜잭션 초기화
select * from tblTrans;

rollback;
------------------------------------------------------------------------------------- 트랜잭션 초기화

select * from tblTrans; -- 홍길동	기획부	사장

-- savepoint

select * from tblTrans;

insert into tblTrans values('후후후', '기획부', '사원');

savepoint a;

delete from tblTrans where name = '홍길동';

savepoint b;

update tblTrans set buseo = '개발부' where name = '후후후';

select * from tblTrans;

rollback to b;  -- savepoint b 시점으로 감

select * from tblTrans; --후후후	기획부	사원

rollback to a;

select * from tblTrans;

rollback;
------------------------------------------------------------------------------------- 트랜잭션 초기화
select * from tblTrans;





































