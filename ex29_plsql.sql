-- ex29_plsql.sql

/*
    PL/SQL
    - Oracle's Procedural Language extension to SQL
    - 기존의 ANSI-SQL + 절차 지향 언어 기능 추가(변수, 제어 흐름, 객체 정의 등)
    
    프로시저, Procedure
    - 메서드, 함수 등..
    - 순서가 있는 명령어들의 집합
    - 모든 PL/SQL 구문은 프로시저 내에서만 작성/동작이 가능
    - 프로시저 영역 <-> ANSI-SQL 영역
    
    1. 익명 프로시저
        - 1회용 코드 작성
    
    2. 실명 프로시저
        - 재사용
        - 저장
        - 데이터베이스 객체
        
    PL/SQL 프로시저 구조
    
    1. 4개의 블럭으로 구성
        - DECLARE
        - BEGIN
        - EXCEPTION
        - END
        
    2. DECALRE
        - 선언부
        - 프로시저 내에서 사용할 변수, 객체 등을 선언하는 영역
        - 생략 가능(변수가 필요없는 경우)
    
    3. BEGIN ~ END
        - 구현부
        - 구현된 코드를 가지는 영역(메서드의 body영역)
        - 생략 불가능
        - 구현된 코드? > ANSI-SQL + PL/SQL(연산, 제어 등)
    
    4. EXCEPTION
        - 예외처리부
        - catch 역할
        - BEGIN~END > try 역할
        - 생략 가능
    
    - PL/SQL 작성        
    [DECLARE
        변수 선언;
        객체 선언;]
    BEGIN
        업무 코드;
        업무 코드;
        업무 코드;
    [EXCEPTION
        예외처리 코드]
    END;
    
    ANSI-SQL <> PL/SQL        
    
    자료형 or 변수 or 제어흐름..
    
    PL/SQL 자료형
    - ANSI-SQL과 동일
    
    변수 선언하기
    - 변수명 자료형(길이) [not null] [default 값];
    
    PL/SQL 연산자
    - 대입 연산자
        - ANSE-SQL) update table set colunm = '값'
        - PL/SQL) 변수 := 값;
    - 나머지: ANSI-SQL과 동일
*/

-- 프로시저의 출력 내용을 보이도록 하는 기능
-- 현재 세션에서만 유효 > 로그인할 때마다 작성해야함
set serveroutput on;    
set serverout on;       

-- 익명 프로시저 선언
begin
    dbms_output.put_line('Hello World');
end;
/   -- '/'로 프로시저의 블럭 자동 지정 

begin
    dbms_output.put_line('Hello World');
end;
/

declare
    -- 변수명 자료형(길이) [not null] [default 값];
    num number;
    name varchar2(30);
    today date;
begin
    num := 10;
    dbms_output.put_line(num);
    
    name := '홍길동';
    dbms_output.put_line(name);
    
    today := sysdate;
    dbms_output.put_line(today);
end;
/

declare
    num1 number;
    num2 number;
    num3 number := 30;
    num4 number default 40;
    num5 number not null := 50; --declare 블럭에서 초기화를 해야 한다.
begin

    dbms_output.put_line('num1' || num1); --null
    
    num2 := 20;
    dbms_output.put_line(num2);
    
    num3 := null;
    dbms_output.put_line(num3);
    
    dbms_output.put_line(num4);
    
    --num5 := null;
    dbms_output.put_line(num5);

end;
/






/*

    변수 > 어떤 용도로 사용?
    - 일반적인 값을 저장하는 용도 > 비중 낮음
    - select 결과를 담는 용도 > 비중 높음
    
    select into 절(PL/SQL)

*/

declare
    vbuseo varchar2(15);
begin
    
    select buseo into vbuseo from tblInsa where name = '홍길동';
    
    dbms_output.put_line(vbuseo);
    
    --insert into tblTodo 
    --    values ((select max(seq) + 1 from tblTodo), '할일', sysdate, null);
    
end;
/










-- 성과급 받는 직원
drop table tblBonus;
create table tblBonus (
    name varchar2(15)
);

-- 1. 개발부 + 부장 > select > name ?
-- 2. tblBonus > name > insert

insert into tblBonus (name)
    values ((select name from tblInsa where buseo = '개발부' and jikwi = '부장'));
    
select * from tblBonus;

declare
    vname varchar2(15);
begin
    
    --1.
    select name into vname from tblInsa where buseo = '개발부' and jikwi = '부장';
    
    --2.
    insert into tblBonus (name) values (vname);
    
end;
/

select * from tblBonus;

desc tblInsa;

declare
    vname varchar2(15);
    vbuseo varchar2(15);
    vjikwi varchar2(15);
    vbasicpay number;
begin
    
    -- select into 절
    -- select name into vname, buseo into vbuseo
    --    , jikwi into vjikwi, basicpay into vbasicpay 
    --from tblInsa where num = 1001;

    -- into 사용 시
    -- 1. 컬럼의 개수와 변수의 개수 일치
    -- 2. 컬럼의 순서와 변수의 순서 일치
    -- 3. 컬럼과 변수의 자료형 일치
    select 
        name, buseo, jikwi, basicpay into vname, vbuseo, vjikwi, vbasicpay 
    from tblInsa where num = 1001;
    
    dbms_output.put_line(vname);
    dbms_output.put_line(vbuseo);
    dbms_output.put_line(vjikwi);
    dbms_output.put_line(vbasicpay);
    
end;
/








/*

    타입 참조
    
    %type
    - 사용하는 테이블의 특정 컬럼의 스키마를 알아내서 변수에 적용
    - 복사되는 정보
        a. 자료형
        b. 길이
        - 자료형, 길이 외의 제약사항과 같은 것은 복사 안 됨
    
    %rowtype
    - 행 전체 참조(여러 개의 컬럼을 참조)
*/
declare
    --vbuseo varchar2(15);
    vbuseo tblInsa.buseo%type;
begin
    select buseo into vbuseo from tblInsa where name = '홍길동';
    dbms_output.put_line(vbuseo);
end;
/

desc tblInsa;

declare
    vname       tblInsa.name%type;
    vbuseo      tblInsa.buseo%type;
    vjikwi      tblInsa.jikwi%type;
    vbasicpay   tblInsa.basicpay%type;
begin
    
    select 
        name, buseo, jikwi, basicpay
            into vname, vbuseo, vjikwi, vbasicpay
    from tblInsa where num = 1001;
    
    dbms_output.put_line(vname);
    dbms_output.put_line(vbuseo);
    dbms_output.put_line(vjikwi);
    dbms_output.put_line(vbasicpay);
    
end;
/

drop table tblBonus;

create table tblBonus (
    seq number primary key,
    num number(5) not null references tblInsa(num), --직원번호(FK)
    bonus number not null
);

-- 프로시저 선언하기
-- 1. 서울, 부장, 영업부
-- 2. tblBonus > 지급 > 보너스(급여 * 1.5)

declare
    vnum tblInsa.num%type;
    vbasicpay tblInsa.basicpay%type;
begin
    select 
        num, basicpay into vnum, vbasicpay
    from tblInsa
        where city =  '서울' and jikwi = '부장' and buseo = '영업부';
        
    insert into tblBonus(seq, num, bonus)
        values ((select nvl(max(seq), 0) + 1 from tblBonus), vnum, vbasicpay * 1.5);
    
end;
/

select * from tblBonus;

select * 
    from tblBonus b
        inner join tblInsa i
            on i.num = b.num;

select * from tblMen;
select * from tblWomen;
desc tblMen;
-- 무명씨 > 성전환 수술 > tblMen -> tblWomen 옮기기
-- 1. '무명씨' 찾기 > tblMen > select
-- 2. tblWomen > insert > 복사
-- 3. tblMen > delete > 원본지우기

declare
--    vname tblMen.name%type;
--    vage tblMen.age%type;
--    vheight tblMen.height%type;
--    vweight tblMen.weight%type;
--    vcouple tblMen.couple%type;
    vrow tblMen%rowtype;    --무조건 전부 다 가져오는 것만 가능    
begin
    -- 1. '무명씨' 찾기 > tblMen > select
--  select name, age, height, weight, couple into vrow from tblMen where name = '무명씨';
    select * into vrow from tblMen where name = '무명씨';
    
    dbms_output.put_line(vrow.name);
    dbms_output.put_line(vrow.age);
    
    --2. tblWomen > insert > 복사
    insert into tblWomen(name, age, height, weight, couple)
        values (vrow.name, vrow.age, vrow.height, vrow.weight, vrow.couple);
        
    --3. tblMen > delete > 원본지우기
    delete from tblMen where name = vrow.name;
        
        
end;
/
select * from tblMen;   -- 무명씨 제거
select * from tblWomen; -- 무명씨 추가

rollback;   --무명씨 성전환 수술 전으로 롤백


/*
    제어문
    1. 조건문
    2. 반복문
    3. 분기문
*/

declare
    vnum number := 10;
begin
    if vnum > 0 then
        dbms_output.put_line('양수');
    end if;
end;
/

declare
    vnum number := 10;
begin
    if vnum > 0 then
        dbms_output.put_line('양수');
    else
        dbms_output.put_line('양수 아님');
    end if;        
end;
/

declare
    vnum number := 10;
begin
    if vnum > 0 then
        dbms_output.put_line('양수');
    elsif vnum < 0 then
        dbms_output.put_line('음수');
    else
        dbms_output.put_line('0');
    end if;        
end;
/

-- tblInsa. 남자 직원/ 여자 직원 > 서로 다른 업무
declare
    vgender char(1);
begin
    -- 1. 성별 구분
    select substr(ssn, 8, 1) into vgender from tblInsa where num = 1049;
    
    -- 2. 성별로 다르게 업무 분담
    if vgender = '1' then
        dbms_output.put_line('남자 업무');
    elsif vgender = '2' then
        dbms_output.put_line('여자 업무');
    end if;
end;
/

-- 직원 1명 선택 > 보너스 지급
-- 차등 지금
-- a. 과장/부장 > basicpay *1.5
-- b. 사원/대리 > basicpay *2

delete from tblBonus;
declare
    vnum tblInsa.num%type;
    vbasicpay tblInsa.basicpay%type;
    vjikwi tblInsa.jikwi%type;
    vbonus number;
begin
    --1.
    select 
        num, basicpay, jikwi into vnum, vbasicpay, vjikwi
    from tblInsa where num = 1005;
        
    --1.5
    if vjikwi in ('과장', '부장') then
        vbonus := vbasicpay * 1.5;
    elsif vjikwi in ('사원', '대리') then
        vbonus := vbasicpay * 2;
    end if;
    
    --2.    
    insert into tblBonus(seq, num, bonus)
        values ((select nvl(max(seq), 0) + 1 from tblBonus), vnum, vbonus);
    
end;
/

select * from tblBonus b
    inner join tblInsa i
        on i.num = b.num;

/*
    case문
    - ANSI-SQL case와 동일
    - 자바: switch문, 다중 if문
*/

declare
    vcontinent tblCountry.continent%type;
    vresult varchar2(30);
begin

    select continent into vcontinent from tblCountry where name = '대한민국';
    
    case
        when vcontinent = 'AS' then vresult := '아시아';
        when vcontinent = 'EU' then vresult := '유럽';
        when vcontinent = 'AF' then vresult := '아프리카';
        else vresult := '기타';
    end case;
    
    dbms_output.put_line(vresult);
    
    case vcontinent
        when 'AS' then vresult := '아시아';
        when 'EU' then vresult := '유럽';
        when 'AF' then vresult := '아프리카';
        else vresult := '기타';
    end case;
    
    dbms_output.put_line(vresult);

end;
/


/*
    반복문
    
    1. loop 
        - 단순 반복
    
    2. for loop
        - loop 기반
        - 횟수 반복(자바 for)
    
    3. while loop
        - loop 기반
        - 조건 반복(자바 while)
*/

declare
    vnum number := 1;
begin
    loop
        dbms_output.put_line(vnum);
        vnum := vnum + 1;
        
        exit when vnum > 10;
    end loop;
end;
/

drop table tblLoop;
create table tblLoop(
    seq number primary key,
    data varchar2(100) not null
);

drop sequence seqLoop;
create sequence seqLoop;


-- date > '항목0001', '항목0002', ... ,'항목1000'

declare
    vnum number := 1;
begin
    loop
        insert into tblLoop(seq, data) 
            values (seqLoop.nextVal, '항목' || lpad(vnum, 4, '0'));
            
        vnum := vnum + 1;
        exit when vnum > 1000;
    end loop;
end;
/

select * from tblLoop;


/*
    2. for loop
*/

begin
    
    for i in 1..10 loop     -- i는 변수
        dbms_output.put_line(i);
    end loop;
end;
/


drop table tblgugudan;
create table tblGugudan (
    dan number not null,
    num number not null,
    result number not null,
    
    constraint tblgugudan_dan_num_pk primary key(dan, num) --복합키(Composite Key)
);

create table tblGugudan (
    dan number not null,
    num number not null,
    result number not null
);

alter table tblGugudan
    add constraint tblgugudan_dan_num_pk primary key(dan, num);

    
begin
    for dan in 2..9 loop
        for num in 1..9 loop
            insert into tblGugudan (dan, num, result)
                values (dan, num, dan * num);
        end loop;
    end loop;
end;
/

select * from tblGugudan;

begin
    for i in reverse 1..10 loop --reverse 10 > 1
        dbms_output.put_line(i);
    end loop;
end;
/

-- 3. while loop
declare
    vnum number := 1;
begin
    while vnum <= 10 loop
        dbms_output.put_line(vnum);
        vnum := vnum + 1;
    end loop;
end;
/







