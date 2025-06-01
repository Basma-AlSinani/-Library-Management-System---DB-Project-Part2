use Library_Management_System

--=====================SELECT Queries=======================
--==========================================================================
--GET /loans/overdue → List all overdue loans with member name, book title, due date  
select L.Loan_ID,M.F_Name+'  '+M.L_Name AS MemberName,B.Title,L.DueDate
from Loan L
join Member M on L.Member_Id=M.Member_Id
join Book B on L.Book_ID=B.Book_ID
where L.DueDate<GETDATE() And  L.ReturnDate IS NULL;
--GETDATE() to get current date
--Loan.Status!='Returned' check that the status is not 'Returned' to ensure it is still due
--select * from Loan

--==========================================================================
--GET /books/unavailable → List books not available  
select * 
from Book
where AvailableStatus=0;

--==========================================================================
-- GET /members/top-borrowers → Members who borrowed >2 books
select M.Member_Id,M.F_Name,M.L_Name,COUNT(*) AS BorrowedBooks
from Loan L
join Member M on L.Member_Id=M.Member_Id
Group by M.Member_Id,M.F_Name,M.L_Name
Having COUNT(*)>2;

--==========================================================================
--GET /books/:id/ratings → Show average rating per book 
select B.Book_ID,B.Title,AVG(R.Rating) AS AvgRating
from Book B
Join Review R on B.Book_ID=R.Book_ID
where B.Book_ID=5--هنا نحط رقم الكتاب اللي نريد نعرف المتوسط له
Group by B.Book_ID,B.Title;

--==========================================================================
--GET /libraries/:id/genres → Count books by genre  
select Genre,COUNT(*) AS BookCount
from Book
where Library_ID=2
Group By Genre;

--==========================================================================
--GET /members/inactive → List members with no loans 
select *
From Member M
Left Join Loan L ON M.Member_Id=L.Member_Id
Where L.Loan_ID IS NULL;

--==========================================================================
--GET /payments/summary → Total fine paid per member  
select M.Member_Id,M.F_Name+'  '+M.L_Name AS MemberName,SUM(FP.Amount) AS TotalPaid
from Fine_Payment FP
join Loan L ON FP.Loan_ID=L.Loan_ID
Join Member M ON L.Member_Id=M.Member_Id
Group by M.Member_Id,M.F_Name,M.L_Name;

--==========================================================================
--GET /reviews → Reviews with member and book info 
Select R.Review_Id,R.Comments,R.Rating,R.ReviewDate,B.Title, M.F_Name + ' ' + M.L_Name AS MemberName
from Review R
join Book B ON R.Book_ID=B.Book_ID
Join Member M ON R.Member_Id=M.Member_Id;

--==========================================================================
--GET /books/popular → List top 3 books by number of times they were loaned
select top 3 B.Book_Id,B.Title, COUNT(*) AS LoanCount
from loan L
join Book B On L.Book_ID=B.Book_ID
Group BY B.Book_ID,B.Title
order by LoanCount DESC;

--==========================================================================
--GET /members/:id/history → Retrieve full loan history of a specific member including book title, loan & return dates 
--Select * from Loan
--Select * from Member
select L.Loan_ID,B.Title,L.LoanDate,L.DueDate,L.ReturnDate,L.Status
From Loan L
join Book B ON L.Book_ID=B.Book_ID
where L.Member_Id=2;

--==========================================================================
--GET /books/:id/reviews → Show all reviews for a book with member name and comments
select * from Book

select R.Review_Id,R.Rating,R.Comments,R.ReviewDate,M.F_Name+' '+M.L_Name AS MemberName
from Review R
join Member M On R.Member_Id=M.Member_Id
where R.Book_ID=5
Order BY R.ReviewDate ;

--==========================================================================
--GET /libraries/:id/staff → List all staff working in a given library
select S.Staff_ID,S.F_Name+' '+S.L_Name AS StaffName,S.Position,L.Library_ID,L.Name AS LibraryName
From Staff S
join Library L ON S.Library_ID=L.Library_ID
where L.Library_ID=2;

--==========================================================================
--GET /books/price-range?min=5&max=15 → Show books whose prices fall within a given range
select Book_ID,Title,Price,Genre,AvailableStatus
from Book
where Price Between 50 AND 150 --Note: I used the range 50 to 150 instead of 5 to 15
-- because there are no books in the database with prices between 5 and 15.

--==========================================================================
--GET /loans/active → List all currently active loans (not yet returned) with member and book info 
select L.Loan_ID,L.LoanDate,L.DueDate,L.Status,M.F_Name+' '+M.L_Name AS MemberName,B.Title
from Loan L
join Member M On L.Member_Id=M.Member_Id
join Book B ON L.Book_ID=B.Book_ID
WHERE L.ReturnDate IS NULL;

--==========================================================================
--GET /members/with-fines → List members who have paid any fine 
select M.Member_Id,M.F_Name+' '+M.L_Name AS MemberName,M.Email,SUM(FP.Amount)AS TotalFinesPaid
from Member M
join Loan L on M.Member_Id=l.Member_Id
Join Fine_Payment FP on l.Loan_ID=FP.Loan_ID
group by M.Member_Id,m.F_Name,m.L_Name,m.Email;

--==========================================================================
--GET /books/never-reviewed →  List books that have never been reviewed
select B.Book_ID,B.Title,B.Genre,B.Price
from Book B
left join Review R On B.Book_ID=R.Book_ID
where R.Review_Id IS NULL;

--==========================================================================
--GET /members/:id/loan-history →Show a member’s loan history with book titles and loan status.
select L.Loan_ID,B.Title AS BookTitle ,L.LoanDate,L.DueDate,L.ReturnDate,L.Status
from Loan L
Join Book B ON L.Book_ID=B.Book_ID
Where L.Member_Id=2;

--==========================================================================
-- GET /members/inactive →List all members who have never borrowed any book.
select M.Member_Id,M.F_Name+'  '+M.L_Name AS MemberName,M.Email,M.StartDate
From Member M
left join Loan L on M.Member_Id=L.Member_Id
where L.Loan_ID IS NULL;

--==========================================================================
--GET /books/never-loaned → List books that were never loaned. 
select B.Book_ID,B.Title, B.Genre, B.AvailableStatus
from Book B
left join Loan L ON B.Book_ID = L.Book_ID
where L.Loan_ID IS NULL;

--==========================================================================
--GET /payments →List all payments with member name and book title. 
select FP.Fine_Payment_Id,FP.PaymentDate,FP.Method,FP.Amount, M.F_Name + ' ' + M.L_Name AS MemberName,B.Title AS BookTitle
from Fine_Payment FP
join Loan L On FP.Loan_ID=L.Loan_ID
join Member M on L.Member_Id=M.Member_Id
Join Book B ON L.Book_ID=B.Book_ID;

--==========================================================================
--GET /loans/overdue→ List all overdue loans with member and book details. 
select  L.Loan_ID, L.LoanDate, L.DueDate,M.F_Name + ' ' + M.L_Name AS MemberName, M.Email, B.Title AS BookTitle, B.Genre
from Loan L 
Join Member M on L.Member_Id=M.Member_Id
Join Book B on L.Book_ID=B.Book_ID
where l.DueDate<GETDATE() And L.Status Is NULL;

--==========================================================================
--GET /books/:id/loan-count → Show how many times a book has been loaned. 
select B.Book_ID,B.Title,Count(L.Loan_Id)AS LoanCount
from Book B
left join Loan L ON B.Book_ID=L.Book_ID
Where B.Book_ID=3
group by B.Book_ID,B.Title;

--==========================================================================
--GET /members/:id/fines → Get total fines paid by a member across all loans
select  M.Member_Id,M.F_Name + ' ' + M.L_Name AS MemberName,SUM(FP.Amount) AS TotalFinesPaid
from  Member M
join Loan L ON M.Member_Id = L.Member_Id
join Fine_Payment FP ON L.Loan_ID = FP.Loan_ID
where M.Member_Id =2
group by M.Member_Id, M.F_Name, M.L_Name;

--==========================================================================
--GET /libraries/:id/book-stats → Show count of available and unavailable books in a library.
select B.AvailableStatus,COUNT(*) AS BookCount
from Book B
where B.Library_ID = 3
group by B.AvailableStatus;

--==========================================================================
--GET /reviews/top-rated → Return books with more than 5 reviews and average rating > 4.5. 
select B.Book_ID,B.Title,COUNT(R.Review_Id) AS ReviewCount,AVG(R.Rating) AS AverageRating
from Book B
JOIN Review R ON B.Book_ID = R.Book_ID
group by  B.Book_ID, B.Title
having COUNT(R.Review_Id) > 5 AND AVG(R.Rating) > 4.5;
