--B-15.sql
--------------------------------------------------------------------------------(완)

--B-15. 교육생 상담 조회

select
    st.name as "교육생명",
    c.purpose as "상담목적",
    c.target as "상담사",
    c.counsel_date as "신청날짜"
from tblStudent st
        inner join tblsugang sg
             on st.student_seq = sg.sugang_seq
                  inner join tblcounsel c
                       on sg.sugang_seq = c.sugang_seq
                            inner join tblmanager m
                                on m.manager_seq = st.manager_seq
       --where st.name like '%이정현%' 
       --and c.purpose like '%%' --2. 이름 및 상담내용으로 부분 조회
                           order by counsel_date desc; -- 1. 전체조회
    
                                