-- Create a table showing the number of retiring employees by title
SELECT e.emp_no, e.first_name, e.last_name, t.title, t.from_date,t.to_date
INTO ee_retiring_title
FROM employees AS e
INNER JOIN titles as t
ON e.emp_no = t.emp_no
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY e.emp_no;

SELECT * FROM ee_retiring_title

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no) rt.emp_no, first_name,  last_name, title
INTO unique_titles
FROM  ee_retiring_title as rt
ORDER BY rt.emp_no, rt.to_date DESC;

SELECT * FROM unique_titles

--  Retrieve the number of employees by their most recent job title who are about to retire
SELECT COUNT(emp_no), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT (emp_no) DESC;

SELECT * FROM retiring_titles

-- Create Mentorship Eligibility table 
SELECT DISTINCT ON (e.emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date, ed.from_date, ed.to_date, t.title
INTO mentorship_eligibility
FROM employees AS e
INNER JOIN employee_dept AS ed
ON e.emp_no = ed.emp_no
INNER JOIN titles AS t
ON e.emp_no = t.emp_no
WHERE ed.to_date = ('9999-01-01')
AND e.birth_date BETWEEN  '1965-01-01' AND '1965-12-31'
ORDER BY e.emp_no;

SELECT * FROM mentorship_eligibility

 