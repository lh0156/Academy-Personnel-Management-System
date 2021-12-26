--B06

--B06
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--교육생 정보 입력시 교육생 이름, 주민번호 뒷자리, 전화번호를 기본으로 등록하고, 주민번호 뒷자리는 교육생 본인이 로그인 시 패스워드로 사용된다. 등록일은 자동으로 입력되도록 한다.
create or REPLACE procedure procMAddstudentInfo(
    pname varchar2,
    pid varchar2,
    pssn varchar2,
    ptel varchar2,
    pmanager_Seq number
)
is
    vnum number;
begin
    INSERT INTO TBLSTUDENT (STUDENT_SEQ, NAME, ID, SSN, TEL, ATTENDDATE, MANAGER_SEQ) 
    VALUES ((select max(student_seq) + 1 from tblstudent), pname, pid, pssn, ptel, sysdate, pmanager_seq);
    exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end procMAddstudentInfo;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMAddstudentInfo('추가임','zsg808','6902211773839','010-4277-5565',1);
end;
select * from tblstudent;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--교육생 정보 출력시 교육생 이름, 주민번호 뒷자리,전화번호, 등록일을 출력한다.
create or replace procedure procMStudentInfo
is
    vrow tblstudent%rowtype;
 cursor vcursor is
        select * from tblstudent;
    vpassword varchar2(8);
begin
    open vcursor;
    loop
        fetch vcursor into vrow;
        exit when vcursor%notfound;
        vpassword := substr(vrow.ssn, 7);
        dbms_output.put_line('==============================================================================================');
        dbms_output.put_line('학생 번호: ' || vrow.student_Seq || '  학생이름: ' || vrow.name || '  비밀번호: ' || vpassword || '  전화번호: ' || vrow.tel || '  등록일: ' || vrow.attenddate);
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
    procMStudentInfo;
end;

commit;
--특정 교육생 선택시 교육생이 수강신청한 또는 수강중인, 수강했던 개설 과정 정보(과정명, 과정기간(시작 년월일, 끝 년월일), 강의실, 수료 및 중도탈락 여부, 수료 및 중도탈락 날짜) 를 출력한다.

create or replace VIEW vwMStudentInfo
as
select
    st.name as stname,
    c.name as classname,
    lc.startclassdate as classSD,
    lc.finishclassdate as classFD,
    cl.name as CRName,
    ss.whether as SugangState,
    ss.sugangstate_Date as OutDate
from tblstudent st
    inner join tblsugang su
        on st.student_seq = su.student_seq
            inner join tbllclass lc
                on lc.class_seq = su.lclass_seq
                    inner join tblclass c
                        on lc.class_Seq = c.class_seq
                            inner join tblclassroom cl
                                on lc.classroom_Seq = cl.classroom_seq
                                    inner join tblsugangstate ss
                                        on ss.sugang_seq = su.sugang_seq;
                                           
commit;
--교육생 정보를 쉽게 확인하기 위한 검색 기능을 사용할 수 있어야 한다.

create or replace procedure procMFindStudent(
    pname varchar2
)
is
    vrow vwMStudentinfo%rowtype;
    vstate varchar2(10);
begin

    select * into vrow from vwMStudentInfo where STname = pname;
    if vrow.outdate is null then vstate := '수강중';
    else vstate := '중도포기';
    end if;
    dbms_output.put_line('==============================================================================================');
    dbms_output.put_line('학생이름: ' || vrow.stname || '  과정이름: ' || vrow.classname || '  시작일: ' || vrow.classSD || '  종료일: ' || vrow.classFD || '  강의실: ' || vrow.CRName || '  수강상태: ' || vrow.SugangState || '  중도포기: ' || vstate);
    dbms_output.put_line('==============================================================================================');
exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end procMFindStudent;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000s
begin
    procMfindStudent('윤한빈');
end;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 교육생에 대한 수료 및 중도 탈락 처리를 할 수 있어야 한다. 수료 또는 중도탈락 날짜를 입력할 수 있어야 한다.
--중도탈락처리
create or replace procedure procMOutDate(
    pname varchar2,
    pdate date
)
is
begin
    update tblsugangstate set sugangstate_date = pdate where sugang_seq = (select tblstudent.student_seq from tblstudent inner join tblsugang on tblsugang.student_seq = tblstudent.student_seq where name = pname);

exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMOutDate('이한형', sysdate);
end;
