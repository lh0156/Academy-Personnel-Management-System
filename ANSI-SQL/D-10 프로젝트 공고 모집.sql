/*
D-10 프로젝트 공고 모집

업무영역
교육생

요구사항 명
프로젝트 공고 게시판

개요
교육생이 본인 클래스와는 별도로 프로젝트 시행 공고를 올려 프로젝트에 참여할 인원을 모집하는 게시판

상세설명
프로젝트 공고 게시판을 통해 클래스에서 진행하는 프로젝트와 별도의 프로젝트를 진행함으로써 교육생들의 실력을 향상시킬수 있도록 도와주는 기능

제약사항
현재 학원에 등록되어있는 교육생이라면 누구든 참여 가능
기간


*/


insert into tblproboard values (
(select max(proboard_seq+1) from tblproboard),
'파파고 굿굿',
'파파고 번역기의 기능을 자바로 그대로 구현하는 프로젝트입니다.',
'2022-02-03', -- 마감기한
5, -- 인원
'lh0156@naver.com',
(select sugang_seq from tblsugang
    where student_seq = (select student_seq from tblstudent stu
        where id = 'abc007' and substr(stu.ssn,7) = '1115158')));

select sugang_seq from tblsugang
    where student_seq = (select student_seq from tblstudent stu
        where id = 'abc007' and substr(stu.ssn,7) = '1115158');

