--PROCEDURE=====================================================================================================
-- <관리자>
----B-15. 교육생 상담 조회  
--==============================================================================================================



--[교육생 상담 조회]-------------------------------------------------------------
select * from tblstudent;

--1. 전체 조회
create or replace procedure proMTotalcounselOutput
(
    pname varchar2 := '',
    ppurpose varchar2 := ''
)
is
    vname tblstudent.name%type;
    vpurpose tblcounsel.purpose%type;
    vtarget tblcounsel.target%type;
    vcounsel_date tblcounsel.counsel_date%type;
    
    cursor vcursor is
select
    st.name as "교육생명",
    c.purpose as "상담목적",
    c.target as "상담사",
    c.counsel_date as "신청날짜"
from tblStudent st
        inner join tblsugang sg
             on st.student_seq = sg.sugang_seq
                  inner join tblcounsel c
                       on sg.sugang_seq = c.sugang_seq
                            inner join tblmanager m
                                on m.manager_seq = st.manager_seq
       where st.name like '%'||pname||'%' 
       and c.purpose like '%'||ppurpose||'%' 
                           order by counsel_date desc;
begin 
    open vcursor;
        loop
            fetch vcursor into vname, vpurpose, vtarget, vcounsel_date;
            exit when vcursor%notfound;
            
            dbms_output.put_line(' '||'이름: ' || vname || '  목적: ' || vpurpose || '  상담사: ' || vtarget || '  상담날짜: ' || vcounsel_date);     
            dbms_output.put_line('====================================================================================');        
        end loop;
    close vcursor;
exception
    when others then
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');

end proMTotalcounselOutput;






-- 실행********************************************************************************
--1. 상담 조회
begin
    dbms_output.put_line('====================================================================================');        
    --proMTotalcounselOutput();         -- 전체조회
    proMTotalcounselOutput('이정현','');    -- 지정 이름 조회
    --proMTotalcounselOutput('','개인');         -- 지정 사유 조회
end;
--********************************************************************************

set serveroutput on;


