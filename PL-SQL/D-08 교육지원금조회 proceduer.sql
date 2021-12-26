create or replace procedure procScovidIsFacetoFaceChange(
    pId in tblstudent.id%type,
    pPw in tblstudent.ssn%type,
    pPeriod in tbledu_subsidy.period%type
)is 
    pname tblstudent.name%type;
    pPrice number(10);
    pRePeriod number(10);
cursor vcursor is select 
    st.name, -- 이름
    es.period, -- 단위기간
    es.edu_subsidy_date*18000 -- 교육 지원금
        from tblEdu_Subsidy es
    inner join tblsugang su on es.sugang_seq = su.sugang_seq
    inner join tblstudent st on su.student_seq = st.student_seq
    where su.sugang_seq = (select sugang_seq from tblsugang where student_seq = 
    (select student_seq from tblstudent stu where id = pId and substr(stu.ssn,7) = pPw)) and
          es.period = pPeriod;
begin
    dbms_output.put_line('====================================================================================');
    
  open vcursor;
    loop
    fetch vcursor into pname, pRePeriod, pRePeriod;
    exit when vcursor%notfound;
    
    dbms_output.put_line('                   '||'이름: '||pname||'/'||'단위기간: '|| pPeriod || '차' || '/' || '교육지원금: ' || pRePeriod || '원');
    end loop;
    close vcursor;
    
    dbms_output.put_line('====================================================================================');
        exception
    when others then
        dbms_output.put_line('====================================================================================');
        dbms_output.put_line('ID, PASSWORD 오류입니다.');
        dbms_output.put_line('====================================================================================');
    
end;

begin
    procScovidIsFacetoFaceChange('abc007', '1115158', 1);
end;

