-- ex21_view.sql

/*
    View, 뷰
    - 데이터 베이스 객체 중 하나(테이블, 제약사항, 시퀀스, 뷰)
    - 가상 테이블, 뷰 테이블 등..
    - 원하는 데이터를 선택해서 사용자 정의를 해놓은 요소
    - 테이블처럼 사용한다.(*********)
    
    create [or replace] view 뷰이름
    as
    select 문;
*/

create or replace view vwInsa
as  --연결부(as, is)
select * from tblInsa;

select * from vwInsa;   --tblInsa 테이블의 복사본

-- 자주 반복 없무 > '영업부' + '서울' + select
create or replace view 영업부
as
select
    num, name, basicpay, substr(ssn, 8) as ssn
from tblInsa
    where buseo = '영업부' and city = '서울';

-- 비디오 대여점 사장 > 날마다 업무
create or replace view vwCheck
as
select
    m.name as 회원,
    v.name as 비디오,
    r.rentdate as 언제,
    r.retdate as 반납,
    g.period as 대여기간,
    r.rentdate + g.period as 반납예정일,
    round(sysdate - (r.rentdate + g.period)) as 연체일,
    round((sysdate - (r.rentdate + g.period)) * g.price * 0.1) as 연체료
from tblRent r
    inner join tblVideo v
        on r.video = v.seq
            inner join tblMember m
                on m.seq = r.member
                    inner join tblGenre g
                        on g.seq = v.genre;
                        
update tblRent set retdate = '2007-02-03' where seq = 2;
update tblRent set retdate = '2007-02-08' where seq = 4;

select * from vwcheck;