-- 더미 데이터 중에서 sugang_seq가 1이고 선생님을 5로 잡고있는 놈이 하나 있음.
delete from tblassessment where assessment_seq = 9;

-- 교사 평가 조회 (프로시저 생성)
create or replace procedure procSTeacherAssessMentCheck(
    pId in tblstudent.id%type,
    pPw in tblstudent.ssn%type
)
is
    pContents tblassessment.contents%type;
    pregdate tblassessment.regdate%type;
    resultContents varchar2(500);
    resultDate varchar2(100);
    seq number := 0;
    cursor vcursor is select
                        a.contents,
                        a.regdate
from tblsugang s
    inner join tblassessment a on a.sugang_seq = s.sugang_seq
            where a.teacher_seq = (select distinct teacher_seq from tblassessment a inner join tblsugang s on a.sugang_seq = s.sugang_seq
            where s.sugang_seq = (select sugang_seq from tblsugang 
            where student_seq = (select student_seq from tblstudent stu where id = pId and substr(stu.ssn,7) = pPw))) and
            a.regdate > (select student.attenddate from tblsugang sugang
            inner join tblstudent student on sugang.student_seq = student.student_seq
            where sugang.sugang_seq = (select sugang_seq from tblsugang
            where student_seq = (select sugang_seq from tblsugang
            where student_seq = (select student_seq from tblstudent stu
            where id = pId and substr(stu.ssn,7) = pPw))));
begin
    dbms_output.put_line('==================================교사 평가===========================================');
  open vcursor;
    loop
      fetch vcursor into pContents, pregdate;
      exit when vcursor%notfound;
      dbms_output.put_line('평가내용: '||pContents||'  날짜: '||pregdate);
      
      dbms_output.put_line('====================================================================================');
    end loop;
    close vcursor;
end;

-- 교사 평가 조회 (프로시저 사용)
begin
    procSTeacherAssessMentCheck('abc007', '1115158');
end;


select * from tblassessment;

-- 교사 평가 작성
create or replace procedure procSTeacherAssessMentWrite(
    pId in tblstudent.id%type,
    pPw in tblstudent.ssn%type,
    pInput in tblassessment.contents%type
)
is 
    seq number:= 0;
begin
    select sugang_seq into seq from tblsugang where student_seq = (select student_seq from tblstudent stu where id = pId and substr(stu.ssn,7) = pPw);
    if seq>0 then
        insert into tblassessment values((select max(assessment_seq)+1 from tblassessment),
        pInput,
        sysdate,
        seq,
        (select distinct teacher_seq from tblassessment a inner join tblsugang s on a.sugang_seq = s.sugang_seq 
        where s.sugang_seq = (select sugang_seq from tblsugang where student_seq = 
        (select student_seq from tblstudent stu where id = pId and substr(stu.ssn,7) = pPw))));
        dbms_output.put_line('교사 평가 작성이 완료되었습니다.');
    else
        dbms_output.put_line('ID 또는 PW 워드가  틀립니다.');
    end if;
end;


begin
    procSTeacherAssessMentWrite('abc007', '1115158', '호호호'); -- 아이디, 비밀번호, 평가내용
end;




-- 교사 평가 추가
insert into tblassessment values((select max(assessment_seq)+1 from tblassessment),
'최고의 센세',
sysdate,
(select sugang_seq from tblsugang where student_seq = (select student_seq from tblstudent stu where id = 'abc007' and substr(stu.ssn,7) = '1115158')),
(select distinct teacher_seq from tblassessment a inner join tblsugang s on a.sugang_seq = s.sugang_seq where s.sugang_seq = 
(select sugang_seq from tblsugang where student_seq = 
(select student_seq from tblstudent stu where id = 'abc007' and substr(stu.ssn,7) = '1115158'))));