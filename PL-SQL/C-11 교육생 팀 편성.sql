---------------------------------------------------C-11 교육생 팀편성-------------------------------------------------------
--업무영역
--교육생 팀편성 등록
--요구사항 명
--C-13. 교육생 팀편성 
--개요
--교사가 팀 편성에 관한 업무를 볼 수 있다.
--
--상세설명
--
--- 교사는 교육생들의 팀을 편성 하고 등록 할 수 있다.
--
--
--제약사항
--
--- 교사는 등록, 수정, 삭제 가능하다.
--ID : tpdls1990
--PW : 1234927
-- 삭제

-- 5명 10번팀으로 추가

-- 1. pl/sql
-- 1. 검색
create or replace procedure proTTeamFormationSearch(
    pid  in tblteacher.id % type,
    ppw  in tblteacher.jumin % type
)
is
    name tblstudent.name%type;
    seq number;
    team number null;
    vcheck number;
    cursor vcursor is select 
                            DISTINCT(s.name),
                            su.sugang_seq,
                            team.team
                        from tbllsubject lsub inner join tblteacher t on lsub.teacher_seq = t.teacher_seq
                                                inner join tbllclass lc on lsub.lclass_seq = lc.class_seq
                                                inner join tblsugang su on su.lclass_seq = lc.class_seq
                                                inner join tblstudent s on s.student_seq = su.student_seq
                                                left outer join tblteam team on team.sugang_seq = su.sugang_seq
                            where t.teacher_seq = (select teacher_seq from tblteacher where pid = id and jumin = ppw)
                            order by sugang_seq asc;
begin
    select teacher_seq into vcheck from tblteacher where teacher_seq = (select teacher_seq from tblteacher where pid = id and jumin = ppw);
    open vcursor;
        loop
            fetch vcursor into name , seq , team;
            exit when vcursor%notfound;
            dbms_output.put_line('=========================================================================================================================================================================================');
            dbms_output.put_line('이름:'||name || '  수강 번호: ' || seq || '  팀: ' || team);
        end loop;
    close vcursor;
    dbms_output.put_line('=========================================================================================================================================================================================');
exception
    when others then
    dbms_output.put_line('              권한이 없습니다. 로그인 정보를 다시 확인하세요');
    dbms_output.put_line('');
    dbms_output.put_line('          ================================================');
end;

--2 수정
create or replace procedure proTTeamFormationChange(
   pid  in tblteacher.id % type,
   ppw  in tblteacher.jumin % type,
   t    in number,
   student1 in number,
   student2 in number,
   student3 in number,
   student4 in number,
   student5 in number,
   student6 in number
)
is
    seq number:=0;
begin
    select teacher_seq into seq from tblteacher where teacher_seq = (select teacher_seq from tblteacher where id = pid and jumin = ppw);
    if seq>0 then
        UPDATE tblteam set team = t WHERE sugang_seq in(student1,student2,student3,student4,student5,student6);
        dbms_output.put_line('=========================================================================================================================================================================================');
        dbms_output.put_line('완료');
        dbms_output.put_line('=========================================================================================================================================================================================');
    end if;
exception
    when others then
    dbms_output.put_line('              권한이 없습니다. 로그인 정보를 다시 확인하세요');
    dbms_output.put_line('');
    dbms_output.put_line('          ================================================');
end;
--3 삭제
create or replace procedure proTTeamFormationRemove(
   pid  in tblteacher.id % type,
   ppw  in tblteacher.jumin % type,
   student1 in number,
   student2 in number,
   student3 in number,
   student4 in number,
   student5 in number,
   student6 in number
)
is
    seq number:=0;
begin
    
    select teacher_seq into seq from tblteacher where teacher_seq = (select teacher_seq from tblteacher where id = pid and jumin = ppw);
    if seq>0 then
        delete from tblteam where sugang_seq in(student1,student2,student3,student4,student5,student6);
        dbms_output.put_line('=========================================================================================================================================================================================');
        dbms_output.put_line('완료');
        dbms_output.put_line('=========================================================================================================================================================================================');
   end if;
exception
    when others then
    dbms_output.put_line('              권한이 없습니다. 로그인 정보를 다시 확인하세요');
    dbms_output.put_line('');
    dbms_output.put_line('          ================================================');
end;
--4 추가 
create or replace procedure proTTeamFormationAdd(
   pid  in tblteacher.id % type,
   ppw  in tblteacher.jumin % type,
   t    in number,
   student1 in number,
   student2 in number,
   student3 in number,
   student4 in number,
   student5 in number,
   student6 in number
)
is
    seq number:=0;
    vcheck1 number:=0;
    vcheck2 number:=0;
    vcheck3 number:=0;
    vcheck4 number:=0;
    vcheck5 number:=0;
    vcheck6 number:=0;
begin
    select teacher_seq into seq from tblteacher where teacher_seq = (select teacher_seq from tblteacher where id = pid and jumin = ppw);
    select count(*) into vcheck1 from tblteam where sugang_seq = student1;
    select count(*) into vcheck2 from tblteam where sugang_seq = student2;
    select count(*) into vcheck3 from tblteam where sugang_seq = student3;
    select count(*) into vcheck4 from tblteam where sugang_seq = student4;
    select count(*) into vcheck5 from tblteam where sugang_seq = student5;
    select count(*) into vcheck6 from tblteam where sugang_seq = student6;
    if seq>0 then
        if vcheck1 = 0 then
            insert into tblTeam VALUES ((select team_seq+1 from(select team_seq from tblteam order by team_seq desc) where rownum = 1),t,student1);
            dbms_output.put_line('=========================================================================================================================================================================================');
            dbms_output.put_line('sugang_seq : '||student1||' 학생 추가 완료');
            dbms_output.put_line('=========================================================================================================================================================================================');
        else
            dbms_output.put_line('=========================================================================================================================================================================================');
            dbms_output.put_line('sugang_seq : '||student1||' 학생 은 이미 팀이 구성되어 있습니다.');
            dbms_output.put_line('=========================================================================================================================================================================================');
        end if;
        if vcheck2 = 0 then
            insert into tblTeam VALUES ((select team_seq+1 from(select team_seq from tblteam order by team_seq desc) where rownum = 1),t,student2);
            dbms_output.put_line('=========================================================================================================================================================================================');
            dbms_output.put_line('sugang_seq : '||student2||' 학생 추가 완료');
            dbms_output.put_line('=========================================================================================================================================================================================');
        else
            dbms_output.put_line('=========================================================================================================================================================================================');
            dbms_output.put_line('sugang_seq : '||student2||' 학생 은 이미 팀이 구성되어 있습니다.');
            dbms_output.put_line('=========================================================================================================================================================================================');
        
        end if;
        if vcheck3 = 0 then
            insert into tblTeam VALUES ((select team_seq+1 from(select team_seq from tblteam order by team_seq desc) where rownum = 1),t,student3);
            dbms_output.put_line('=========================================================================================================================================================================================');
            dbms_output.put_line('sugang_seq : '||student3||' 학생 추가 완료');
            dbms_output.put_line('=========================================================================================================================================================================================');
        else
            dbms_output.put_line('=========================================================================================================================================================================================');
            dbms_output.put_line('sugang_seq : '||student3||' 학생 은 이미 팀이 구성되어 있습니다.');
            dbms_output.put_line('=========================================================================================================================================================================================');
        
        end if;
        if vcheck4 = 0 then
            insert into tblTeam VALUES ((select team_seq+1 from(select team_seq from tblteam order by team_seq desc) where rownum = 1),t,student4);
            dbms_output.put_line('=========================================================================================================================================================================================');
            dbms_output.put_line('sugang_seq : '||student4||' 학생 추가 완료');
            dbms_output.put_line('=========================================================================================================================================================================================');
        else
            dbms_output.put_line('=========================================================================================================================================================================================');
            dbms_output.put_line('sugang_seq : '||student4||' 학생 은 이미 팀이 구성되어 있습니다.');
            dbms_output.put_line('=========================================================================================================================================================================================');
        
        end if;
        if vcheck5 = 0 then
            insert into tblTeam VALUES ((select team_seq+1 from(select team_seq from tblteam order by team_seq desc) where rownum = 1),t,student5);
            dbms_output.put_line('=========================================================================================================================================================================================');
            dbms_output.put_line('sugang_seq : '||student5||' 학생 추가 완료');
            dbms_output.put_line('=========================================================================================================================================================================================');
        else
            dbms_output.put_line('=========================================================================================================================================================================================');
            dbms_output.put_line('sugang_seq : '||student5||' 학생 은 이미 팀이 구성되어 있습니다.');
            dbms_output.put_line('=========================================================================================================================================================================================');
        
        end if;
        if vcheck6 = 0 then
            insert into tblTeam VALUES ((select team_seq+1 from(select team_seq from tblteam order by team_seq desc) where rownum = 1),t,student6);
            dbms_output.put_line('=========================================================================================================================================================================================');
            dbms_output.put_line('sugang_seq : '||student6||' 학생 추가 완료');
            dbms_output.put_line('=========================================================================================================================================================================================');
        else
            dbms_output.put_line('=========================================================================================================================================================================================');
            dbms_output.put_line('sugang_seq : '||student6||' 학생 은 이미 팀이 구성되어 있습니다.');
            dbms_output.put_line('=========================================================================================================================================================================================');
        
        end if;
    end if;
exception
    when others then
    dbms_output.put_line('              권한이 없습니다. 로그인 정보를 다시 확인하세요');
    dbms_output.put_line('');
    dbms_output.put_line('          ================================================');
end;
-- 실행
begin
    proTTeamFormationSearch('tpdls1990',1234927);
end;
begin
    proTTeamFormationChange('tpdls1990',1234927, 10 ,1,2,3,4,5,6);
end;
begin
    proTTeamFormationremove('tpdls1990',1234927,1,2,3,4,5,6);
end;
begin
    proTTeamFormationAdd('tpdls1990',1234927,10,1,2,3,4,5,6);
end;
select * from tblteam;
---------------------------------------------------C-11 교육생 팀편성-------------------------------------------------------
rollback;
commit;