
select * from tblcovids 
 where sugang_seq = (select sugang_seq from tblsugang where student_seq = 
 (select student_seq from tblstudent stu where id = 'abc007' and substr(stu.ssn,7) = '1115158'))
    and attendance between sysdate and sysdate+7;
    
    
update tblcovids set facetoface = 'Y' where sugang_seq = (select sugang_seq from tblsugang where student_seq = 
 (select student_seq from tblstudent stu where id = 'abc007' and substr(stu.ssn,7) = '1115158')) and attendance = '21/12/03';