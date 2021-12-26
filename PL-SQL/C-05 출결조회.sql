-- C-5


create or replace procedure proctFindStudentAttendence(
    pid tblteacher.id % type,
    ppw tblteacher.jumin % type,
    msname varchar2 := '',                                         
    mstartdate varchar2 := '0001-01-01',
    menddate varchar2 := '9999-12-31',                       
    mcname varchar2 := ''  
)
is
    aattendencedate tblattendence.attendence_date%type;
    cname tblclass.name%type;
    sname tblstudent.name%type;
    aabsencetype tblattendence.absence_type%type;
    cursor vcursor 
is 
SELECT 
    distinct a.attendence_date,   
    c.name,
    s.name,
    a.absence_type
FROM tblattendence a
    LEFT JOIN tblSugang g
        ON a.sugang_Seq = g.sugang_Seq
            LEFT JOIN tblStudent s
                ON g.student_Seq =  s.student_Seq
                    LEFT JOIN tblLClass l
                        ON l.LClass_Seq = g.LClass_seq
                            LEFT JOIN tblLsubject j
                                ON j.LClass_Seq = l.Lclass_Seq
                                    LEFT JOIN tblTeacher t
                                        ON t.Teacher_Seq = j.Teacher_Seq
                                            LEFT JOIN tblClass c
                                                ON c.Class_Seq = l.Class_Seq
                        
WHERE 1=1
AND s.name like '%'||msname||'%' 
AND a.attendence_date between to_date(mstartdate,'yyyy/mm/dd') AND to_date(menddate,'yyyy/mm/dd')
AND c.name like '%'||mcname||'%'
AND t.teacher_seq = (select teacher_seq from tblteacher where pid = id and jumin = ppw)
ORDER BY a.attendence_date asc
;    
begin
    open vcursor; 
      dbms_output.put_line('===================================================================================================================================');      
        loop
            fetch vcursor into aattendencedate, cname, sname, aabsencetype;
            exit when vcursor%notfound;     
            dbms_output.put_line('날짜' || ':  ' || aattendencedate || ' 교육과정' || ':  ' || cname || ' 이름' || ':  ' || sname || ' 근태' || ':  ' || aabsencetype);        

        end loop;
    close vcursor;
exception
    when others then
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');
end;

begin
    --proctFindStudentAttendence(이름, 시작날짜, 종료날짜, 교육과정);
    proctFindStudentAttendence('tpdls1990',1234927,'황현우','20210908','20211105','');
end;