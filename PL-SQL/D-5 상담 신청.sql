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
-- 1. 관리자 & 선생님 상담신청

create or replace PROCEDURE ProSCounselAdd(
    pid in tblstudent.id%type,
    ppw in tblstudent.ssn%type,
    PTARGET in tblCounsel.TARGET%type,
    PPURPOSE in tblCounsel.PURPOSE%type
)
is
    vcheck number:=0;
begin
    select 1 into vcheck  from tblsugang su where su.student_seq = ( select stu.student_seq from tblstudent stu where stu.id = pid and substr(stu.ssn,7) = ppw);
    if vcheck <> 0 then
        insert into tblCounsel
        select 
            (select counsel_seq from(select * from tblCounsel order by counsel_seq desc) where rownum = 1)+1,
            PTARGET,
            PPURPOSE,
            sysdate,
            su.sugang_seq ,
            t.teacher_seq,
            m.manager_seq
        from tblsugang su inner join tbllclass lc on su.lclass_seq = lc.lclass_seq
                          inner join tbllsubject ls on ls.lclass_seq = lc.lclass_seq
                          inner join tblteacher t on t.teacher_seq = ls.teacher_seq
                          inner join tblstudent stu on stu.student_seq = su.student_seq
                          inner join tblmanager m on m.manager_seq = stu.manager_seq
            where rownum =1 and su.student_seq = (select stu.student_seq from tblstudent stu where stu.id = pid and substr(stu.ssn,7) = ppw);
        dbms_output.put_line('=========================================================================================================================================================================================');
        dbms_output.put_line('완료');
        dbms_output.put_line('=========================================================================================================================================================================================');
    end if;
exception
    when others then
    dbms_output.put_line('              권한이 없습니다. 로그인 정보를 다시 확인하세요');
    dbms_output.put_line('');
    dbms_output.put_line('          ================================================');
end;
-- 실행 
begin
    ProSCounselAdd('qrs102','2325740','선생님','프로시저 테스트 중 입니다.');
end;
-- 확인용
select * from tblCounsel where sugang_seq =6 and teacher_seq =11 and target = '선생님';
select * from tblCounsel where sugang_seq =6 and manager_seq =1 and target = '관리자';
--------------------------------------------------D-05 상담 신청-------------------------------------------------------
rollback;
commit;