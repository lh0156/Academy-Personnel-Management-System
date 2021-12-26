create or replace procedure procSSerchProject
is
    cursor vcursor is select * from tblproboard;
    vrow tblproboard%rowtype;
begin
    dbms_output.put_line('====================================================================================================================================================');
    open vcursor;
    loop
        fetch vcursor into vrow;
        exit when vcursor%notfound;
        dbms_output.put_line('프로젝트 명: ' || vrow.project_name ||
        '   내용: ' ||vrow.content ||
        '   프로젝트 마감 기한: ' ||vrow.period ||
        '   인원 수: ' || vrow.limit ||
        '   이메일: ' || vrow.email );
        dbms_output.put_line('====================================================================================================================================================');
    end loop;
    close vcursor;
        exception
    when others then
        dbms_output.put_line('====================================================================================');
        dbms_output.put_line('잘못된 접근으로 발생한 오류입니다.');
        dbms_output.put_line('====================================================================================');
end;



begin
    procSerchProject();
end;

-- 프로젝트 등록
create or replace procedure procProjectWrite(
    pId in tblstudent.id%type,
    pPw in tblstudent.ssn%type,
    pProjectName in tblproboard.project_name%type,
    pContent in tblproboard.content%type,
    pPeriod in tblproboard.period % type,
    pLimit in tblproboard.limit%type,
    pEmail in tblproboard.Email%type
)
is seq number := 0;
begin
    select sugang_seq into seq from tblsugang where student_seq = (select student_seq from tblstudent stu where id = pId and substr(stu.ssn,7) = pPw);
    dbms_output.put_line('====================================================================================');
    
    if seq>0 then
        insert into tblproboard values (
        (select max(proboard_seq+1) from tblproboard),
        pProjectName,
        pContent,
        pPeriod,
        pLimit,
        pEmail,
        seq);
        
        dbms_output.put_line('                           프로젝트 등록이 완료되었습니다.');
        
        dbms_output.put_line('====================================================================================');
    
    end if;
        exception
    when others then
        dbms_output.put_line('====================================================================================');
        dbms_output.put_line('ID, PASSWORD 오류입니다.');
        dbms_output.put_line('====================================================================================');
end;

select * from tblproboard;

begin
procProjectWrite('abc007',
'1115158',
'자바의 왕', -- 프로젝트 명
'값진 시간ㄹㄹㄹㄹ이 될겁니다.', -- 프로젝트 내용
'22/05/01', -- 프로젝트 종료일자
5, -- 인원수
'lh0156@nave.com'); -- 이메일
end;