-- C-4

-- 과목 선택

create or replace procedure proctFindlsubjectscore(
    pid tblteacher.id % type,
    ppw tblteacher.jumin % type
)
is
    usubject_seq tblsubject.subject_seq%type;
    bname tblclass.name%type;
    llperiod varchar(100);
    rname tblClassroom.name%type;
    uname tblsubject.name%type;
    jjperiod varchar(100);
    nname tblbookname.name%type;
    cursor vcursor 
is 
SELECT 
    distinct
    u.subject_seq,
    b.name,
    l.startclassdate || '~' || l.finishclassdate as lperiod,
    r.name,
    u.name,
    j.start_date || '~' || j.end_date as jperiod,
    n.name    
    
FROM tblTestScore e
    INNER JOIN tblTest t
        ON t.test_seq = e.test_seq
            INNER JOIN tblLSubject j
                ON t.lsubject_seq = j.lsubject_seq
                    INNER JOIN tblSugang g
                        ON e.sugang_seq = g.sugang_seq
                            INNER JOIN tblStudent s
                                ON s.student_seq = g.student_seq
                                    INNER JOIN tblSubject u
                                        ON u.subject_seq = j.subject_seq
                                            INNER JOIN tblTeacher c
                                                ON c.teacher_seq = j.teacher_seq
                                                    INNER JOIN tbledu_subsidy y
                                                        ON y.sugang_seq = g.sugang_seq
                                                            INNER JOIN tblLClass l
                                                                ON l.lclass_seq = j.lclass_seq
                                                                    INNER JOIN tblClass b
                                                                        ON b.class_seq = l.class_seq
                                                                            INNER JOIN tblClassroom r
                                                                                ON r.classroom_seq = l.classroom_seq
                                                                                     INNER JOIN tblBookName n
                                                                                        ON n.Bookname_seq = j.bookname_seq
                                                                                        

WHERE 1=1
AND j.end_Date < Sysdate                        -- 강의를 마친 과목에 대해서만 성적처리를 할 수 있다.
AND c.teacher_seq = (select teacher_seq from tblteacher where pid = id and jumin = ppw)
ORDER BY u.subject_seq asc
;    
begin
    open vcursor; 
      dbms_output.put_line('====================================================================================================================================================================================================================================');
        loop
            fetch vcursor into usubject_seq, bname, llperiod, rname, uname, jjperiod, nname;
            exit when vcursor%notfound;

            dbms_output.put_line('과목번호' || ': ' || usubject_seq || ' 과정명' || ':  ' || bname || ' 과정기간' || ':  ' || llperiod || ' 강의실명' || ':  ' || rname || ' 과목명' || ':  ' || uname || ' 과목기간' || ':  ' || jjperiod || ' 교재명' || ':  ' || nname || ' 출결배점' || ':  ' || '20%' || ' 필기배점' || ':  ' || '40%' || ' 실기배점' || ':  ' || '40%');        
            
        end loop;
    close vcursor;
exception
    when others then
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');
end;

begin
    proctFindlsubjectscore('tpdls1990',1234927);
end;

-- 성적 출력

create or replace procedure proctFindStudentscore(
    pid tblteacher.id % type,
    ppw tblteacher.jumin % type,
    mbname varchar2 := '',                     
    mjlsubject_seq varchar2 := '',                     
    mtkind_of varchar2 := '',                        
    msname varchar2 := ''                        

)
is
    uname tblsubject.name%type;
    jlsubject_seq tbllsubject.lsubject_seq%type;
    sname tblStudent.name%type;
    stel tblStudent.tel%type;
    awhether tblsugangstate.whether%type;
    awhetherdate varchar(3);
    escore tblTestScore.score%type;
    tquestion tblTest.question%type;
    tkind_of tblTest.kind_of%type;
    aattscore number;
    cursor vcursor 
is 
SELECT 
    distinct
    u.name,
    j.lsubject_seq,
    s.name,
    s.tel,
    a.whether,
    case
        when a.whether = 'Y' then a.sugangstate_date
    end as wheterdate,
    e.score,
    t.question,
    t.kind_of,
    ((SELECT count(*) FROM tblattendence
        WHERE tblattendence.attendence_date BETWEEN '21/09/08' AND '21/11/05' AND sugang_seq = 1) 
    * 0.1) as attscore
    
    
    
FROM tblTestScore e
    INNER JOIN tblTest t
        ON t.test_seq = e.test_seq
            INNER JOIN tblLSubject j
                ON t.lsubject_seq = j.lsubject_seq
                    INNER JOIN tblSugang g
                        ON e.sugang_seq = g.sugang_seq
                            INNER JOIN tblStudent s
                                ON s.student_seq = g.student_seq
                                    INNER JOIN tblSubject u
                                        ON u.subject_seq = j.subject_seq
                                            INNER JOIN tblTeacher c
                                                ON c.teacher_seq = j.teacher_seq
                                                    INNER JOIN tbledu_subsidy y
                                                        ON y.sugang_seq = g.sugang_seq
                                                            INNER JOIN tblLClass l
                                                                ON l.lclass_seq = j.lclass_seq
                                                                    INNER JOIN tblClass b
                                                                        ON b.class_seq = l.class_seq
                                                                            INNER JOIN tblClassroom r
                                                                                ON r.classroom_seq = l.classroom_seq
                                                                                     INNER JOIN tblBookName n
                                                                                        ON n.Bookname_seq = j.bookname_seq
                                                                                            INNER JOIN tblsugangstate a
                                                                                               ON a.sugang_seq = g.sugang_seq

WHERE 1=1
AND j.end_Date < Sysdate        -- 강의를 마친 과목에 대해서만 성적처리를 할 수 있다.
AND c.teacher_seq = (select teacher_seq from tblteacher where pid = id and jumin = ppw)
AND b.name like '%'||mbname||'%' 
AND j.lsubject_seq like '%'||mjlsubject_seq||'%' 
AND t.kind_of like '%'||mtkind_of||'%' 
AND s.name like '%'||msname||'%'      
ORDER BY s.name asc
;    
begin
    open vcursor; 
      dbms_output.put_line('=============================================================================================================================================');   
        loop
            fetch vcursor into uname, jlsubject_seq, sname, stel, awhether, awhetherdate, escore, tquestion, tkind_of, aattscore;
            exit when vcursor%notfound;

            dbms_output.put_line('과목명' || ':  ' || uname || ' 과목번호' || ':  ' || jlsubject_seq  || ' 이름' || ':  ' || sname || ' 전화번호' || ':  ' || stel || ' 중도탈락여부' || ':  ' || awhether || ' 중도탈락날짜' || ':  ' || awhetherdate || ' 점수' || ':  ' || escore || ' 문제' || ':  ' || tquestion || ' 실기/필기' || ':  ' || tkind_of || ' 점수' || ':  ' || aattscore);        
            
        end loop;
    close vcursor;
exception
    when others then
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');
end;

begin
    --proctFindStudentscore('과정이름','과목번호','필기실기','학생이름');
    proctFindStudentscore('tpdls1990',1234927,'','','','황현우');
end;


-- 성적 입력

create or replace procedure procTAddTestScore(
    cscore tblTestScore.score%type,
    ctestdate tblTestScore.testdate%type,
    csugang_seq tblTestScore.sugang_seq%type,
    ctest_seq tblTestScore.test_seq%type
)
is

begin
  
    INSERT INTO tbltestscore (TestScore_Seq, Score, Testdate, Sugang_seq, Test_Seq)
        Values ((select max(TestScore_Seq) + 1 from tblTestScore), cscore, ctestdate, csugang_seq, ctest_seq);
exception
    when others then
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');

end;

begin
    procTAddTestScore(60, sysdate, 1, 101);
end;