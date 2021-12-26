-- C-6

-- 학생의 질문 조회

SELECT * FROM tblanswer;
SELECT * FROM tblattendence;

create or replace procedure proctFindStudentQuestion(
    pid tblteacher.id % type,
    ppw tblteacher.jumin % type,
    msname varchar2 := '',
    mstartdate varchar2 := '0001-01-01',
    menddate varchar2 := '4444-12-31'
)
is
    sname tblstudent.name%type;
    qquestion tblquestion.question%type;
    qquestiondate tblquestion.questiondate%type;
    tname tblTeacher.name%type;
    aanswer tblanswer.answer%type;
    aanswerdate tblanswer.answerdate%type;
    cursor vcursor 
is 
SELECT 
    s.name,
    q.question,
    q.questiondate,
    t.name,
    a.answer,
    a.answerdate
    
FROM tblanswer a
    INNER JOIN tblquestion q
        ON a.question_Seq = q.question_seq
            INNER JOIN tblTeacher t
                ON t.teacher_Seq = a.teacher_seq
                    INNER JOIN tblsugang g
                        ON g.sugang_seq = q.sugang_seq
                            INNER JOIN tblStudent s
                                ON s.student_Seq = g.student_Seq

WHERE 1=1
AND t.teacher_seq = (select teacher_seq from tblteacher where pid = id and jumin = ppw)
AND a.answerdate between to_date(mstartdate,'yyyy-mm-dd') AND to_date(menddate,'yyyy-mm-dd')
AND s.name like '%'||msname||'%' 
;    
begin
    open vcursor; 
      dbms_output.put_line('===================================================================================================================================');
        loop
            fetch vcursor into sname, qquestion, qquestiondate, tname, aanswer, aanswerdate;
            exit when vcursor%notfound; 
            dbms_output.put_line('이름' || ':  ' || sname || ' 질문내용' || ':  ' || qquestion || ' 질문날짜' || ':  ' || qquestiondate || ' 교사' || ':  ' || tname || ' 답변내용' || ':  ' || aanswer || ' 답변날짜' || ':  ' || aanswerdate);        
            
        end loop;
    close vcursor;
end;

begin
    --proctFindStudentQuestion(학생이름, 시작날짜, 종료날짜);
    proctFindStudentQuestion('tpdls1990',1234927,'황현우','20210908','20211205');
end;



-- 답변 작성

create or replace procedure proctAnswerStudentQuestion(
    pid tblteacher.id % type,
    ppw tblteacher.jumin % type,
    aanswer tblanswer.answer%type,
    aquestion_seq tblanswer.question_seq%type
)
is
    cursor vcursor 
is 
SELECT
    t.name
FROM tblteacher t
WHERE 1=1
AND t.teacher_seq = (select teacher_seq from tblteacher where pid = id and jumin = ppw);
begin
    open vcursor;
    INSERT INTO tblanswer (answer_seq, answer, answerdate, Teacher_Seq, question_seq)
        Values ((select max(answer_seq) + 1 from tblanswer), aanswer, sysdate, (select teacher_seq from tblteacher where pid = id and jumin = ppw), aquestion_seq);
    close vcursor;
end;

begin
    --proctAnswerStudentQuestion(답변, 질문번호);
    proctAnswerStudentQuestion('tpdls1990',1234927,'그만들으세요','100');
end;
