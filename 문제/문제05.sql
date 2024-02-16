-- ### decode ###################################


-- 1. tblInsa. 부장 몇명? 과장 몇명? 대리 몇명? 사원 몇명?
select
    count (decode(jikwi, '부장', 1)) as 부장인원,
    count (decode(jikwi, '과장', 1)) as 과장인원,
    count (decode(jikwi, '대리', 1)) as 대리인원,
    count (decode(jikwi, '사원', 1)) as 사원인원,
from tblInsa;

-- 2. tblInsa. 간부(부장, 과장) 몇명? 사원(대리, 사원) 몇명?
select
    count(decode(jikwi, '부장', 1)) + count(decode(jikwi, '과장', 1)) as 간부,
    count(decode(jikwi, '대리', 1)) + count(decode(jikwi, '사원', 1)) as 사원
from tblInsa;

select
    count(decode(jikwi, '부장', 1, '과장', 2)) as 간부,
    count(decode(jikwi, '대리', 3, '사원', 4)) as 사원
from tblInsa;

-- 3. tblInsa. 기획부, 영업부, 총무부, 개발부의 각각 평균 급여?
select 
    round(avg(decode(buseo, '기획부', basicpay))) as 기획부
from tblInsa;

select
    round(avg(decode(buseo, '기획부', basicpay))) as 기획부,
    round(avg(decode(buseo, '영업부', basicpay))) as 영업부,
    round(avg(decode(buseo, '총무부', basicpay))) as 총무부,
    round(avg(decode(buseo, '개발부', basicpay))) as 개발부
from tblInsa;

-- 4. tblInsa. 남자 직원 가장 나이가 많은 사람이 몇년도 태생? 여자 직원 가장 나이가 어린 사람이 몇년도 태생?
select
    max(decode(substr(ssn, 8, 1), '1', substr(ssn, 1, 2))),
    min(decode(substr(ssn, 8, 1), '2', substr(ssn, 1, 2)))
from tblInsa;

select * from tblInsa;
