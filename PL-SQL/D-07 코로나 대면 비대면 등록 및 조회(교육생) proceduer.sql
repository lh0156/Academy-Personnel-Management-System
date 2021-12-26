/*

제약사항
본인의 정보만 조회할 수 있다.
sysdate를 기준으로 다음주(+7일)의 교육만 대면 / 비대면 을 선택 할 수 있다.

*/
-- create문에 unieuq 제약 걸어야할듯
-- 건 다음 '가' 실행
-- 이거 다 끝난다음 걸어보자!


-- 적용 필요사항
delete from tblcovids where covids_seq = 455;
delete from tblcovids where covids_seq = 457;

select * from tblcovids;

insert into tblcovids values (455, '21/12/08', 'N', 1);
insert into tblcovids values (456, '21/12/09','N', 1);
insert into tblcovids values (457, '21/12/10','N', 1);
insert into tblcovids values (458, '21/12/13','N', 1);



create or replace procedure procCovidAttendanceExpand 
insert into tblcovids values ((select max(covids_seq+1) from tblcovids),
sysdate,
'N',
(select student_seq from tblstudent stu
        where id = 'abc007' and substr(stu.ssn,7) = '1115158')
);


-- 코로나 대면, 비대면 조회(프로시저 생성)
create or replace procedure procScovidIsFacetoFaceCheck(
    pId in tblstudent.id%type,
    pPw in tblstudent.ssn%type
)
is
    pAttendance tblcovids.attendance%type;
    pFacetoFace tblcovids.facetoface%type;
    resultAttend1 varchar2(100);
    resultAttend2 varchar2(100);
    resultAttend3 varchar2(100);
    cursor vcursor is select
                        attendance,
                        facetoface
                    from tblcovids 
                    where sugang_seq = (select sugang_seq from tblsugang where student_seq = (select student_seq from tblstudent stu where id = pId and substr(stu.ssn,7) = pPw))
                                        and attendance between sysdate and sysdate+7;
begin
    
  open vcursor;
  dbms_output.put_line('====================================================================================');
    loop
      fetch vcursor into pAttendance, pFacetoFace;
      exit when vcursor%notfound;
      resultAttend1 := substr(to_char(pAttendance), 1, 2);
      resultAttend2 := substr(to_char(pAttendance), 4, 2);
      resultAttend3 := substr(to_char(pAttendance), 7, 2);
      dbms_output.put_line('                          20' ||resultAttend1 || '년 ' || resultAttend2 || '월 ' || resultAttend3 || '일 : ' || pFacetoFace);
    end loop;
    dbms_output.put_line('====================================================================================');
    close vcursor;
        
            exception
    when others then
        dbms_output.put_line('====================================================================================');
        dbms_output.put_line('ID, PASSWORD 오류입니다.');
        dbms_output.put_line('====================================================================================');
end;


-- 코로나 대면, 비대면 조회(프로시저 사용)
set serverout on;
begin
    procScovidIsFacetoFaceCheck('abc007', '1115158');
end;





select * from tblcovids;


-- 코로나 대면 비대면 변경(프로시저 생성)
create or replace procedure procScovidIsFacetoFaceChange(
    pId in tblstudent.id%type,
    pPw in tblstudent.ssn%type,
    pftf in tblcovids.facetoface%type,
    pAt in tblcovids.attendance%type
)
is 
    seq number:= 0;
begin
    select sugang_seq into seq from tblsugang where student_seq = (select student_seq from tblstudent stu where id = pId and substr(stu.ssn,7) = pPw);
    dbms_output.put_line('====================================================================================');
    if seq>0 then
        update tblcovids set facetoface = pftf where sugang_seq = seq and attendance = pAt;
        dbms_output.put_line('20'||
        substr(pAT, 1, 2) ||
        '년 ' ||
        substr(pAT, 4, 2) ||
        '월 ' ||
        substr(pAT, 7, 2) ||
        '일의 대면 여부가 "' ||
        pftf ||
        '" 로 변경 되었습니다.');
    
    end if;
    dbms_output.put_line('====================================================================================');
    exception
    when others then
        dbms_output.put_line('====================================================================================');
        dbms_output.put_line('ID, PASSWORD 오류입니다.');
        dbms_output.put_line('====================================================================================');
end;
    

-- 코로나 대면 비대면 변경(프로시저 사용)
begin
    procScovidIsFacetoFaceChange('abc007', '1115158', 'Y', '21/12/09');
end;
    
    
