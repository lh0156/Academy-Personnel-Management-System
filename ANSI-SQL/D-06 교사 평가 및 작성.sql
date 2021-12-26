-- 교사 평가 조회(최종)
select * from tblassessment;

select
    a.contents,
    a.regdate
from tblsugang s
    inner join tblassessment a on a.sugang_seq = s.sugang_seq
            where a.teacher_seq = 
            (select distinct teacher_seq from tblassessment a inner join tblsugang s on a.sugang_seq = s.sugang_seq 
            where s.sugang_seq = (select sugang_seq from tblsugang where student_seq = (select student_seq from tblstudent stu 
            where id = 'abc007' and substr(stu.ssn,7) = '1115158'))) and
            
                a.regdate > (select student.attenddate from tblsugang sugang
                    inner join tblstudent student on sugang.student_seq = student.student_seq
                    where sugang.sugang_seq = (select sugang_seq from tblsugang 
                    where student_seq = (select sugang_seq from tblsugang 
                    where student_seq = (select student_seq from tblstudent stu 
                    where id = 'abc007' and substr(stu.ssn,7) = '1115158'))));

-- 교사 평가 추가
insert into tblassessment values((select max(assessment_seq)+1 from tblassessment),
'최고의 센세',
sysdate,
(select sugang_seq from tblsugang where student_seq = (select student_seq from tblstudent stu where id = 'abc007' and substr(stu.ssn,7) = '1115158')),
(select distinct teacher_seq from tblassessment a inner join tblsugang s on a.sugang_seq = s.sugang_seq where s.sugang_seq = 
(select sugang_seq from tblsugang where student_seq = 
(select student_seq from tblstudent stu where id = 'abc007' and substr(stu.ssn,7) = '1115158'))));