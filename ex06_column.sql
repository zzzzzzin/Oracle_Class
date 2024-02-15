-- ex06_column.sql

-- 컬럼 리스트에서 할 수 있는 행동
-- select 컬럼리스트

-- 컬럼 명시
select name, jikwi, buseo from tblInsa;

-- 연산
select name || '님', basicpay * 2 from tblInsa;

-- 상수
select name, 100 from tblInsa;


/*

    Java Stream > list.stream().distinct().forEach()

    distinct
    - 컬럼 리스트에서 사용
    - 중복값 제거
    - distinct 컬럼명(X) > distinct 컬럼리스트(O) 

*/

-- tblCountry에 어떤 대륙이 있습니까?
select continent from tblCountry;
select distinct continent from tblCountry;

-- tblInsa. 어떤 부서들이 있습니까?
select distinct buseo from tblInsa;
select distinct jikwi from tblInsa;
select distinct city from tblInsa;

select distinct name from tblInsa; --동명이인 없다.


select distinct buseo, name from tblInsa;

select distinct jikwi, city from tblInsa;

select distinct jikwi, city, buseo from tblInsa;


/*

    case
    - 대부분의 절에서 사용 가능
    - 조건문 역할 > 컬럼값 조작
    - 조건을 만족하면 then 값을 반환
    - 조건을 만족하지 못하면 null을 반환

*/

select
    last || first as name,
    gender
from tblComedian;


select
    last || first as name,
    case 
        -- when 조건 then 값
        when gender = 'm' then '남자'
        when gender = 'f' then '여자'
    end as gender
from tblComedian;


select
    last || first as name,
    case gender
        when 'm' then '남자'
        when 'f' then '여자'
    end as gender
from tblComedian;


select
    name, continent,
    case
        when continent = 'AS' then '아시아'
        when continent = 'EU' then '유럽'
        when continent = 'AF' then '아프리카'
        --else '기타'
        --else continent
        --else name
    end as continentName
from tblCountry;


select
    last || first as name,
    weight,
    case
        when weight > 90 then '과체중'
        when weight > 50 then '정상체중'
        else '저체중'
    end as state,
    case
        when weight >= 50 and weight <= 90 then '정상체중'
        else '주의체중'
    end as state2,
    case
        when weight between 50 and 90 then '정상체중'
        else '주의체중'
    end as state3
from tblComedian;

-- 사원, 대리 > 현장직
-- 과장, 부장 > 관리직

select
    name, jikwi,
    case
        when jikwi = '과장' or jikwi = '부장' then '관리직'
        else '현장직'
    end,
    case
        when jikwi in ('과장', '부장') then '관리직'
        else '현장직'
    end,
    case
        when jikwi like '%장' then '관리직'
        else '현장직'
    end 
from tblInsa;

select
    title,
    case
        when completedate is null then '미완료'
        when completedate is not null then '완료'
    end
from tblTodo;


