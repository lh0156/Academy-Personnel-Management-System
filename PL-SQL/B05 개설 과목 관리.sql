-- B05


--B5 개설 과목 관리
--특정 개설 과정 선택시 개설 과목 정보 출력 및 개설 과목 신규 등록을 할 수 있도록 한다.
--개설 과목 출력시 개설 과정 정보(과정명, 과정기간(시작 년월일, 끝 년월일), 강의실)와 과목명, 과목기간(시작 년월일, 끝년월일). 교재명, 교사명을 출력한다.
------------------------------- 개설 과목 출력시 -----------------------------------------------------------------------------
create or replace view vwMLsubject
as
select
    ls.lsubject_Seq vwSubject_Seq,
    c.name as classname,
    lc.startclassdate as classSD,
    lc.finishclassdate as ClassFD,
    cl.name as CRname,
    s.name as subjectName,
    ls.start_date as subjectSD,
    ls.end_date as subjectED,
    b.name as BookName,
    t.name as teacherName    
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
                                                on ls.teacher_seq = t.teacher_seq order by vwSubject_Seq;

create or replace procedure procMLSubjectInfo(
 pseq number
)
is
    vrow vwMlsubject%rowtype;
begin

    select * into vrow from vwMlsubject where vwsubject_seq = pseq;
    dbms_output.put_line('==============================================================================================');
    dbms_output.put_line('과정명: ' || vrow.classname || '  과정시작일: ' || vrow.classSD || '  과정종료일: ' || vrow.ClassFD || '  강의실: ' || vrow.CRname || '  과목명: ' || vrow.subjectName || '  과목시작일: ' || vrow.subjectSD || ' 과목종료일: ' || vrow.subjectED || '  교재명: ' || vrow.BookName || '  교사명: ' || vrow.teacherName);
    dbms_output.put_line('==============================================================================================');
exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end procMLSubjectInfo;
    
--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000              
begin
    procMLsubjectInfo(1);
end;

--교사 명단은 현재 과목과 강의 기능 과목이 일치하는 교사 명단만 보여야 한다.

--개설 과목 정보에 대한 입력, 출력, 수정 삭제 기능을 사용할 수 있어야 한다.

--------- 개설과목정보 수정-----------------------------------------------------------------------------
create or replace procedure procMFixLsubjectDate(
    pseq number,
    pSdate date,
    pEdate date
)
is
begin    
    update tbllsubject set Start_Date = pSdate, End_Date = pEdate where lsubject_Seq = pseq;
    exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMFixLsubjectdate(7,sysdate, sysdate);
end;
select * from tbllsubject;
-------------------------------------------------------------------------------------------------------------
--------- 개설과목정보 삭제-----------------------------------------------------------------------------
create or replace procedure procMDeleteLsubject(
    pseq number
)
is
begin    
    delete from tbllsubject where lsubject_Seq = pseq;
    exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end;

-------------------------------------------------------------------------------------------------------------
--------- 개설과목정보 출력-----------------------------------------------------------------------------
create or replace procedure procMLsubjectList
is
    vrow tbllsubject%rowtype;
    cursor vcursor
        is select * from tbllsubject;
    vsubjectname varchar2(30);
    vBookName varchar2(100);
    vteacherName varchar2(15);
    vclassname varchar2(100);
begin
    
    open vcursor;
    loop
         fetch vcursor into vrow;
         exit when vcursor%notfound;
         select name into vsubjectname from tblsubject where subject_Seq = vrow.subject_seq;
        select name into vBookname from tblbookname where bookname_Seq = vrow.bookname_Seq;
        select name into vteachername from tblteacher where teacher_seq = vrow.teacher_Seq;  
        select name into vclassname from tblclass c inner join tbllclass lc on lc.class_seq = c.class_seq where lc.lclass_seq = vrow.lclass_Seq;
        dbms_output.put_line('==============================================================================================');
        dbms_output.put_line('개설과목 번호: ' || vrow.lsubject_Seq || '  시작일: ' || vrow.start_date || '  종료일: ' || vrow.end_Date || '  과목명: ' || vsubjectname || '  교재명: ' || vbookname || '  교사명: ' || vteachername || '  과정명: ' || vclassname);
    
    end loop;
    close vcursor;
    dbms_output.put_line('==============================================================================================');
exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMLsubjectList;
end;

