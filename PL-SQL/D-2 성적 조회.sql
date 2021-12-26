-----------------------------------------------------D-02 성적 조회-----------------------------------------------------------
-- 점수 출력 view 생성 쿼리 
CREATE OR REPLACE VIEW vwAttendenceScore
as
(select
    Asu.sugang_seq as sugang_seq,
    (select  --현재까지 정상 출석일
            count(distinct att.attendence_date) 
        from tblattendence att inner join tblsugang su on att.sugang_seq = su.sugang_seq  
            where att.sugang_seq = Asu.sugang_seq
                and att.absence_type = '정상')/
    (select --개강 후 총 날짜
            count(att.attendence_date) 
        from tblattendence att inner join tblsugang su on att.sugang_seq = su.sugang_seq  
            where att.sugang_seq = Asu.sugang_seq)*20 as score
from tblsugang Asu);


CREATE OR REPLACE VIEW vwScore
as
(select 
    su.sugang_seq as sugang_seq,
    s.name as subjectName,
    test.kind_of as kind_of,
    ts.score as score,
    ts.testdate as testDate,
    test.question
from tblstudent stu inner join tblsugang su on stu.student_seq = su.student_seq
                    inner join tbllclass lc on lc.lclass_seq = su.lclass_seq
                    inner join tblclass c on c.class_seq = lc.class_seq
                    inner join tbllsubject ls on ls.lclass_seq = lc.lclass_seq
                    inner join tblsubject s on s.subject_seq = ls.subject_seq
                    inner join tblbookname B on b.bookname_seq = ls.bookname_seq
                    inner join tblteacher T on t.teacher_seq = ls.teacher_seq
                    inner join tbltest test on test.lsubject_seq = ls.lsubject_seq
                    left outer join tbltestscore ts on ts.test_seq=test.test_seq and ts.sugang_seq = su.sugang_seq);
--업무영역
--교육생
--요구사항 명
--D-02 교육생 성적 조회
--개요
--교육생의 성적을 조회할 수 있다.
--
--상세설명
---	교육생이 로그인 한 후 과정명, 과정기간 (시작 연월일 ~ 끝 연월일), 강의실이 출력된다.
---	과정을 클릭하면 교육생의 성적을 확인할 수 있다.
--
--     제약사항
---	교육생은 한 개의 과정만을 등록해서 수강한다.
---	한 개의 과정 내에는 여러개의 과목을 수강한다. (과정 기간이 끝나지 않은 교육생 또는 중도탈락 처리된 교육생의 경우 일부 과목만 수강했다고 가정한다.)
---	과목번호, 과목명, 과목기간 (시작 연월일 ~ 끝 연월일), 교재명, 교사명, 과목별 배점정보(출결, 필기, 실기 배점), 과목별 성적 정보(출결, 필기, 실기 점수), 과목별 시험날짜, 시험문제가 출력되어야 한다.
---	//성적 정보는 과목별 목록 형태로 출력한다.
---	성적이 등록되지 않은 과목이 있는 경우 과목 정보는 출력되고 점수는 null 값으로 출력되도록 한다.
-- ID : qrs102
-- PW : 2325740

-- pl/sql
-- 1.현재 수강중인 과정명과 과목명 , 과목별 기간을 출력

create or replace procedure ProSGradeCheckclassSearch(
    pid in tblstudent.id%TYPE,
    ppw in tblstudent.ssn%type
)
is  
    vcheck NUMBER;
    vclassName tblclass.name%type;
    vsubjectName tblSubject.name%type;
    vsd tbllsubject.start_date%type;
    ved tbllsubject.end_date%type;
    vroom tblclassroom.name%type;
    cursor vcursor is select 
                        c.name as "과정명",
                        s.name as "과목명",
                        ls.start_date as "과목 시작 날짜",
                        ls.end_date as "과목 종료 날짜",
                        room.name as "강의실"
                    from tblstudent stu inner join tblsugang su on stu.student_seq = su.student_seq
                                        inner join tbllclass lc on lc.lclass_seq = su.lclass_seq
                                        inner join tblclass c on c.class_seq = lc.class_seq
                                        inner join tbllsubject ls on ls.lclass_seq = lc.lclass_seq
                                        inner join tblsubject s on s.subject_seq = ls.subject_seq
                                        inner join tblclassroom room on room.classroom_seq = lc.classroom_seq
                        where stu.student_seq = (select student_seq from tblstudent where id = pid and substr(ssn,7) = ppw);
begin
    select 1 into vcheck  from tblsugang su where su.student_seq = ( select stu.student_seq from tblstudent stu where stu.id = pid and substr(stu.ssn,7) = ppw);
    open vcursor;
        loop
            fetch vcursor into vclassName ,vsubjectName ,vsd ,ved, vroom;
            exit when vcursor%notfound;
            dbms_output.put_line('=========================================================================================================================================================================================');
            dbms_output.put_line('과정명 : '||vclassName||'    과목명 : '||vsubjectName||'    시작 날짜 : '||vsd||' 종료 날짜 : '||ved||' 강의실 : '||vroom);
            dbms_output.put_line('=========================================================================================================================================================================================');
        end loop;
    close vcursor;
exception
    when others then
    dbms_output.put_line('              권한이 없습니다. 로그인 정보를 다시 확인하세요');
    dbms_output.put_line('');
    dbms_output.put_line('          ================================================');    
end;


-- 2.전체 or 과목 선택시 시험 정보 조회
create or replace procedure ProSGradeCheckclassSelSearch(
    pid in tblstudent.id%TYPE,
    ppw in tblstudent.ssn%type,
    pclassName in tblclass.name%type
)
is    
    studentName tblstudent.name%type;
    className tblclass.name%type;
    subjectName tblsubject.name%type;
    startDate tbllsubject.start_date%type;
    endDate tbllsubject.end_date%type;
    bookName tblbookName.name%type;
    teacherName tblteacher.name%type;
    pQuestion tbltest.question%type;
    pTestDate tbltestscore.testdate%type;
    pTestScore tbltestscore.score%type;
    sQuestion tbltest.question%type;
    sTestDate tbltestscore.testdate%type;
    stestScore tbltestscore.score%type;
    attend number;
    cursor vcursor is select 
                        stu.name as 학생명,
                        c.name as "과정명",
                        s.name as "과목명",
                        ls.start_date as "과목 시작 날짜",
                        ls.end_date as "과목 종료 날짜",
                        b.name as "책 이름",
                        t.name as "선생님 이름",
                        (select question from vwscore where sugang_seq = su.sugang_seq and kind_of = '필기' and subjectName = s.name) as "필기 문제",
                        (select testdate from vwscore where sugang_seq = su.sugang_seq and kind_of = '필기' and subjectName = s.name) as "필기 시험 날짜",
                        CASE WHEN (select score from vwscore where sugang_seq = su.sugang_seq and kind_of = '필기' and subjectName = s.name) <> 0 THEN (select score from vwscore where sugang_seq = su.sugang_seq and kind_of = '필기' and subjectName = s.name) 
                             ELSE 0 END as "필기점수",
                        (select question from vwscore where sugang_seq = su.sugang_seq and kind_of = '실기' and subjectName = s.name) as "실기 문제",
                        (select testdate from vwscore where sugang_seq = su.sugang_seq and kind_of = '실기' and subjectName = s.name) as "실기 시험 날짜",
                        CASE WHEN (select score from vwscore where sugang_seq = su.sugang_seq and kind_of = '실기' and subjectName = s.name) <> 0 THEN (select score from vwscore where sugang_seq = su.sugang_seq and kind_of = '실기' and subjectName = s.name)
                             ELSE 0 END as "실기점수",
                        (select score from vwattendencescore where sugang_seq = su.sugang_seq) as "출석"
                    from tblstudent stu inner join tblsugang su on stu.student_seq = su.student_seq
                                        inner join tbllclass lc on lc.lclass_seq = su.lclass_seq
                                        inner join tblclass c on c.class_seq = lc.class_seq
                                        inner join tbllsubject ls on ls.lclass_seq = lc.lclass_seq
                                        inner join tblsubject s on s.subject_seq = ls.subject_seq
                                        inner join tblbookname B on b.bookname_seq = ls.bookname_seq
                                        inner join tblteacher T on t.teacher_seq = ls.teacher_seq
                        where su.sugang_seq  = (select student_seq from tblstudent where id = pid and substr(ssn,7) = ppw) and s.name like '%'||pclassName;
begin
    open vcursor;
        loop
            fetch vcursor into studentName, className ,subjectName ,startDate ,endDate ,bookName ,teacherName ,pQuestion ,pTestDate ,pTestScore ,sQuestion ,sTestDate ,stestScore ,attend;
            exit when vcursor%notfound;
                dbms_output.put_line('=========================================================================================================================================================================================');
                dbms_output.put_line('이름 : '||studentName||' 과정명 : '||className ||' 과목명 : '||subjectName ||' 과목 시작 날짜 : '||startDate ||' 과목 종료 날짜 : '||endDate 
                );
                dbms_output.put_line('=========================================================================================================================================================================================');
                dbms_output.put_line('      교재 이름 : '||bookName ||' 교사 이름 : '||teacherName );
                dbms_output.put_line('=========================================================================================================================================================================================');
                dbms_output.put_line('      필기 문제 : '||pQuestion ||' 필기 시험 날짜 : '||pTestDate ||' 필기 점수 : '||pTestScore ||' 점');
                dbms_output.put_line('=========================================================================================================================================================================================');
                dbms_output.put_line('      실기 문제 : '||sQuestion ||' 실기 시험 날짜 : '||sTestDate ||' 실기 점수 : '||stestScore ||' 점');
                dbms_output.put_line('=========================================================================================================================================================================================');
                dbms_output.put_line('      현재 출석 점수 : '||attend);
                dbms_output.put_line('=========================================================================================================================================================================================');
        end loop;
    close vcursor;
exception
    when others then
    dbms_output.put_line('              권한이 없습니다. 로그인 정보를 다시 확인하세요');
    dbms_output.put_line('');
    dbms_output.put_line('          ================================================');  
end;
           
-- 실행
begin
    ProSGradeCheckclassSearch('qrs102','2325740');
end;
begin
    ProSGradeCheckclassSelSearch('qrs102','2325740','');
end;
-----------------------------------------------------D-02 성적 조회-----------------------------------------------------------
commit;
rollback;