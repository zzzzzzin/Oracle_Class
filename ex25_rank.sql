-- ex25_rank.sql

/*
    순위 함수
    - rownum 기반으로 만들어진 함수
    
    1. rank() over()
        - 동일값 = 동일순서
        - 누적 O
    
    2. dense_rank() over()
        - 동일값 = 동일순서
        - 누적 X
    
    3. row_number() over()
        - rownum 동일
*/

-- tblInsa. 급여순으로 가져오시오. + 순위 표시
select a.*, rownum from (select name, buseo, basicpay from tblInsa order by basicpay desc) a;

select 
    name, buseo, basicpay,
    rank() over(order by basicpay desc) as rnum
from tblInsa;    

select 
    name, buseo, basicpay,
    dense_rank() over(order by basicpay desc) as rnum
from tblInsa;      

select 
    name, buseo, basicpay,
    row_number() over(order by basicpay desc) as rnum
from tblInsa; 


-- 급여 5위?
-- ORA-30483: 윈도우 함수를 여기에 사용할 수 없습니다
select 
    name, buseo, basicpay,
    row_number() over(order by basicpay desc) as rnum
from tblInsa
    where (row_number() over(order by basicpay desc)) = 5;
    
select * from
    (select 
        name, buseo, basicpay,
        row_number() over(order by basicpay desc) as rnum
    from tblInsa)
        where rnum = 5;

select * from
    (select 
        name, buseo, basicpay,
        rank() over(order by basicpay desc) as rnum
    from tblInsa)
        where rnum = 8;    

-- 순위 함수 (+ order by)
------------------------------------------------------
-- 순위 함수 (+ order by + partition by) > 그룹별 순위

select 
    name, buseo, basicpay,
    rank() over(partition by buseo order by basicpay desc) as rnum
from tblInsa; 

select * from
    (select 
        name, buseo, basicpay,
        rank() over(order by basicpay desc) as rnum
    from tblInsa)
        where rnum = 1;
    
select * from
    (select 
        name, buseo, basicpay,
        rank() over(partition by buseo order by basicpay desc) as rnum
    from tblInsa)
        where rnum = 1;
