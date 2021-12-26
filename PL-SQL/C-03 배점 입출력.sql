--PROCEDURE=====================================================================================================
-- <교사>
----C-03. 배점 입출력
--============================================================================================================== 

--[배점 입출력]---------------------------------------------------------------------

--1. 입력
create or replace procedure proTPointsInput
(
    -- 로그인 권한 
    pid  in tblteacher.id % type,
    ppw  in tblteacher.jumin % type,    
    
    --ppoints_seq number,
    pwritten number,
    ppractical number,
    ppattendance number,
    psubject_seq number,
    
    presult out number
)
is
    vteacher_seq number;
    vsum number := pwritten + ppractical + ppattendance;
begin
    select teacher_seq into vteacher_seq from tblteacher where teacher_seq = (select teacher_seq from tblteacher where id = pid and jumin = ppw);
        
        if (vsum = 100) and (ppattendance >= 20) then
            insert into tblpoints values ((select max(points_seq) +1 from tblPoints), pwritten, ppractical, ppattendance, psubject_seq);
            presult := 1;
        
        elsif pwritten is null and ppractical is null and ppattendance is null then
            insert into tblpoints values ((select max(points_seq) +1 from tblPoints), pwritten, ppractical, ppattendance, psubject_seq);
            presult := 2;     
        
        end if;
exception
    when others then
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');

end proTPointsInput;




--2. 수정
-- 과목명 or 과목번호(조건 : 강의마침), 필기 배점, 실기 배점, 출결 배점, *총합(100 계산식)

create or replace procedure proTPointsUpdate
(
    -- 로그인 권한 
    pid  in tblteacher.id % type,
    ppw  in tblteacher.jumin % type,
    
    -- 배점수정
    pwritten number,
    ppractical number,
    ppattendence number,
    ppoints_seq number
  
)
is
    vteacher_seq number;
    vsum number := pwritten + ppractical + ppattendence;
begin

    select teacher_seq into vteacher_seq from tblteacher where teacher_seq = (select teacher_seq from tblteacher where id = pid and jumin = ppw);
        if (vsum = 100) and (ppattendence >= 20) then
            update tblPoints set written = pwritten, practical = ppractical, pattendance = ppattendence where points_seq = ppoints_seq;
            dbms_output.put_line('배점 변경이 완료되었습니다.');
            dbms_output.put_line('====================================================================================');    
        else
            dbms_output.put_line('잘못 입력했습니다. 다시입력하세요');
            dbms_output.put_line('(출결 20이상, 배점의 총합은 100)');
            dbms_output.put_line('====================================================================================');    
        end if;
exception
    when others then
    dbms_output.put_line('권한이 없습니다. 로그인 정보를 다시 확인하세요');
    dbms_output.put_line('====================================================================================');      
end proTPointsUpdate;










--[과목목록 출력]----------------------------------------------------------------(완)

-- 1. 특정 과목을 조회(조건 : 강의를 마친 과목)

create or replace procedure proTSearchSubjectOutput
(
    -- 권한 
    pid in tblteacher.id%type,
    ppw in tblteacher.jumin%type
)
is
    ssubject_seq tblsubject.subject_seq%type;
    sname tblsubject.name%type;
    lsstart_date tbllsubject.start_date%type;
    lsend_date tbllsubject.end_date%type;
    cname tblclass.name%type;
    lcstartclassdate tbllclass.startclassdate%type;
    lcfinishclassdate tbllclass.finishclassdate%type;
    bname tblbookname.name%type;
    crclassroom_seq tblclassroom.classroom_seq%type;
    pwritten tblpoints.written%type;
    ppractical tblpoints.practical%type;
    ppattendance tblpoints.pattendance%type;
     cursor vcursor is
select 
    sb.subject_seq as "과목번호",
    sb.name as "과목명",
    ls.start_date as "과목시작",
    ls.end_date as "과목종료",
    c.name as "과정명",
    lc.startclassdate as "개강",
    lc.finishclassdate as "종강",
    b.name as "교재명",
    cr.classroom_seq as "강의실",
    p.written as "필기배점",
    p.practical as "실기배점",
    p.pattendance as "출결배점"
     
from tblsubject sb
    inner join tbllsubject ls
        on ls.subject_seq = sb.subject_seq
            inner join tbllclass lc
                on lc.lclass_seq = ls.lclass_seq
                    inner join tblteacher t
                        on t.teacher_seq = ls.teacher_seq
                            inner join tblclass c
                                on c.class_seq = lc.class_seq
                                    inner join tblclassroom cr
                                        on cr.classroom_seq = lc.classroom_seq
                                            inner join tblbookname b
                                                on b.bookname_seq = ls.bookname_seq
                                                    inner join tblpoints p
                                                        on p.subject_seq = sb.subject_seq
    where ls.end_date < sysdate and t.id = pid and t.jumin = ppw;
begin
 open vcursor;
        loop
            fetch vcursor 
                into ssubject_seq, 
                     sname, 
                     lsstart_date, 
                     lsend_date, 
                     cname, 
                     lcstartclassdate, 
                     lcfinishclassdate, 
                     bname,
                     crclassroom_seq, 
                     pwritten, 
                     ppractical, 
                     ppattendance;
                     
            exit when vcursor%notfound;
            dbms_output.put_line
            (' 과목번호: '||ssubject_seq || '  과목명: ' || sname || '  과목시작일: ' || lsstart_date || '  과목종료일' || lsend_date || '  강의명: '  || cname ); 
            dbms_output.put_line('  개강: ' || lcstartclassdate || '  종강: ' || lcfinishclassdate || '  교재: ' || bname || '  강의실: ' || crclassroom_seq ||
            '  필기배점: ' || to_char(pwritten, '00')|| '  실기배점: ' || to_char(ppractical, '00') || '  출결배점: ' || to_char(ppattendance, '00'));
        dbms_output.put_line('====================================================================================');      
        end loop;
    close vcursor;
exception
    when others then
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');

end proTSearchSubjectOutput;




--2. 배점번호로 해당 강의중 종료된 과목 배점 정보 출력
-- 교사는 자기가 설정한 배점정보를 배점번호로 구분한다.*****
select * from tblpoints;

create or replace procedure proTEachSubjectPointsOutput
(
    -- 권한 
    pid in tblteacher.id%type,
    ppw in tblteacher.jumin%type,
    
    -- 배점번호
    ppseq in tblpoints.points_seq%type
)
is
    ppoints_seq tblpoints.points_seq%type;
    lcclass_seq tbllclass.lclass_seq%type;
    sname tblsubject.name%type;
    pwritten tblpoints.written%type;
    ppractical tblpoints.practical%type;
    ppattendance tblpoints.pattendance%type;

    cursor vcursor is
select
    p.points_seq as "배점번호",
    lc.lclass_seq as "강의번호",
    sb.name as "과목명",
    p.written as "필기배점",
    p.practical as "실기배점",
    p.pattendance as "출결배점"
     
from tblsubject sb
    inner join tbllsubject ls
        on ls.subject_seq = sb.subject_seq
            inner join tbllclass lc
                on lc.lclass_seq = ls.lclass_seq
                    inner join tblteacher t
                        on t.teacher_seq = ls.teacher_seq
                            inner join tblpoints p
                                on p.subject_seq = sb.subject_seq
        where ls.end_date < sysdate 
        and t.id = pid 
        and t.jumin = ppw 
        and p.points_seq = ppseq;
begin
    open vcursor;
            loop
                fetch vcursor into ppoints_seq, lcclass_seq, sname, pwritten, ppractical, ppattendance;
                exit when vcursor%notfound;
                dbms_output.put_line(' 배점번호: ' || ppoints_seq || '  강의번호: ' || lcclass_seq || '  과목: ' || sname || '  필기: ' || pwritten || '  실기: ' || ppractical 
                                    || '  출석: ' || ppattendance);
                dbms_output.put_line('====================================================================================');
            end loop;
    close vcursor;
exception
    when others then
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');

end proTEachSubjectPointsOutput;








set serveroutput on;





-- [시험에 관련된 값]--------------------------------------------------------------
select * from tbltest;
--1. 테스트 문제 추가

create or replace procedure proTTestAdd
(
    -- 권한 
    pid in tblteacher.id%type,
    ppw in tblteacher.jumin%type,
    
    pquestion varchar2,
    pkind_of varchar2,
    plsubject_seq number
)
is
    vteacher_seq number := 0;
begin
    select teacher_seq into vteacher_seq from tblteacher where teacher_seq = (select teacher_seq from tblteacher where id = pid and jumin = ppw);
    
    if vteacher_seq > 0 then
        insert into tbltest values ((select max(test_seq) + 1 from tbltest), pquestion, pkind_of, plsubject_seq);
        dbms_output.put_line('테스트 추가가 완료되었습니다.');
        dbms_output.put_line('====================================================================================');    

    end if;   
exception
    when others then
        dbms_output.put_line('로그인 정보 및 테스트 정보가 올바른지 다시 확인해주세요.');
        dbms_output.put_line('====================================================================================');    
end proTTestAdd;


--*********************************************************************************
--------------------------------------------------------------------------------
--출력
--1. 배점 입력(추가)
declare
    vresult number;
begin
    proTPointsInput('tpdls1990', 1234927, 10, 20, 60, 20, vresult); -- 마지막 = 과목번호값    
    --proTPointsInput('tpdls1990', 1234927, null, null, null, 21, vresult); --null값 입력 허용(요구분석서) 단, 3개 배점 전부 null일경우만
    
    if vresult = 1 or vresult = 2 then
        dbms_output.put_line('====================================================================================');
        dbms_output.put_line('입력이 완료됐습니다.');
        dbms_output.put_line('====================================================================================');
    else
        dbms_output.put_line('====================================================================================');
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');
    end if;

end;


select * from tblpoints;
set serveroutput on;


--2. 배점 수정 
begin
    dbms_output.put_line('====================================================================================');
    proTPointsUpdate('tpdls1990', 1234927, 20, 50, 30, 104); -- 마지막 = 배점번호(points_seq)
end;


select * from tblpoints;




--3. 특정 과목을 조회(조건 : 강의를 마친 과목)
begin
    dbms_output.put_line('====================================================================================');
    proTSearchSubjectOutput('tpdls1990', 1234927);
end;


--4. 배점번호로 해당 강의중 종료된 과목 배점 정보 출력
begin
    dbms_output.put_line('====================================================================================');
    proTEachSubjectPointsOutput('tpdls1990', 1234927, 100); -- 마지막 = 배점번호
end;



--5. 테스트 문제 추가
begin
    dbms_output.put_line('====================================================================================');
    proTTestAdd('tpdls1990', 1234927, '프로시저테스트추가', '필기', 1);  -- 마지막 = 과목 번호 
end;

select * from tbltest;
