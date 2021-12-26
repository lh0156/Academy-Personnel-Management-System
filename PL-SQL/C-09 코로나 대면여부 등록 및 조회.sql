-- C-9

-- 코로나 대면여부 조회

create or replace procedure proctFindCovidTAttendance(
    pid tblteacher.id % type,
    ppw tblteacher.jumin % type
)
is
    cattendance tblcovidt.attendance%type;
    tname tblteacher.name%type;
    cfacetoface tblcovidt.facetoface%type;
    resultAttend1 varchar2(100);
    resultAttend2 varchar2(100);
    resultAttend3 varchar2(100);
    cursor vcursor 
is 
SELECT 
     c.attendance,
     t.name,
     c.facetoface
     
FROM tblCovidT c
    LEFT JOIN tblTeacher t
        ON c.Teacher_Seq = t.Teacher_Seq
        
WHERE 1=1
AND t.teacher_seq = (select teacher_seq from tblteacher where pid = id and jumin = ppw)
AND c.attendance between sysdate and sysdate+7;

begin
    dbms_output.put_line('====================================================================================');
    
  open vcursor;
    loop
      fetch vcursor into cAttendance, tname, cFacetoFace;
      exit when vcursor%notfound;
      resultAttend1 := substr(to_char(cAttendance), 1, 2);
      resultAttend2 := substr(to_char(cAttendance), 4, 2);
      resultAttend3 := substr(to_char(cAttendance), 7, 2);
      dbms_output.put_line('20' ||resultAttend1 || '년 ' || resultAttend2 || '월 ' || resultAttend3 || '일 : ' || cFacetoFace || ' 이름 : ' || tname);

    end loop;
    close vcursor;
exception
    when others then
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');        
        
end;



begin
    proctFindCovidTAttendance('tpdls1990',1234927);
end;


-- 대면여부 변경

SELECT * FROM tblcovidt;
SELECT * FROM tblstudent;

create or replace procedure proctChangeCovidTAttendance(
    pid tblteacher.id % type,
    ppw tblteacher.jumin % type,
    pftf in tblcovidt.facetoface%type,
    pAt in tblcovidt.attendance%type
)
is 
    seq number:= 0;
begin
    select teacher_seq into seq from tblteacher where teacher_seq = (select teacher_seq from tblteacher t where id = pid and jumin = ppw);
    if seq>0 then
        update tblcovidt set facetoface = pftf where teacher_seq = seq and attendance = pAt;
        dbms_output.put_line('완료');
    else
        dbms_output.put_line('ID 또는 패스워드가 틀립니다.');
    end if;
exception
    when others then
        dbms_output.put_line('잘못된 입력');
        dbms_output.put_line('====================================================================================');
end;
    
    

begin
    --proctChangeCovidTAttendance(대면여부, 날짜);
    proctChangeCovidTAttendance('tpdls1990',1234927, 'Y', '21/12/09');
end;

