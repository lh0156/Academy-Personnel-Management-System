--select문
--B01
--매니저 아이디 비밀번호
select * from tblManager;
select count(*) as cnt from tblmanager where id = 'ssangyong1' and password = '1024982';

--B02
--매니저가 기초정보 조회
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
                                        
--기본정보 추가
    insert into tblClass (Class_Seq, name) values ((select max(class_Seq) + 1 from tblclass), '추가과정');
    insert into tblsubject (subject_Seq, name) values ((select max(subject_Seq) + 1 from tblsubject), '추가과목');
    insert into tblclassroom (classroom_Seq, name, totalNum) values ((select max(classroom_Seq) + 1 from tblclassroom), '추가강의실', '정원');
    insert into tblBookName (bookname_seq, name, publisher) values ((select max(bookname_Seq) + 1 from tblbookname), '책이름', '출판사');

--기본정보 수정                                        
    update tblclass set name = pname where class_seq = 과정번호;
    update tblsubject set name = pname where subject_seq = 과목번호;
    update tblclassroom set name = pname, totalnum = ptotalnum where classroom_seq = 교실번호;
    update tblbookname set name = '수정책이름', publisher = '출판사' where bookname_seq = 책번호;

--기본 정보 삭제
    delete from tblclass where class_Seq = 과정번호;
    delete from tblsubject where subject_Seq = 과목번호;
    delete from tblclassroom where classroom_Seq = 교실번호;
    delete from tblbookname where bookname_Seq = 책번호;


--B03, B04
--교사 정보 조회
select * from tblteacher;
-- 특정 교사 정보 조회
select * into from tblteacher where name = '특정 교사 이름'
--개설과정 정보
select 
    ls.start_date as "개설시작날",
    ls.end_date as "개설끝날",
    s.name as "개설과목명",
    c.name as "개설과정명",
    lc.startclassdate as "과정시작일",
    lc.finishclassdate as "과정종료일",
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
                                                
--교사추가
 INSERT INTO tblTeacher(Teacher_Seq, name, id, jumin, tel, possibleLecture, now, Subject_Seq, Manager_Seq)
        Values ((select max(teacher_Seq) + 1 from tblteacher), '추가교사', 'wewe545', '1234564', '010-1111-1111', '자바,파이썬,오라클', 'N', 50, 1);
--교사 아이디 수정
    update tblteacher set id = pid where teacher_seq = 교사번호;
--교사 전화번호 수정
    update tblteacher set tel = ptel where teacher_seq = 교사번호;
--교사 삭제
    delete from tblteacher where teacher_Seq = 교사번호;

--과정 종료일 설정
    update tbllclass set finishclassdate = pdate where lclass_seq = 개설과정번호;
--과정 강의실 설정
    update tbllclass set classroom_Seq = pcseq where lclass_seq = 개설과정번호;




-- 개설 과목 정보
--B05
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
                                                
--개설과목 일정 변경
    update tbllsubject set Start_Date = '변경시작날짜', End_Date = '변경종료날짜' where lsubject_Seq = 개설과목번호;
--개설과목 삭제
    delete from tbllsubject where lsubject_Seq = 개설과목번호;



--학생 정보
--B06
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

--교육생 추가
INSERT INTO TBLSTUDENT (STUDENT_SEQ, NAME, ID, SSN, TEL, ATTENDDATE, MANAGER_SEQ) 
    VALUES ((select max(student_seq) + 1 from tblstudent), '홍길동', 'hong1234', '9502161265485', '010-2222-3333', sysdate, 5);

--중도 처리 관리
    update tblsugangstate set sugangstate_date = '2021-12-02', whether = 'Y' where sugang_seq = (select tblstudent.student_seq from tblstudent inner join tblsugang on tblsugang.student_seq = tblstudent.student_seq where name = '교육생이름');

