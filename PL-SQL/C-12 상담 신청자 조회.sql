--------------------------------------------------C-12 상담 신청자 조회--------------------------------------------------------
--업무영역
--교사
--요구사항 명
--C-14, 상담 신청자 조회
--개요
--교육생의 상담 신청 현황을 확인한다.
--	교육생의 상담 신청 여부를 확인할 수 있다.
---	교육생의 이름, 과정명, 강의실 등을 확인할 수 있다.

--pl/Sql
--1 . 조회
create or replace procedure ProTCounselSearch(
    pid  in tblteacher.id % type,
    ppw  in tblteacher.jumin % type
)
is
    seq number;
    d date;
    name tblstudent.name%type;
    class tblclass.name%type;
    room number;
    counsel tblcounsel.purpose%type;
    cursor vcursor is select 
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
                                  t.teacher_seq = (select teacher_seq from tblteacher where id = pid and jumin = ppw)
                            order by con.counsel_date ; -- 현재 로그인된 교사의 개설 과정을 수강 중인 학생의 상담내역 확인
begin
    select teacher_seq into seq from tblteacher where teacher_seq = (select teacher_seq from tblteacher where id = pid and jumin = ppw);
    open vcursor;
        LOOP
            fetch vcursor into d,name,class,room,counsel;
            exit when vcursor%notfound;
            dbms_output.put_line('=========================================================================================================================================================================================');
            dbms_output.put_line('날짜 : ' || to_char(d,'yyyy-mm-dd')||' 이름: '||name||' 과정명 : '||class||' 강의실: '||room||' 상담 신청 내용: '|| counsel );
            dbms_output.put_line('=========================================================================================================================================================================================');
        end loop;
    close vcursor;
exception
    when others then
    dbms_output.put_line('              권한이 없습니다. 로그인 정보를 다시 확인하세요');
    dbms_output.put_line('');
    dbms_output.put_line('          ================================================');
end;
-- 실행
begin
    ProTCounselSearch('tpdls1990',1234927);
end;
--------------------------------------------------C-12 상담 신청자 조회--------------------------------------------------------