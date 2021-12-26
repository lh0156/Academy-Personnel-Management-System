-----------------------------------------------------D-02 성적 조회-----------------------------------------------------------
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

-- 1.현재 수강중인 과정명과 과목명 , 과목별 기간을 출력
select 
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
    where stu.student_seq = (select student_seq from tblstudent where id = 'qrs102' and substr(ssn,7) = '2325740');

-- 2.전체 시험 정보 조회
select
    stu.name as "이름",
    c.name as "과정명",
    s.name as "과목명",
    ls.start_date as "과목 시작 날짜",
    ls.end_date as "과목 종료 날짜",
    b.name as "책 이름",
    t.name as "선생님 이름",
    test.kind_of as "시험 종류",
    ts.score  as "점수",
    (select (select count(distinct attendence_date) from tblattendence where sugang_seq = su.sugang_seq and absence_type = '정상')/
    (select count(attendence_date) from tblattendence where sugang_seq = su.sugang_seq) * 20
    from dual)as "출석 점수",
    ts.testdate as "시험 날짜",
    test.question as "시험 문제"
from tblstudent stu inner join tblsugang su on stu.student_seq = su.student_seq
                    inner join tbllclass lc on lc.lclass_seq = su.lclass_seq
                    inner join tblclass c on c.class_seq = lc.class_seq
                    inner join tbllsubject ls on ls.lclass_seq = lc.lclass_seq
                    inner join tblsubject s on s.subject_seq = ls.subject_seq
                    inner join tblbookname B on b.bookname_seq = ls.bookname_seq
                    inner join tblteacher T on t.teacher_seq = ls.teacher_seq
                    inner join tbltest test on test.lsubject_seq = ls.lsubject_seq
                    left outer join tbltestscore ts on ts.test_seq=test.test_seq and ts.sugang_seq = su.sugang_seq
    where su.sugang_seq = (select student_seq from tblstudent where id = 'qrs102' and substr(ssn,7) = '2325740');
    
-- 3.과목 선택 후 점수 조회시
select
    stu.name as "이름",
    c.name as "과정명",
    s.name as "과목명",
    ls.start_date as "과목 시작 날짜",
    ls.end_date as "과목 종료 날짜",
    b.name as "책 이름",
    t.name as "선생님 이름",
    test.kind_of as "시험 종류",
    ts.score  as "점수",
    (select (select count(distinct attendence_date) from tblattendence where sugang_seq = su.sugang_seq and absence_type = '정상')/
    (select count(attendence_date) from tblattendence where sugang_seq = su.sugang_seq) * 20
    from dual)as "출석 점수",
    ts.testdate as "시험 날짜",
    test.question as "시험 문제"
from tblstudent stu inner join tblsugang su on stu.student_seq = su.student_seq
                    inner join tbllclass lc on lc.lclass_seq = su.lclass_seq
                    inner join tblclass c on c.class_seq = lc.class_seq
                    inner join tbllsubject ls on ls.lclass_seq = lc.lclass_seq
                    inner join tblsubject s on s.subject_seq = ls.subject_seq
                    inner join tblbookname B on b.bookname_seq = ls.bookname_seq
                    inner join tblteacher T on t.teacher_seq = ls.teacher_seq
                    inner join tbltest test on test.lsubject_seq = ls.lsubject_seq
                    left outer join tbltestscore ts on ts.test_seq=test.test_seq and ts.sugang_seq = su.sugang_seq
    where su.sugang_seq = (select student_seq from tblstudent where id = 'qrs102' and substr(ssn,7) = '2325740')
           and s.name = '자바';

-----------------------------------------------------D-02 성적 조회-----------------------------------------------------------
commit;