-- ### group by ###################################
-- 못 푼 문제 :
-- 틀린 문제: 2번, 3번
-- 이해 안 된 문제: 

-- 1. tblZoo. 종류(family)별 평균 다리의 갯수를 가져오시오.
select * from tblZoo;
select
    family,
    round(avg(leg))
from tblZoo
group by family;


-- 2. traffic_accident. 각 교통 수단 별(지하철, 철도, 항공기, 선박, 자동차) 발생한 총 교통 사고 발생 수, 총 사망자 수, 사건 당 평균 사망자 수를 가져오시오.
select * from traffic_accident;
select
    trans_type,
    sum(total_acct_num),
    sum(death_person_num),
    round(sum(total_acct_num) / sum(death_person_num))
from traffic_accident
-- where 이유?
where total_acct_num > o
group by trans_type;
    
-- 3. tblZoo. 체온이 변온인 종류 중 아가미 호흡과 폐 호흡을 하는 종들의 갯수를 가져오시오.
select * from tblZoo;
select
    count(case
        when breath = 'gill' then 1
    end) as 아가미,
    count(case
        when breath = 'lung' then 1
    end) as 폐
from tblZoo
group by thermo
having thermo = 'variable';

        
-- 4. tblZoo. 사이즈와 종류별로 그룹을 나누고 각 그룹의 갯수를 가져오시오.
select * from tblZoo;
select
    sizeof,
    family,
    count(*)
from tblZoo
group by sizeof, family;

-- 5. tblAddressBook. 관리자의 실수로 몇몇 사람들의 이메일 주소가 중복되었다. 중복된 이메일 주소만 가져오시오.
select * from tblAddressBook where email like 'take%';
select distinct email
from tblAddressBook
group by email
having count(email) >= 2;


-- 6. tblAddressBook. 성씨별 인원수가 100명 이상 되는 성씨들을 가져오시오.
select * from tbladdressbook;
select
    substr(name, 1, 1)
from tbladdressbook
group by substr(name, 1, 1)
having count(substr(name, 1, 1)) >= 100;



-- 7. tblAddressBook. '건물주'와 '건물주자제분'들의 거주지가 서울과 지방의 비율이 어떻게 되느냐?
select * from tblAddressBook;
select
    job,
    round(
        count(case when substr(address, 1, 2) = '서울' then 1 end) / count(job) * 100, 2
    ) || '%' as 서울비율,
    round(
        count(case when substr(address, 1, 2) <> '서울' then 1 end) / count(job) * 100, 2
    ) || '%' as 지방비율
from tblAddressBook
group by job
having job in ('건물주', '건물주자제분');