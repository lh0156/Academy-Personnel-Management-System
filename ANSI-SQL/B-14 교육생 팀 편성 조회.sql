--B-14.sql(완)
--------------------------------------------------------------------------------

--B-14. 교육생 팀 편성 조회

-- 1. 팀 조회
select
    lc.class_seq as "과정번호",
    t.team || '조' as "팀",
    st.name as "교육생명"
from tblStudent st
    inner join tblsugang sg
        on sg.student_seq = st.student_seq
            inner join tblTeam t
                on t.sugang_seq = sg.sugang_seq
                    inner join tbllclass lc
                        on lc.lclass_seq = sg.lclass_seq
                            inner join tblmanager m
                                on m.manager_seq = st.manager_seq
                   --where t.team = 1 and st.name like '%이정현%' -- 2. 특정 팀과 교육생 이름으로 선택적 조회
                    order by lc.class_seq, "교육생명"; -- 1. 전체 조회


-- 2. 특정 강의의 특정 팀 조회
select
    c.name as "과정이름",
    t.team as "팀",
    st.name as "교육생명"
from tblStudent st
    inner join tblsugang sg
        on sg.student_seq = st.student_seq
            inner join tblTeam t
                on t.sugang_seq = sg.sugang_seq
                    inner join tbllclass lc
                        on lc.lclass_seq = sg.lclass_seq
                            inner join tblclass c
                                on c.class_seq = lc.class_seq
                                    where t.team = 1 and c.name like '%플랫폼 연동 융합 개발자%'
            order by c.name, st.name;
  