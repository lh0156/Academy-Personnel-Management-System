--------------------------------------------------C-12 상담 신청자 조회--------------------------------------------------------
--업무영역
--교사
--요구사항 명
--C-14, 상담 신청자 조회
--개요
--교육생의 상담 신청 현황을 확인한다.
--	교육생의 상담 신청 여부를 확인할 수 있다.
---	교육생의 이름, 과정명, 강의실 등을 확인할 수 있다.
select 
    DISTINCT(con.counsel_date),
    s.name as "이름",
    c.name as "과정명",
    lc.classroom_seq as "강의실",
    con.purpose as "상담 신청 내용"
from tbllsubject lsub inner join tblteacher t on lsub.teacher_seq = t.teacher_seq
                        inner join tbllclass lc on lsub.lclass_seq = lc.class_seq
                        inner join tblsugang su on su.lclass_seq = lc.class_seq
                        inner join tblstudent s on s.student_seq = su.student_seq
                        inner join tblCounsel con on con.sugang_seq = su.sugang_seq
                        inner join tblClass c on c.class_seq = lc.class_seq
    where con.target = '선생님' and
          t.teacher_seq = (select teacher_seq from tblteacher where id = 'tpdls1990' and jumin = '1234927')
    order by con.counsel_date ; -- 현재 로그인된 교사의 개설 과정을 수강 중인 학생의 상담내역 확인
--------------------------------------------------C-12 상담 신청자 조회--------------------------------------------------------
commit;