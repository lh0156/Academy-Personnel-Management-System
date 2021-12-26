--PROCEDURE=====================================================================================================
-- <교사>
----C-02. 강의 스케줄 조회 
--==============================================================================================================

-- [본인의 강의 스케줄 확인]-------------------------------------------------------
-- 1. 강의과정 스케줄 조회(교수 : 강의 = 1 : N)


create or replace procedure proTClassSearch
(
    pteacher_seq tblteacher.teacher_seq%type
    
)
is
    tname tblteacher.name%type;
    cname tblclass.name%type;
    vstartclassdate tbllclass.startclassdate%type;
    vfinishclassdate tbllclass.finishclassdate%type;
    crname tblclassroom.name%type;  
 
    vtotal tblsugang.lclass_seq%type;--- 총 등록 인원수
    lcstate varchar2(30); -- 강의 진행 상태
    
    vtotalnum number;
    
    cursor vcursor is
select 
    distinct t.name as "교사명", 
    c.name as "과정명", 
    lc.startclassdate as "개강", 
    lc.finishclassdate as "종강", 
    cr.name "강의실",
 (select 
    count(distinct(student_seq)) 
from tblteacher t inner join tbllsubject ls on t.teacher_seq = ls.teacher_seq
                  inner join tbllclass lc on lc.lclass_seq = ls.lclass_seq
                  inner join tblsugang su on su.lclass_seq = lc.lclass_seq
    where t.teacher_seq =pteacher_seq) as "등록인원수",
    case
        when lc.startclassdate <= sysdate and lc.finishclassdate >= sysdate then '진행중'
        when lc.startclassdate > sysdate then '예정'
        when lc.startclassdate < sysdate then '종료'
    end as "강의진행상태"
from tblclass c
    inner join tbllclass lc
        on c.class_seq = lc.class_seq
            inner join tbllsubject ls
                on ls.lclass_seq = lc.class_seq
                    inner join tblteacher t
                        on t.teacher_seq = ls.teacher_seq
                            inner join tblclassroom cr
                                on cr.classroom_seq = lc.classroom_seq                                    
                 where ls.teacher_seq = pteacher_seq
                    order by "개강" asc;
begin 
    open vcursor;
        loop
            fetch vcursor into tname, cname, vstartclassdate, vfinishclassdate, crname, vtotal, lcstate;
            exit when vcursor%notfound;           
            dbms_output.put_line(' '|| '교사이름: ' ||tname|| '  과정명: ' || cname);     
            dbms_output.put_line(' 개강: ' || vstartclassdate|| '  종강: ' || vfinishclassdate || ' 강의실명: ' || crname|| '  상태: ' || lcstate);
            dbms_output.put_line('====================================================================================');                
        end loop;
    close vcursor;
exception
    when others then
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');
end proTClassSearch;


--*********************************************************************
begin
    dbms_output.put_line('====================================================================================');        
    proTClassSearch(5); 
end;
--*********************************************************************




-- 2. 과정별 과목 스케줄(강의명 겹치지 X)

create or replace procedure proTEachClassSearch
(
    pid  in tblteacher.id%type,
    ppw  in tblteacher.jumin%type
)
is
    cname tblclass.name%type;
    sname tblsubject.name%type;
    snum tblsubject.subject_seq%type;
    lsstart tbllsubject.start_date%type;
    lsend tbllsubject.end_date%type;
    bbookname tblbookname.name%type;
    crname tblclassroom.name%type;
    --vstate tbllsubject.start_date%type; -- 강의 진행 상태
    vstate varchar2(30);
    cursor vcursor is

select
    c.name as "과정명",
    sb.name as "과목명",
    sb.subject_seq as "과목번호",
    ls.start_date as "과목시작날짜",
    ls.end_date as "과목종료날짜",
    b.name as "교재명",
    cr.name "강의실",
    case
        when ls.start_date <= sysdate and ls.end_date >= sysdate then '진행중'
        when ls.start_date > sysdate then '예정'
        when ls.start_date < sysdate then '종료'
    end as "강의진행상태"
    
from tbllsubject ls
    inner join tbllclass lc
        on lc.lclass_seq = ls.lclass_seq
            inner join tblsubject sb
                on sb.subject_seq = ls.subject_seq
                    inner join tblclass c
                        on c.class_seq = lc.class_seq
                            inner join tblbookname b
                                on b.bookname_seq = ls.bookname_seq
                                    inner join tblclassroom cr
                                        on cr.classroom_seq = lc.classroom_seq
                                             inner join tblteacher t
                                                on t.teacher_seq = ls.teacher_seq
                         where t.teacher_seq = (select teacher_seq from tblteacher t where pid = t.id and ppw = t.jumin)

                                            order by ls.start_date asc;
begin
    open vcursor;
        loop
            fetch vcursor into cname, sname, snum, lsstart, lsend, bbookname, crname, vstate;
            exit when vcursor%notfound;
            dbms_output.put_line(' ' || '과정명: ' || cname);
            dbms_output.put_line(' 과목명: ' || sname || '과목번호' || snum || '  과목시작: ' || lsstart || '  과목종료: ' || lsend );
            dbms_output.put_line(' 교재명: ' ||bbookname|| '  강의실:' ||crname || '  상태:' ||vstate);
            dbms_output.put_line('====================================================================================');    
        end loop;
    close vcursor;
exception
    when others then
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');

end proTEachClassSearch;



--*********************************************************************
begin
    dbms_output.put_line('====================================================================================');    
    proTEachClassSearch('tpdls1990', 1234927);
end;
--************************************************************************************



-- [교육생 강의 정보 확인]-------------------------------------------------------------------------------


-- 1. 전체 출력
create or replace procedure proTTotalStudentClassInfo(
    pid  in tblteacher.id%type,
    ppw  in tblteacher.jumin%type
)
is
    vsubject_seq tblsubject.subject_seq%type;
    vname tblstudent.name%type;
    vtel tblstudent.tel%type;
    venroll tblstudent.attenddate%type;
    lcstate varchar2(30);
    cursor vcursor is
select
    distinct
    c.class_seq as "과정번호",
    st.name as "교육생명",
    st.tel as "전화번호",
    st.attenddate as "수강등록일",
    case
        when lc.startclassdate <= sysdate and lc.finishclassdate >= sysdate and sgs.whether = 'N' then '진행중'
        when sgs.whether = 'Y' then '중도탈락'
        when lc.finishclassdate < sysdate and sgs.whether = 'N' then '수료'
        when lc.startclassdate > sysdate then '진행예정' 
    end as "강의진행상태"
from tblsugang sg
    inner join tblstudent st
        on st.student_seq = sg.student_seq
            inner join tbllclass lc
                on lc.lclass_seq = sg.lclass_seq
                    inner join tblclass c
                        on c.class_seq = lc.class_seq
                            inner join tblsugangstate sgs
                                on sgs.sugang_seq = sg.sugang_seq   
                                    inner join tbllsubject ls
                                        on ls.lclass_seq = lc.lclass_seq
                                            inner join tblteacher t
                                                 on t.teacher_seq = ls.teacher_seq
                            where t.teacher_seq = (select teacher_seq from tblteacher where pid = id and jumin = ppw)
                                    order by attenddate asc;

begin
    open vcursor;
        loop
            fetch vcursor into vsubject_seq, vname , vtel, venroll, lcstate;
            exit when vcursor%notfound;
            dbms_output.put_line(' 과목번호: ' || vsubject_seq || '  이름: '|| vname || '  전화번호: ' || vtel || '  등록일: ' || venroll || '  수강상태: ' || lcstate );
            dbms_output.put_line('====================================================================================');    

        end loop;
    close vcursor;
exception
    when others then
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');

end proTTotalStudentClassInfo;


--****************************************************
begin
    proTTotalStudentClassInfo('tpdls1990',1234927);    
end;
--****************************************************

set serveroutput on;




-- 2. 교육생 정보 = 과정번호 + 강의 진행중 + 지정 교사

create or replace procedure proTEachStudentINGSearch(
    pcseq in tblclass.class_seq%type,
    pid  in tblteacher.id % type,
    ppw  in tblteacher.jumin % type
)
is
    vcalss_seq tbllclass.class_seq%type;
    vname tblstudent.name%type;
    vtel tblstudent.tel%type;
    venroll tblstudent.attenddate%type;
    lcstate varchar2(30);
    cursor vcursor is
select
    distinct
    c.class_seq as "과정번호",
    st.name as "교육생명",
    st.tel as "전화번호",
    st.attenddate as "등록일",
    case
        when lc.startclassdate <= sysdate and lc.finishclassdate >= sysdate and sgs.whether = 'N' then '진행중'
        when sgs.whether = 'Y' then '중도탈락'
        when lc.finishclassdate < sysdate and sgs.whether = 'N' then '수료'
        when lc.startclassdate > sysdate then '진행예정'
    end as "진행상태"
from tblsugang sg
    inner join tblstudent st
        on st.student_seq = sg.student_seq
            inner join tbllclass lc
                on lc.lclass_seq = sg.lclass_seq
                    inner join tblclass c
                        on c.class_seq = lc.class_seq
                            inner join tblsugangstate sgs
                                on sgs.sugang_seq = sg.sugang_seq
                                    inner join tbllsubject ls
                                        on ls.lclass_seq = lc.lclass_seq
                                            inner join tblteacher t
                                                on t.teacher_seq = ls.teacher_seq
            
        where c.class_seq = pcseq -- 과정번호 
            and lc.startclassdate <= sysdate 
            and lc.finishclassdate >= sysdate
            and ls.teacher_seq = (select teacher_seq from tblteacher where id = pid and jumin = ppw) -- 선생님 
              order by attenddate asc;
begin
    open vcursor;
        loop
            fetch vcursor into vcalss_seq , vname , vtel, venroll, lcstate;
            exit when vcursor%notfound;
            dbms_output.put_line('====================================================================================');    
            dbms_output.put_line(' 과정번호: ' || vcalss_seq || '  교육생 이름: ' || vname || '  전화번호: '  || vtel || '  등록일: ' || venroll || ' 수강상태:' || lcstate);
        end loop;
    close vcursor;
exception
    when others then
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');

end proTEachStudentINGSearch;

--****************************************************
begin
    proTEachStudentINGSearch( 101, 'tpdls1990', 1234927);
    dbms_output.put_line('====================================================================================');    
end;
--****************************************************




--3. 특정과목을 과목번호로 선택시 해당 과정에 등록된 교육생 정보를 조회
create or replace procedure proTEachStudentSearchSubseq
(
    psubesq in tblsubject.subject_seq%type,
    pid  in tblteacher.id % type,
    ppw  in tblteacher.jumin % type
)
is
    sname tblstudent.name%type;
    sid tblstudent.id%type;
    sssn tblstudent.ssn%type;
    stel tblstudent.tel%type;
    sattenddate tblstudent.attenddate%type;
    smanager_seq tblstudent.manager_seq%type;
    cursor vcursor is
select
    distinct st.name as "교육생명",
    st.id as "아이디",
    st.ssn as "주민번호",
    st.tel as "전화번호",
    st.attenddate as "등록일",
    st.manager_seq "매니저번호"
from tbllsubject ls
    inner join tbllclass lc
        on lc.lclass_seq = ls.lclass_seq
            inner join tblsugang sg
                on sg.lclass_seq = lc.lclass_seq
                    inner join tblstudent st
                        on st.student_seq = sg.student_seq
                            inner join tblclass c
                                on c.class_seq = lc.class_seq
                                    inner join tbllsubject ls
                                        on ls.lclass_seq = lc.lclass_seq
                                            inner join tblteacher t
                                                on t.teacher_seq = ls.teacher_seq                                
        where ls.subject_seq =  psubesq -- 과목번호 (선택)
            and ls.teacher_seq = (select teacher_seq from tblteacher where id = pid and jumin = ppw ) -- 선생님 
                                    order by "교육생명";
begin
    open vcursor;
            dbms_output.put_line('');
        loop
            fetch vcursor into sname , sid , sssn, stel, sattenddate, smanager_seq;
            exit when vcursor%notfound;
            dbms_output.put_line(' 이름:'|| sname || '  ID: ' || sid || '  PW: ' || sssn || '  전화번호: ' || stel ||
                                '  등록일: ' || sattenddate || '  매니저번호: ' || smanager_seq);
            dbms_output.put_line('====================================================================================');    

        end loop;
    close vcursor;
exception
    when others then
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');

end proTEachStudentSearchSubseq;


--실행****************************************************************
begin
    proTEachStudentSearchSubseq(1, 'tpdls1990', 1234927);
end;
--********************************************************************
