/* CREATE DATABASE MovieRentalStoreDatabase_2;

USE MovieRentalStoreDatabase_2;

CREATE TABLE Movies(
	movieID INT IDENTITY(1,1) PRIMARY KEY,
	movieTitle VARCHAR(255) NOT NULL,
	movieGenre VARCHAR(255) NOT NULL,
	releaseYear INT NOT NULL,
	rentalPricePerDay DECIMAL(5,2) NOT NULL,
	copiesAvailable INT DEFAULT 0 NOT NULL
);

CREATE TABLE Customers(
	customerID INT IDENTITY(1,1) PRIMARY KEY,
	customerFirstName VARCHAR(255) NOT NULL,
	customerLastName VARCHAR(255) NOT NULL,
	customerEmail VARCHAR(255) UNIQUE NOT NULL,
	customerPhone VARCHAR(255) NOT NULL,
	membershipDate DATE DEFAULT CAST(GETDATE() AS DATE)
);

CREATE TABLE Rentals(
	rentalID INT IDENTITY(1,1) PRIMARY KEY,
	movieID INT
	CONSTRAINT fk_movieID
	FOREIGN KEY(movieID)
	REFERENCES Movies(movieID),
	customerID INT
	CONSTRAINT fk_customerID
	FOREIGN KEY(customerID)
	REFERENCES Customers(customerID),
	rentalDate DATE NOT NULL,
	dueDate DATE NOT NULL,
	actualReturnDate DATE
);


INSERT INTO Movies
VALUES	('Dune: Part Two', 'Sci-Fi', 2024, 3.50, 4),--1
		('Kung Fu Panda 4', 'Animation', 2024, 2.99, 3),--2
		('Anyone But You', 'Romance', 2023, 2.99, 2),--3
		('Godzilla x Kong', 'Action', 2024, 3.00, 5),--4
		('The Holdovers', 'Comedy', 2023, 2.50, 1),--5
		('Poor Things', 'Drama', 2023, 3.00, 2),--6
		('Migration', 'Animation', 2023, 2.50, 3),--7
		('Ferrari', 'Biography', 2023, 2.99, 2);--8

INSERT INTO Customers
VALUES	('Thabo', 'Ndlovu', 'thabo@email.com', '0712345678', '2025-01-10'),--1
		('Priya', 'Singh', 'priya@email.com', '0723456789', '2025-02-15'),--2
		('Ahmed', 'Patel', 'ahmed@email.com', '0734567890', '2025-03-20'),--3
		('Zoe', 'Van Wyk', 'zoe@email.com', '0745678901', '2025-04-05'),--4
		('Lebo', 'Mokoena', 'lebo@email.com', '0756789012', '2025-05-12'),--5
		('James', 'Smith', 'james@email.com', '0767890123', '2025-06-01');--6


INSERT INTO Rentals
VALUES	(1, 1, '2026-06-01', '2026-06-08', '2026-06-07'),--1
		(3, 2, '2026-06-05', '2026-06-12', NULL),--2
		(5, 3, '2026-06-07', '2026-06-14', NULL),--3
		(7, 4, '2026-06-10', '2026-06-17', NULL),--4
		(8, 5, '2026-06-02', '2026-06-09', '2026-06-10'),--5
		(6, 6, '2026-06-08', '2026-06-15', NULL),--6
		(1, 2, '2026-06-11', '2026-06-18', NULL),--7
		(2, 1, '2026-06-03', '2026-06-10', '2026-06-09'),--8
		(4, 3, '2026-06-12', '2026-06-19', NULL),--9
		(3, 4, '2026-06-09', '2026-06-16', NULL),--10
		(5, 6, '2026-06-04', '2026-06-11', '2026-06-13'),--11
		(8, 5, '2026-06-13', '2026-06-20', NULL);--12


-- Query Activities

-- Activity 1- List all movies with title, genre, and rental price, ordered by genre then title

SELECT  movieGenre, movieTitle, rentalPricePerDay
FROM Movies
ORDER BY movieGenre, movieTitle;

-- Activity 2- Show all currently rented movies with customer name and rental date

SELECT	Customers.customerID, 
		Customers.customerFirstName+ ' '+Customers.customerLastName AS CustomerFullName,
		Rentals.rentalDate
FROM Rentals
JOIN Customers ON Customers.customerID = Rentals.customerID
WHERE actualReturnDate IS NULL
;

-- Activity 3- Find movies that have been rented at least twice(show title and rental count)

SELECT	Rentals.movieID,
		Movies.movieTitle,
		COUNT(Rentals.movieID) AS [Number Of times Rented]
FROM Rentals
JOIN Movies ON Rentals.movieID = Movies.movieID
GROUP BY Rentals.movieID, Movies.movieTitle
HAVING COUNT(Rentals.movieID) > 1 ;


-- Activity 4- Calculate total revenue earned from rentals. Returned movies only (Assume kept days= DATEDIFF(DAY, rental date, actual returned date))

SELECT	SUM(Movies.rentalPricePerDay * DATEDIFF(DAY, rentalDate, actualReturnDate)) 
		AS [Revenue From Returned Movies]
FROM Movies
JOIN Rentals ON Rentals.movieID = Movies.movieID
WHERE Rentals.actualReturnDate IS NOT NULL ;

-- Activity 5- Show customers who have rented more than 2 movies (include cutomer name and count)

SELECT	Customers.customerFirstName+ ' '+Customers.customerLastName AS CustomerFullName,
		COUNT(Rentals.movieID) AS [Number Of times Rented]
FROM Rentals
JOIN Customers ON Rentals.customerID = Customers.customerID
GROUP BY Customers.customerFirstName, Customers.customerLastName
HAVING COUNT(Rentals.movieID) > 2 ;

-- Activity 6- List movies that have never been rented

SELECT	Movies.movieID,
		Movies.movieTitle
FROM Movies
LEFT JOIN Rentals ON Movies.movieID = Rentals.movieID
WHERE Rentals.rentalID IS NULL;

-- Activity 7- Find the most popular genre 

SELECT TOP 3 Movies.movieGenre,
		COUNT(Rentals.movieID) AS NumberOfRentals
FROM Rentals
JOIN Movies ON Rentals.movieID= Movies.movieID
GROUP BY Movies.movieGenre
ORDER BY COUNT(Rentals.movieID) DESC;

-- Activity 8- Calculate average rental price per genre

SELECT	Movies.movieGenre,
		AVG(Movies.rentalPricePerDay) AS [average rental price]
FROM Movies
GROUP BY Movies.movieGenre
ORDER BY AVG(Movies.rentalPricePerDay) DESC
;

-- Activity 9- Find the top 3 customers who have rented the most movies(by total number of rentals)

SELECT	TOP 3 Customers.customerFirstName+ ' '+Customers.customerLastName AS CustomerFullName,
		COUNT(Rentals.customerID) AS [total number of rentals]
FROM Rentals
INNER JOIN Customers ON Rentals.customerID = Customers.customerID
GROUP BY Customers.customerFirstName, Customers.customerLastName
ORDER BY COUNT(Rentals.customerID) DESC;

-- Activity 10- Display overdue rentals as of today (2026-06-14), include movie title, customer name, rental date, due date, and days overdue

SELECT	Rentals.rentalID,
		Movies.movieID,
		Movies.movieTitle,
		Customers.customerFirstName+ ' '+Customers.customerLastName AS CustomerFullName,
		Rentals.rentalDate,
		Rentals.dueDate,
		Rentals.actualReturnDate
FROM Rentals
JOIN Movies ON Movies.movieID = Rentals.movieID
JOIN Customers ON Customers.customerID = Rentals.customerID
WHERE dueDate < CAST(GETDATE() AS DATE) AND actualReturnDate IS NULL
;


SELECT * FROM Movies;
SELECT * FROM Customers;
SELECT * FROM Rentals;

-- Activities on Indexes, Views, Stored Procedures and Temp tables

CREATE NONCLUSTERED INDEX idx_genre
ON Movies(movieGenre);

CREATE NONCLUSTERED INDEX idx_actualReturnDate
ON Rentals(actualReturnDate);
*/

-- Create a View showing movies with Copies Available
/*
CREATE VIEW vw_AvailableMovies
AS
SELECT	Movies.movieGenre,
		Movies.movieTitle,
		Movies.copiesAvailable AS [Available Movies]
FROM Movies
WHERE Movies.copiesAvailable > 0
;
*/
SELECT * FROM vw_AvailableMovies;

-- Create a View showing customer rental history

/*
CREATE VIEW vw_CustomerRentalHistory 
AS
SELECT	Customers.customerFirstName+' '+ Customers.customerLastName AS CustomerFullName,
		Movies.movieTitle,
		Rentals.rentalDate,
		Rentals.dueDate,
		Rentals.actualReturnDate,
		SUM(DATEDIFF(DAY, Rentals.rentalDate, Rentals.actualReturnDate)) AS DaysKept

FROM Rentals
JOIN Customers ON Rentals.customerID = Customers.customerID
JOIN Movies ON Rentals.movieID = Movies.movieID
GROUP BY	Movies.movieTitle, 
			Rentals.rentalDate, 
			Rentals.dueDate,
			Rentals.actualReturnDate,
			Customers.customerFirstName, 
			Customers.customerLastName
;
*/
SELECT * FROM vw_CustomerRentalHistory;




CREATE TABLE MonthlyRentalReport(
		ReportID INT IDENTITY(1,1) PRIMARY KEY,
		Month INT NOT NULL,
		Year INT NOT NULL,
		MovieID INT NOT NULL
		CONSTRAINT fk_movieIDreport
		FOREIGN KEY (MovieID) 
		REFERENCES Movies(movieID)
		,
		MovieTitle VARCHAR(255) NOT NULL,
		TotalRentals INT NOT NULL,
		TotalRevenue DECIMAL(10,2) NOT NULL
);

GO
CREATE PROCEDURE sp_GenerateMonthlyRentalReport
	@Month INT,
	@Year INT
AS 
BEGIN
	CREATE TABLE #MonthlySummary(
		MovieID INT NOT NULL,
		MovieTitle VARCHAR(255) NOT NULL,
		TotalRentals INT NOT NULL,
		TotalRevenue DECIMAL(10,2) 
	);
	INSERT INTO #MonthlySummary(MovieID, MovieTitle, TotalRentals, TotalRevenue)
	SELECT	Movies.movieID,
			Movies.movieTitle,
			COUNT(Rentals.movieID) AS TotalRentals,
 SUM(DATEDIFF(DAY, rentalDate, COALESCE(actualReturnDate, GETDATE() ) )) * Movies.rentalPricePerDay
 AS TotalRevenue

	FROM Movies 
	LEFT JOIN Rentals ON Rentals.movieID = Movies.movieID
						AND MONTH(Rentals.rentalDate)= @Month
						AND YEAR(Rentals.rentalDate)= @Year
	GROUP BY	Movies.movieID,
				Movies.movieTitle,
				Movies.rentalPricePerDay;

	INSERT INTO MonthlyRentalReport
	SELECT	@Month,
			@Year,
			MovieID, 
			MovieTitle, 
			TotalRentals, 
			TotalRevenue

	FROM #MonthlySummary

	SELECT * FROM #MonthlySummary
	ORDER BY TotalRevenue DESC;

END;

EXEC sp_GenerateMonthlyRentalReport @Month = 6, @Year = 2026;

SELECT * FROM MonthlyRentalReport WHERE Month= 6 AND Year= 2026;