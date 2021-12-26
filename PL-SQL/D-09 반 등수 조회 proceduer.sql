create or replace procedure procSRankOfClass(
    pId in tblstudent.id%type,
    pPw in tblstudent.ssn%type
) is
    prank varchar2(100);
cursor vcursor is select
    rownum||'등' as 등수
        from (select * from (select
            a.sugang_seq,
            floor(sum(b.score) / 4 * 0.8 / count(distinct c.attendence_date))  
            + (select (select count(distinct attendence_date) from tblattendence where sugang_seq = (select sugang_seq from tblsugang where student_seq = 
                (select student_seq from tblstudent stu where id = pId and substr(stu.ssn,7) = pPw)) and absence_type = '정상')/
                (select count(attendence_date) from tblattendence where sugang_seq = (select sugang_seq from tblsugang where student_seq = 
                (select student_seq from tblstudent stu where id = pId and substr(stu.ssn,7) = pPw))) * 20 from dual) as lastScore
                        from tblsugang a
                            inner join tbltestscore b on a.sugang_seq = b.sugang_seq
                            inner join tblattendence c on a.sugang_seq = c.sugang_seq
                                group by a.sugang_seq
                                   having a.sugang_seq between 1 and 6)
                                   order by lastScore)
                                        where sugang_seq = (select sugang_seq from tblsugang where student_seq = 
                                            (select student_seq from tblstudent stu where id = pId and substr(stu.ssn,7) = pPw));
                                
begin
    dbms_output.put_line('====================================================================================');
    
  open vcursor;
    loop
    fetch vcursor into prank;
    exit when vcursor%notfound;
    dbms_output.put_line('                    당신의 등수는 "' ||prank|| '" 입니다.');
    end loop;
    close vcursor;
    
    dbms_output.put_line('====================================================================================');
    exception
    when others then
        dbms_output.put_line('====================================================================================');
        dbms_output.put_line('ID, PASSWORD 오류입니다.');
        dbms_output.put_line('====================================================================================');
end;


begin
    procSRankOfClass('abc007', '1115158');
end;













create or replace view viewRank as
select rownum||'등' as 등수
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
