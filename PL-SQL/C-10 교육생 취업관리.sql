-- C-10

create or replace procedure proctFindStudentWishJob(
    msname varchar2 := '',
    mwcity varchar2 := ''
)
is
    sname tblstudent.name%type;
    wbasicpay tblwishjob.basicpay%type;
    wcity tblwishjob.city%type;
    cursor vcursor 
is 
SELECT 
    s.name, 
    w.basicpay * 12, 
    w.city 
FROM tblWishJob w
    LEFT JOIN tblstudent s
        ON w.student_Seq = s.Student_Seq
WHERE 1=1
AND w.city like '%'||mwcity||'%'
AND s.name like '%'||msname||'%'
;    
begin
    open vcursor; 
         
        loop
            fetch vcursor into sname, wbasicpay, wcity;
            exit when vcursor%notfound;

            dbms_output.put_line('이름' || ':  ' || sname || ' 희망연봉' || ':  ' || wbasicpay || ' 희망 취업처' || ':  ' || wcity);
            
        end loop;
    close vcursor;
exception
    when others then
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');
end;



begin
    --proctFindStudentWishJob(학생이름, 희망 취업처);
    proctFindStudentWishJob('황현우','');
end;