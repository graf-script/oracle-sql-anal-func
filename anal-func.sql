Analytical Functions or Window Functions in Oracle:
==========================================
/*
    1. RANK() -- RANK() over(order by ranking_cloumn asc|desc)
    
    --RANK() over(partition by group_column order by ranking_cloumn asc|desc)
    
    2. DENSE_RANK() -- Dense_RANK() over(order by ranking_cloumn asc|desc)
    
    3. Row_number()
    
    4. Lead()
    
    5. Lag()

*/

SELECT * FROM employees;

SELECT SUM(salary) FROM employees;

SELECT employee_id, first_name, salary, department_id,
SUM(salary) OVER(PARTITION BY department_id), SUM(salary) OVER() FROM employees;

------------------------------------

/*
    RANK() OVER(ORDER BY salary DESC)
*/

SELECT employee_id first_name, email, phone_number, salary, department_id, 
RANK() OVER(ORDER BY salary DESC) RANK FROM employees;

-- DENSE_RANK()

SELECT employee_id, first_name, email, phone_number, salary, department_id,
DENSE_RANK() OVER(ORDER BY salary) RANK FROM employees;

SELECT employee_id, first_name, email, phone_number, salary, department_id,
DENSE_RANK() OVER(ORDER BY salary DESC) RANK FROM employees;

-- ROW_NUMBER()

SELECT employee_id, first_name, email, phone_number, hire_date, salary, department_id,
ROW_NUMBER() OVER(ORDER BY salary DESC) no_ties FROM employees;

SELECT employee_id, first_name, email, phone_number, hire_date, salary, department_id,
ROW_NUMBER() OVER(ORDER BY salary, hire_date) no_ties FROM employees;

-------------------

-- GROUP BY => PARTITION BY

SELECT employee_id, first_name, email, phone_number, salary, department_id,
RANK() OVER(PARTITION BY department_id ORDER BY salary) RANK FROM employees;

SELECT employee_id, first_name, email, phone_number, salary, department_id,
RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) RANK FROM employees;

-----------------------

SELECT employee_id, first_name, email, phone_number, salary, department_id,
DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary) RANK FROM employees;

SELECT employee_id, first_name, email, phone_number, salary, department_id,
DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) RANK FROM employees;

------------------------

-- Least 5 salaried employees

SELECT employee_id, first_name, email, phone_number, salary, department_id,
RANK FROM (SELECT employee_id, first_name, email, phone_number, salary, department_id,
RANK() OVER(ORDER BY salary) RANK FROM employees) WHERE RANK <= 5;

-- Top 5 earners

SELECT employee_id, first_name, email, phone_number, salary, department_id,
RANK FROM (SELECT employee_id, first_name, email, phone_number, salary, department_id,
RANK() OVER(ORDER BY salary DESC) RANK FROM employees) WHERE RANK <= 5;

-- Least 5 employees

SELECT employee_id, first_name, email, phone_number, salary, department_id,
RANK FROM (SELECT employee_id, first_name, email, phone_number, salary, department_id,
DENSE_RANK() OVER(ORDER BY salary) RANK FROM employees) WHERE RANK <= 5;

SELECT employee_id, first_name, email, phone_number, salary, department_id,
RANK FROM (SELECT employee_id, first_name, email, phone_number, salary, department_id,
DENSE_RANK() OVER(ORDER BY salary DESC) RANK FROM employees) WHERE RANK <= 5;

-----------------

-- Top 5 earners with department_name

SELECT 
a.first_name,
a.email,
a.phone_number,
a.salary,
a.department_id,
d.department_name,
a.rank
FROM (SELECT employee_id, first_name, email, phone_number, salary, department_id,
RANK() OVER(ORDER BY salary DESC) "RANK" FROM employees) a INNER JOIN departments d
ON a.department_id = d.department_id WHERE a.rank <=5 ORDER BY a.rank;

-------------------

-- 100

-- middle record

SELECT * FROM employees WHERE ROWNUM <= 5;

-- 107

-- SELECT COUNT(ROWNUM) = COUNT(ROWNUM)/2;

SELECT ROWNUM, e.* FROM employees e WHERE ROWNUM <= (SELECT ROUND(COUNT(*)/2) FROM employees)
MINUS
SELECT ROWNUM, e.* FROM employees e WHERE ROWNUM < (SELECT ROUND(COUNT(*)/2) FROM employees);

-------------------

-- LEAD()
-- LAG()

SELECT employee_id, first_name, email, phone_number, hire_date, salary, departmenT_id,
LEAD(hire_date) OVER(ORDER BY hire_date) after_hire,
LEAD(first_name) OVER(ORDER BY hire_date) after_hire_name FROM employees;

SELECT * FROM (
SELECT employee_id, first_name, email, phone_number, hire_date, salary, department_id,
LAG(hire_date) OVER(ORDER BY hire_date) before_hire_date,
LAG(first_name) OVER(ORDER BY hire_date) before_hire_name FROM employees) 
WHERE employee_id = 142;

----------------------

SELECT employee_id, first_name, email, phone_number, hire_date, salary, department_id,
LEAD(first_name) OVER(ORDER BY salary) high_salary_person,
LEAD(salary) OVER(ORDER BY salary) high_salary FROM employees;

----------------------

SELECT employee_id, first_name, salary, department_id, SUM(salary) OVER() FROM employees;

SELECT employee_id, first_name, salary, department_id, SUM(salary) OVER(PARTITION BY department_id),
SUM(salary) OVER() FROM employees;
