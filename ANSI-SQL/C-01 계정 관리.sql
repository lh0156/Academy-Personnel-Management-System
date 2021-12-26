--C-01.sql
--------------------------------------------------------------------------------(완)


--C-01. 계정관리


select * from tblTeacher;
-- 교사 로그인(예시 : 박세인 선생님)
-- 1이면 성공 0이면 실패
select count(*) as "로그인" from tblTeacher where id = 'tpdls1990' and jumin = '1234927'; -- 1

