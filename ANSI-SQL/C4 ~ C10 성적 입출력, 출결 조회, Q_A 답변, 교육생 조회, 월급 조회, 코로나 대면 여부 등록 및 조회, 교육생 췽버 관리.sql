
-- C04

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



-- C05

SELECT 
    distinct a.attendence_date,   
    c.name,
    s.name,
    a.absence_type
FROM tblattendence a
    LEFT JOIN tblSugang g
        ON a.sugang_Seq = g.sugang_Seq
            LEFT JOIN tblStudent s
                ON g.student_Seq =  s.student_Seq
                    LEFT JOIN tblLClass l
                        ON l.LClass_Seq = g.LClass_seq
                            LEFT JOIN tblLsubject j
                                ON j.LClass_Seq = l.Lclass_Seq
                                    LEFT JOIN tblTeacher t
                                        ON t.Teacher_Seq = j.Teacher_Seq
                                            LEFT JOIN tblClass c
                                                ON c.Class_Seq = l.Class_Seq
                        
WHERE 1=1
AND s.name like '%'||msname||'%' 
AND a.attendence_date between to_date(mstartdate,'yyyy/mm/dd') AND to_date(menddate,'yyyy/mm/dd')
AND c.name like '%'||mcname||'%'
AND t.teacher_seq = (select teacher_seq from tblteacher where pid = id and jumin = ppw)
ORDER BY a.attendence_date asc
; 




-- C06

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


-- C07

SELECT 
    s.name,
    p.Education,
    p.Certificate
    
FROM tblStudentSpec p                           
    LEFT JOIN tblStudent s                          
        ON p.student_Seq = s.student_Seq       
WHERE 1=1
AND s.name like '%'||msname||'%'
;

-- C08

SELECT 
    t.Name,
    s.Period,
    s.Salary
    
FROM tblsalary s
LEFT JOIN tblTeacher t
ON s.Teacher_Seq = t.Teacher_Seq

WHERE 1=1
AND s.Period BETWEEN mstartmonth AND mendmonth
AND t.teacher_seq = (select teacher_seq from tblteacher where pid = id and jumin = ppw)
;

-- C09

SELECT 
     c.attendance,
     t.name,
     c.facetoface
     
FROM tblCovidT c
    LEFT JOIN tblTeacher t
        ON c.Teacher_Seq = t.Teacher_Seq
        
WHERE 1=1
AND t.teacher_seq = (select teacher_seq from tblteacher where pid = id and jumin = ppw)
AND c.attendance between sysdate and sysdate+7;

-- C10

SELECT 
    s.name, 
    w.basicpay * 12, 
    w.city 
FROM tblWishJob w
    LEFT JOIN tblstudent s
        ON w.student_Seq = s.Student_Seq
WHERE 1=1
AND w.city like '%'||mwcity||'%'
AND s.name like '%'||msname||'%'
;