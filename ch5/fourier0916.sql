CREATE VIEW faculty AS
    SELECT
        id,
        name,
        dept_name
    FROM
        instructor;

drop view faculty;

select * from faculty;

SELECT
    name
FROM
    faculty
WHERE
    dept_name = 'Biology';

CREATE VIEW departments_total_salary (
    dept_name,
    total_salary
) AS
    SELECT
        dept_name,
        SUM(salary)
    FROM
        instructor
    GROUP BY
        dept_name;

CREATE VIEW physics_fall_2009 AS
    SELECT
        course.course_id,
        sec_id,
        building,
        room_number
    FROM
        course,
        section
    WHERE
            course.course_id = section.course_id
        AND
            course.dept_name = 'Physics'
        AND
            section.semester = 'Fall'
        AND
            section.year = '2009';

CREATE VIEW physics_fall_2009_watson AS
    SELECT
        course_id,
        room_number
    FROM
        physics_fall_2009
    WHERE
        building = 'Watson';


/* example for recursive review */

WITH rec_prereq (
    course_id,
    prereq_id
) AS (
    SELECT
        course_id,
        prereq_id
    FROM
        prereq
    UNION ALL
    SELECT
        rec_prereq.course_id,
        prereq.prereq_id
    FROM
        rec_prereq,
        prereq
    WHERE
        rec_prereq.prereq_id = prereq.course_id
) SELECT
    *
FROM
    rec_prereq;

INSERT INTO faculty VALUES('30719','Green2','Biology'); 

INSERT INTO instructor VALUES('013','kevin','Biology', 50000);

select * from instructor;

SELECT
    *
FROM
    instructor;

SELECT
    *
FROM
    faculty; /* updated as new records are inserted in the table/relation */

CREATE VIEW instructor_info AS
    SELECT
        id,
        name,
        building
    FROM
        instructor,
        department
    WHERE
        instructor.dept_name = department.dept_name;

drop view history_instructors;

CREATE VIEW bio_instructors AS
    SELECT
        *
    FROM
        instructor
    WHERE
        dept_name = 'Biology';

select * from bio_instructors;

select * from instructor;

INSERT INTO bio_instructors VALUES (
    '25900',
    'Brown',
    'English',
    50000
);

SELECT
    *
FROM
    instructor; /* inserted into the instructor relation,not the view */

/*
Transactions 

SEt Autocommit,ON/OFF/IMM/n; n cannot be less than zero or greater than 2,000,000,000
*/

SHOW autocommit;

SET AUTOCOMMIT ON;

SET AUTOCOMMIT IMM;

SET AUTOCOMMIT OFF;

SET AUTOCOMMIT 3;

Select * from instructor where dept_name = 'Biology' or dept_name= 'Comp. Sci.';

/* do not forget to add "/" at a new line, and ";" after END in Oralce*/

begin
update instructor set salary = salary-10000 where dept_name ='Biology';
update instructor set salary = salary+10000 where dept_name ='Comp. Sci.';
commit;
end;
/

/* check*/

create table section_test2 (
    course_id varchar(8),
    sec_id varchar(8),
    semester varchar(6),
    year numeric(4,0),
    building varchar(15),
    room_number varchar(7),
    time_slot_id varchar(4), 
    primary key (course_id, sec_id, semester, year),
    check (semester in ('Fall', 'Winter', 'Spring', 'Summer'))
    );

desc section_test2;

select * from section_test2;
/* on cascade, set default, set null */
insert into section_test2 values('CS425', '01', 'Fax', 2018, null, null, null);

insert into section_test2 values('CS425', '01', 'Fall', 2018, null, null, null);

delete from department where dept_name= 'Math';

select * from student where dept_name='Math';
select * from student where dept_name is null;
select * from department;

/* foreign key to reference itself */    
    
create table person(
ID char(10),
name char(40),
mother char(10),
father char(10),
primary key(ID),
foreign key(father) references person(ID),
foreign key(mother) references person(ID)
);

desc person;

insert into person values('1', 'Lexi', null, null);
insert into person values('2', 'Bob', null, null);
insert into person values('3', 'Alice', '1', '2');

select * from person;

delete from person;

drop table person;
/* create index , add function; add index type, e.g., on Instructor(name, 1) with B-tree; more later on */

create index faculty_indx on Instructor(upper(name));

drop index faculty_indx;

select upper(dept_name) from instructor where name is not null;

/* type*/

/* varray defined in PL/SQL can store a fixed-size sequential collection of elements of the same type*/

create type dollars as varray(10) of numeric(12,2);
/

drop type dollars;

create table company(com_name varchar(20), 
        building varchar(15),
        budget Dollars);
        
desc company;

drop table company;

select * from company;

insert into company values('Oracle', 'SB', 12000.00);
insert into company values('Oracle', 'SB', dollars(12000.00));


/* another example */

CREATE TYPE external_person AS OBJECT (
  name        VARCHAR2(30),
  phone       VARCHAR2(20));
/

CREATE TABLE contacts (
  ID varchar(10), 
  contact external_person,
  primary key(ID)
  );
  
select * from contacts;

desc contacts;

insert into contacts values('111', external_person('Chris', '312-111-1111'));

select * from contacts;

select p.contact.phone from contacts p;

drop table contacts;

drop type external_person;

/* a more complicaed example for type */

Create or replace type customer_s_type as object (
   csID number, 
   csName varchar(15),
   csType number) NOT FINAL;
/

Create or replace type supervisor_type UNDER customer_s_type (title varchar (10));
/

desc supervisor_type;
desc customer_s_type;

Create or replace type agent_type UNDER customer_s_type (title varchar (10));
/

desc agent_type;

Create table supervisor of customer_s_type (
   CONSTRAINT supervisor_PK PRIMARY KEY (csID));

desc customer_s_type;
desc supervisor;

Create table agent of agent_type (CONSTRAINT agent_PK PRIMARY KEY (csID));

desc agent;

drop type agent_type;
drop type supervisor_type;

drop table agent;
drop table supervisor;


/* CREATE DOMAIN is not a valid DDL statement in Oracle */

/* Access Control */

grant insert on instructor to public;

revoke insert on instructor from public;

/* run this 

alter session set "_ORACLE_SCRIPT"=true;

before creating the role (if error occurs in Oracle 12c)

*/

/* our accounts do not have permission to create role on fourier */

create role data_analyst;

drop role data_analyst;

create or replace view geo_ins as 
(select * from instructor where dept_name = 'Geology');

grant select on geo_ins to public;

revoke select on geo_ins from public;

grant references (dept_name) on department to public;

grant references on department to public;

revoke references on department from public CASCADE CONSTRAINTS;

grant select on department to public with grant option;

revoke select on department from public CASCADE CONSTRAINTS;

