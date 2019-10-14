-- cs425 hw2  luping xue A20453695
--Question 2.1.1 (15 Points)
-- Write the SQL statements for all the five relations: Employee, Customer, Product, Sales, and Manages. 
-- Note: (1) An appropriate data type should be used for each attribute, and (2) All the foreign keys should be created
-- create table employee
CREATE TABLE Employee (
	eid VARCHAR ( 15 ) NOT NULL,
	ename VARCHAR ( 10 ),
	dob VARCHAR ( 15 ),
	salary numeric ( 10, 0 ),
	primary key ( eid ) 
);
INSERT INTO employee
VALUES
	( '0011', 'Alice', '07/03/1976', 140000 );
INSERT INTO employee
VALUES
	( '0012', 'Bob', '09/14/1978', 110000 );
INSERT INTO employee
VALUES
	( '0013', 'Chris', '06/22/1991', 80000 );
INSERT INTO employee
VALUES
	( '0014', 'David', '05/17/1982', 105000 );
INSERT INTO employee
VALUES
	( '0015', 'Edward', '04/15/1988', 98000 );
INSERT INTO employee
VALUES
	( '0017', 'luping', '04/15/1988', 110000 );
-- create table customer
CREATE TABLE Customer (
	cid VARCHAR ( 15 ) NOT NULL,
	cname VARCHAR ( 10 ),
	city VARCHAR ( 10 ),
	state VARCHAR ( 10 ),
	primary key ( cid ) 
);
INSERT INTO customer
VALUES
	( 'B101', 'Citi Bank', 'New York', 'NY' );
INSERT INTO customer
VALUES
	( 'B102', 'JP Mprgan', 'New York', 'NY' );
INSERT INTO customer
VALUES
	( 'B103', 'Fidelity', 'Boston', 'MA' );
INSERT INTO customer
VALUES
	( 'B104', 'Moto', 'Chicago', 'IL' );
INSERT INTO customer
VALUES
	( 'B105', 'Disney', 'Orlando', 'FL' );
-- create table product
CREATE TABLE Product (
pid VARCHAR ( 15 ),
pname VARCHAR ( 15 ),
unit_price numeric ( 10, 0 ),
primary key ( pid ) 
);
INSERT into   product
VALUES
	( 'A17811', 'Desk', '750' );
INSERT INTO product
VALUES
	( 'A17812', 'Chair', '230' );
INSERT INTO product
VALUES
	( 'A23453', 'PC', '900' );
INSERT INTO product
VALUES
	( 'A34451', 'MAC', '300' );
-- create table sales
CREATE TABLE sales (
	eid VARCHAR ( 15 ) NOT NULL,
	cid VARCHAR ( 15 ) NOT NULL,
	pid VARCHAR ( 15 ) NOT NULL,
	quantity numeric ( 10, 0 ),
	primary key ( eid, cid, pid ),
	foreign key ( eid ) references EMPLOYEE,
	foreign key ( cid ) references CUSTOMER,
	foreign key ( pid ) references PRODUCT 
);
INSERT INTO sales
VALUES
	( '0011', 'B101', 'A17811', '700' );
INSERT INTO sales
VALUES
	( '0011', 'B102', 'A17812', '200' );
INSERT INTO sales
VALUES
	( '0012', 'B102', 'A23453', '100' );
INSERT INTO sales
VALUES
	( '0013', 'B101', 'A34451', '50' );
	INSERT INTO sales
VALUES
	( '0013', 'B104', 'A17812', '500' );
		INSERT INTO sales
VALUES
	( '0012', 'B104', 'A23453', '200' );
	
		INSERT INTO sales
VALUES
	( '0013', 'B103', 'A17812', '400' );
		INSERT INTO sales
VALUES
	( '0012', 'B103', 'A23453', '200' );
			INSERT INTO sales
VALUES
	( '0012', 'B105', 'A23453', '30' );
CREATE TABLE Manages (
	eid1 VARCHAR ( 15 ) NOT NULL,
	eid2 VARCHAR ( 15 ) NOT NULL,
	primary key ( eid1, eid2 ),
	foreign key ( eid1 ) references EMPLOYEE ( eid ),
	foreign key ( eid2 ) references EMPLOYEE ( eid ) 
);
INSERT INTO Manages
VALUES
	( '0011', '0013' );
INSERT INTO Manages
VALUES
	( '0013', '0017' );
INSERT INTO Manages
VALUES
	( '0012', '0013' );
	INSERT INTO Manages
VALUES
	( '0013', '0014' );
	
--	Question 2.1.2 (5 Points)
-- Write an SQL statement that adds a constraint to the Employee relation to make sure that the salary attribute cannot be NULL, and the value of this attribute has to be between 40,000 and 500,000. Furthermore, the default value for this attribute should be 80,000.
	
ALTER TABLE EMPLOYEE ADD constraint bt CHECK ( SALARY BETWEEN 40000 AND 500000 );
ALTER TABLE EMPLOYEE ADD constraint nn CHECK ( SALARY IS NOT NULL );
ALTER TABLE EMPLOYEE MODIFY SALARY DEFAULT 80000;
	
	
-- 2.2.1 Write an SQL query that returns the products (pid and pname)-- which are sold by the direct manager(s) of employee ‘0013’ and the quantity for any customer (not aggregated) is greater than 300.
-- Hint: relation Manages stores the “managing” information in the company (e.g., the employee with eid1 is the direct manager of the employee with eid2).
SELECT
	p.pid,
	p.pname 
FROM
	product p,
	MANAGES m,
	SALES s 
WHERE
	m.EID1 = s.EID 
	AND s.PID = p.PID 
	AND m.eid2 = '0013' 
	AND s.QUANTITY > 300;
-- Question 2.2.2 (7 Points)
--Write an SQL query that returns the IDs of all the products, 
--with the total ordered quantity in ‘Chicago’ greater than the total ordered quantity in ‘Boston’.

CREATE TABLE compare AS (
	SELECT
		s.PID,
		CITY,
		SUM( s.QUANTITY ) AS sum_quanity 
	FROM
		SALES s,
		CUSTOMER c 
	WHERE
		c.CID = s.CID 
		AND c.CITY = 'Chicago' 
	GROUP BY
		s.PID,
		CITY UNION
	SELECT
		s.PID,
		CITY,
		SUM( s.QUANTITY ) AS sum_quanity 
	FROM
		SALES s,
		CUSTOMER c 
	WHERE
		c.CID = s.CID 
		AND c.CITY = 'Boston' 
	GROUP BY
		s.PID,
		CITY 
	);
	
	
SELECT
	c1.PID 
FROM
	compare c1,
	compare c2 
WHERE
	c1.CITY = 'Chicago' 
	AND c2.CITY = 'Boston' 
	AND c1.PID = c2.PID 
	AND c1.sum_quanity > c2.sum_quanity;

-- Question 2.2.3 (7 Points)-- Write an SQL query that returns the name and unit price of all the products (pname and unit_price) which are never ordered by ‘Disney’.
SELECT
	p.pname,
	p.UNIT_PRICE 
FROM
	PRODUCT p 
WHERE
	p.pid NOT IN ( SELECT s.pid FROM CUSTOMER c LEFT JOIN SALES s ON s.CID = c.CID WHERE c.CNAME = 'Disney' );
-- Question 2.2.4 (7 Points)-- Write an SQL query that returns all the employees 
-- and their average sales amount (of all the customers) for each of the products (query result: eid, pid and avg_sales).

SELECT
	e.EID,
	s.PID,
	AVG( s.QUANTITY ) as avg_sales
FROM
	employee e,
	SALES s 
WHERE
	e.EID = s.EID 
GROUP BY
	e.EID,
	s.PID 
ORDER BY
	e.EID;


---- Question 2.2.5 (7 Points)
-- Write an SQL query that returns all the employees and the total number of employees directly managed by each employee 
-- (if no one is directly managed, then return 0). Hint: relation Manages stores the “managing” information in the company 
--(e.g.,the employee with eid1 is the direct manager of the employee with eid2).

SELECT
	e.EID,
	COUNT( m.EID2 ) 
FROM
	EMPLOYEE e
	LEFT JOIN MANAGES m ON e.EID = m.EID1 
GROUP BY
	e.EID;

---- Question 2.2.6 (7 Points)
-- Write an SQL query that returns the number of products where the average ordered quantity (of all the employees and customers) is lower than 1000.
	
SELECT
	count( * ) 
FROM
	(
SELECT
	p.PID
FROM
	PRODUCT p,
	SALES s 
WHERE
	p.PID = s.PID 
GROUP BY
	p.PID 
HAVING
	AVG( s.QUANTITY ) < 1000 
	);
	

-- Question 2.2.7 (7 Points)-- Write an SQL query that returns the product names and the name of the customer(s) who ordered the highest quantity (from all the employees). 
-- Query result: pname and cname.
CREATE TABLE max_q AS (
	SELECT
		s.pid,
		s.cid,
		SUM( s.quantity ) AS sum_q 
	FROM
		sales  s 
	GROUP BY
		s.pid,
		s.cid 
	ORDER BY
		s.pid 
	);
	
SELECT
	p.pname,
	c.cname
FROM
	( SELECT m.pid, MAX( m.sum_q ) AS maxq FROM max_q AS m GROUP BY m.pid ) AS m1,
	max_q  m2 , 		
	Customer  c,
		Product  p 
WHERE
	m1.pid = m2.pid 
	and p.pid = m2.pid
	and c.cid=m2.cid
	AND m1.maxq = m2.sum_q;


-- Question 2.2.8 (7 Points)
-- Write an SQL query which returns all the employees’ IDs and their managed employees’ IDs. 
--Hint: the result should include not only directly managed employees but also indirectly managed employees.
	select EID1, wm_concat(EID2) from(
	with  rec_manages(EID1,EID2) as (
	select EID1,EID2 from manages 
	UNION all
	select r.EID1,m.EID2 from rec_manages r, MANAGES m where r.EID2=m.EID1
	)
	select EID1,EID2 from rec_manages 
	)
	GROUP BY EID1 ;



-- Question 2.3.1 (5 Points)-- Delete all the customers without placing any order.
delete  from CUSTOMER where CID not in (select CID from SALES);

-- Question 2.3.2 (4 Points)-- A new product Telephone is added to the warehouse (available for sale). The unit price is $100. 
-- Add the information to the Product relation. Assume that pid is automatically maintained by the system.
-- TODO
 insert into PRODUCT (PNAME , UNIT_PRICE) values ('Telephone',100);


-- Question 2.3.3 (8 Points)
-- Update the unit_price in the Product relation according to this rule:
-- • if it is negative, set it to 0
-- • if it is larger than 10,000, then set it to 2,500
-- • if it is NULL, set it to 1,000
-- • if none of the above applies do not change the unit_price
-- Note that we expect you to write a single statement that implements this.
-- 
UPDATE PRODUCT 
SET UNIT_PRICE =  (CASE WHEN UNIT_PRICE < 0 THEN 0 WHEN UNIT_PRICE > 10000 THEN 2500 WHEN UNIT_PRICE IS NULL THEN 1000 ELSE UNIT_PRICE END );

-- Question 2.3.4 (7 Points)-- Update the salaries of employees as his/her current salary + 0.02 · (his/her total sales amount).
--
CREATE TABLE sum_q AS SELECT
EID,
sum( QUANTITY ) AS sum_quantity 
FROM
	SALES 
GROUP BY
	EID;
UPDATE EMPLOYEE e 
SET salary = SALARY + 0.02 * ( SELECT s.SUM_QUANTITY FROM sum_q s WHERE s.EID = e.EID ) 
WHERE
	e.EID = ( SELECT s.EID FROM sum_q s WHERE s.EID = e.EID );











