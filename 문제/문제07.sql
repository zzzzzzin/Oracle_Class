-- ### subquery ###################################
-- 못 푼 문제: 
-- 틀린 문제: 2번, 3번

-- 1. employees. 'Munich' 도시에 위치한 부서에 소속된 직원들 명단?
select * from employees;
select * from departments;
select * from locations;

-- department_id(employees) > department_id, location_id(departments) > location_id, city(locations)
select *
from employees e
where e.department_id = (select d.department_id from departments d where d.location_id = (select l.location_id from locations l where city = 'Munich'));

-- 2. tblMen. tblWomen. 서로 짝이 있는 사람 중 남자와 여자의 정보를 모두 가져오시오.
--    [남자]        [남자키]   [남자몸무게]     [여자]    [여자키]   [여자몸무게]
--    홍길동         180       70              장도연     177        65
--    아무개         175       null            이세영     163        null
--    ..
select * from tblMen;
select * from tblWomen;

select
    m.name as "[남자]",
    m.height as "[남자키]",
    m.weight as "[남자몸무게]",
    m.couple as "[여자]",
    (case
        when (select w.couple from tblWomen w where w.name = m.couple) = m.name then (select w.height from tblWomen w where w.name = m.couple)
    end) as "[여자키]",
    (case
        when (select w.couple from tblWomen w where w.name = m.couple) = m.name then (select w.weight from tblWomen w where w.name = m.couple)
    end) as "[여자몸무게]"
    -- 답지
    -- (SELECT height FROM tblwomen where tblmen.couple = name) as "[여자키]",
    -- (SELECT weight FROM tblwomen where tblmen.couple = name) as "[여자몸무게]" 
from tblMen m
-- 서로 짝이 있는 사람 중 > 미작성
where couple is not null;

-- 3. tblAddressBook. 가장 많은 사람들이 가지고 있는 직업은 주로 어느 지역 태생(hometown)인가?
select * from tblAddressBook;

-- 가장 많은 사람들이 가지고 있는 직업
select job from tblAddressBook group by job order by count(*) desc; --학생

-- 가장 많은 사람들이 가지고 있는 직업을 가진 사람들의 수
select max(count(*)) from tblAddressBook group by job;  --332

select distinct hometown from tblAddressBook where job
    = (select job from tblAddressBook group by job having count(*)
        = (select max(count(job)) from tblAddressBook group by job));

-- 4. tblAddressBook. 이메일 도메인들 중 평균 아이디 길이가 가장 긴 이메일 사이트의 도메인은 무엇인가?

--도메인 길이
select
    length(substr(email, instr(email, '@') + 1, instr(email, '.') - instr(email, '@') -1))
        as 도메인길이
from tblAddressBook;

-- group by 도메인길이
select
    substr(email, instr(email, '@') + 1, instr(email, '.') - instr(email, '@') -1),
    avg(length(substr(email, 1, instr(email, '@') -1 )))
from tblAddressBook
group by substr(email, instr(email, '@') + 1, instr(email, '.') - instr(email, '@') -1);

-- 5. tblAddressBook. 평균 나이가 가장 많은 출신(hometown)들이 가지고 있는 직업 중 가장 많은 직업은?
-- 5-1. 평균 나이가 가장 높은 출신
select max(round(avg(age))) from tbladdressbook group by hometown;
-- 5-3. 광주 출신 학생


-- 6. tblAddressBook. 남자 평균 나이보다 나이가 많은 서울 태생 + 직업을 가지고 있는 사람들을 가져오시오.


-- 7. tblAddressBook. gmail.com을 사용하는 사람들의 성별 > 세대별(10,20,30,40대) 인원수를 가져오시오.


-- 8. tblAddressBook. 가장 나이가 많으면서 가장 몸무게가 많이 나가는 사람과 같은 직업을 가지는 사람들을 가져오시오.


-- 9. tblAddressBook.  동명이인이 여러명 있습니다. 이 중 가장 인원수가 많은 동명이인의 명단을 가져오시오.(모든 이도윤)


-- 10. tblAddressBook. 가장 사람이 많은 직업의(332명) 세대별 비율을 구하시오.
--    [10대]       [20대]       [30대]       [40대]
--    8.7%        30.7%        28.3%        32.2%

