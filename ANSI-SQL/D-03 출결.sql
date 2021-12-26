-------------------------------------------------------D-03 출결-------------------------------------------------------------
--업무영역
--교육생
--요구사항 명
--D-03 교육생 출결 관리
--개요
--교육생이 본인의 출결을 관리할 수있다.
--상세설명
--매일 근태 관리를 기록할 수 있어야 한다.
---본인의 출결 현황을 기간별(전체,월,일) 조회할 수 있어야 한다.
--
--제약사항
--	-	다른 교육생의 현황은 조회할 수 없다.
---	모든 출결 조회는 상황을 구분할 수 있어야 한다.(정상,지각,조퇴,외출,병가,기타)
-- ID : qrs102
-- PW : 2325740

-- 1. 본인 출결 전체조회
select 
    stu.name,
    at.attendence_date,
    at.absence_type,
    to_char(at.gotowork , 'HH24:mi') as gotowork,
    to_char(at.offwork , 'HH24:mi') as offwork
from tblstudent stu inner join tblsugang su on stu.student_seq =su.student_seq
                    inner join tblattendence at on at.sugang_seq = su.sugang_seq
    where stu.student_seq = (select stu.student_seq from tblstudent stu where stu.id = 'qrs102' and substr(stu.ssn,7) = '2325740'); -- 로그인 후 학생 번호를 돌려주는 쿼리
-- 2. 본인 출결 년도별조회
select 
    stu.name,
    at.attendence_date,
    at.absence_type,
    to_char(at.gotowork , 'HH24:mi') as gotowork,
    to_char(at.offwork , 'HH24:mi') as offwork
from tblstudent stu inner join tblsugang su on stu.student_seq =su.student_seq
                    inner join tblattendence at on at.sugang_seq = su.sugang_seq
    where   TO_char(at.attendence_date,'yyyy') = '2021'and
            stu.student_seq = (select stu.student_seq from tblstudent stu where stu.id = 'qrs102' and substr(stu.ssn,7) = '2325740'); -- 로그인 후 학생 번호를 돌려주는 쿼리
-- 3. 본인 출결 월조회
select 
    stu.name,
    at.attendence_date,
    at.absence_type,
    to_char(at.gotowork , 'HH24:mi') as gotowork,
    to_char(at.offwork , 'HH24:mi') as offwork
from tblstudent stu inner join tblsugang su on stu.student_seq =su.student_seq
                    inner join tblattendence at on at.sugang_seq = su.sugang_seq
    where   TO_char(at.attendence_date,'mm') = '09'and
            stu.student_seq = (select stu.student_seq from tblstudent stu where stu.id = 'qrs102' and substr(stu.ssn,7) = '2325740'); -- 로그인 후 학생 번호를 돌려주는 쿼리   
-- 4. 본인 출결 특정 일 조회
select 
    stu.name,
    at.attendence_date,
    at.absence_type,
    to_char(at.gotowork , 'HH24:mi') as gotowork,
    to_char(at.offwork , 'HH24:mi') as offwork
from tblstudent stu inner join tblsugang su on stu.student_seq =su.student_seq
                    inner join tblattendence at on at.sugang_seq = su.sugang_seq
    where   TO_char(at.attendence_date,'yyyy-mm-dd') = '2021-12-03'and
            stu.student_seq = (select stu.student_seq from tblstudent stu where stu.id = 'qrs102' and substr(stu.ssn,7) = '2325740'); -- 로그인 후 학생 번호를 돌려주는 쿼리  
-- 5 출결 입력

--'정상', '지각', '조퇴', '외출', '병가', '기타'

-- 출근 쿼리 
insert into tblAttendence(Attendence_Seq, absence_type, Attendence_Date, Sugang_Seq , GoTowork)
    select 
        (select * from (select attendence_seq from tblAttendence order by attendence_seq desc) where rownum =1)+1,
        case
            when to_char(sysdate , 'HH24:MM')> '09:00' then '지각'
            when to_char(sysdate , 'HH24:MM')< '09:00' then '기타'
        end,
        to_char(sysdate , 'yyyy-mm-dd'),
        su.sugang_seq,
        sysdate
    from tblsugang su
        where su.student_seq = ( select stu.student_seq from tblstudent stu where stu.id = 'qrs102' and substr(stu.ssn,7) = '2325740') ;
-- 퇴근 쿼리 
update tblAttendence set offwork = sysdate, 
                         absence_type = ( select 
                                                case
                                                    when  ABSENCE_TYPE = '지각' then '지각'
                                                    when  to_char(sysdate , 'HH24:MM')< '18:00' then '조퇴'
                                                    when  to_char(sysdate , 'HH24:MM')> '18:00' then '정상'
                                                end
                                            from tblAttendence 
                                                where ATTENDENCE_SEQ = (select 
                                                                            * 
                                                                        from (select 
                                                                                ATTENDENCE_SEQ 
                                                                              from tblsugang s inner join tblAttendence a on s.sugang_seq = a.sugang_seq 
                                                                              where student_seq  = ( select 
                                                                                                        stu.student_seq 
                                                                                                     from tblstudent stu 
                                                                                                        where stu.id = 'qrs102' and substr(stu.ssn,7) = '2325740') 
                                                                              order by attendence_seq desc) 
                                                                        where rownum =1)) -- 수정해야될 행의 출근시간 참조
                                                where ATTENDENCE_SEQ = (select 
                                                                            * 
                                                                        from (select 
                                                                                ATTENDENCE_SEQ 
                                                                              from tblsugang s inner join tblAttendence a on s.sugang_seq = a.sugang_seq 
                                                                              where student_seq  = ( select 
                                                                                                        stu.student_seq 
                                                                                                     from tblstudent stu 
                                                                                                        where stu.id = 'qrs102' and substr(stu.ssn,7) = '2325740') 
                                                                              order by attendence_seq desc) 
                                                                        where rownum =1); -- 로그인 한 학생이 마지막에 남김 정보
-----------------------------------------------------D-03 출결-------------------------------------------------------------
rollback;
commit;