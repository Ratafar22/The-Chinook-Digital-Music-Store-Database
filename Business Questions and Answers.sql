-- Which Employee has the Highest total number of Customers?

SELECT e.LastName || ' ' || e.FirstName AS Employee, COUNT(c.customerid) AS Total_Customer
FROM Employee e
JOIN Customer c
ON e.EmployeeId = c.SupportRepId
GROUP BY 1
ORDER BY 1 DESC;


