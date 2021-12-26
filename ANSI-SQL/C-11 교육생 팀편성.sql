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
--1  
select 
    DISTINCT(s.name),
    su.sugang_seq,
    team.team
from tbllsubject lsub inner join tblteacher t on lsub.teacher_seq = t.teacher_seq
                        inner join tbllclass lc on lsub.lclass_seq = lc.class_seq
                        inner join tblsugang su on su.lclass_seq = lc.class_seq
                        inner join tblstudent s on s.student_seq = su.student_seq
                        left outer join tblteam team on team.sugang_seq = su.sugang_seq
    where t.teacher_seq = (select teacher_seq from tblteacher where id = 'tpdls1990' and jumin = '1234927'); -- 현재 로그인된 교사의 개설 과정을 수강 중인 학생중 팀 구성이 완료된 학생정보
--1 번에 존재하지만 2 번에 존재하지 않으면 팀 편성이 안된 학생임. 번호를 참고해서 팀편성
-- 수정    
UPDATE tblteam set team = 10 WHERE sugang_seq in(3,4,5,6,1,2);
-- 삭제
delete from tblteam where sugang_seq in(3,4,5,6,1,2);
-- 5명 10번팀으로 추가
insert into tblTeam VALUES ((select team_seq+1 from(select team_seq from tblteam order by team_seq desc) where rownum = 1),10,1);
insert into tblTeam VALUES ((select team_seq+1 from(select team_seq from tblteam order by team_seq desc) where rownum = 1),10,2);
insert into tblTeam VALUES ((select team_seq+1 from(select team_seq from tblteam order by team_seq desc) where rownum = 1),10,3);
insert into tblTeam VALUES ((select team_seq+1 from(select team_seq from tblteam order by team_seq desc) where rownum = 1),10,4);
insert into tblTeam VALUES ((select team_seq+1 from(select team_seq from tblteam order by team_seq desc) where rownum = 1),10,5);
---------------------------------------------------C-11 교육생 팀편성-------------------------------------------------------
rollback;
commit;