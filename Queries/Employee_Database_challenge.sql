-- DELIVERABLE 1
-- Create Retirement Titles Table
SELECT e.emp_no, e.first_name, e.last_name, t.title, t.from_date, t.to_date
INTO retirement_titles
FROM employees AS e
INNER JOIN titles AS t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no ASC;

-- Remove duplicate employee numbers
SELECT DISTINCT ON (rt.emp_no) 
rt.emp_no, 
rt.first_name, 
rt.last_name, 
rt.title
INTO unique_titles
FROM retirement_titles AS rt
WHERE rt.to_date = '9999-01-01'
ORDER BY rt.emp_no ASC, rt.to_date DESC;

-- Retrieve number of employees by title
SELECT title, COUNT(emp_no) AS "total count"
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY "total count" DESC;

-- DELIVERABLE 2
-- Create Mentorship Eligibility Table
SELECT DISTINCT ON (e.emp_no) 
e.emp_no, 
e.first_name, 
e.last_name, 
e.birth_date, 
de.from_date, 
de.to_date, 
t.title
INTO mentorship_eligibility
FROM employees AS e
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
INNER JOIN titles AS t
ON (e.emp_no = t.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

-- ADDITIONAL QUERY
SELECT title, COUNT(emp_no) AS "total count"
INTO mentee_count
FROM mentorship_eligibility
GROUP BY title
ORDER BY "total count" DESC;

SELECT rt.title,
  	rt."total count" as "Retiree Count",
  	mc."total count" as "Mentee Count",
    ROUND(rt."total count"/mc."total count", 1) AS PERCENT
FROM retiring_titles as rt
LEFT JOIN mentee_count as mc
ON (rt.title = mc.title);
