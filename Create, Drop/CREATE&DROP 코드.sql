
--FullTableDrop.sql
DROP TABLE tblclassroom CASCADE CONSTRAINTS;
DROP TABLE tblclass CASCADE CONSTRAINTS;
DROP TABLE tblbookname CASCADE CONSTRAINTS;
DROP TABLE tblsubject CASCADE CONSTRAINTS;
DROP TABLE tblPoints CASCADE CONSTRAINTS;
DROP TABLE tblmanager CASCADE CONSTRAINTS;
DROP TABLE tblteacher CASCADE CONSTRAINTS;
DROP TABLE tblstudent CASCADE CONSTRAINTS;
DROP TABLE tbllsubject CASCADE CONSTRAINTS;
DROP TABLE tbllclass CASCADE CONSTRAINTS;
DROP TABLE tblsalary CASCADE CONSTRAINTS;
DROP TABLE tbltcattendance CASCADE CONSTRAINTS;
DROP TABLE tblsugang CASCADE CONSTRAINTS;
DROP TABLE tbltest CASCADE CONSTRAINTS;
DROP TABLE tblgraduate CASCADE CONSTRAINTS;
DROP TABLE tblsugangstate CASCADE CONSTRAINTS;
DROP TABLE tblattendence CASCADE CONSTRAINTS;
DROP TABLE tbltestscore CASCADE CONSTRAINTS;
DROP TABLE tbledu_subsidy CASCADE CONSTRAINTS;
DROP TABLE tblproboard CASCADE CONSTRAINTS;
DROP TABLE tblgisuboard CASCADE CONSTRAINTS;
DROP TABLE tblcontent CASCADE CONSTRAINTS;
DROP TABLE tblcon_comment CASCADE CONSTRAINTS;
DROP TABLE tblcom_comment CASCADE CONSTRAINTS;
DROP TABLE tblwishjob CASCADE CONSTRAINTS;
DROP TABLE tblstudentspec CASCADE CONSTRAINTS;
DROP TABLE tblcounsel CASCADE CONSTRAINTS;
DROP TABLE tblassessment CASCADE CONSTRAINTS;
DROP TABLE tblteam CASCADE CONSTRAINTS;
DROP TABLE tblmentoring CASCADE CONSTRAINTS;
DROP TABLE tblcovid CASCADE CONSTRAINTS;
DROP TABLE tblcovidt CASCADE CONSTRAINTS;
DROP TABLE tblcovids CASCADE CONSTRAINTS;
DROP TABLE tblquestion CASCADE CONSTRAINTS;
DROP TABLE tblanswer CASCADE CONSTRAINTS;

COMMIT;
set define off;
--------------------------------------------------------------------------------

CREATE TABLE tblclassroom (
    classroom_seq NUMBER NOT NULL,
    NAME VARCHAR2(50) NOT NULL,
    totalnum NUMBER NOT NULL,
    
    CONSTRAINT tblclassroom_classroom_seq_pk PRIMARY KEY(classroom_seq),     
    CONSTRAINT tblclassroom_totalnum_ck CHECK(totalnum <= 30)
);

CREATE TABLE tblclass (
    class_seq NUMBER NOT NULL,
    NAME VARCHAR2(100) NOT NULL,
    
    CONSTRAINT tblclass_class_seq_pk PRIMARY KEY(class_seq),
    CONSTRAINT tblclass_class_seq_ck CHECK (class_seq >=1),
    CONSTRAINT tblclass_name_uq UNIQUE(NAME)
);

CREATE TABLE tblbookname (
    bookname_seq NUMBER NOT NULL,
    NAME VARCHAR2(150) NOT NULL,
    publisher VARCHAR2(100) NOT NULL,
    
    CONSTRAINT tblbookname_book_seq_pk PRIMARY KEY(bookname_seq),
    CONSTRAINT tblbookname_book_seq_ck CHECK (bookname_seq >=1)
);

CREATE TABLE tblsubject (
    subject_seq NUMBER NOT NULL,
    NAME varchar2(20) NOT NULL,
    
    CONSTRAINT tblsubject_subiect_seq_pk PRIMARY KEY(subject_seq),
    CONSTRAINT tblsubject_subiect_seq_ck CHECK (subject_seq >=1)
);

create table tblPoints
(
    Points_seq number not null, -- 시퀀스
    Written number null,        -- 필기 배점(요구분석서 = null 허용)
    Practical number null,      -- 실기 배점
    PAttendance number null,    -- 출결 배점
    Subject_seq number not null,-- 과목번호(FK)
        
    constraint tblPoints_Points_seq_pk primary key(Points_seq),
    constraint tblPoints_Subject_seq_fk foreign key(Subject_seq) references tblSubject(Subject_Seq),
    constraint tblPoints_PAttendance_ck check (PAttendance >= 20)
);
create sequence seqPoints;

CREATE TABLE tblmanager (
    manager_seq NUMBER NOT NULL,
    ID VARCHAR2(15) NOT NULL,
    PASSWORD VARCHAR2(15) NOT NULL,
    
    CONSTRAINT tblmanager_manager_seq_pk PRIMARY KEY(manager_seq)
);

CREATE TABLE tblteacher (
    teacher_seq NUMBER NOT NULL,
    NAME VARCHAR2(15) NOT NULL,
    ID VARCHAR2(15) NOT NULL,
    jumin NUMBER NOT NULL,
    tel VARCHAR2(15) NOT NULL,
    possiblelecture VARCHAR2(4000) NOT NULL,
    NOW VARCHAR2(15) NOT NULL,
    subject_seq NUMBER NULL,
    manager_seq NUMBER NOT NULL,
    
    CONSTRAINT tblteacher_teacher_seq_pk PRIMARY KEY(teacher_seq),
    CONSTRAINT tblteacher_subject_seq_fk FOREIGN KEY (subject_seq) REFERENCES tblsubject(subject_seq),
    CONSTRAINT tblteacher_manager_seq_fk FOREIGN KEY (manager_seq) REFERENCES tblmanager(manager_seq)
);

CREATE TABLE tblstudent (
    student_seq NUMBER NOT NULL,
    NAME VARCHAR2(20) NOT NULL,
    ID VARCHAR2(15) NOT NULL,
    ssn VARCHAR2(14) NOT NULL,
    tel VARCHAR2(15) NOT NULL,
    attenddate DATE NOT NULL,
    manager_seq NUMBER(3) NOT NULL,
    
    CONSTRAINT tblstudent_student_seq_pk PRIMARY KEY(student_seq),
    CONSTRAINT tblstudent_manager_seq_fk FOREIGN KEY(manager_seq) REFERENCES tblmanager(manager_seq)
);

create table tblLClass (
	LClass_Seq number not null, 
          StartClassDate date default sysdate,
          FinishClassDate date not null,
          Class_Seq number not null,
          Classroom_seq number not null,
                   
          constraint tbllclass_lclassseq_pk primary key(LClass_seq),
          constraint tbllclass_ClassRoom_seq_fk foreign key(ClassRoom_Seq) references tblClassroom(Classroom_Seq)

);


create table tblLSubject (
	LSubject_Seq number not null,
	start_date date,
	end_date date,
	Subject_Seq number not null,
	BookName_Seq number not null,
	Teacher_Seq number not null,
    LClass_Seq number not null,

     constraint tblLSubject_LSubject_seq_pk primary key(LSubject_seq),
    constraint tblLSubject_Subject_Seq_fk foreign key (subject_seq) REFERENCES tblSubject(Subject_Seq),
    constraint tblLSubject_BookName_Seq_fk foreign key (bookname_seq) REFERENCES tblbookname(BookName_Seq),
    constraint tblLSubject_Teacher_Seq_fk foreign key (teacher_seq) REFERENCES tblteacher(Teacher_Seq),
    constraint tblLSubject_LClass_Seq_fk foreign key (LClass_seq) REFERENCES tblLClass(LClass_Seq)
);





CREATE TABLE tblsalary(
    salary_seq NUMBER,
    PERIOD VARCHAR2(30) NOT NULL,
    salary NUMBER NULL,
    teacher_seq NUMBER NOT NULL,
    
    CONSTRAINT tblsalary_salary_seq_pk PRIMARY KEY(salary_seq),
    CONSTRAINT tblsalary_salary_seq_ck CHECK (salary_seq >= 1),
    CONSTRAINT tblsalary_teacher_seq_fk FOREIGN KEY (teacher_seq) REFERENCES tblteacher(teacher_seq)
);

CREATE TABLE tbltcattendance(
    tcattendance_seq NUMBER PRIMARY KEY,
    TYPE VARCHAR2(20) NOT NULL,
    tcattendancedate DATE DEFAULT sysdate,
    teacher_seq NUMBER NOT NULL,
    
    CONSTRAINT tbltcattendance_type_ck CHECK (TYPE IN('정상', '지각', '조퇴', '외출', '병가', '기타')),
    CONSTRAINT tbltcattendance_teacher_seq_fk FOREIGN KEY (teacher_seq) REFERENCES tblteacher(teacher_seq)
);


CREATE TABLE tblsugang (
    sugang_seq NUMBER NOT NULL,
    lclass_seq NUMBER NOT NULL,
    student_seq NUMBER NOT NULL,
    
    CONSTRAINT tblsugang_sugang_seq_pk PRIMARY KEY(sugang_seq),
    CONSTRAINT tblsugang_sugang_seq_fk FOREIGN KEY (lclass_seq) REFERENCES tbllclass(lclass_seq),
    CONSTRAINT tblsugang_student_seq_fk FOREIGN KEY (student_seq) REFERENCES tblstudent(student_seq)
);


CREATE TABLE tbltest (
    test_seq NUMBER(3) NOT NULL,
    question VARCHAR2(2000) NOT NULL,
    kind_of VARCHAR2(6) NOT NULL,
    lsubject_seq NUMBER(3) NOT NULL,
    CONSTRAINT tbltest_test_seq_pk PRIMARY KEY(test_seq),
    CONSTRAINT tbltest_kind_of_ck CHECK (kind_of IN('실기', '필기')),
    CONSTRAINT tbltest_lsubject_seq_fk FOREIGN KEY(lsubject_seq) REFERENCES tbllsubject(lsubject_seq)
);

CREATE TABLE tblgraduate(
    graduate_seq NUMBER,
    NAME VARCHAR2(15) NOT NULL,
    ID VARCHAR2(60) NOT NULL,
    last_ssn NUMBER(14),
    phonenumber VARCHAR2(26),
    complationdate DATE,
    employment VARCHAR2(60),
    salary NUMBER,
    sugang_seq NUMBER NOT NULL,       
    CONSTRAINT tblgraduate_seq_pk PRIMARY KEY(graduate_seq),  
    CONSTRAINT tblsugang_fk  FOREIGN KEY (sugang_seq) REFERENCES tblsugang(sugang_seq)
);

CREATE TABLE tblsugangstate (
    sugangstate_seq NUMBER NOT NULL,
    sugangstate_date DATE NULL,
    whether VARCHAR2(1) NULL,
    sugang_seq NUMBER NOT NULL,
    CONSTRAINT tblsugangstate_seq_ck CHECK (sugangstate_seq >= 1),
    CONSTRAINT tblsugangstate_type_ck CHECK (whether IN('Y', 'N')),
    CONSTRAINT tblsugangstate_seq_pk PRIMARY KEY(sugangstate_seq),
    CONSTRAINT tblsugangstate_seq_fk FOREIGN KEY(sugang_seq) REFERENCES tblsugang(sugang_seq)
);


CREATE TABLE tblattendence(
    attendence_seq NUMBER NOT NULL,
    absence_type VARCHAR2(6) NOT NULL,
    attendence_date DATE NOT NULL,
    sugang_seq NUMBER NOT NULL,
    GoTowork date NULL,
    offWork date NULL,
    CONSTRAINT tblattendence_seq_ck CHECK (attendence_seq >= 1),
    CONSTRAINT tblattendence_type_ck CHECK (absence_type IN('정상', '지각', '조퇴', '외출', '병가', '기타')),
    CONSTRAINT tblattendence_seq_pk PRIMARY KEY(attendence_seq),
    CONSTRAINT tblattendence_seq_fk FOREIGN KEY(sugang_seq) REFERENCES tblsugang(sugang_seq)
);



CREATE TABLE tbltestscore (
    testscore_seq NUMBER NOT NULL,
    score NUMBER(3) NULL,
    testdate DATE NULL,
    sugang_seq NUMBER NOT NULL,
    Test_Seq NUMBER NOT NULL,
	
    CONSTRAINT tbltestscore_testscore_seq_pk PRIMARY KEY(testscore_seq),
    CONSTRAINT tbltestscore_sugangt_seq_fk FOREIGN KEY(sugang_seq) REFERENCES tblsugang(sugang_seq),
	constraint tblTestScore_Test_Seq_fk foreign key(Test_Seq) references tblTest(Test_Seq)
);


CREATE TABLE tbledu_subsidy (
    edu_subsidy_seq NUMBER NOT NULL,
    edu_subsidy_date NUMBER NOT NULL,
    PERIOD VARCHAR2(10) NOT NULL,
    sugang_seq NUMBER NOT NULL,
    CONSTRAINT tbledu_subsidy_seq_ck CHECK (edu_subsidy_seq  >= 1),
    CONSTRAINT tbledu_subsidy_seq_pk PRIMARY KEY(edu_subsidy_seq ),
    CONSTRAINT  tbledu_subsidy_seq_fk FOREIGN KEY(sugang_seq) REFERENCES tblsugang(sugang_seq)
);



CREATE TABLE tblproboard (
    proboard_seq NUMBER(3) NOT NULL,
    project_name VARCHAR(100) NOT NULL,
    CONTENT VARCHAR2(300) NOT NULL,
    PERIOD DATE NOT NULL,
    LIMIT NUMBER(2) NOT NULL,
    email VARCHAR2(25) NOT NULL,
    sugang_seq NUMBER(3) NOT NULL,
    CONSTRAINT tblproboard_proboard_seq_pk PRIMARY KEY(proboard_seq),
    CONSTRAINT tblproboard_sugang_seq_fk FOREIGN KEY(sugang_seq) REFERENCES tblsugang(sugang_seq)
);


CREATE TABLE tblgisuboard (
    gisuboard_seq NUMBER NOT NULL,
    title VARCHAR2(100) NOT NULL,
    gisuboard_date DATE DEFAULT sysdate,
    sugang_seq NUMBER NOT NULL,
    CONSTRAINT tblgisuboard_seq_ck CHECK (gisuboard_seq >= 1),
    CONSTRAINT tblgisuboard_seq_pk PRIMARY KEY(gisuboard_seq),
    CONSTRAINT  tblgisuboard_seq_fk FOREIGN KEY(sugang_seq) REFERENCES tblsugang(sugang_seq)
);

CREATE TABLE tblcontent(
    content_seq NUMBER,
    CONTENT VARCHAR2(4000) NOT NULL,
    gisuboard_seq NUMBER NOT NULL,
    CONSTRAINT tblcontent_content_seq_pk PRIMARY KEY(content_seq),
    CONSTRAINT tblgisuboard_fk FOREIGN KEY (gisuboard_seq) REFERENCES tblgisuboard(gisuboard_seq)
);

CREATE TABLE tblcon_comment(
    con_comment_seq NUMBER,
    CONTENT VARCHAR2(4000) NOT NULL,
    reg_time DATE DEFAULT sysdate NOT NULL,
    content_seq NOT NULL,
    CONSTRAINT con_comment_seq_pk PRIMARY KEY(con_comment_seq),
    CONSTRAINT tblcontent_fk FOREIGN KEY (content_seq) REFERENCES tblcontent(content_seq)
);


CREATE TABLE tblcom_comment(
    com_comment_seq NUMBER,
    CONTENT VARCHAR2(4000) NOT NULL,
    reg_time DATE DEFAULT sysdate NOT NULL,
    con_comment_seq NUMBER NOT NULL,
    CONSTRAINT com_comment_seq_pk PRIMARY KEY(com_comment_seq),
    CONSTRAINT tblcon_comment_fk  FOREIGN KEY (con_comment_seq) REFERENCES tblcon_comment(con_comment_seq)
);


CREATE TABLE tblwishjob (
    wishjob_seq NUMBER(3) NOT NULL,
    city VARCHAR2(30) NOT NULL,
    basicpay NUMBER(8) NOT NULL,
    student_seq NUMBER(3) NOT NULL,
    CONSTRAINT tblwishjob_wishjob_seq_pk PRIMARY KEY(wishjob_seq),
    CONSTRAINT tblwishjob_student_seq_fk FOREIGN KEY(student_seq) REFERENCES tblstudent(student_seq)
);


CREATE TABLE tblstudentspec(
    student_seq NUMBER,
    education VARCHAR2(60),
    certificate VARCHAR2(4000),
    CONSTRAINT tblstudentspec_srudent_seq_pk PRIMARY KEY(student_seq),
    CONSTRAINT tblstudent_fk  FOREIGN KEY (student_seq) REFERENCES tblstudent(student_seq)
);

CREATE TABLE tblcounsel(
    counsel_seq NUMBER NOT NULL,
    TARGET VARCHAR2(20) DEFAULT '선생님',
    purpose VARCHAR2(100) NOT NULL,
    counsel_date DATE DEFAULT sysdate,
    sugang_seq NUMBER NOT NULL,
    teacher_seq NUMBER NOT NULL,
    manager_seq NUMBER NOT NULL,
    
    CONSTRAINT tblcounsel_counsel_seq_pk PRIMARY KEY(counsel_seq),
    CONSTRAINT tblcounsel_counsel_seq_ck CHECK(counsel_seq>=1),
    CONSTRAINT tblcounsel_sugang_seq_fk FOREIGN KEY (sugang_seq) REFERENCES tblsugang(sugang_seq),
    CONSTRAINT tblcounsel_teacher_seq_fk FOREIGN KEY (teacher_seq) REFERENCES tblteacher(teacher_seq),
    CONSTRAINT tblcounsel_manager_seq_fk FOREIGN KEY (manager_seq) REFERENCES tblmanager(manager_seq),
    CONSTRAINT tblcounsel_target_seq_ck CHECK (TARGET IN ('선생님', '관리자'))
);


CREATE TABLE tblassessment(
    assessment_seq NUMBER,
    CONTENTS VARCHAR2(4000),
    regdate DATE DEFAULT sysdate,
    sugang_seq NUMBER NOT NULL,
    teacher_seq NUMBER NOT NULL,
    CONSTRAINT tblclassroom_class_seq_pk PRIMARY KEY(assessment_seq ),
    CONSTRAINT sugang_fk FOREIGN KEY (sugang_seq) REFERENCES tblsugang(sugang_seq),
    CONSTRAINT teacher_fk  FOREIGN KEY (teacher_seq) REFERENCES tblteacher(teacher_seq)
);

create table tblTeam(
    Team_seq number not null,
    Team number not null,
    sugang_seq number not null,
    constraint tblTeam_Team_seq_pk primary key(team_seq),
    constraint tblTeam_Team_seq_ck check (Team_seq >=1),
    constraint tblTeam_Team_ck check (Team between 1 and 10),
    constraint tblSugang_seq_fk foreign key (sugang_seq) REFERENCES tblSugang(Sugang_Seq)
);


CREATE TABLE tblmentoring(
    mento_seq NUMBER NOT NULL,
    graduate_seq NUMBER NOT NULL,
    student_seq NUMBER NOT NULL,
    CONSTRAINT tblmentoring_seq_pk PRIMARY KEY(mento_seq),
    CONSTRAINT tblmentoring_graduate_seq_fk FOREIGN KEY (graduate_seq) REFERENCES tblgraduate(graduate_seq),
    CONSTRAINT tblmentoring_student_seq_fk  FOREIGN KEY (student_seq) REFERENCES tblstudent(student_seq)
);



CREATE TABLE tblcovidt (
    covidt_seq NUMBER NOT NULL,
    attendance DATE,
    facetoface VARCHAR2(15) NOT NULL,
    teacher_seq NUMBER NOT NULL, 
    
    CONSTRAINT tblcovidt_covidt_seq_pk PRIMARY KEY(covidt_seq),
    CONSTRAINT tblcovidt_attendance_ck CHECK (facetoface IN('Y', 'N')),
    CONSTRAINT tblcovidt_teacher_seq_fk FOREIGN KEY (teacher_seq) REFERENCES tblteacher(teacher_seq)
);

CREATE TABLE tblcovids (
    covids_seq NUMBER NOT NULL,
    attendance DATE,
    facetoface VARCHAR2(15) NOT NULL,
    sugang_seq NUMBER NOT NULL, 
    
    CONSTRAINT tblcovids_covids_seq_pk PRIMARY KEY(covids_seq),
    CONSTRAINT tblcovids_attendance_ck CHECK (facetoface IN('Y', 'N')),
    CONSTRAINT tblcovids_sugang_seq_fk FOREIGN KEY (sugang_seq) REFERENCES tblsugang(sugang_seq)
);



CREATE TABLE tblquestion(
    question_seq NUMBER NOT NULL,
    question VARCHAR2(2000) NOT NULL,
    questiondate DATE DEFAULT sysdate,
    sugang_seq NUMBER NOT NULL,
    
    CONSTRAINT tblquestion_question_seq_pk PRIMARY KEY(question_seq),
    CONSTRAINT tblquestion_question_seq_ck CHECK (question_seq>=1),
    CONSTRAINT tblquestion_sugang_seq_fk FOREIGN KEY (sugang_seq) REFERENCES tblsugang(sugang_seq)
);


CREATE TABLE tblanswer(
    answer_seq NUMBER(10) NOT NULL,
    answer VARCHAR2(2000) NOT NULL,
    answerdate DATE DEFAULT sysdate,
    teacher_seq NUMBER NOT NULL,
    question_seq NUMBER NOT NULL,

    CONSTRAINT tblanswer_answer_seq_pk PRIMARY KEY(answer_seq),
    CONSTRAINT tblanswer_answer_seq_ck CHECK(answer_seq >= 1),
    CONSTRAINT tblanswer_teacher_seq_fk FOREIGN KEY (teacher_seq) REFERENCES tblteacher(teacher_seq),
    CONSTRAINT tblanswer_question_seq_fk FOREIGN KEY (question_seq) REFERENCES tblquestion(question_seq)
);

commit;

