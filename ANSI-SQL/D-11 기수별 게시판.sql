-- 로그인한 학생이 참여해있는 과목(기수)의 기수 게시판
create or replace view viewgisuboard as
select * from tblgisuboard
    where sugang_seq between (select min(sugang_seq) from tblsugang
    where lclass_seq = (select lclass_seq from tblsugang
    where sugang_seq = (select student_seq from tblstudent stu
        where id = 'abc007' and substr(stu.ssn,7) = '1115158'))) and
                            (select max(sugang_seq) from tblsugang
    where lclass_seq = (select lclass_seq from tblsugang
    where sugang_seq = (select student_seq from tblstudent stu
        where id = 'abc007' and substr(stu.ssn,7) = '1115158')));

insert into tblgisuboard values ((select max(gisuboard_seq+1) from tblgisuboard),
'어제 상사랑 회식했는데 기억이 없습니다..',
sysdate,
(select sugang_seq from tblsugang
    where student_seq = (select student_seq from tblstudent stu
        where id = 'abc007' and substr(stu.ssn,7) = '1115158')));
        
        
-- 로그인한 학생이 참여하고 있는 학생들
select sugang_seq from tblsugang
    where lclass_seq = (select lclass_seq from tblsugang
    where sugang_seq = (select student_seq from tblstudent stu
        where id = 'abc007' and substr(stu.ssn,7) = '1115158'));