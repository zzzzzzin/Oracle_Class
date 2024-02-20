-- ex27_hierarchical.sql

/*
    계층형 쿼리, Hierarchical Query
    - 오라클 전용 쿼리
    - 레코드의 관계가 서로간의 상하 수직 구조인 경우에 사용
    - 자기 참조를 하는 테이블에서 사용(셀프 조인)
    - 자바(= 트리구조)
    
    tblSelf
    홍사장
        - 김부장
            - 박과장
                - 최대리
                    - 정사원
        - 이부장
*/

drop table tblComputer;
create table tblComputer(
    seq number primary key,                         --식별자(PK)
    name varchar2(50) not null,                     --부품명
    qty number not null,                            --수량
    pseq number null references tblComputer(seq)    --부모부품(FK)
);

insert into tblComputer values (1, '컴퓨터', 1, null);

insert into tblComputer values (2, '본체', 1, 1);
insert into tblComputer values (3, '메인보드', 1, 2);
insert into tblComputer values (4, '그래픽카드', 1, 2);
insert into tblComputer values (5, '랜카드', 1, 2);
insert into tblComputer values (6, 'CPU', 1, 2);
insert into tblComputer values (7, '메모리', 2, 2);

insert into tblComputer values (8, '모니터', 1, 1);
insert into tblComputer values (9, '보호필름', 1, 8);
insert into tblComputer values (10, '모니터암', 1, 8);
insert into tblComputer values (14, '모니터클리너', 1, 8);

insert into tblComputer values (11, '프린터', 1, 1);
insert into tblComputer values (12, 'A4용지', 100, 11);
insert into tblComputer values (13, '잉크카트리지', 3, 11);

select * from tblcomputer;

-- 부품 가져오기 + 부모 부품의 정보
select
    c2.name as 부품명,
    c1.name as 부모부품명
from tblComputer c1             --부모부품 (부모테이블)
    inner join tblComputer c2   --부품 (자식테이블)    
        on c1.seq = c2.pseq;

-- 계층형 쿼리
-- 1. start with절 + connect by 절
-- 2. 계층형 쿼리에서만 사용 가능한 의사 컬럼들
--      a. prior: 자신과 연관된 부모 레코드를 참조하는 객체
--      b. level: 세대 수 or depth

-- prior: 부모 레코드 참조
-- connect_by_root: 최상위 레코드 참조
-- connect_by_isleaf: 말단 노드

select
    seq as 번호,
    lpad(' ', (level -1) * 5) || name as 부품명,
    prior name as 부모부품명,
    level
from tblComputer
    start with seq = 1                  --루트 레코드 지정
        connect by prior seq = pseq;    --현재 레코드와 부모 레코드를 연결하는 조건

select
    seq as 번호,
    lpad(' ', (level -1) * 5) || name as 부품명,
    prior name as 부모부품명,
    level
from tblComputer
    start with seq = 1                  
        connect by prior seq = pseq
            order siblings by name asc;    --siblings

select
    seq as 번호,
    lpad(' ', (level -1) * 5) || name as 부품명,
    prior name as 부모부품명,
    level
from tblComputer
    start with seq = (select seq from tblComputer where name = '컴퓨터')                   
        connect by prior seq = pseq
            order siblings by name asc;    

select
    seq as 번호,
    lpad(' ', (level -1) * 5) || name as 부품명,
    prior name as 부모부품명,
    level
from tblComputer
    start with pseq is null
        connect by prior seq = pseq
            order siblings by name asc;    

select
    seq as 번호,
    lpad(' ', (level -1) * 5) || name as 부품명,
    prior name as 부모부품명,       -- prior                : 부모 레코드 참조
    level,
    connect_by_root name,           -- connect_by_root name : 최상위 레코드 참조
    connect_by_isleaf,              -- connect_by_isleaf    : 말단 노드
    sys_connect_by_path(name, '→')  -- sys_connect_by_path  : 모니터클리너 > →컴퓨터→모니터→모니터클리너
from tblComputer
    start with pseq is null
        connect by prior seq = pseq
            order siblings by name asc;    

select
    lpad(' ', (level - 1) * 2) || name as 직원명
from tblSelf
    start with super is null
        connect by super = prior seq;