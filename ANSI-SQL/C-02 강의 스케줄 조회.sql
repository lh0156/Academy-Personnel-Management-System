--C-02.sql
--------------------------------------------------------------------------------

--C-02. 강의 스케줄 조회

-- 1.강의 스케줄 확인

-- 1) 교수별 강의과정 스케줄 조회 쿼리(교수 : 강의 = 1 : N)
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
    where t.teacher_seq = 11) as "등록인원수",
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
                 where ls.teacher_seq = 11
                    order by "개강" asc;
                                    


-- 2) 지정 강의(=과정)의 과목 스케줄
select 
    c.name as "과정명", 
    sb.name as "과목명", 
    sb.subject_seq as "과목번호", 
    ls.start_date as "과목시작날짜",
    ls.end_date as "과목종료날짜",
    b.name as "교재명", --
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
                      where t.teacher_seq = (select t.teacher_seq from tblteacher  t where t.id = 'tpdls1990' and t.jumin = 1234927)
                                            order by ls.start_date asc;




-- 3) 전체 출력 쿼리
--> 교사명, 과정명, 과정기간(시작,끝), 과목번호, 과목명, 과목기간, 교재명, 강의실, *교육생 등록인원, 강의진행상태
select 
    distinct t.name as "교사명", 
    c.name as "과정명", --
    lc.startclassdate as "개강", 
    lc.finishclassdate as "종강", 
    sb.subject_seq as "과목번호", 
    sb.name as "과목명", 
    ls.start_date as "과목시작날짜",
    ls.end_date as "과목종료날짜",
    b.name as "교재명",
    cr.name "강의실",
    (select 
    count(distinct(student_seq)) 
from tblteacher t inner join tbllsubject ls on t.teacher_seq = ls.teacher_seq
                  inner join tbllclass lc on lc.lclass_seq = ls.lclass_seq
                  inner join tblsugang su on su.lclass_seq = lc.lclass_seq
    where t.teacher_seq =11) as "등록인원수",

    case
        when ls.start_date <= sysdate and ls.end_date >= sysdate then '진행중'
        when ls.start_date > sysdate then '예정'
        when ls.start_date < sysdate then '종료'
    end as "강의진행상태"
    
from tblteacher t
    inner join tbllsubject ls
        on t.teacher_seq = ls.teacher_seq
            inner join tbllclass lc
                on lc.lclass_seq = ls.lclass_seq
                    inner join tblclass c
                        on c.class_seq = lc.class_seq
                            inner join tblbookname b
                                on b.bookname_seq = ls.bookname_seq
                                    inner join tblsubject sb
                                        on ls.subject_seq = sb.subject_seq
                                            inner join tblclassroom cr
                                                on cr.classroom_seq = lc.classroom_seq                                                   
                                                    inner join tblsugang sg
                                                        on sg.lclass_seq = lc.lclass_seq
                                    
                                                             where ls.teacher_seq = 11;



--===============================================================================

-- 2.교육생 정보 확인


--1) 과정번호, 교육생명, 전화번호, 등록일, 수료/중도탈락

-- 1-1.전체출력 쿼리(중도탈락 여부 무시)
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
                            where t.id = 'tpdls1990' and t.jumin = 1234927
                                    order by attenddate asc;
       
                
-- 1-2. 교육생 정보 = 과정번호 + 강의 진행중 + 지정 교사
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
            
        where c.class_seq = '101' -- 과정번호 
            and lc.startclassdate <= sysdate 
            and lc.finishclassdate >= sysdate
            and ls.teacher_seq = (select teacher_seq from tblteacher where id = 'tpdls1990' and jumin = '1234927') -- 선생님 
              order by attenddate asc;



--2. 특정과목을 과목번호로 선택 ->  해당 과정에 등록된 교육생 정보를 조회

-- 1) 특정 과목 선택 쿼리
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
        where ls.subject_seq = 1 -- 과목번호 (선택)
            and ls.teacher_seq = (select teacher_seq from tblteacher where id = 'tpdls1990' and jumin = '1234927') -- 선생님 
                                    order by "교육생명";

