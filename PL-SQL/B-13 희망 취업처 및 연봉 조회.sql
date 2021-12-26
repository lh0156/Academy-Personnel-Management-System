--PROCEDURE=====================================================================
-- <관리자>
--B-13. 희망 취업처 및 연봉 조회
/*
예외발생
when others

    dbms_output.put_line('====================================================================================');
    dbms_output.put_line('                    ');

    dbms_output.put_line('                    ');
    dbms_output.put_line('====================================================================================');
*/
--==============================================================================
set serveroutput on;

--[학생들의 희망 취업처 및 희망 연봉 조회]-----------------------------------------
create or replace procedure proMWishjobOutput
(
    pstudent varchar2 := ''    
)
is
    vname tblstudent.name%type;
    vcity tblwishjob.city%type;
    vbasicpay tblwishjob.basicpay%type;
    vseq number := 0;
    
    cursor vcursor is 
select 
    s.name as "교육생명", 
    w.city as "희망 지역", 
    w.basicpay as "희망 연봉"
from tblwishjob w
    inner join tblStudent s
        on w.student_seq = s.student_seq
    where s.name like '%'||pstudent||'%';
begin
    open vcursor;
        loop
            vseq := vseq + 1;
            fetch vcursor into vname, vcity, vbasicpay;
            exit when vcursor%notfound;
            dbms_output.put_line( ' 번호:' ||to_char(vseq, '000') ||'  교육생이름: ' || vname || '  희망지역: ' || vcity || '  희망연봉: ' || vbasicpay);
            dbms_output.put_line('====================================================================================');       
        end loop;
    close vcursor;
exception
    when others then
    dbms_output.put_line('잘못된 입력');
    dbms_output.put_line('====================================================================================');
end proMWishjobOutput;


---------------------------------------

-- 2. 학생(상담내용 + 희망 취업처 + 희망 연봉) 조회 

create or replace procedure proMCounselWishjobOutput
(
    pstudent varchar2 := ''
)
is
    vname tblstudent.name%type;
    vpurpose tblcounsel.purpose%type;
    vtarget tblcounsel.target%type;
    vcounsel_date tblcounsel.counsel_date%type;
    vcity tblwishjob.city%type;
    vbasicpay tblwishjob.basicpay%type;
    vseq number := 0;

    cursor vcursor is 
select 
    st.name as "교육생명",
    c.purpose "상담목적",
    c.target "상담사",
    c.counsel_date "신청날짜",
    w.city as "취업희망지역",
    w.basicpay "희망연봉"
from tblcounsel c
    inner join tblsugang su
        on c.sugang_seq = su.sugang_seq
            inner join tblstudent st    
                on st.student_seq = su.student_seq
                    inner join tblwishjob w
                        on w.student_seq = st.student_seq   
        where st.name like '%'||pstudent||'%'
            order by c.counsel_date desc;
begin
    open vcursor;
        loop
            vseq := vseq + 1;
            fetch vcursor into vname, vpurpose, vtarget, vcounsel_date, vcity, vbasicpay;
            exit when vcursor%notfound;
            dbms_output.put_line
            ( ' 번호:'|| to_char(vseq, '0000') || '  교육생이름: ' || vname || '  상담목적: '|| vpurpose || '  상담사: ' || vtarget || '  상담날짜: ' || vcounsel_date || '  희망연봉: ' || vcity || '   ' || vbasicpay);     
            dbms_output.put_line('====================================================================================');
        end loop;
    close vcursor;
exception
    when others then
    dbms_output.put_line('잘못된 입력');
    dbms_output.put_line('====================================================================================');
end proMCounselWishjobOutput;








--실행***************************************************************************
--1. 학생(희망 취업처 + 희망 연봉)
begin
    dbms_output.put_line('====================================================================================');
    proMWishjobOutput();-- 전체 조회
    --proMWishjobOutput('이정현'); -- 지정 조회
end;


--2. 학생(상담 + 희망 취업처 + 희망 연봉) 
begin
    dbms_output.put_line('====================================================================================');
    --proMCounselWishjobOutput(); -- 전체 조회
    proMCounselWishjobOutput('이정현'); -- 지정 조회    
end;
--********************************************************************************

