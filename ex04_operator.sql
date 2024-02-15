-- ex04_operator.sql

/*

    연산자, Operator
    
    1. 산술 연산자
    - +, -, *, /
    - %(없음) > 함수로 제공(mod())
    
    2. 문자열 연산자(concat)
    - +(X) > ||(O)
    
    3. 비교 연산자
    - >, >=, <, <=
    - =(==), <>(!=)
    - 논리값 반환 > boolean 존재(X) > 명시적 표현 불가능 > 조건에서 사용 가능
    - 컬럼 리스트에서 사용 불가
    - 조건절에서 사용
    
    4. 논리 연산자
    - and(&&), or(||), not(!)
    - 컬럼 리스트에서 사용 불가
    - 조건절에서 사용
    
    5. 대입 연산자
    - =
    - 컬럼 = 값
    - update 문
    - 복합 대입 연산자(+=, -=...) > 없음
    
    6. 3항 연산자
    - 없음
    - 제어문 없음
    
    7. 증감 연산자
    - 없음
    
    8. SQL 연산자
    - 자바 > instanceof
    - 오라클 > in, between, like, is 등..
    
    
*/

select 
    population,
    area,
    population + area,
    population - area,
    population * area,
    population / area
from tblCountry;

select 
    name || capital
from tblCountry;

select 
    population,
    area,
    population > area
from tblCountry;

select 
    * 
from tblCountry 
    where continent = 'AS';

select 
    * 
from tblCountry 
    where population > 5000 and population < 10000;
    




-- 컬럼의 별칭(Alias)
-- : 되도록 가공된 컬럼에 사용
-- : *** 결과셋의 컬럼명이 식별자로 적합하지 않을 때 > 적합한 식별자로 수정
-- : 별칭을 생성한 이후 > 별칭이 컬럼명이 된다.(원래 컬럼명은 기억X)
select
    name as 이름,
    age,
    age - 1 as 만나이,
    couple as "여자 친구",
    name as "select"
from tblMen;


-- 테이블의 별칭
-- : 편하게~ or 가독성 향상

select name, age, height from tblMen;

select hr.tblMen.name, hr.tblMen.age, hr.tblMen.height from hr.tblMen;

select m.name, m.age, m.height  --2.
from hr.tblMen m; --1.




