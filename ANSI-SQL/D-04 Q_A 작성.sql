---------------------------------------------------D-04 Q&A 작성------------------------------------------------------
--업무영역
--교육생
--요구사항 명
--D-04 Q&A 작성
--개요
--교육생이 질문을 남기고, 조회할 수 있다.
--상세설명
---	교육생이 교육과정 진로 등 주제에 구애 받지 않고 질문을 남길 수 있다.
---	관리자 또는 선생님이 해당 Q&A에 답변을 남겼을 경우 해당 답변을 확인 할 수 있다.
--제약사항
---	해당 Q&A 에 답변이 없을 경우 답변을 확인할 수 없다.
---	본인이 남긴 Q&A만 조회할 수 있다.
---	작성날짜 
-- ID : qrs102
-- PW : 2325740
-- 1. 작성
insert into tblquestion (question_seq,question,sugang_seq) 
                                select
                                        (select question_SEQ from (select question_SEQ from tblquestion order by question_seq desc) where rownum =1)+1,
                                        '질문이 있어요!!!!!!!!!!!!!!!!!!!',
                                        su.sugang_seq
                                   from tblsugang su
                                        where sugang_seq = (select stu.student_seq from tblstudent stu where stu.id = 'qrs102' and substr(stu.ssn,7) = '2325740');
-- 2. 조회
select 
    q.questiondate as "질문 날짜",
    q.question as "질문",
    case
        when a.answerdate is null then 'null'
        when a.answerdate is not null then to_char(a.answerdate,'yyyy-mm-dd')
    end as "답변 날짜",
    case
        when a.answerdate is null then '답변이 등록되지 않은 질문 입니다.'
        else a.answer 
    end as "답변"
from tblSugang sugang inner join tblquestion Q on sugang.sugang_seq = q.sugang_seq
                      left outer join tblanswer A on q.question_seq = A.question_seq
    where sugang.student_seq = (select stu.student_seq from tblstudent stu where stu.id = 'qrs102' and substr(stu.ssn,7) = '2325740'); -- 로그인 후 학생 번호를 돌려주는 쿼리
---------------------------------------------------D-04 Q&A 작성------------------------------------------------------
rollback;
commit;