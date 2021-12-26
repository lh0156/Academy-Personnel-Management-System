-- 기수보드 조회(프로시저 등록)
create or replace procedure procSGisuBoardSerch (
    pId in tblstudent.id%type,
    pPw in tblstudent.ssn%type
)
is
    pTitle varchar2(200);
    pDate varchar2(200);
cursor vcursor is select
                    title,
                    gisuboard_date 
    from tblgisuboard
    where sugang_seq between (select min(sugang_seq) from tblsugang
    where lclass_seq = (select lclass_seq from tblsugang
    where sugang_seq = (select student_seq from tblstudent stu
        where id = pId and substr(stu.ssn,7) = pPw ))) and
                            (select max(sugang_seq) from tblsugang
    where lclass_seq = (select lclass_seq from tblsugang
    where sugang_seq = (select student_seq from tblstudent stu
        where id = pId and substr(stu.ssn,7) = pPw)));
    
begin
dbms_output.put_line('====================================================================================================================================================');
    open vcursor;
    loop
    fetch vcursor into pTitle, pDate;
    dbms_output.put_line('게시글 명: ' || pTitle ||
        '   게시일자: ' || pDate);
        dbms_output.put_line('====================================================================================================================================================');
    exit when vcursor%notfound;
    
    end loop;
    close vcursor;
    
    exception
    when others then
        dbms_output.put_line('====================================================================================');
        dbms_output.put_line('ID, PASSWORD 오류입니다.');
        dbms_output.put_line('====================================================================================');
    
end;

-- 기수보드 조회(프로시저 사용)
begin
    procSGisuBoardSerch('abc007', '1115158');
end;



create or replace procedure procGisuBoardWrite(
    pId in tblstudent.id%type,
    pPw in tblstudent.ssn%type,
    pTitle in tblgisuboard.title%type
)
    is
    seq number := 0;
begin
    dbms_output.put_line('====================================================================================');
    select sugang_seq into seq from tblsugang where student_seq = (select student_seq from tblstudent stu where id = pId and substr(stu.ssn,7) = pPw);
    if seq>0 then
        
        insert into tblgisuboard values ((select max(gisuboard_seq+1) from tblgisuboard),
        pTitle,
        sysdate,
        seq);
        dbms_output.put_line('                        게시글 작성이 완료되었습니다.');
        dbms_output.put_line('====================================================================================');
    else
        dbms_output.put_line('ID 또는 패스워드가 틀립니다.');
        
        dbms_output.put_line('====================================================================================');
    end if;
        exception
    when others then
        dbms_output.put_line('====================================================================================');
        dbms_output.put_line('ID, PASSWORD 오류입니다.');
        dbms_output.put_line('====================================================================================');
end;
    
begin
    procGisuBoardWrite('abc007', '1115158', '테스트 1234');
end;
