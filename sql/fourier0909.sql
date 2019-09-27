insert into instructor values('10212', 'Smith', 'Biology', 66000);

select * from instructor;

delete from instructor 
where ID ='10211';

create table department3
	(dept_name		varchar(20), 
	 building		varchar(15), 
	 budget		        numeric(12,2) check (budget > 0),
	 primary key (dept_name)
	);

alter table department3 add facultynum numeric(4,0);

alter table department3 drop column facultynum;

select dept_name from instructor;

select dept_name as deptname from instructor;

select dept_name deptname from instructor;

select distinct dept_name from instructor;

select * from instructor;

select ID, name, salary/12 from instructor;

select * from teaches; 

select * from instructor, teaches;

select instructor.name from instructor where dept_name='Comp. Sci.' and salary>80000;

select name, course_id from instructor, teaches 
where instructor.ID=teaches.ID;

select * from instructor, teaches where instructor.ID=teaches.ID;

select * from instructor natural join teaches;

select name, title from instructor natural join course;

select name, title from instructor natural join teaches natural join course;

select name, title from instructor natural join teaches, course
where teaches.course_id=course.course_id;

select name, title from (instructor natural join teaches) join course using(course_id);

select * from course natural left outer join prereq;

select * from course natural right outer join prereq;

select * from instructor inner join teaches on instructor.ID=teaches.ID;

select * from course natural full outer join prereq;

select * from course inner join prereq on course.course_id=prereq.course_id;

select * from course left outer join prereq on course.course_id=prereq.course_id;

select * from course natural right outer join prereq;

select * from course full outer join prereq using (course_id);

select ID, name, salary/12 monthly_salary from instructor;

/* remove as for renaming relation/table in Oralce
select distinct T.name
from instructor as T, instructor as S
where T.salary>S.salary and S.dept_name='Comp. Sci.';
*/

select distinct name from instructor;

select distinct T.name
from instructor T, instructor S
where T.salary>S.salary;

select distinct name from instructor;

select distinct T.name
from instructor T, instructor as S
where T.salary>S.salary and S.dept_name='Comp. Sci.';

select name from instructor where name like 't%';

select name from instructor where name like '%w%';

select name from instructor where name like '___';

select name||' '||ID from instructor;

select lower(upper (name)) from instructor;

select length (name) from instructor;

select substr('xxxxxxx', 1, 3) from instructor;

select substr(name, 1, 3) from instructor;

/* */ --

select 
    name, 
    case 
        when salary<50000 then 'low'
        else 'regular'
    end category
from instructor;

select distinct name from instructor order by name;

select * from instructor order by salary desc;

select dept_name, salary from instructor order by dept_name desc, salary desc;

select name, salary from instructor where salary between 118143.98 and 124651.41;

select name, course_id from instructor, teaches
where instructor.ID=teaches.ID and dept_name='Biology';

select course_id from section where semester = 'Fall' and year =2009
union
select course_id from section where semester = 'Spring' and year = 2010;

(select course_id from section where semester = 'Fall' and year =2009)
union
(select course_id from section where semester = 'Spring' and year = 2010);

(select course_id from section where semester = 'Fall' and year =2009)
intersect
(select course_id from section where semester = 'Spring' and year = 2010);

(select course_id from section where semester = 'Fall' and year =2009)
minus
(select course_id from section where semester = 'Spring' and year = 2010);

(select course_id from section where semester = 'Fall' and year =2009)
union all
(select course_id from section where semester = 'Spring' and year = 2010);

insert into instructor(ID, name, dept_name,salary) values('005', 'Kevin', 'Biology', null);

insert into instructor(ID, name, dept_name) values('006', 'Kevin', 'Biology');

select name from instructor where salary is null;

select avg(salary) from instructor where dept_name='Comp. Sci.';

select count (distinct ID) from teaches where semester ='Spring' and year = 2010;

select count(*) from course;

select * from instructor natural join prereq;

select dept_name, count(ID), avg(salary) from instructor group by dept_name;

select dept_name, avg(salary) from instructor group by dept_name having avg(salary)>80000;

select sum(salary) from instructor;

/* subqueries*/

select dept_name, avg_salary
from (select dept_name, avg(salary) as avg_salary from instructor group by dept_name)
where avg_salary>90000;

/* another way*/
with deptavg(dept_name, avg_salary) as (select dept_name, avg(salary) from instructor group by dept_name) 
select dept_name, avg_salary 
from deptavg
where avg_salary>90000;

select distinct course_id
from section 
where semester='Fall' and year = 2009 and 
course_id in (select course_id from section where semester ='Spring' and year=2010);

select distinct course_id
from section 
where semester='Fall' and year = 2009 and 
course_id not in (select course_id from section where semester ='Spring' and year=2010);

select count(distinct ID)
from takes
where (course_id, sec_id, semester, year) in 
(select course_id, sec_id, semester, year from teaches where teaches.ID=10101);

select distinct T.name
from instructor T, instructor S
where T.salary>S.salary and S.dept_name='Biology';

select name, salary from instructor 
where salary > some(select salary from instructor where dept_name='Biology');

select name from instructor
where salary>all(select salary from instructor where dept_name='Biology');

select course_id
from section S
where semester ='Fall' and year=2009 and
exists (select * from section T
where semester='Spring' and year=2010 and S.course_id=T.course_id);

select distinct S.ID, S.name
from student S
where not exists ((select course_id from course where dept_name ='Biology') minus
(select T.course_id from takes T where S.ID=T.ID));

with max_budget(value) as (select max(budget) from department)
select dept_name from department, max_budget
where department.budget=max_budget.value;

with dept_total(dept_name, value) as
(select dept_name, sum(salary) from instructor group by dept_name),
dept_total_avg(value) as 
(select avg(value) from dept_total)
select dept_name
from dept_total, dept_total_avg
where dept_total.value>=dept_total_avg.value;

select dept_name, (select count(*) from instructor where department.dept_name=instructor.dept_name) as num_instructors
from department;

select name 
from instructor
where salary*10> (select budget from department where department.dept_name=instructor.dept_name);

/*insert into course values('CS-425', 'Databases', 'Comp. Sci.', 4);*/

select 1; -- does not support

select 1 from instructor;

select 'ok' from instructor;

select 1 from instructor group by 1;

select sum(salary) from instructor
group by salary/2;

/*Insert into student
select ID, name, dept_name, 0 from instructor;*/

select * from department3;

delete from department3;

drop table department3;

select * from department2;

insert into department2
select * from department;

update instructor
set salary=salary*1.03
where salary>50000;

update instructor
set salary=case
when salary<=100000 then salary*1.05
else salary*1.03
end

update student S
set tot_cred =(select sum(credits)
from takes natural join course
where S.ID=takes.ID and takes.grade<>'F' and takes.grade is not null);

update student S
set tot_cred =(select coalesce(sum(credits),0)
from takes natural join course
where S.ID=takes.ID and takes.grade<>'F' and takes.grade is not null);