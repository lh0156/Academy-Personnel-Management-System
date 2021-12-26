/*
D-08 교육지원금 조회

업무영역
교육생

요구사항 명
D-09 교육생  예상 교육지원금 조회

개요
교육생이 해당 N차 단위기간의 교육지원금을 조회할 수 있다.


상세설명
교육생이 입력한 N차 단위기간을 기준으로 해당 단위 기간의 예상 지원금을 조회할 수 있다.


제약사항
본인의 예상 지원금만 확인할 수 있다.
단위기간을 지정해야 확인 가능하다.
교육 지원금은 출석률과 비례하여 산정된다.


-- input values: id, passWord, period
-- output values: name, period, subsidy
*/

select * from tblstudent;

create or replace view viewSubsidy as
select 
    st.name as 조회자이름,
    es.period||'차' as 단위기간,
    es.edu_subsidy_date*18000 as 교육지원금
from tblEdu_Subsidy es
    inner join tblsugang su on es.sugang_seq = su.sugang_seq
    inner join tblstudent st on su.student_seq = st.student_seq
    where su.sugang_seq = (select sugang_seq from tblsugang where student_seq = 
(select student_seq from tblstudent stu where id = 'abc007' and substr(stu.ssn,7) = '1115158')) and
          es.period = 1;
          





