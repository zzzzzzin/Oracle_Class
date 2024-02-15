-- ex12_datetime_function.sql

/*
    날짜 시간 함수
    
    sysdate
    - 현재 시스템의 시각을 반환
    - java의 Calendat.getInstance()
    - date sysdate
*/

select sysdate from dual;   --24/02/15

/*
    날짜 연산
    1. 시각 - 시각 = 시간
    2. 시각 + 시간 = 시각
    3. 시각 - 시간 = 시각
*/

-- 1. 시각 - 시각 = 시간(일)
-- 현재 - 입사일
select
    name,
    to_char(ibsadate, 'yyyy-mm-dd') as 입사일,
    round(sysdate - ibsadate) as 근무일수,
    round((sysdate - ibsadate) * 24) as 근무시수,
    round((sysdate - ibsadate) * 24 * 60) as 근무분수,
    round((sysdate - ibsadate) * 24 * 60 * 60) as 근무초수,
    round((sysdate - ibsadate) / 365) as 근무년수   --매년마다 일수가 다르므로 정확한 값이 아닌 대략적인 값
from tblInsa;

select
    title,
    adddate,
    completedate,
    round((completedate - adddate) * 24) as "실행하기까지 걸린 시간"  --completedate가 null일때, 결과값 null > null과의 연산 결과는 무조건 null
from tblTodo
    order by "실행하기까지 걸린 시간" desc;   --null을 포함해서 정렬하면 null이 가장 우선으로 나온다.

-- 2. 시각 + 시간(일) = 시각
-- 3. 시각 - 시간(일) = 시각

select
    sysdate,                      
    sysdate + 100 as "100일 뒤",   
    sysdate - 100 as "100일 전",   
    to_char(sysdate + (3/24), 'hh24:mi:ss') as "3시간 후",  
    to_char(sysdate + (30/24/60), 'hh24:mi') as "30분 후"
from dual;

/*
    months_between()
    - 시각 - 시각 = 시간(월)
    - number months_between(date, date)
*/

select
    name,
    round(sysdate - ibsadate) as 근무일수,
    round((sysdate - ibsadate) / 365) as 근무년수,
    round(months_between(sysdate, ibsadate)) as 근무월수,
    round(months_between(sysdate, ibsadate) / 12) as 근무년수
from tblInsa;