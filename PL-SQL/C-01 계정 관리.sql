--PROCEDURE=====================================================================================================
-- <교사>
----C-01. 계정관리 
--==============================================================================================================


--[교사 본인 계정 조회] 
create or replace procedure ProTAccountSearch
( 
    pid in tblteacher.id%type,
    ppw in tblteacher.jumin%type
)
is
    vrow tblteacher%rowtype;
/*
    vteacher_seq tblteacher.teacher_seq%type;
    vname tblteacher.name%type;
    vid tblteacher.id%type;
    vjumin tblteacher.jumin%type;   
    vtel tblteacher.tel%type;
    vnow tblteacher.now%type;
    vsubject_seq tblteacher.subject_seq%type;
    vmanager_seq tblteacher.manager_seq%type;
    */
    cursor vcursor is
select * from tblteacher--teacher_seq, name, id, tel, now, subject_seq, manager_seq from tblTeacher 
    where teacher_seq = (select t.teacher_seq from tblteacher t where pid = t.id and ppw = t.jumin);
begin
    open vcursor;
        loop
            fetch vcursor into vrow;--vteacher_seq, vname, vid, vtel, vnow, vsubject_seq, vmanager_seq;
            exit when vcursor%notfound;
            dbms_output.put_line(' 교사번호: '|| vrow.teacher_seq || '  교사이름: ' || vrow.name || '  ID: ' || vrow.id || '  PW: '|| vrow.jumin||'  전화번호: '|| vrow.tel);
            dbms_output.put_line(' 과목: ' || vrow.possiblelecture ||'  현재강의여부: '|| vrow.now || '  과목: ' || vrow.subject_seq || '  담당매니저: ' || vrow.manager_seq);
            dbms_output.put_line('====================================================================================');              
        end loop; 
    close vcursor;
exception
    when others then
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');
end ProTAccountSearch;



--실행***************************************************************************
begin
    dbms_output.put_line('====================================================================================');              
    ProTAccountSearch('tpdls1990',1234927);
end;
--******************************************************************************


