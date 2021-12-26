--PROCEDURE=====================================================================
-- <관리자>
--B-14. 교육생 팀 편성 조회
--==============================================================================

--[팀 편성 조회]-----------------------------------------------------------------

--------------------------------------------------------------------------------
-- 1. 팀 조회
create or replace procedure proMTotalTeamOutput
(
    pteam varchar2 := '',
    pname varchar2 := ''
)
is
    vclass_seq tbllclass.class_seq%type;
    vteam tblteam.team%type;
    vname tblstudent.name%type;
    cursor vcursor is 
select
    lc.class_seq as "과정번호",
    t.team as "팀",
    st.name as "교육생명"
from tblStudent st
    inner join tblsugang sg
        on sg.student_seq = st.student_seq
            inner join tblTeam t
                on t.sugang_seq = sg.sugang_seq
                    inner join tbllclass lc
                        on lc.lclass_seq = sg.lclass_seq
                   where t.team like '%'||pteam||'%' and st.name like '%'||pname||'%'
                        order by lc.class_seq;
begin
    open vcursor;
        loop
            fetch vcursor into vclass_seq, vteam, vname;
            exit when vcursor%notfound;         
            dbms_output.put_line( ' '||'과정번호: ' || vclass_seq || '  ' || '조: ' || vteam || '  교육생 이름:' || vname);
    dbms_output.put_line('====================================================================================');
            
        end loop;
    close vcursor;
exception
    when others then
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');
end proMTotalTeamOutput;







-- 2. 특정 강의 and 특정 팀 조회
create or replace procedure proMClassandTeamOutput
(
    pteam varchar2 := '',
    plecture varchar2 := ''
)
is
    cname tblclass.name%type;  
    vteam tblteam.team%type;
    vname tblstudent.name%type;
     cursor vcursor is 
select
    c.name as "과정이름",
    t.team as "팀",
    st.name as "교육생명"
from tblStudent st
    inner join tblsugang sg
        on sg.student_seq = st.student_seq
            inner join tblTeam t
                on t.sugang_seq = sg.sugang_seq
                    inner join tbllclass lc
                        on lc.lclass_seq = sg.lclass_seq
                            inner join tblclass c
                                on c.class_seq = lc.class_seq
                                    where t.team like '%'||pteam||'%' and c.name like '%'||plecture||'%'
            order by c.name, st.name;
begin
    open vcursor;
        loop
            fetch vcursor into cname, vteam, vname;
            exit when vcursor%notfound; 
            dbms_output.put_line( ' '||'과정이름: ' || cname || '  ' || vteam || '조: ' || vname);      
            dbms_output.put_line('====================================================================================');       
        end loop;
    close vcursor;
exception
    when others then
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');
end proMClassandTeamOutput;
                    



--****************************************************************************************************
--1. 전체 수강새의 팀 조회
begin
    dbms_output.put_line('====================================================================================');
    proMTotalTeamOutput(''); -- 전체 조회
    --proMTotalTeamOutput('','이정현'); -- 지정 조회(이름)
    --proMTotalTeamOutput('1'); -- 지정 조회(조번호)   
end;



-- 2. 특정 강의 and 특정 팀 조회
begin
    dbms_output.put_line('====================================================================================');
    --proMClassandTeamOutput('', ''); -- 전체 조회
    --proMClassandTeamOutput('1', ''); -- 지정 팀 조회(조번호)
    --proMClassandTeamOutput('', '임베디드'); -- 지정 강의 조회(강의이름)
    proMClassandTeamOutput('1', '임베디드'); -- 지정 강의+ 팀 조회(강의이름 + 조번호)        
end;

          