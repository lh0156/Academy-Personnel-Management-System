--B03

--교사 계정관리-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--1. 전체 교사 정보 조회 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------

create or replace procedure procMTeacherInfo
is
    cursor vcursor is
        select * from tblteacher;
    vrow tblteacher%rowtype;
begin 
    open vcursor;
    loop
        fetch vcursor into vrow;
        exit when vcursor%notfound;
        dbms_output.put_line('==============================================================================================');
        dbms_output.put_line('교사번호: ' || vrow.teacher_Seq || '  교사이름: ' || vrow.name || '  교사아이디: ' || vrow.id ||' 교사비밀번호: ' || vrow.jumin || '  교사전화번호: ' || vrow.tel || ' 가능과목: ' || vrow.possibleLecture);
        --Teacher_Seq, name, id, jumin, tel, possibleLecture, now, Subject_Seq, Manager_Seq
    end loop;
    close vcursor;
    dbms_output.put_line('==============================================================================================');
end;
--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMteacherinfo;
end;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 교사 계정 추가------------------------------------------------------------------------------------------------------------------------------------------------------------

create or replace procedure procMAddTeacher(
    pname varchar2,
    pid varchar2,
    pjumin number,
    ptel varchar2,
    ppossibleLecture varchar2,
    pnow varchar2,
    psubject_name varchar2,
    pmanager_seq number    
)
is
    vsubject_seq number;
begin
   select subject_Seq into vsubject_Seq from tblsubject where name = psubject_name;
    
    INSERT INTO tblTeacher(Teacher_Seq, name, id, jumin, tel, possibleLecture, now, Subject_Seq, Manager_Seq)
        Values ((select max(teacher_Seq) + 1 from tblteacher), pname, pid, pjumin, ptel, ppossibleLecture, pnow, vsubject_Seq, pmanager_seq);
        exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end procMAddteacher;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMAddteacher('추가', 'tttt22', 2231233, '010-5454-5663', '추가 가능과목','N', 'C', 1);
end;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--교사 계정 조회-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

create or replace procedure procMTeacherFind(
    pname varchar2
)
is
    vrow tblteacher%rowtype;
    vstate varchar2(30);
    vsubject_name varchar2(30);
begin 
    select * into vrow from tblteacher where name = pname;
    select name into vsubject_name from tblsubject where subject_seq = vrow.subject_seq;
    
    if
        vrow.now = 'Y' then vstate := '수강중';
        else vstate := '수강중 아님';
    end if;
    dbms_output.put_line('==============================================================================================');

    dbms_output.put_line('교사이름: ' ||vrow.name || '  아이디: ' || vrow.id || '  비밀번호: ' || vrow.jumin || '  전화번호: ' || vrow.tel || ' 강의가능과목: ' || vrow.possibleLecture || '  강의 상태: ' || vstate || '  추가과목: ' || vsubject_name || '  매니저번호: ' || vrow.manager_Seq);
    dbms_output.put_line('==============================================================================================');
exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMteacherFind('박세');
end;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--교사 계정 수정, 삭제 --------------------------------------------------------------------------------------------------------------------
-- id 수정 ---------------------------------------------------------------------------------------------------------------------------------

create or replace procedure procMUpdateteacherid(
    pnum number,
    pid varchar2   
)
is
begin
    update tblteacher set id = pid where teacher_seq = pnum;
    exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end procMUpdateteacherid;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMupdateteacherid(12, '수정');
end;
---------------------------------------------------------------------------------------------------------------------------------------------------
-- 2. 전화번호 수정------------------------------------------------------------------------------------------------------------------------------
create or replace procedure procMUpdateteachertel(
    pnum number,
    ptel varchar2   
)
is
begin
    update tblteacher set tel = ptel where teacher_seq = pnum;
    exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end procMUpdateteachertel;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMupdateteachertel(12, '010-1234-4567');
end;
---------------------------------------------------------------------------------------------------------------------------------------
-- 계정 삭제
create or replace procedure procMDeleteTeacher(
    pseq number
)
is
begin
    delete from tblteacher where teacher_Seq = pseq;
    exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end procMDeleteTeacher;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMDeleteTeacher(12);
end;
------------------------------------------------------------------------------------------------------------------------------------------------
--배정된 개설 과목명, 개설 과목 기간, 과정명, 개설과정기간, 교재명, 강의실, 강의 진행여부를 확인할 수 있어야 한다. 
create or replace view vwMLclass
as
select 
    ls.start_date as "개설시작날",
    ls.end_date as "개설끝날",
    s.name as "개설과목명",
    cl.name as "강의실",
    b.name as "교재명",
    t.name as "교사이름",
    t.now as "강의진행여부"
from tbllclass lc
    inner join tblclass c
        on lc.class_Seq = c.class_seq
            inner join tblclassroom cl
                on lc.classroom_seq = cl.classroom_seq
                    inner join tbllsubject ls
                        on ls.lclass_seq = lc.class_seq
                            inner join tblsubject s
                                on ls.subject_seq = s.subject_seq
                                    inner join tblbookname b
                                        on ls.bookname_seq = b.bookname_seq
                                            inner join tblteacher t 
                                                on ls.teacher_seq = t.teacher_seq;
select * from vwMLclass;
                                 select * from tbllsubject;    
                                 select * from tbllclass;
-- 선생님이 강의하고잇는 과정 정보
create or replace procedure procMTeacherClass(
    pname varchar2
)
is
    vrow vwMLclass%rowtype;
    cursor vcursor
        is select * from vwMLclass where 교사이름 = pname;
begin
    open vcursor;
    loop
        fetch vcursor into vrow;
        exit when vcursor%notfound;
    dbms_output.put_line('==============================================================================================');
    dbms_output.put_line('시작일: ' || vrow.개설시작날 || '  종료일: ' || vrow.개설끝날 || '  개설과목명: ' || vrow.개설과목명 || '  강의실: ' || vrow.강의실 || ' 교재명: ' || vrow.교재명 || '  교사이름: ' || vrow.교사이름 || ' 강의진행여부: ' || vrow.강의진행여부);
    end loop;
    close vcursor;
    dbms_output.put_line('==============================================================================================');
exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end procMTeacherClass;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMTeacherClass('박세인');
end;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

commit;
