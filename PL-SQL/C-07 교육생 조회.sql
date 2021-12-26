-- C-7

create or replace procedure proctFindStudentSpec(
    msname varchar2 := ''
)
is
    sname tblstudent.name%type;
    peducation tblstudentspec.education%type;
    pcertificate tblstudentspec.certificate%type;
    cursor vcursor 
is 
SELECT 
    s.name,
    p.Education,
    p.Certificate
    
FROM tblStudentSpec p                           
    LEFT JOIN tblStudent s                          
        ON p.student_Seq = s.student_Seq       
WHERE 1=1
AND s.name like '%'||msname||'%'
;    
begin
    open vcursor; 
         dbms_output.put_line('===================================================================================================================================');
        loop
            fetch vcursor into sname, peducation, pcertificate;
            exit when vcursor%notfound;     
            dbms_output.put_line('이름' || ':  ' || sname || ' 학력' || ':  ' || peducation || ' 보유자격증' || ':  ' || pcertificate);
        end loop;
    close vcursor;
exception
    when others then
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');
end;

begin
    --proctFindStudentSpec(학생이름);
    proctFindStudentSpec('황현우');
end;