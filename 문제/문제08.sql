-- ### join ###################################
--못 푼 문제: 24번, 26번
--틀린 문제: 4(where), 7번(join), 8번(where)
--이해x 문제: 8번(where)

-- 1. tblStaff, tblProject. 현재 재직중인 모든 직원의 이름, 주소, 월급, 담당프로젝트명을 가져오시오.
select
    s.name as 직원명,
    s.address as 직원주소,
    s.salary as 직원월급,
    p.project as 담당프로젝트명
from tblStaff s inner join tblProject p
    on s.seq = p.staff_seq;
    
-- 2. tblVideo, tblRent, tblMember. '뽀뽀할까요' 라는 비디오를 빌려간 회원의 이름은?
select 
    m.name as 회원명
from tblVideo v
    inner join tblRent r
        on v.seq = r.video
            inner join tblMember m
                on r.member = m.seq
where v.name = '뽀뽀할까요';

-- 3. tblStaff, tblProejct. 'TV 광고'을 담당한 직원의 월급은 얼마인가?
select * from tblStaff;
select * from tblProject;

select
--    s.name as 직원명,
    s.salary as 월급
from tblProject p
    inner join tblStaff s
        on p.staff_seq = s.seq
where p.project = 'TV 광고';

    
-- 4. tblVideo, tblRent, tblMember. '털미네이터' 비디오를 한번이라도 빌려갔던 회원들의 이름은?
select 
    m.name as 회원명,
    v.name as 비디오명
from tblMember m
    inner join tblRent r
        on m.seq = r.member
            inner join tblVideo v
                on r.video = v.seq
where v.name = '털미네이터';
-- 답지
-- where v.name = '털미네이터' and r.rentdate is not null;
                
-- 5. tblStaff, tblProject. 서울시에 사는 직원을 제외한 나머지 직원들의 이름, 월급, 담당프로젝트명을 가져오시오.
select * from tblStaff;
select
    s.name as 이름,
    s.salary as 월급,
    p.project as 담당프로젝트명
from tblStaff s
    inner join tblproject p
        on s.seq = p.staff_seq
where s.address <> '서울시';

    
-- 6. tblCustomer, tblSales. 상품을 2개(단일상품) 이상 구매한 회원의 연락처, 이름, 구매상품명, 수량을 가져오시오.
select * from tblcustomer;
select * from tblsales;
select
    c.name as 회원명,
    c.tel as 연락처,
    s.item as 구매상품평,
    s.qty as 수량
from tblcustomer c
    inner join tblsales s
        on c.seq = s.cseq
where s.qty >= 2;

                
-- 7. tblVideo, tblRent, tblGenre. 모든 비디오 제목, 보유수량, 대여가격을 가져오시오.
select
    v.name as 제목,
    v.qty as 보유수량,
    g.price as 대여가격
from tblvideo v
    inner join tblgenre g
        on v.genre = g.seq;

-- 8. tblVideo, tblRent, tblMember, tblGenre. 2007년 2월에 대여된 구매내역을 가져오시오. 회원명, 비디오명, 언제, 대여가격
select
    m.name as 회원명,
    v.name as 비디오명,
    r.rentdate as 언제,
    g.price as 대여가격
from tblRent r
    inner join tblmember m
        on r.member = m.seq
            inner join tblvideo v
                on r.video = v.seq
                    inner join tblgenre g
                        on v.genre = g.seq
where r.rentdate like '07/02%';
-- where r.rentdate >= to_date('2007-02-01', 'yyyy-mm-dd');

-- 9. tblVideo, tblRent, tblMember. 현재 반납을 안한 회원명과 비디오명, 대여날짜를 가져오시오.
select
    m.name as 회원명,
    v.name as 비디오명,
    r.rentdate as 대여날짜
from tblRent r
    inner join tblmember m
        on r.member = m.seq
            inner join tblvideo v
                on r.video = v.seq
where r.retdate is null;
    
-- 10. employees, departments. 사원들의 이름, 부서번호, 부서명을 가져오시오.
select 
    e.first_name || ' ' || e.last_name as 사원이름,
    d.department_id as 부서번호,
    d.department_name as 부서명
from employees e
    inner join departments d
        on e.department_id = d.department_id;
        
-- 11. employees, jobs. 사원들의 정보와 직업명을 가져오시오.
select 
    e.*,
    j.job_title as 직업명
from employees e
    inner join jobs j
        on e.job_id = j.job_id;
        
-- 12. employees, jobs. 직무(job_id)별 최고급여(max_salary) 받는 사원 정보를 가져오시오.
select * from jobs;
select 
    j.job_title,
    max(j.max_salary)
from employees e
    inner join jobs j
        on e.job_id = j.job_id
group by j.job_title;
    
-- 13. departments, locations. 모든 부서와 각 부서가 위치하고 있는 도시의 이름을 가져오시오.
select
    d.department_name,
    l.city
from departments d
    inner join locations l
        on d.location_id = l.location_id;
        
-- 14. locations, countries. location_id 가 2900인 도시가 속한 국가 이름을 가져오시오.
select
    c.country_name
from locations l
    inner join countries c
        on l.country_id = c.country_id
where l.location_id = 2900;
            
-- 15. employees. 급여를 12000 이상 받는 사원과 같은 부서에서 근무하는 사원들의 이름, 급여, 부서번호를 가져오시오.
select 
    distinct e.first_name || ' ' || e.last_name as 이름,
    e.salary as 급여,
    e.department_id as 부서번호    
from employees e
    inner join employees d
        on e.department_id = d.department_id
where d.salary >= 12000;
        
-- 16. employees, departments. locations.  'Seattle'에서(LOC) 근무하는 사원의 이름, 직위, 부서번호, 부서이름을 가져오시오.
select
    e.first_name || ' ' || e.last_name as 이름,
    e.job_id as 직위,
    e.department_id as 부서번호,
    d.department_name as 부서이름
from employees e
    inner join departments d
        on e.department_id = d.department_id
            inner join locations l
                on d.location_id = l.location_id
where l.city = 'Seattle';
    
-- 17. employees, departments. first_name이 'Jonathon'인 직원과 같은 부서에 근무하는 직원들 정보를 가져오시오.
select 
    e.*
from employees e
    inner join departments d
        on e.department_id = d.department_id
where d.department_id = (select department_id from employees where first_name = 'Jonathon');

    
-- 18. employees, departments. 사원이름과 그 사원이 속한 부서의 부서명, 그리고 월급을 출력하는데 월급이 3000이상인 사원을 가져오시오.
select 
    e.first_name || ' ' || e.last_name as 이름,
    d.department_name as 부서명,
    e.salary as 월급
from employees e
    inner join departments d
        on e.department_id = d.department_id
where e.salary >= 3000;
            
-- 19. employees, departments. 부서번호가 10번인 사원들의 부서번호, 부서이름, 사원이름, 월급을 가져오시오.
select 
    d.department_id as 부서번호,
    d.department_name as 부서명,
    e.first_name || ' ' || e.last_name as 이름,
    e.salary as 월급
from employees e
    inner join departments d
        on e.department_id = d.department_id
where d.department_id = 10;
            
            
-- 20. departments, job_history. 퇴사한 사원의 입사일, 퇴사일, 근무했던 부서 이름을 가져오시오.
select * from departments;
select * from job_history;
select
    j.start_date as 입사일,
    j.end_date as 퇴사일,
    d.department_name as 부서명
from departments d
    inner join job_history j
        on d.department_id = j.department_id;
        
-- 21. employees. 사원번호와 사원이름, 그리고 그 사원을 관리하는 관리자의 사원번호와 사원이름을 출력하되 각각의 컬럼명을 '사원번호', '사원이름', '관리자번호', '관리자이름'으로 하여 가져오시오.
select
    e.employee_id as 사원번호,
    e.first_name || ' ' || e.last_name as 사원이름,
    e.manager_id as 관리자번호,
    m.first_name || ' ' || m.last_name as 관리자이름
from employees e
    inner join employees m
        on e.manager_id = m.employee_id;
        
-- 22. employees, jobs. 직책(Job Title)이 Sales Manager인 사원들의 입사년도와 입사년도(hire_date)별 평균 급여를 가져오시오. 년도를 기준으로 오름차순 정렬.
select * from employees;
select * from jobs;
select
    19 || substr(e.hire_date, 1,2) as 입사년도,
    avg(e.salary) as 평균급여
from employees e
    inner join jobs j
        on e.job_id = j.job_id
where j.job_title = 'Sales Manager'
group by e.hire_date
order by substr(e.hire_date, 1,2);

-- 23. employees, departments. locations. 각 도시(city)에 있는 모든 부서 사원들의 평균급여가 가장 낮은 도시부터 도시명(city)과 평균연봉, 해당 도시의 사원수를 가져오시오.
--     단, 도시에 근 무하는 사원이 10명 이상인 곳은 제외하고 가져오시오.
select
    l.city, round(avg(e.salary)),count(*)
from employees e
    inner join departments d
        on e.department_id = d.department_id
            inner join locations l
                on d.location_id = l.location_id
group by l.city
having count(*) < 10
order by round(avg(e.salary));

-- 24. employees, jobs, job_history. ‘Public  Accountant’의 직책(job_title)으로 과거에 근무한 적이 있는 모든 사원의 사번과 이름을 가져오시오.
--     현재 ‘Public Accountant’의 직책(job_title)으로 근무하는 사원은 고려 하지 말것.


-- 25. employees, departments, locations. 커미션을 받는 모든 사람들의 first_name, last_name, 부서명, 지역 id, 도시명을 가져오시오.
select
    e.first_name,
    e.last_name,
    d.department_name,
    l.location_id,
    l.city
from employees e
    inner join departments d
        on e.department_id = d.department_id
            inner join locations l
                on d.location_id = l.location_id
where e.commission_pct is not null;
    
-- 26. employees. 자신의 매니저보다 먼저 고용된 사원들의 first_name, last_name, 고용일을 가져오시오.
select
    e.first_name,
    e.last_name,
    e.hire_date,
    m.e.employee_id
from employees e
    inner join employees m
        on e.manager_id = m.employee_id
where e.hire_date - m.hire_date < 0; 

