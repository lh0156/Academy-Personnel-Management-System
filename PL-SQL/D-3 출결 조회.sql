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

-- 1. 본인 출결 전체 및 날짜별 조회
create or replace procedure ProSAttendSelSearch(
    pid in tblstudent.id%type,
    ppw in tblstudent.ssn%type,
    psel in varchar2
)
is  
    vcheck NUMBER;
    studentName tblstudent.name%type;
    attendDate tblattendence.attendence_date%type;
    absenceType tblattendence.absence_type%type;
    vGoToWork varchar2(6);
    vOffWork varchar2(6);
    cursor vcursor is select 
                            stu.name,
                            at.attendence_date,
                            at.absence_type,
                            to_char(at.gotowork , 'HH24:mi') as gotowork,
                            to_char(at.offwork , 'HH24:mi') as offwork
                        from tblstudent stu inner join tblsugang su on stu.student_seq =su.student_seq
                                            inner join tblattendence at on at.sugang_seq = su.sugang_seq
                            where   to_char(at.attendence_date ,'yyyy-mm-dd')like (psel||'%') and
                                    stu.student_seq = (select stu.student_seq from tblstudent stu where stu.id = pid and substr(stu.ssn,7) = ppw); -- 로그인 후 학생 번호를 돌려주는 쿼리
begin
    select 1 into vcheck  from tblsugang su where su.student_seq = ( select stu.student_seq from tblstudent stu where stu.id = pid and substr(stu.ssn,7) = ppw);
    open vcursor;
        LOOP
            fetch vcursor into studentName ,attendDate  ,absenceType ,vGoToWork ,vOffWork;
            exit when vcursor%notfound;
            dbms_output.put_line('=========================================================================================================================================================================================');
            dbms_output.put_line(' 이름 : '||studentName||' | 출석 '||attendDate||' | 출결 종류 : '||absenceType||' | 입실 시간 : '||vGoToWork||' | 퇴실 시간 : '||vOffWork);
            dbms_output.put_line('=========================================================================================================================================================================================');
        end loop;
    close vcursor;
exception
    when others then
    dbms_output.put_line('              권한이 없습니다. 로그인 정보를 다시 확인하세요');
    dbms_output.put_line('');
    dbms_output.put_line('          ================================================');  
end;

-- 3. 출결 입력
-------1. 출근
create or replace procedure ProSGoTowork(
    pid in tblstudent.id%type,
    ppw in tblstudent.ssn%type
)
is
    vcheck number:=0;
begin
    select 1 into vcheck  from tblsugang su where su.student_seq = ( select stu.student_seq from tblstudent stu where stu.id = pid and substr(stu.ssn,7) = ppw);
    if vcheck <> 0 then
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
            where su.student_seq = ( select stu.student_seq from tblstudent stu where stu.id = pid and substr(stu.ssn,7) = ppw) ;
        dbms_output.put_line('=========================================================================================================================================================================================');
        dbms_output.put_line('출근완료');
        dbms_output.put_line('=========================================================================================================================================================================================');
    end if;
exception
    when others then
    dbms_output.put_line('              권한이 없습니다. 로그인 정보를 다시 확인하세요');
    dbms_output.put_line('');
    dbms_output.put_line('          ================================================');  
end;

-------2. 퇴근
create or replace procedure ProSOffWork(
    pid in tblstudent.id%type,
    ppw in tblstudent.ssn%type
)
is
    vcheck number:=0;
begin
    select 1 into vcheck  from tblsugang su where su.student_seq = ( select stu.student_seq from tblstudent stu where stu.id = pid and substr(stu.ssn,7) = ppw);
    if vcheck <> 0 then
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
                                                                                                        where stu.id = pid and substr(stu.ssn,7) = ppw) 
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
                                                                                                        where stu.id = pid and substr(stu.ssn,7) = ppw) 
                                                                              order by attendence_seq desc) 
                                                                       where rownum =1); -- 로그인 한 학생이 마지막에 남김 정보
        dbms_output.put_line('=========================================================================================================================================================================================');
        dbms_output.put_line('퇴근완료');
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
    ProSAttendSelSearch('qrs102','2325740','2021-12');
end;
begin
    ProSGoTowork('qrs102','2325740');
end;
begin
    ProSOffWork('qrs102','2325740');
end;
-----------------------------------------------------D-03 출결-------------------------------------------------------------
commit;
rollback;