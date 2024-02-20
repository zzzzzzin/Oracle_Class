-- ex20_join.sql

/*
     관계형 데이터베이스 시스템이 지양하는 것들 - join이 제 역할을 하는 이유
     - 테이블을 다시 수정해야만 고쳐지는 것들 > 구조적 문제!!
     
     1. 테이블에 기본키가 없는 상태 > 데이터 조작 불가능(레코드 식별 불가능)
     2. null이 많은 상태의 테이블 > 공간 낭비 + SQL 작업 불편
     3. 데이터가 중복되는 상태 > 공간 낭비 + 데이터 조작 문제 발생(일관성 저하)
     4. 하나의 속성값 이 원자값이 아닌 상태 > 더 이상 쪼개지지 않는 값을 넣어야 한다.
*/

-- 직원 정보
-- 직원(번호(PK), 직원명, 급여, 거주지, 담당프로젝트)
create table tblStaff(
    seq number primary key,         -- 직원번호(PK)
    name varchar2(30) not null,     -- 직원명
    salary number not null,         -- 급여
    address varchar(300) not null,  -- 거주지
    project varchar2(300)           -- 담당 프로젝트
);

insert into tblStaff(seq, name, salary, address, project)
    values(1, '홍길동', 300, '서울시', '홍콩 수출');
    
insert into tblStaff(seq, name, salary, address, project)
    values(2, '아무개', 250, '인천시', 'TV 광고');

insert into tblStaff(seq, name, salary, address, project)
    values(3, '하하하', 350, '의정부시', '매출 분석');
    
select * from tblStaff;--1	홍길동	300	서울시	홍콩 수출

-- '홍길동'에게 담당 프로젝트가 1건 추가 > '고객 관리'
-- 홍콩 수출 + 고객 관리

update tblStaff set
    project = project || ', 고객 관리'
        where seq = 1;

select * from tblStaff; --1	홍길동	300	서울시	홍콩 수출, 고객 관리


insert into tblStaff(seq, name, salary, address, project)
    values(4, '홍길동', 300, '서울시', '고객 관리');
    
select * from tblStaff; --4	홍길동	300	서울시	고객 관리


insert into tblStaff(seq, name, salary, address, project)
    values(5, '호호호', 250, '서울시', '게시판 관리, 회원 응대');

insert into tblStaff(seq, name, salary, address, project)
    values(6, '후후후', 250, '부산시', '불량 회원 응대');

select * from tblStaff;

-- '회원 응대' > 담당자가 누구? > 호호호
select * from tblStaff where project =  '회원 응대';        -- 아무도 안 나옴
select * from tblStaff where project like  '%회원 응대%';   -- 호호호, 후후후 > '회원 응대' 담당자만 찾기 힘듦
                                                            -- 원인: 테이블 스키마(구조)가 잘못된 상태
                                                            -- 해결: 테이블 재구성 > project를 독립된 table로 생성

drop table tblProject;
drop table tblStaff;

-- 참조 방향 결정
-- : 테이블(레코드) 생성 시간을 고려 (적중률: 99%)

-- 직원 정보
-- 직원(번호(PK)), 직원명, 급여, 거주지)    --부모 테이블 > 자식 테이블보다 먼저 생성되어야 함, 자식 테이블보다 먼저 삭제 안 됨
create table tblStaff(
    seq number primary key,         -- 직원번호(PK)
    name varchar2(30) not null,     -- 직원명
    salary number not null,         -- 급여
    address varchar(300) not null   -- 거주지
);

-- 프로젝트(번호(PK), 담당 프로젝트, 담당 직원 번호)  --자식 테이블 > 부모 테이블 참조
create table tblProject(
    seq number primary key,                             -- 프로젝트 번호(PK)
    project varchar2(100) not null,                     -- 프로젝트명
    staff_seq number not null references tblStaff(seq)  -- 담당 직원번호(FK)
);

insert into tblStaff (seq, name, salary, address) values (1, '홍길동', 300, '서울시');
insert into tblStaff (seq, name, salary, address) values (2, '아무개', 250, '인천시');
insert into tblStaff (seq, name, salary, address) values (3, '하하하', 350, '부산시');

insert into tblProject (seq, project, staff_seq) values (1, '홍콩 수출', 1);    --홍길동
insert into tblProject (seq, project, staff_seq) values (2, 'TV 광고', 2);      --아무개  
insert into tblProject (seq, project, staff_seq) values (3, '매출 분석', 3);    -- 하하하
insert into tblProject (seq, project, staff_seq) values (4, '노조 협상', 1);    -- 홍길동
insert into tblProject (seq, project, staff_seq) values (5, '대리점 분양', 2);  -- 아무개

select * from tblStaff;
select * from tblProject;


-- 'TV 광고' 담당자?
-- 2	TV 광고	2
select * from tblProject where project = 'TV 광고';   -- 2 (담당직원번호)
select * from tblStaff where seq = 2;   -- 아무개
select * from tblStaff 
    where seq = (select staff_seq from tblProject where project = 'TV 광고');

-- A. 신입 사원 입사 > 신규 프로젝트 배정
-- A1. 신입사원 추가 (O)
insert into tblStaff (seq, name, salary, address)
    values(4, '호호호', 250, '성남시');

select * from tblStaff;

-- A.2 신규 프로젝트 배정 (O)
insert into tblProject (seq, project, staff_seq)
    values (6, '자재 매입', 4);
    
select * from tblProject;

-- A.3 신규 프로젝트 추가 > 에러(X) > 논리 오류 (담당 직원이 없는 프로젝트가 생성됨)
-- references(FK) 제약 설정 이후 error: ORA-02291: 무결성 제약조건(HR.SYS_C008518)이 위배되었습니다- 부모 키가 없습니다
insert into tblProject (seq, project, staff_seq)
    values (7, '고객 유치', 5);
select * from tblProject;

select * from tblStaff 
    where seq = (select staff_seq from tblProject where project = '고객 유치'); --담당 직원 없음

-- B. '홍길동' 퇴사
-- B.1 '홍길동' 삭제 > 에러(X) > 논리 에러 ('홍길동'이 담당한 프로젝트의 담당 직원이 퇴사)
-- references(FK) 제약 설정 이후 error: ORA-02292: 무결성 제약조건(HR.SYS_C008518)이 위배되었습니다- 자식 레코드가 발견되었습니다
delete from tblStaff where seq = 1;

-- B.2 '홍길동' 삭제 전 > 업무 인수 인계(위임) > '홍길동'이 담당한 프로젝트를 '아무개'에게 인수인계
update tblProject set staff_seq = 2 where staff_seq = 1;

-- B.3 '홍길동' 삭제
delete from tblStaff where seq = 1;

select * from tblStaff;
select * from tblProject;


-- 테이블 2개 생성
-- 고객 테이블 
create table tblCustomer(
    seq number primary key,         -- 고객번호(PK)
    name varchar2(30) not null,     -- 고객명
    tel varchar2(15) not null,      -- 연락처
    address varchar2(100) not null  -- 주소
);

-- 판매내역 테이블
create table tblSales(
    seq number primary key,                             -- 판매번호(PK)
    item varchar2(50) not null,                         -- 제품명
    qty number not null,                                -- 수량
    regdate date default sysdate not null,              -- 판매날짜
    cseq number not null references tblCustomer(seq)    -- 고객번호(FK)
);



-- 테이블 4개 생성

-- 장르 테이블
create table tblGenre(
    seq number primary key,     -- 장르번호(PK)
    name varchar2(30) not null, -- 장르명
    price number not null,      -- 대여가격
    period number not null      -- 대여기간(일)
);

-- 비디오 테이블
create table tblVideo(
    seq number primary key,                         -- 비디오번호(PK)
    name varchar2(100) not null,                    -- 제목
    qty number not null,                             -- 수량
    company varchar2(50) null,                      -- 제작사
    director varchar2(50) null,                     -- 감독
    major varchar2(50) null,                        -- 주연배우
    genre number not null references tblGenre(seq)  -- 장르번호(FK)
);

-- 회원 테이블
create table tblMember(
    seq number primary key,         -- 회원번호(PK)
    name varchar2(30) not null,     -- 회원명
    grade number(1) not null,       -- 회원등급(1,2,3)
    byear number(4) not null,       -- 생년
    tel varchar2(15) not null,      -- 연락처
    address varchar2(300) null,     -- 주소
    money number not null           -- 예치금
);

-- 대여 테이블
create table tblRent(
    seq number primary key,                             -- 대여번호(PK)
    member number not null references tblMember(seq),   -- 회원번호(FK)
    video number not null references tblVideo(seq),     -- 비디오번호(FK)
    rentdate date default sysdate not null,             -- 대여시각
    retdate date null,                                  -- 반납시각
    remart varchar2(500) null                           -- 비고
);

create sequence genreSeq;
create sequence videoSeq;
create sequence memberSeq;
create sequence rentSeq;

select * from tblCustomer;
select * from tblSales;

select * from tblGenre;
select * from tblVideo;
select * from tblMember;
select * from tblRent;


/*
    조인, Join
    - (서로 관계를 맺고 있는) 2개(1개) 이상의 테이블을 1개의 결과 셋으로 만드는 기술
    
    조인의 종류
    1. 단순 조인, cross join (x)
    2. 내부 조인, inner join (***)
    3. 외부 조인, outer join (***)
    ========================================
    4. 셀프 조인, self join (셀프조인+내부조인) or (셀프조인+외부조인)
    5. 전체 외부 조인, full outer join
    
    1. 단순 조인, cross join, 카티션 곱, 데카르드 곱
    - 모든 조인의 기본 동작
    - A 테이블 x B 테이블
    - 쓸모없다. > 가치 있는 행과 가치 없는 행이 뒤섞여 있기 때문
    - 다량 더미 데이터(유효성 낮음)
    
    
*/

select * from tblCustomer;  --3명
select * from tblSales;     --9건

-- 1. 단순 조인, cross join
select * from tblCustomer cross join tblSales;  --ANSI-SQL(수업) > 이건 어떤 환경이든 사용 가능 > 왠만해선 이거 사용
select * from tblCustomer, tblSales;            --Oracle 전용 > 한정적으로 사용 가능



/*
    2. 내부 조인, inner join (***)
    - 단순 조인에서 유효한 레코드만 추출한 조인
    
    select 컬럼리스트 from 테이블A inner join 테이블 B on 테이블A.PK = 테이블B.FK;
    select
        컬럼리스트
    from 테이블A               --부모 테이블
        inner join 테이블 B    --자식 테이블
            on 테이블A.PK = 테이블B.FK;
*/
select * from tblCustomer inner join tblSales on tblCustomer.seq = tblSales.cseq;

-- ORA-00918: 열의 정의가 애매합니다 > seq가 tblCustomer건지 tblSales건지 알 수 없어서
select 
    tblCustomer.seq as 고객번호,
    tblSales.seq as 판매번호,
    name,
    tblCustomer.name
from tblCustomer 
    inner join tblSales 
        on tblCustomer.seq = tblSales.cseq;

-- 테이블 as 붙이기 > 가독성 > 오로지 사람을 위해
select 
    c.seq as 고객번호,
    s.seq as 판매번호,
    name,
    c.name
from tblCustomer c
    inner join tblSales s
        on c.seq = s.cseq;

-- 조인 vs 서브쿼리
-- 고객 테이블 + 판매 테이블
-- > 어떤 고객(c.name)이 어떤 물건(s.item)을 몇개(s.qty) 사갔습니까?

-- 조인
select
    c.name as 고객명,
    s.item as 제품명,
    s.qty as 수량
from tblCustomer c
    inner join tblSales s
        on c.seq = s.cseq;

-- 서브쿼리
-- 메인쿼리(자식) + 상관서브쿼리(부모)
select
    item, 
    qty,
    cseq,
    (select name from tblCustomer where seq = tblSales.cseq)
from tblSales;

-- 4개 테이블 조인
-- 1단계] 비디오 + 장르
select
    *
from tblGenre g
    inner join tblVideo v
        on g.seq = v.genre;

-- 2단계] 비디오 + 장르 + 대여
select
    *
from tblGenre g
    inner join tblVideo v
        on g.seq = v.genre
            inner join tblRent r
                on r.video = v.seq;
                
-- 3단계] 비디오 + 장르 + 대여 + 회원
select
    m.name as 누가,
    v.name as 무엇을,
    r.rentdate as 언제,
    g.price as 얼마
from tblGenre g
    inner join tblVideo v
        on g.seq = v.genre
            inner join tblRent r
                on r.video = v.seq
                    inner join tblMember m
                        on m.seq = r.member;

select * from employees;
select * from departments;
select * from locations;
select * from countries;
select * from regions;
select * from jobs;

select
    e.first_name || ' ' || e.last_name as 직원명,
    d.department_name as 부서명,
    l.city as 도시명,
    c.country_name as 국가명,
    r.region_name as 대륙명,
    j.job_title as 직업명
from employees e
    inner join departments d
        on d.department_id = e.department_id
            inner join locations l
                on l.location_id = d.location_id
                 inner join countries c
                    on c.country_id = l.country_id
                        inner join regions r
                            on r.region_id = c.region_id
                                inner join jobs j
                                    on j.job_id = e.job_id;


/*
    3. 외부 조인, outer join (***)
    - 내부 조인의 반대말(X)
    - 내부 조인 결과 + a(내부 조인에 포함되지 않은 부모 테이블의 나머지 레코드)
    
    select
            컬럼리스트
        from 테이블A
            (left | rigth) outer join 테이블B
                on 테이블A.PK = 테이블B.PK;
*/
insert into tblCustomer values (4, '호호호', '010-1234-5678', '서울시');
insert into tblCustomer values (5, '후후후', '010-1234-5678', '서울시');

select * from tblCustomer;  -- 5명
select * from tblSales;     -- 9건

-- 내부 조인    -- 9행
-- > 물건을 한번이라도 구매한 이력이 있는 고객의 정보와 구매내역을 가져오시오.
select * from tblCustomer c
    inner join tblSales s
        on c.seq = s.cseq;

-- 외부 조인(left: 부모 테이블)    -- 11행
-- > 물건을 한번이라도 구매한 이력이 있는 고객의 정보와 구매내역을 가져오시오.
-- > 물건을 한번도 구매 안 한 고객의 정보까지도 같이 가져오시오.
select * from tblCustomer c
    left outer join tblSales s
        on c.seq = s.cseq;

-- 외부 조인(right)    -- 9행
-- > 물건을 한번이라도 구매한 이력이 있는 고객의 정보와 구매내역을 가져오시오.
-- > 물건을 한번도 구매 안 한 고객의 정보까지도 같이 가져오시오.
select * from tblCustomer c
    right outer join tblSales s
        on c.seq = s.cseq;
        
select * from tblStaff;     -- 3명
select * from tblProject;   -- 6건

update tblProject set staff_seq = 4 where staff_seq = 3;

-- 내부 조인 > 프로젝트를 최소 1건 이상 담당하고 있는 직원 + 프로젝트 정보
select 
    *
from tblStaff s
    inner join tblProject p
        on s.seq = p.staff_seq;

-- 외부 조인 > 담당 프로젝트의 유뮤와 상관없이 모든 직원을 가져오시오. + 프로젝트가 있다면 가져오기
select 
    *
from tblStaff s
    left outer join tblProject p
        on s.seq = p.staff_seq;

-- 비디오 + 대여 > 대여가 한번이라도 발생했던 비디오 + 대여기록
select * from tblVideo v
    inner join tblRent r
        on v.seq = r.video;
        
-- 비디오 + 대여 > 대여내역과 상관없이 모든 비디오 + 대여 기록이 있다면 가져오기
select * from tblVideo v
    left outer join tblRent r
        on v.seq = r.video;
        
-- 회원 + 대여 > 대여를 최소 1회 이상했던 회원 + 대여 내역
select * from tblMember m
    inner join tblRent r
        on m.seq = r.member;
        
-- 회원 + 대여 > 대여와 무관하게 모든 회원 + 대여 내역 있으면 가져오기
select * from tblMember m
    left outer join tblRent r
        on m.seq = r.member
            where r.seq is null;    ---- 아직 한번도 대여하지 않은 회원 조건
            
-- 대여 기록이 있는 회원의 이름과 연락처?
select
    distinct m.name,
    m.tel 
from tblMember m
    left outer join tblRent r
        on m.seq = r.member
            where r.seq is null;
            
-- 대여 기록이 있는 회원의 이름과 연락처> + 대여 횟수? (서브쿼리)
select m.name, (select tel from tblMember where name = m.name), count(*) from tblMember m
    inner join tblRent r
        on m.seq = r.member
            group by m.name;
            
-- 대여 기록이 있는 회원의 이름과 연락처> + 대여 횟수? (group by tel 추가)            
select m.name, m.tel, count(*) from tblMember m
    inner join tblRent r
        on m.seq = r.member
            group by m.name, m.tel
             order by count(*);


/*
    4. 셀프 조인, self join
    - 1개의 테이블을 사용하는 조인
    - 테이블의 자기 스스로와 관계를 맺는 경우에 사용
*/
-- 직원 테이블
drop table tblSelf;
create table tblSelf(
    seq number primary key,                 -- 직원번호(PK)
    name varchar2(30) not null,             -- 직원명
    department varchar2(30) not null,        -- 부서명
    super number null references tblSelf    -- 상사번호(FK)
);
insert into tblSelf values(1, '홍사장', '사장실', null);
insert into tblSelf values(2, '김부장', '영업부', 1);
insert into tblSelf values(3, '박과장', '영업부', 2);
insert into tblSelf values(4, '최대리', '영업부', 3);
insert into tblSelf values(5, '정사원', '영업부', 4);
insert into tblSelf values(6, '이부장', '개발부', 1);
insert into tblSelf values(7, '하과장', '개발부', 6);
insert into tblSelf values(8, '신과장', '개발부', 6);
insert into tblSelf values(9, '황대리', '개발부', 7);
insert into tblSelf values(10, '허사원', '개발부', 9);

-- 직원 명단을 가져오시오. 단, 상사의 이름까지
-- 1. join
-- 2. sub query
-- 3. 계층형 쿼리(오라클 전용)

-- 1. join
select
    s2.name as 직원명,
    s2.department as 부서명,
    s1.name as 상사명
from tblSelf s1                 -- 역할: 부모테이블 > 상사
    inner join tblSelf s2       -- 역할: 자식테이블 > 직원
        on s1.seq = s2.super;

select
    s2.name as 직원명,
    s2.department as 부서명,
    s1.name as 상사명
from tblSelf s1                 -- 역할: 부모테이블 > 상사
    right outer join tblSelf s2 -- 역할: 자식테이블 > 직원
        on s1.seq = s2.super;

-- 2. sub query
select
    name as 직원명,
    department as 부서명,
    (select name from tblSelf s1 where seq = s2.super) as 상사명
from tblSelf s2;    -- 직원테이블



/*
    5. 전체 외부 조인, full outer join
    - 서로 참조하고 있는 관계에서 사용
*/

select * from tblMen;   -- 부모
select * from tblWomen; -- 자식

-- 커플인 남/녀를 가져오시오. 
select
    m.name as 남자,
    w.name as 여자
from tblMen m
    inner join tblWomen w
        on m.name = w.couple;
        
-- 커플인 남/녀를 가져오시오. + 솔로 남자 
select
    m.name as 남자,
    w.name as 여자
from tblMen m
    left outer join tblWomen w
        on m.name = w.couple;

-- 커플인 남/녀를 가져오시오. + 솔로 여자
select
    m.name as 남자,
    w.name as 여자
from tblMen m
    right outer join tblWomen w
        on m.name = w.couple;

-- 모든 커플 + 솔로 남자 + 솔로 여자
select
    m.name as 남자,
    w.name as 여자
from tblMen m
    full outer join tblWomen w
        on m.name = w.couple;

drop table tblStaff;
drop table tblProject;

create table tblStaff (
    seq number primary key,         
    name varchar2(30) not null,     
    salary number not null,         
    address varchar2(300) not null, 
    project varchar2(300)           
);

create table tblProject (
    seq number primary key,         
    project varchar2(100) not null, 
    staff_seq number null references tblStaff(seq) 
);

insert into tblStaff (seq, name, salary, address) values (1, '홍길동', 300, '서울시');
insert into tblStaff (seq, name, salary, address) values (2, '아무개', 250, '인천시');
insert into tblStaff (seq, name, salary, address) values (3, '하하하', 350, '부산시');

insert into tblProject (seq, project, staff_seq) values (1, '홍콩 수출', 1); 
insert into tblProject (seq, project, staff_seq) values (2, 'TV 광고', 2); 
insert into tblProject (seq, project, staff_seq) values (3, '매출 분석', 3); 
insert into tblProject (seq, project, staff_seq) values (4, '노조 협상', 1); 
insert into tblProject (seq, project, staff_seq) values (5, '대리점 분양', 2); 

insert into tblStaff (seq, name, salary, address) values (4, '호호호', 350, '부산시');
insert into tblStaff (seq, name, salary, address) values (5, '후후후', 350, '부산시');

insert into tblProject (seq, project, staff_seq) values (6, '재고 관리', null); 
insert into tblProject (seq, project, staff_seq) values (7, '가격 인상', null); 
insert into tblProject (seq, project, staff_seq) values (8, '신제품 개발', null); 

select * from tblStaff;
select * from tblProject;

select * from tblStaff s inner join tblProject p on s.seq = p.staff_seq;
select * from tblStaff s left outer join tblProject p on s.seq = p.staff_seq;
select * from tblStaff s right outer join tblProject p on s.seq = p.staff_seq;
select * from tblStaff s full outer join tblProject p on s.seq = p.staff_seq;