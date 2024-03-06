-- ex32_index.sql

/*
    인덱스, Index
    - 검색을 빠른 속도로 하기 위해 사용하는 도구
    - SQL 명령 처리 속도를 빠르게 하기 위해서, 특정 컬럼에 대해서 생성하는 도구
    
    데이터베이스
    - 실제 DB(HDD) > 레코드 순서가 사용자가 원하는 정렬 상태가 아니다.
        > DBMS가 자체적으로 정렬 + 저장
    - 어떤 데이터를 검색 > 처음 ~ 끝까지 차례대로 검색 > table full scan
    - 특정 컬럼 선택 > 별도의 테이블에 복사 > 미리 정렬 >> 인덱스
    - 인덱스 -> 참조 > 테이블(레코드)
    
    인덱스 장단점
    - 장점 > 처리 속도를 향상 시킨다.
    - 단점 > 무분별한 인덱스 사용은 DB 성능을 저하시킨다.
    
    자동으로 인덱스가 걸리는 컬러
    - Primary key
    - Unique
    - *** 테이블에서 PK 컬럼을 검색하는 속도 >>>>> 테이블에서 PK에서 아닌 컬럼을 검색하는 속도
*/
select * from tblInsa;
select * from tblAddressBook;
select count(*) from tblAddressBook;

create table tblIndex
as
select * from tblAddressBook;

insert into tblIndex select * from tblIndex;

select count(*) from tblIndex;  --16384000

-- 시간 확인 
set timing on;

select count(*) from tblIndex where name = '최민기';

-- 인덱스 생성
create index idxName
    on tblIndex(name);
    
    
select /*+ index(tblIndex idxName) */
    count(*) from tblIndex where name = '최민기';

select * from tblInsa where num = 1010;        -- 인덱스 O
select * from tblInsa where name = '이순신';   -- 인덱스 X
 
/*
    인덱스 종류
    1. 고유 인덱스
        - PK, UQ > 자동으로 생성되는 인덱스
        - 인덱스의 값이 중복 불가능
        
    2. 비고유 인덱스
        - 일반 컬럼 > 사용자가 생성하는 인덱스
        - 인덱스의 값이 중복 가능
    
    3. 단일 인덱스
        - 컬럼 1개를 대상으로 만드는 인덱스
        
    4. 복합 인덱스
        - 컬럼 N개를 대상으로 만드는 인덱스
    
    5. 함수 기반 인덱스
*/

create index 인덱스명 on 테이블명(컬럼명);         --비고유 인덱스
create unique index 인덱스명 on 테이블명(컬럼명);  --고유 인덱스

create index idxInsaBuseo on tblInsa(buseo);            --비고유 인덱스
create unique index idxInsaJikwi on tblInsa(jikwi);     --고유 인덱스   --ORA-00955: 기존의 객체가 이름을 사용하고 있습니다.
create unique index idxInsaJikwi on tblInsa(name);      --고유 인덱스

create index idxHometown on tblIndex(hometown);

select 
    count(*) from tblIndex where hometown = '서울';                   --경과 시간: 00:00:03.749
select /*+ index(tblIndex idxHometown) */
    count(*) from tblIndex where hometown = '서울';                   --경과 시간: 00:00:00.828
select /*+ index(tblIndex idxHometown) */
    count(*) from tblIndex where hometown = '서울' and job = '학생';  --경과 시간: 00:00:14.655
    
create index idxHometownJob on tblIndex(hometown, job); 
select /*+ index(tblIndex idxHometownJob) */
    count(*) from tblIndex where hometown = '서울' and job = '학생';    --경과 시간: 00:00:00.034

-- 함수 기반 인덱스
select * from tblAddressBook;   
select count(*) from tblIndex where substr(email, instr(email, '@')) = '@naver.com';    --경과 시간: 00:00:05.098

create index idxEmail on tblIndex(email);
select /*+ idex(tblIndex idxEmail) */
    count(*) from tblIndex 
    where substr(email, instr(email, '@')) = '@naver.com';    --경과 시간: 00:00:05.098

drop index idxEmail;
create index idxEmail on tblIndex(substr(email, instr(email, '@')));

-- 프로젝트 맨 마지막 > 부하 걸리는 작업 선별 > 인덱스 적용 > 차이 발생?
/*
    인덱스를 사용해야 하는 상황
    1. 테이블에 데이터(레코드)가 많을 때
    2. where절에 사용되는 횟수가 많은 컬럼에 적용(*******)
    3. 인덱스 손익분기점 > 검색 결과가 원본 테이블의 10~15%이하인 경우
    4. null을 포함하는 경우 > 인덱스에는 null을 제외
    
    인덱스를 사용하지 말아야 하는 상황
    1. 테이블에 데이터(레코드)가 적을때(풀 스캔과 차이없음)
    2. 인덱스 손익분기점 > 검색 결과가 원본 테이블의 15% 이상인 경우
    3. 해당 테이블이 삽입, 수정, 삭제가 빈번할 경우(*********)
    
    프로젝트 + 수업(JDBC)
    JDBC = Java + Oracle
*/

