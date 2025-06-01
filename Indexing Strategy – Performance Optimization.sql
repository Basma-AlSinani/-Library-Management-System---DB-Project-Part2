use Library_Management_System
--============================== Indexing Strategy – Performance Optimization ======================
--Library Table 
--Non-clustered on Name → Search by name
create Nonclustered Index IX_Library_Name
ON Library(Name)

--Non-clustered on Location → Filter by location
create Nonclustered Index IX_Library_Location
ON Library(Location)

--Book Table 
-- Clustered on LibraryID, ISBN → Lookup by book in specific library
Create Clustered Index IX_Book_LibraryID_ISBN
ON Book(Library_ID, ISBN)
--I GET THIS ERROR
--Cannot create more than one clustered index on table 'Book'. Drop the existing clustered index 'PK__Book__C223F39499208A34' before creating another.

--The main key index for a column such as Book_ID i the current index. 
--SQL Server automatically builds a clustered index on a primary key when it is built.

--Non-clustered on Genre → Filter by genre 
create Nonclustered Index IX_Book_genre
ON Book(Genre)

--Loan Table 
--Non-clustered on MemberID → Loan history 
create Nonclustered Index IX_Loan_MemberID
ON Loan(Member_ID)

--Non-clustered on Status → Filter by status 
create Nonclustered Index IX_Loan_status
ON Loan(status)
--Composite index on BookID, LoanDate, ReturnDate → Optimize overdue checks 
create Nonclustered Index IX_Loan_BookID_LoanDate_ReturnDate
ON Loan(Book_ID, LoanDate, ReturnDate);


