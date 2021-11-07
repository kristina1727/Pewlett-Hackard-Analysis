-- Creating tables for PH-EmployeeDB
CREATE TABLE departments(
	dept_no VARCHAR (4) NOT NULL,
	dept_name VARCHAR (40) NOT NULL,
	PRIMARY KEY (dept_no),
	UNIQUE (dept_name)
);
CREATE TABLE employees(	
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);
CREATE TABLE dept_manager(
	dept_no VARCHAR NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);
CREATE TABLE employee_dept(
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles(
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

SELECT * FROM departments;

-- Retirement Eligibility
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- Find employees with birth dates in 1952
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31'

-- Find employees with birth dates in 1953
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

-- Find employees with birth dates in 1954
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

-- Find employees with birth dates in 1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement Eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create a Retirement Info table to then export to CSV
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;
DROP TABLE retirement_info;

-- Create a Retirement Info table to include emp_no
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
	dept_manager.emp_no,
	dept_manager.from_date,
	dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	employee_dept.to_date
FROM retirement_info
LEFT JOIN employee_dept
ON retirement_info.emp_no = employee_dept.emp_no;

-- Joining retirement_info and dept_emp tables using Aliases
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	ed.to_date
FROM retirement_info as ri
LEFT JOIN employee_dept as ed
ON ri.emp_no = ed.emp_no;

-- Join retirement_info and employee_dept tables to create a table current_emp
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	ed.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN employee_dept as ed
ON ri.emp_no = ed.emp_no
WHERE ed.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), ed.dept_no
INTO dept_emp_count
FROM current_emp as ce
LEFT JOIN employee_dept as ed
ON ce.emp_no = ed.emp_no
GROUP BY ed.dept_no
ORDER BY ed.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT emp_no, first_name, last_name, gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- List of employee information
SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary, ed.to_date
-- INTO emp_info
From employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN employee_dept as ed
ON (e.emp_no = ed.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (ed.to_date = '9999-01-01');

-- List of managers per department
SELECT dm.dept_no,
	d.dept_name,
	dm.emp_no,
	ce.last_name,
	ce.first_name,
	dm.from_date,
	dm.to_date
INTO manager_info
FROM dept_manager AS dm
INNER JOIN departments AS d
ON (dm.dept_no = d.dept_no)
INNER JOIN current_emp AS ce
ON (dm.emp_no = ce.emp_no);

SELECT * FROM manager_info;

-- List of Department Retirees
SELECT ce.emp_no, 
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN employee_dept as ed
ON (ce.emp_no = ed.emp_no)
INNER JOIN departments as d
ON (ed.dept_no = d.dept_no);

SELECT * FROM dept_info;

DROP TABLE sales_info;
-- Sales Retirement List
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
INTO sales_info
FROM retirement_info as ri
INNER JOIN employee_dept as ed
ON (ri.emp_no = ed.emp_no)
INNER JOIN departments as d
ON (ed.dept_no = d.dept_no)
WHERE d.dept_name = ('Sales');

SELECT * FROM sales_info;

DROP TABLE sales_develop_info;
-- Sales Retirement List
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
INTO sales_develop_info
FROM retirement_info as ri
INNER JOIN employee_dept as ed
ON (ri.emp_no = ed.emp_no)
INNER JOIN departments as d
ON (ed.dept_no = d.dept_no)
WHERE d.dept_name IN ('Sales', 'Development');

SELECT * FROM sales_develop_info;