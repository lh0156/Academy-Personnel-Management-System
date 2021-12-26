-- B01~B02

-- 회원 확인 > 로그인 > 1(로그인 성공), 0(로그인 실패)
select count(*) as cnt from tblmanager where id = 'ssangyong1' and password = '1024982';

create or replace procedure procMLogin(
    pid varchar2,
    ppassword varchar2
)
is
    vrow tblmanager%rowtype;
    cursor vcursor is
        select * into vrow from tblManager;
    vnum number;
begin
    vnum := 0;
    open vcursor;
        loop
            fetch vcursor into vrow;
            exit when vcursor%notfound;
            if vrow.id = pid and vrow.password = ppassword
                then vnum := vnum + 1;
            end if;
        end loop;
    close vcursor;
    
    if vnum = 1 then
        dbms_output.put_line('로그인 성공');
    else
        dbms_output.put_line('로그인 실패');
    end if;
    
end;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procTLogin('ssangyong1', '1024982');
end;
--기초 정보 출력
-- 기초 정보 열람 procedure ------------------------------------------------------------------------------------------------------------------------------------
create or replace procedure procMbasicinfo
is
    cname tblclass.name%type;
    sname tblsubject.name%type;
    clname tblclassroom.name%type;
    bname tblbookname.name%type;
    cursor vcursor is 
select
    c.name, s.name, cl.name, b.name as name
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
                                        on ls.bookname_seq = b.bookname_seq;    
begin
    open vcursor; 
        loop
            fetch vcursor into cname, sname, clname, bname;
            exit when vcursor%notfound;  
            dbms_output.put_line('==============================================================================================');
            dbms_output.put_line('과정이름: ' || cname || '  과목명: ' || sname || '  강의실명: ' || clname || '  과제명: ' || bname);        
            
        end loop;
    close vcursor;
        dbms_output.put_line('==============================================================================================');
end;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMbasicinfo;
end;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 기초 정보 입력, 수정, 삭제 -----------------------------------------------------------------------------------------------------------------------------------
-- class 추가 프로시저 ------------------------------------------------------------------------------------------------------------------------------------------
drop procedure procAddclass;
create or replace procedure procMAddclass(
    pname varchar2   
)
is
begin
    insert into tblClass (Class_Seq, name) values ((select max(class_Seq) + 1 from tblclass), pname);
    exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');       
end procMAddclass;
--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMAddclass('');
end;
select * from tblclass;
commit;
--------------------------------------------------------------------------------------------------------------------------------
-- update 프로시져----------------------------------------------------------------------------------------------------------
create or replace procedure procMUpdateclass(
    pnum number,
    pname varchar2   
)
is
begin
    update tblclass set name = pname where class_seq = pnum;
    exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');   
end procMUpdateclass;
commit;
--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
   procMUpdateclass(11, '');
end;
select * from tblclass;
rollback;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 삭제 프로시져----------------------------------------------------------------------------------------------------------------------------------------------------------
create or replace procedure procMDeleteclass(
    pnum number
)
is
begin
    delete from tblclass where class_Seq = pnum;
    exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end procMDeleteclass;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMdeleteclass(102);
end;
commit;
---------------------------------------------------------------------------------------------------------------------------------------------
--2. subject---------------------------------------------------------------------------------------------------------------------------------
-- subject 추가 프로시저 ------------------------------------------------------------------------------------------------------------------ss
create or replace procedure procMAddsubject(
    pname varchar2   
)
is
begin
    insert into tblsubject (subject_Seq, name) values ((select max(subject_Seq) + 1 from tblsubject), pname);
    exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end procMAddsubject;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMAddsubject('');
end;
--------------------------------------------------------------------------------------------------------------------------------
-- update 프로시져----------------------------------------------------------------------------------------------------------
create or replace procedure procMUpdatesubject(
    pnum number,
    pname varchar2   
)
is
begin
    update tblsubject set name = pname where subject_seq = pnum;
    exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end procMUpdatesubject;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMupdatesubject(33, '수정');
end;

----------------------------------------------------------------------------------------------------------------------------------------
-- 삭제 프로시져-----------------------------------------------------------------------------------------------------------------------
create or replace procedure procMDeletesubject(
    pnum number
)
is
begin
    delete from tblsubject where subject_Seq = pnum;
    exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end procMDeletesubject;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMdeletesubject(33);
end;
---------------------------------------------------------------------------------------------------------------------------------------------
-- classroom
create or replace procedure procMAddclassroom(
    pname varchar2,
    ptotalnum number
)
is
begin
    insert into tblclassroom (classroom_Seq, name, totalNum) values ((select max(classroom_Seq) + 1 from tblclassroom), pname, ptotalnum);
    exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end procMAddclassroom;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMAddclassroom('추가 강의실');
end;
--------------------------------------------------------------------------------------------------------------------------------
-- update 프로시져----------------------------------------------------------------------------------------------------------
create or replace procedure procMUpdateclassroom(
    pnum number,
    pname varchar2,
    ptotalnum number
)
is
begin
    update tblclassroom set name = pname, totalnum = ptotalnum where classroom_seq = pnum;
    exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end procMUpdateclassroom;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMupdateclassroom(6, '수정 강의실', 30);
end;
----------------------------------------------------------------------------------------------------------------------------------------
-- 삭제 프로시져-----------------------------------------------------------------------------------------------------------------------
create or replace procedure procMDeleteclassroom(
    pnum number
)
is
begin
    delete from tblclassroom where classroom_Seq = pnum;
    exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end procMDeleteclassroom;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMdeleteclassroom(6);
end;
--------------------------------------------------------------------------------------------------------------------------------------------------
-- bookname------------------------------------------------------------------------------------------------------------------------------

create or replace procedure procMAddBookName(
    pname varchar2,
    ppublisher varchar2
)
is
begin
    insert into tblBookName (bookname_seq, name, publisher) values ((select max(bookname_Seq) + 1 from tblbookname), pname, ppublisher);
exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end procMAddbookname;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMAddbookname('추가 책이름', '추가 책 출판사');
end;
--------------------------------------------------------------------------------------------------------------------------------
-- update 프로시져----------------------------------------------------------------------------------------------------------
create or replace procedure procMUpdatebookname(
    pnum number,
    pname varchar2,
    ppublisher varchar2
)
is
begin
    update tblbookname set name = pname, publisher = ppublisher where bookname_seq = pnum;
    exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end procMUpdatebookname;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMupdatebookname(131, '수정된 책이름', '수정출판사');
end;
----------------------------------------------------------------------------------------------------------------------------------------
-- 삭제 프로시져-----------------------------------------------------------------------------------------------------------------------
create or replace procedure procMDeletebookname(
    pnum number
)
is
begin
    delete from tblbookname where bookname_Seq = pnum;
    exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end procMDeletebookname;

begin
    procMdeletebookname(131);
end;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


