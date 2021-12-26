/*
반 등수 조회
*/

-- 학생의 개설 과정?
-- 학생의 출석일수 x 0.2를 한다
  -- 1. 수강 시퀀스 -> 출결 조인
  -- 2. 출석일자 * (20/* 총 출석일자)
-- 학생의 

-- 1번 학생이 듣고있는 개설 과정의 번호
delete from tbltestscore where testscore_seq = 7;
delete from tbltestscore where testscore_seq = 15;
delete from tbltestscore where testscore_seq = 45;
delete from tbltestscore where testscore_seq = 53;


select tl.lclass_seq from tblsugang su
    inner join tbllclass tl
        on su.lclass_seq = tl.lclass_seq
            where su.sugang_seq = 1;
            
-- 아이디 비밀번호를 넣었을 때 해당 학생의 개설 과정을 듣는 학생들
select su.sugang_seq from tblsugang su
    inner join tbllclass tl
        on su.lclass_seq = tl.lclass_seq
            where tl.lclass_seq = (select tl.lclass_seq from tblsugang su
                inner join tbllclass tl
                    on su.lclass_seq = tl.lclass_seq
                        where su.sugang_seq = (select student_seq from tblstudent stu
                            where id = 'abc007' and substr(stu.ssn,7) = '1115158'));
            
select * from tblattendence;
select * from tbledu_subsidy;

-- 반 등수 조회
-- 1~6 -> 조원들
            
select * from tblsugang su
    inner join tblattendence ad on su.sugang_seq = ad.sugang_seq
    inner join tbltestscore tc on su.sugang_seq = tc.sugang_seq
        where su.sugang_seq between 1 and 6;
    
내가 시험을 쳤어.
100점이 4개야
400점

100점 필기 * 0.4 = 40
100점 실기 * 0.4 = 40
    
200 / 2 * 0.4 = 0.4

-- 반 등수
시험성적(O) +

출석 내가 출석한 일자/총출능한 날짜x0석가.2(배점)

select
    a.sugang_seq,
    floor(sum(b.score) / 4 * 0.8 / count(distinct c.attendence_date))  
    + (select (select count(distinct attendence_date) from tblattendence where sugang_seq = 1 and absence_type = '정상')/
    (select count(attendence_date) from tblattendence where sugang_seq = (select student_seq from tblstudent stu
        where id = 'abc007' and substr(stu.ssn,7) = '1115158')) * 20 from dual) as 연산후점수
            from tblsugang a
                inner join tbltestscore b on a.sugang_seq = b.sugang_seq
                inner join tblattendence c on a.sugang_seq = c.sugang_seq
                    group by a.sugang_seq
                    having a.sugang_seq between 1 and 6;


select * from (select
    a.sugang_seq,
    floor(sum(b.score) / 4 * 0.8 / count(distinct c.attendence_date))  
    + (select (select count(distinct attendence_date) from tblattendence where sugang_seq = 1 and absence_type = '정상')/
    (select count(attendence_date) from tblattendence where sugang_seq = (select student_seq from tblstudent stu
        where id = 'abc007' and substr(stu.ssn,7) = '1115158')) * 20 from dual) as lastScore
            from tblsugang a
                inner join tbltestscore b on a.sugang_seq = b.sugang_seq
                inner join tblattendence c on a.sugang_seq = c.sugang_seq
                    group by a.sugang_seq
                    having a.sugang_seq between 1 and 6)
                        order by lastScore;

create or replace view viewRank as
select sugang_seq as 수강번호
    , rownum||'등' as 등수
from (select * from (select
    a.sugang_seq,
    floor(sum(b.score) / 4 * 0.8 / count(distinct c.attendence_date))  
    + (select (select count(distinct attendence_date) from tblattendence where sugang_seq = 1 and absence_type = '정상')/
        (select count(attendence_date) from tblattendence where sugang_seq = 1) * 20 from dual) as lastScore
                from tblsugang a
                    inner join tbltestscore b on a.sugang_seq = b.sugang_seq
                    inner join tblattendence c on a.sugang_seq = c.sugang_seq
                        group by a.sugang_seq
                           having a.sugang_seq between 1 and 6)
                           order by lastScore)
                                where sugang_seq = 1;

select * from viewRank;



-- max 출석일 * 연산

select (select count(distinct attendence_date) from tblattendence where sugang_seq = 1 and absence_type = '정상')/
(select count(attendence_date) from tblattendence where sugang_seq = 1) * 20
from dual;

-- 내가 출석한 날짜
select count(distinct attendence_date) from tblattendence where sugang_seq = 1 and absence_type = '정상';

-- 내가 출석 가능한 max일자
select count(attendence_date) from tblattendence where sugang_seq = 1;

55/59*0.2

select * from tblattendence;


    
    
select * from tbledu_subsidy where sugang_seq between 1 and 6;
delete from tbledu_subsidy where edu_subsidy_seq = 10;
delete from tbledu_subsidy where edu_subsidy_seq = 79;
delete from tbledu_subsidy where edu_subsidy_seq = 80;
delete from tbledu_subsidy where edu_subsidy_seq = 88;
