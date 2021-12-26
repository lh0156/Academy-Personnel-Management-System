-------------------------------------------------------D-01 계정-------------------------------------------------------------
--업무영역
--교육생
--요구사항 명
--D-01 교육생 계정
--개요
--교육생 계정
--
--상세설명
---	교육생은 시스템의 일부 기능을 로그인 과정을 거친후에 사용할 수 있다.
---	교육생은 성적 조회 기능을 이용할 수 있다.
--
--
--     제약사항
---	사전에 관리자에 의해 데이터베이스에 등록된 것으로 간주한다.
-- ID : qrs102
-- PW : 2325740

--pl/sql
--1. 기본 정보 조회
create or replace procedure ProSAccountBasicSearch(
    pid in tblstudent.id%type,
    ppw in tblstudent.ssn%type
)
is  
    vcheck number;
    vname tblstudent.name%type;
    vid tblStudent.id%type;
    vssn tblstudent.ssn%type;
    vtel tblstudent.tel%type;
    vd tblstudent.attenddate%type;
    vedu tblstudentspec.EDUCATION%type;
    vcer tblstudentspec.certificate%type;
    vcity tblwishjob.city%type;
    vpay tblwishjob.basicpay%type;
    cursor vcursor is select
                            student.name as "이름",
                            student.id as "아이디",
                            student.ssn as "주민번호",
                            student.tel as "전화번호",
                            student.attenddate as "회원가입일",
                            stuspec.education as "최종 학력",
                            stuspec.certificate as "자격증",
                            wish.city as "희망 지역",
                            wish.basicpay as "희망 월급"
                        from tblstudent student inner join tblstudentspec stuSpec on student.student_seq = stuspec.student_seq
                                                inner join tblwishjob wish on wish.student_seq = student.student_seq
                            where student.student_seq = (select 
                                                            student_seq 
                                                        from tblstudent 
                                                            where id = pid and substr(ssn,7) = ppw);
begin
    select 1 into vcheck  from tblsugang su where su.student_seq = ( select stu.student_seq from tblstudent stu where stu.id = pid and substr(stu.ssn,7) = ppw);
    open vcursor;
        loop
            fetch vcursor into vname,vid,vssn,vtel,vd,vedu,vcer,vcity,vpay;
            exit when vcursor%notfound;
            dbms_output.put_line('=========================================================================================================================================================================================');
            dbms_output.put_line('이름 : '||vname||' |아이디 : '||vid||' |주민번호 : ' ||vssn||' |전화번호 : '||vtel||' |회원가입일 : '||vd
                                    || ' |최종학력 : '||vedu||' |자격증 : '||vcer|| ' |희망 지역 : '||vcity||' |희망 월급 : '||vpay);
            dbms_output.put_line('=========================================================================================================================================================================================');
        end loop;
    close vcursor;
exception
    when others then
    dbms_output.put_line('              권한이 없습니다. 로그인 정보를 다시 확인하세요');
    dbms_output.put_line('');
    dbms_output.put_line('          ================================================');
end;
-- 현재 수강중인 과정 및 과정명 ,담당 교사 ,기간 등 확인.
create or replace procedure ProSAccountSugangSearch(
    pid in tblstudent.id%type,
    ppw in tblstudent.ssn%type
)
is
    vcheck number;
    vsname tblstudent.name%type;
    vclassName tblclass.name%type;
    vsubjectName tblsubject.name%type;
    vbook tblbookname.name%type;
    vsd tbllclass.startclassdate%type;
    ved tbllclass.finishclassdate%type;
    vroom tblclassroom.name % type;
    vtName tblteacher.name % type;
    cursor vcursor is select
                            student.name as "이름",
                            class.name as "과정명",
                            sub.name as "과목명",
                            book.name as "교재명",
                            lsub.start_date as "과목 시작날짜",
                            lsub.end_date as "과목 종료날짜",
                            room.name as "강의실",
                            teacher.name as "담당 선생님 이름"
                        from tblstudent student  
                            inner join  tblsugang sugang    on student.student_seq = sugang.student_seq
                            inner join tbllclass lclass     on lclass.lclass_seq = sugang.lclass_seq
                            inner join tblclass class       on class.class_seq = lclass.class_seq
                            inner join tbllsubject lsub     on lsub.lclass_seq = lclass.lclass_seq
                            inner join tblsubject sub       on sub.subject_seq = lsub.subject_seq
                            inner join tblbookname book     on book.bookname_seq = lsub.bookname_seq
                            inner join tblclassroom room    on room.classroom_seq = lclass.classroom_seq
                            inner join tblteacher teacher   on teacher.teacher_seq = lsub.teacher_seq
                                where student.student_seq = (select 
                                                            student_seq 
                                                        from tblstudent 
                                                            where id = pid and substr(ssn,7) = ppw);
begin
    select 1 into vcheck  from tblsugang su where su.student_seq = ( select stu.student_seq from tblstudent stu where stu.id = pid and substr(stu.ssn,7) = ppw);
    open vcursor;
        loop
            fetch vcursor into vsname,vclassName,vsubjectName,vbook,vsd,ved,vroom,vtName;
            exit when vcursor%notfound;
            dbms_output.put_line('=========================================================================================================================================================================================');
            dbms_output.put_line('이름 : '||vsname||' 과정명 : '||vclassName||' 과목명 :    '||vsubjectName||' 책 이름 : '||vbook );
            dbms_output.put_line('=========================================================================================================================================================================================');
            dbms_output.put_line('시작 날짜 : '|| vsd||' 강의실 : '||vroom||' 종료 날짜 : '||ved||' 선생님 : '||vtName);
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
    ProSAccountBasicSearch('qrs102','2325740');
end;
begin
    ProSAccountSugangSearch('qrs102','2325740');
end;
-------------------------------------------------------D-01 계정-------------------------------------------------------------