---------------------------------------------------D-05 상담 신청-------------------------------------------------------
--업무영역
--교육생
--요구사항 명
--D-05 상담 신청
--개요
--교육생이 관리자 또는 선생님에게 상담을 신청할 수 있다.
--
--상세설명
---	교육생이 관리자 또는 선생님에게 상담을 신청할 수 있다.
---	상담신청이 수락 되었을 경우 관리자 또는 선생님과 상담을 할 수 있다.
--    제약사항
-- 1. 선생님 상담신청
insert into tblCounsel
select 
    (select counsel_seq from(select * from tblCounsel order by counsel_seq desc) where rownum = 1)+1,
    '선생님',
    '테스트 상담 테스트',
    sysdate,
    su.sugang_seq ,
    t.teacher_seq,
    m.manager_seq
from tblsugang su inner join tbllclass lc on su.lclass_seq = lc.lclass_seq
                  inner join tbllsubject ls on ls.lclass_seq = lc.lclass_seq
                  inner join tblteacher t on t.teacher_seq = ls.teacher_seq
                  inner join tblstudent stu on stu.student_seq = su.student_seq
                  inner join tblmanager m on m.manager_seq = stu.manager_seq
    where rownum =1 and su.student_seq = (select stu.student_seq from tblstudent stu where stu.id = 'qrs102' and substr(stu.ssn,7) = '2325740');
-- 2. 관리자 상담신청
insert into tblCounsel
select 
    (select counsel_seq from(select * from tblCounsel order by counsel_seq desc) where rownum = 1)+1,
    '관리자',
    '테스트 상담 테스트',
    sysdate,
    su.sugang_seq ,
    t.teacher_seq,
    m.manager_seq
from tblsugang su inner join tbllclass lc on su.lclass_seq = lc.lclass_seq
                  inner join tbllsubject ls on ls.lclass_seq = lc.lclass_seq
                  inner join tblteacher t on t.teacher_seq = ls.teacher_seq
                  inner join tblstudent stu on stu.student_seq = su.student_seq
                  inner join tblmanager m on m.manager_seq = stu.manager_seq
    where rownum =1 and su.student_seq = (select stu.student_seq from tblstudent stu where stu.id = 'qrs102' and substr(stu.ssn,7) = '2325740');    
select * from tblCounsel where sugang_seq = 6;--test
--------------------------------------------------D-05 상담 신청-------------------------------------------------------
rollback;
commit;