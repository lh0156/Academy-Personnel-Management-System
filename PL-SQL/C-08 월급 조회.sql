-- C-8


create or replace procedure proctFindSalary(
    pid tblteacher.id % type,
    ppw tblteacher.jumin % type,
    mstartmonth number := '',
    mendmonth number := ''
)
is
    tname tblTeacher.name%type;
    speriod tblsalary.period%type;
    ssalary tblsalary.salary%type;
    cursor vcursor
is 
SELECT 
    t.Name,
    s.Period,
    s.Salary
    
FROM tblsalary s
LEFT JOIN tblTeacher t
ON s.Teacher_Seq = t.Teacher_Seq

WHERE 1=1
AND s.Period BETWEEN mstartmonth AND mendmonth
AND t.teacher_seq = (select teacher_seq from tblteacher where pid = id and jumin = ppw)
;    
begin
    open vcursor; 
  dbms_output.put_line('===================================================================================================================================');
        loop
            fetch vcursor into tname, speriod, ssalary;
            exit when vcursor%notfound;
            
      
            dbms_output.put_line('이름' || ':  ' || tname || ' 월' || ':  ' || speriod || ' 월급' || ':  ' || ssalary);
        end loop;
    close vcursor;
exception
    when others then
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');
end;

begin
    --proctFindSalary(시작 월,종료 월);
    proctFindSalary('tpdls1990',1234927,'1','12');
end;