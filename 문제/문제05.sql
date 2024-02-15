-- ### decode ###################################


-- 1. tblInsa. 부장 몇명? 과장 몇명? 대리 몇명? 사원 몇명?
select
    count(case
        when jikwi = '부장' then 1
    end) as 부장인원,
    count(case
        when jikwi = '과장' then 1
    end) as 과장인원,
    count(case
        when jikwi = '대리' then 1
    end) as 대리인원,
    count(case
        when jikwi = '사원' then 1
    end) as 사원인원
from tblInsa;

-- 2. tblInsa. 간부(부장, 과장) 몇명? 사원(대리, 사원) 몇명?
select
    count(case
        when jikwi in ('부장', '과장') then 1
    end) as 간부인원,
    count(case
        when jikwi in('대리', '사원') then 1
    end) as 사원인원
from tblInsa;

-- 3. tblInsa. 기획부, 영업부, 총무부, 개발부의 각각 평균 급여?
select * from tblInsa;
select 
    avg(case
        when buseo = '기획부' then basicpay
    end) as 기획부평균급여,
    avg(case
        when buseo = '총무부' then basicpay
    end) as 총무부평균급여,
    avg(case
        when buseo = '개발부' then basicpay
    end) as 개발부평균급여
from tblInsa;

-- 4. tblInsa. 남자 직원 가장 나이가 많은 사람이 몇년도 태생? 여자 직원 가장 나이가 어린 사람이 몇년도 태생?
select
    min(case
        when substr(ssn, 8, 1) = '1' then substr(ssn, 1, 6)
    end) as 남자연장자,
    min(case
        when substr(ssn, 8, 1) = '2' then substr(ssn, 1, 6)
    end)as 여자연장자
from tblInsa;
