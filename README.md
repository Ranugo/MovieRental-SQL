##### Movie Rental Database SQL Project



###### Project Overview



This project simulates a database for a movie rental store. It tracks movies, customers, and rentals, and answers key business questions using SQL. This was my third independent database project, built to demonstrate my growing SQL skills including advanced features like indexes, views, stored procedures, and temporary tables.



Technologies Used

\- SQL Server Management Studio (SSMS)



###### Database Schema (3NF)



Movies

\- movieID (PK), movieTitle, movieGenre, releaseYear, rentalPricePerDay, copiesAvailable



Customers

\- customerID (PK), customerFirstName, customerLastName, customerEmail, customerPhone, membershipDate



Rentals

\- rentalID (PK), movieID (FK), customerID (FK), rentalDate, dueDate, actualReturnDate



###### Skills Demonstrated



Database Design

\- Entity Relationship Diagram (included in design notes)

\- Normalisation to 3NF



DDL \& DML

\- CREATE TABLE with PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE, DEFAULT

\- INSERT sample data



Queries

\- SELECT, WHERE, ORDER BY

\- INNER JOIN, LEFT JOIN

\- GROUP BY, HAVING

\- Aggregate functions: COUNT, AVG, SUM

\- DATEDIFF for date calculations

\- TOP with ORDER BY



Advanced Features

\- Indexes: NONCLUSTERED INDEX on Genre and ActualReturnDate

\- Views: vw\_AvailableMovies, vw\_CustomerRentalHistory

\- Stored Procedure: sp\_GenerateMonthlyRentalReport

\- Temporary Table: #MonthlySummary

\- Permanent log table: MonthlyRentalReport



###### Author

\- KWEZI RANUGO \[www.linkedin.com/in/kwezi-ranugo-3718b8379]

\- Student, IIE Bachelor of IT in Business Systems (DBAS6211)

