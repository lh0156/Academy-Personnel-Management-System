--C-03.sql
--------------------------------------------------------------------------------
--C-03. 배점 입출력

-- 배점 수정, 입력, 출력(프로시저)
-- 1)배점 수정
update tblPoints set written = 30, practical = 20, pattendance =30 where points_seq= 101;
commit;
rollback;

-- 2) 배점 입력
--insert into 배점테이블(과목명, 필기배점, 실기배점, 출결배점, (총합(계산컬럼)) values (); -- 프로시저

-- 3) 강의를 마친 과목의 특정 과목 조회 ** erd 꼬인거같음.. -> 같은 강의 같은 과목이더라도 시험마다 배점다르게 매겨서 배점번호 나온다고 해야할듯
select 
    sb.subject_seq as "과목번호",
    sb.name as "과목명",
    ls.start_date as "과목시작",
    ls.end_date as "과목종료",
    c.name as "과정명",
    lc.startclassdate as "개강",
    lc.finishclassdate as "종강",
    b.name as "교재명",
    cr.classroom_seq as "강의실",
    p.written as "필기배점",
    p.practical as "실기배점",
    p.pattendance as "출결배점"
     
from tblsubject sb
    inner join tbllsubject ls
        on ls.subject_seq = sb.subject_seq
            inner join tbllclass lc
                on lc.lclass_seq = ls.lclass_seq
                    inner join tblteacher t
                        on t.teacher_seq = ls.teacher_seq
                            inner join tblclass c
                                on c.class_seq = lc.class_seq
                                    inner join tblclassroom cr
                                        on cr.classroom_seq = lc.classroom_seq
                                            inner join tblbookname b
                                                on b.bookname_seq = ls.bookname_seq
                                                    inner join tblpoints p
                                                        on p.subject_seq = sb.subject_seq
    where  ls.end_date < sysdate and t.id = 'tpdls1990' and t.jumin = 1234927;




-- 4) 배점번호로 해당 강의중 종료된 과목 배점 정보 출력
select
    p.points_seq as "배점번호",
    lc.lclass_seq as "강의번호",
    sb.name as "과목명",
    p.written as "필기배점",
    p.practical as "실기배점",
    p.pattendance as "출결배점"
     
from tblsubject sb
    inner join tbllsubject ls
        on ls.subject_seq = sb.subject_seq
            inner join tbllclass lc
                on lc.lclass_seq = ls.lclass_seq
                    inner join tblteacher t
                        on t.teacher_seq = ls.teacher_seq
                            inner join tblpoints p
                                on p.subject_seq = sb.subject_seq
    where ls.end_date < sysdate 
        and t.id = 'tpdls1990' 
        and t.jumin = 1234927 
        and p.points_seq = 100;



-- 2. 시험에 관련한 데이터를 추가 할 수 있다.(프로시저) 
-- 테스트 문제 추가
insert into tbltest values (109, '추가문제', '실기', 1);





