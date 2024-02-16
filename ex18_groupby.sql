-- ex18_groupby.sql

/*
    [WITH <Sub Query>]    
    SELECT column_list
    FROM table_name
    [WHERE search_condition]
    [GROUP BY group_by_expression]
    [HAVING search_condition]
    [ORDER BY order_expression [ASC|DESC]];
    
    
    SELECT 컬럼리스트       4. 컬럼 지정 (보고 싶은 컬럼만 가져오기) > Projection
    FROM 테이블             1. 테이블 지정
    WHERE 검색조건          2. 조건 지정 (보고 싶은 행만 가져오기) > Selection
    GROUP BY 그룹 기준      3. 그룹을 나눈다.
    ORDER BY 정렬기준;      5. 정렬해서
    
    GROUP BY절
    - 특정 기준으로 레코드를 그룹으로 나눈다.          (수단)
        > 각각의 그룹을 대상으로 집계함수를 실행한다.  (목적)
    
*/

-- tblInsa. 부서별 평균 급여?
select * from tblInsa;

select round(avg(basicpay)) from tblInsa;  --155 (전체의 평균 급여)

select distinct buseo from tblInsa; --7 (부서 7개)

-- group by 절 없이 만들려면
select round(avg(basicpay)) from tblInsa where buseo = '기획부';   -- 185
select round(avg(basicpay)) from tblInsa where buseo = '총무부';   -- 171
select round(avg(basicpay)) from tblInsa where buseo = '개발부';   -- 138
select round(avg(basicpay)) from tblInsa where buseo = '영업부';   -- 160
select round(avg(basicpay)) from tblInsa where buseo = '홍보부';   -- 145
select round(avg(basicpay)) from tblInsa where buseo = '인사부';   -- 153
select round(avg(basicpay)) from tblInsa where buseo = '자재부';   -- 141

-- group by 절 사용
select
    buseo,
    round(avg(basicpay)) as "부서별 평균 급여",
    count(*) as "부서별 인원 수",
    sum(basicpay) as "부서별 총 지급액",
    max(basicpay) as "부서내의 최고 급여",
    min(basicpay) as "부서내의 최저 급여"
from tblInsa
    group by buseo;

-- 남자 수? 여자 수?    
select * from tblComedian;

-- group by 없이
select
 count(decode(gender, 'm', 1)) as 남자수,
 count(decode(gender, 'f', 1)) as 여자수
from tblComedian;

-- group by 있이
select
    gender,count(*)
from tblComedian
    group by gender;

select
    jikwi, count(*)
from tblInsa
    group by jikwi;

select
    city, count(*)
from tblInsa
    group by city;

select 
    buseo, count(*)
from tblInsa
    group by buseo
        order by count(*) desc;

-- 다중 그룹 
select 
    count(*), buseo, jikwi
from tblInsa
    group by buseo, jikwi
        order by buseo, jikwi;

select 
    count(*), buseo, jikwi
from tblInsa
    group by jikwi, buseo
        order by jikwi, buseo;

-- 급여별 그룹
-- 100만원 이하
-- 100만원 ~ 200만원
-- 200만원 이상

select
    basicpay,
    count(*)
from tblInsa
    group by basicpay;

select 
--    basicpay,
    (floor(basicpay / 1000000) + 1) * 100 || '만원 이하' as money,
    count(*)
from tblInsa
    group by floor(basicpay / 1000000);

-- tblInsa. 남자 수? 여자 수?
select
    substr(ssn, 8, 1),
    count(*)
from tblInsa
    group by substr(ssn, 8, 1);

-- tblTodo 완료 한 일 몇개? 아직 못 끝낸거 몇개?
select
    case
        when completedate is not null then 1
        else 2
    end,
    count(*)
from tblTodo
    group by case
        when completedate is not null then 1
        else 2
    end;

-- tblInsa. 과장+부장 몇명? 사원+대리 몇명?
select
    case
        when jikwi in ('과장', '부장') then 1
        when jikwi in ('대리', '사원') then 1
    end,
    count(*)
from tblInsa
    group by case
        when jikwi in ('과장', '부장') then 1
        when jikwi in ('대리', '사원') then 1
    end;

-- 다른 답





/*
    SELECT 컬럼리스트       5. 컬럼 지정 (보고 싶은 컬럼만 가져오기) > Projection
    FROM 테이블             1. 테이블 지정
    WHERE 검색조건          2. 조건 지정 (보고 싶은 행만 가져오기) > Selection > 레코드에 대한 조건
    GROUP BY 그룹 기준      3. (레코드끼리)그룹을 나눈다.
    HAVING 조건             4. 그룹에 대한 조건(그룹에 대한 where절)
    ORDER BY 정렬기준;      6. 정렬해서
    
    having 절
    - 그룹에 대한 조건
    - having을 만족하는 그룹만 결과셋 남는다.
*/

select
    count(*)
from tblInsa
    where basicpay >= 1500000;

-- 전 직원 중, 급여가 150만원 이상인 사람들을 부서별로 그룹지어 각 부서별의 인원수를 가져오시오
select
    buseo, count(*), round(avg(basicpay))   --4. 각 그룹별로 집계함수를 가져온다.
from tblInsa                                --1. 60명의 데이터를 가져온다.
    where basicpay >= 1500000               --2. 60명을 대상으로 조건을 검사한다.
        group by buseo;                     --3. 2번을 통과한 사람들을 대상으로 그룹을 짓는다.

-- 전 직원을 부서별로 그룹짓고, 그룹별 평균 급여가 150만원 이상인 그룹의 인원수를 가져오시오.
select                                          
    buseo, count(*), round(avg(basicpay))   --4. 각그룹별로 집계함수를 가져온다.
from tblInsa                                --1. 60명의 데이터를 가져온다.
    group by buseo                          --2. 60명을 대상으로 그룹을 짓는다.
        having avg(basicpay) >= 1500000;    --3. 그룹을 대상으로 조건을 검사한다.


-- 부서내(group by) 과장/부장(where)의 인원수가 3명 이상(having)인 부서들? 
select
    buseo, count(*)
from tblInsa
    where jikwi in ('과장', '부장')
        group by buseo
            having count(*) >= 3;


/*
    rollup()
    - group by의 집계 결과를 좀 더 자세하게 반환
    - 그룹별 중간 통계
    
*/

select
    buseo,
    jikwi,
    city,
    count(*),
    sum(basicpay),
    round(avg(basicpay)),
    max(basicpay),
    min(basicpay)
from tblInsa
--    group by rollup(buseo);
--    group by rollup(buseo, jikwi);
    group by rollup(buseo, jikwi, city);

/*
    cube()
    - group by의 집계 결과를 좀 더 자세하게 반환
    - 그룹별 중간 통계
*/

select
    buseo,
    jikwi,
    city,
    count(*),
    sum(basicpay),
    round(avg(basicpay)),
    max(basicpay),
    min(basicpay)
from tblInsa
--    group by cube(buseo);
--    group by cube(buseo, jikwi);
    group by cube(buseo, jikwi, city);







