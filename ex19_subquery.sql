-- ex19_subquery.sql

/*
    SQL
    1. Main Query, 쿼리
        - 하나의 문장 안에 하나의 select(insert, update, delete)로 되어 있는 쿼리
    
    2. Sub Query, 서브 쿼리, 부속 질의
        - 하나의 문장 안에 또 다른 문장이 들어있는 쿼리
        - select <- select
        - insert <- select
        - update <- select
        - delete <- select
        - 삽입 위치 > 거의 대부분의 절에서 사용 가능(***)
        - 값을 넣을 수 있는 장소면 서브쿼리가 들어갈 수 있다.
    
*/

-- tblCountry. 인구 수가 가장 많은 나라의 이름? 중국
select max(population) from tblCountry; --120660
select * from tblCountry 
    where population 
    = (select max(population) from tblCountry); --Sub Query

-- tblComedian. 몸무게가 가장 많이 나가는 사람의 이름?
select max(weight) from tblComedian;
select min(weight) from tblComedian;
select * from tblComedian where weight = (select max(weight) from tblComedian);
select * from tblComedian where weight = (select min(weight) from tblComedian);

-- tblInsa. 평균 급여보다 많이 받는 직원들?
select * from tblInsa where basicpay >= (select round(avg(basicpay)) from tblInsa);

-- 남자(166cm)의 여자친구 키?
select * from tblMen;
select * from tblWomen;
select * from tblWomen where couple = (select name from tblMen where height = 166);

/*
    서브쿼리 삽입 위치
    1. 조건절 > 비교값으로 사용
        a. 반환값이 1행 1열 > 단일값 반환 > 상수 취급 > 값 1개
        b. 반환값이 N행 1열 > 다중값 반환 > 열거형 비교 > in 사용
        c. 반환값이 1행 N열 > 다중값 반환 > 그룹 비교 > N개의 컬럼 : N개의 컬럼
        d. 반환값이 N행 N열 > 다중값 반환 > 2번 + 3번 > in + 그룹 비교
*/

-- 급여가 260만원 이상 받는 직원이 근무하는 부서의 직원 명단을 가져오기
-- ORA-01427: 단일 행 하위 질의에 2개 이상의 행이 리턴되었습니다.
select * from tblInsa
    where buseo = (select buseo from tblInsa where basicpay >= 2600000);

select * from tblInsa
    where buseo in ('총무부', '기획부');

select * from tblInsa
    where buseo in (select buseo from tblInsa where basicpay >= 2600000);


-- '홍길동'과 같은 지역, 같은 부서인 직원 명단을 가져오시오. > 서울, 기획부
select city, buseo from tblInsa where name = '홍길동';

select * from tblInsa where city = '서울' and buseo = '기획부';

--where 1:1 and 1:1
select * from tblInsa 
    where city = (select city from tblInsa where name = '홍길동')
        and buseo = (select buseo from tblInsa where name = '홍길동');

-- where 2:2 > 순서, 갯수 동일해야 함
select * from tblInsa 
    where (city,buseo) = (select city, buseo from tblInsa where name = '홍길동');


-- 급여가 260만원 이상 받는 직원과 같은 부서, 같은 지역 > 명단?
select * from tblInsa
    where (buseo, city) in (select buseo, city from tblInsa where basicpay >= 2600000);

/*
    서브쿼리 삽입 위치
    1. 조건절 > 비교값으로 사용
        a. 반환값이 1행 1열 > 단일값 반환 > 상수 취급 > 값 1개
        b. 반환값이 N행 1열 > 다중값 반환 > 열거형 비교 > in 사용
        c. 반환값이 1행 N열 > 다중값 반환 > 그룹 비교 > N개의 컬럼 : N개의 컬럼
        d. 반환값이 N행 N열 > 다중값 반환 > 2번 + 3번 > in + 그룹 비교
        
    2. 컬럼리스트 > 컬럼값으로 사용
        - 반드시 결과값이 1행 1열이어야 한다. > 스칼라 쿼리(원자값 반환)
        a. 정적 쿼리 > 모든 행에 동일한 값을 반환
        b. 상관 서브 쿼리(*****) > 메인 쿼리의 일부 컬럼값을 서브쿼리에서 사용
*/

select
    name, buseo, basicpay,
    (select round(avg(basicpay)) from tblInsa)
from tblInsa;

-- ORA-01427: 단일 행 하위 질의에 2개 이상의 행이 리턴되었습니다. 
select
    name, buseo, basicpay,
    (select jikwi from tblInsa)
from tblInsa;

-- ORA-00913: 값의 수가 너무 많습니다
select
    name, buseo, basicpay,
    (select jikwi, city from tblInsa where num = 1001)
from tblInsa;

-- 상관서브쿼리
select
    name, buseo, basicpay,
    (select round(avg(basicpay)) from tblInsa where buseo = a.buseo)
from tblInsa a;


select * from tblMen;
select * from tblWomen;

-- 상관서브쿼리
-- 남자(이름, 키, 몸무게) + 여자(이름, 키, 몸무게) > 결과셋
select
    name,
    height,
    weight,
    couple,
    (select height from tblWomen where name = tblMen.couple),
    (select weight from tblWomen where name = tblMen.couple)
from tblMen;


/*
    서브쿼리 삽입 위치
    1. 조건절 > 비교값으로 사용
        a. 반환값이 1행 1열 > 단일값 반환 > 상수 취급 > 값 1개
        b. 반환값이 N행 1열 > 다중값 반환 > 열거형 비교 > in 사용
        c. 반환값이 1행 N열 > 다중값 반환 > 그룹 비교 > N개의 컬럼 : N개의 컬럼
        d. 반환값이 N행 N열 > 다중값 반환 > 2번 + 3번 > in + 그룹 비교
        
    2. 컬럼리스트 > 컬럼값으로 사용
        - 반드시 결과값이 1행 1열이어야 한다. > 스칼라 쿼리(원자값 반환)
        a. 정적 쿼리 > 모든 행에 동일한 값을 반환
        b. 상관 서브 쿼리(*****) > 메인 쿼리의 일부 컬럼값을 서브쿼리에서 사용
    
    3. FROM절에서 사용
        - 서브쿼리의 결과 테이블을 또 하나의 테이블이라고 생각하고 메인 쿼리를 실행
        - 인라인 뷰(Inline View)
*/

-- 인라인 뷰
select * from (select name from tblInsa where name = '홍길동');    --select name from tblInsa where name = '홍길동' > 1행 1열의 테이블

-- 인라인 뷰 주의할 점 > as 사용하면 후에 영향을 줄 수 있으므로 주의
select
    *
from (select name, buseo, basicpay as salary from tblInsa where city = '경기')
    where salary >= 2000000;
































