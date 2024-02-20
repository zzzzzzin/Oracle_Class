-- ex24_pseudo.sql

/*
    의사 컬럼, Pseudo Column
    - 실제 컬럼은 아닌데 컬럼처럼 행동하는 객체
    
    rownum
    - 행번호
    - 시퀀스 객체 상관 x
    - 테이블의 행번호를 가져오는 역할
    - 오라클 전용
*/

select
    name, buseo,        -- 컬럼(속성) > 객체(레코드)
    100,                -- 상수 > 모든 객체(레코드)가 동일한 값을 가진다.
    substr(name, 2),    -- 함수 > I/O > 객체(레코드)의 특성에 따라 다른 값을 가진다.
    rownum              -- 의사컬럼
from tblInsa;

-- 게시판 > 페이시 > 페이징
-- 1페이지 > where rownum betwenn  1 and 20
-- 2페이지 > where rownum betwenn 21 and 40
-- 3페이지 > where rownum betwenn 41 and 60

select name, buseo, rownum from tblInsa where rownum = 1;
select name, buseo, rownum from tblInsa where rownum <= 5;

-- 값이 없음
select name, buseo, rownum from tblInsa where rownum = 5;
select name, buseo, rownum from tblInsa where rownum between 5 and 10;
-- *** 1. rownum은 from절이 호출될때 계산되어진다.
-- *** 2. where절에 의해 결과셋의 변화가 발생될 때 다시 계산되어진다.

select name, buseo, rownum  -- 2. 1번에서 생성된 rownum을 가져온다. (rownum num호출될 때 생성x)
from tblInsa;               -- 1. from절이 실행되는 순간, 모든 레코드에 rownum 할당

select name, buseo, rownum  --3. 소비
from tblInsa                --1. 할당
where rownum = 1;           --2. 조건

select name, buseo, rownum  --3. 소비 
from tblInsa                --1. 할당
where rownum = 3;           --2. 조건 > where절은 shift로 인해 이전 rownum을 삭제하고 다음 rownum이 1
                            --              > 절대 rownum의 2번부터 시작하지 않음



-- 서브쿼리 + rownum
-- 급여가 5~10등까지 가져오시오    --이미경, 김인수, 지재환, 이상헌, 최석규, 김영길
select name, basicpay, rownum as rnum3 from 
(select name, basicpay, rownum as rnum2 from 
(select name, basicpay, rownum as rnum1 
    from tblInsa 
    order by basicpay desc))
        where rnum2 = 5;

-- 서브쿼리 + rownum 좀더 보기 좋게
-- 1. 가장 안 쪽 쿼리를 정렬
select name, basicpay from tblInsa order by basicpay desc;
-- 2. 1번을 서브쿼리로 묶는다 + rownum > 별칭
select a.*, rownum from (select name, basicpay from tblInsa order by basicpay desc) a;
-- 3. 2번을 서브쿼리로 묶는다. + rnum 조건
select * from (select a.*, rownum as rnum 
    from (select name, basicpay from tblInsa order by basicpay desc) a)
        where rnum = 5;

--alias 주의
select *, name from tblInsa;            --에러
select tblInsa.*, name from tblInsa;    --정상

-- tblInsa. 급여순 정렬 + 10명씩
select * 
from tblInsa 
order by basicpay desc;

select * from 
    (select * 
        from tblInsa order by basicpay desc);

select a.*, rownum as rnum from (select * from tblInsa order by basicpay desc) a;

select * from 
    (select a.*, rownum as rnum 
        from (select * from tblInsa order by basicpay desc) a)
            where rnum BETWEEN 1 and 10;

-- where 절 빼고 뷰 생성 > rnum에 조건을 걸어 원하는 값을 계속 가져오기 위해
create or replace view vwBasicpay
as
select * from 
    (select a.*, rownum as rnum 
        from (select * from tblInsa order by basicpay desc) a);

select * from vwbasicpay where rnum BETWEEN 1 and 10;
select * from vwbasicpay where rnum BETWEEN 11 and 20;