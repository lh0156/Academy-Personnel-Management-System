-- B-13.sql
--------------------------------------------------------------------------------

--B-13. 희망 취업처 및 연봉 조회

--1. 관리자는 학생들의 희망 취업처 및 희망 연봉을 조회할 수 있다.
--1) 희망 취업처와 연봉'만' 조회
select 
    s.name as "교육생명", 
    w.city as "희망 지역", 
    w.basicpay as "희망 연봉"
from tblwishjob w
    inner join tblStudent s
        on w.student_seq = s.student_seq
    where s.name like '%이정현%'; 
 
        
-- 2) 학생(상담내용 + 희망 취업처 + 희망 연봉) 조회 
           
select 
    st.name as "교육생명",
    c.purpose "상담목적",
    c.target "상담사",
    c.counsel_date "신청날짜",
    w.city as "취업희망지역",
    w.basicpay "희망연봉"
from tblcounsel c
    inner join tblsugang su
        on c.sugang_seq = su.sugang_seq
            inner join tblstudent st    
                on st.student_seq = su.student_seq
                    inner join tblwishjob w
                        on w.student_seq = st.student_seq                    
            where st.name like '%이정현%'
                order by "신청날짜";
    

