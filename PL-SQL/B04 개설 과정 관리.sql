--B04
--B04 개설 과정 관리
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--수료날짜 지정 -> lclass finishclassdate 조절

create or replace procedure procMFixFinishClass(
    pseq number,
    pdate date
)
is
begin
    update tbllclass set finishclassdate = pdate where lclass_seq = pseq;
    exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end procMFixFinishClass;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMFixFinishClass(1, '22/12/15');
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--강의실 정보 수정
create or replace procedure procMFixLClassClassRoom(
    pseq number,
    pcseq number
)
is
begin
    update tbllclass set classroom_Seq = pcseq where lclass_seq = pseq;
    exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end procMFixLClassClassRoom;

--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMFixLClassClassRoom(1, 5);
end;

--개설 과정 정보에 대한 입력, 출력, 수정, 삭제 기능을 사용할 수 있어야 한다.
-- 개설 과정 정보 출력
create or replace procedure procMLClassInfo
is          
    vrow vwMLclass%rowtype;
    cursor vcursor
        is select * from vwMLClass;
begin
    open vcursor;
    loop
    fetch vcursor into vrow;
    exit when vcursor%notfound;
    dbms_output.put_line('==============================================================================================');

    dbms_output.put_line('시작날: ' || vrow.개설시작날 || '  종료날: ' || vrow.개설끝날 || '  과목명: ' || vrow.개설과목명 || '  강의실: ' || vrow.강의실 || '  교재명: ' || vrow.교재명 || '  교사명: ' || vrow.교사이름 || '  강의진행여부: ' || vrow.강의진행여부);
    
    end loop;
    close vcursor;
    dbms_output.put_line('==============================================================================================');
exception
    when others then
    dbms_output.put_line('===================================================');           
    dbms_output.put_line('              잘못 입력하였습니다.');
    dbms_output.put_line('===================================================');  
end;
--000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
begin
    procMLClassInfo;
end;
commit;
---------------------------------------------------------------------------------------------------------------------------------------------------------------
----삭제
--ALTER TABLE tbllsubject DISABLE CONSTRAINT TBLLSUBJECT_LCLASS_SEQ_FK;
--ALTER TABLE tbllsubject ENABLE CONSTRAINT TBLLSUBJECT_LCLASS_SEQ_FK; 


    create or replace procedure procMDeleteLclass(
        pnum number
    )
    is
    begin
        delete from tbllclass where Lclass_seq = pnum;
    end;
        
    begin
        procMdeleteLclass(100);
    end;