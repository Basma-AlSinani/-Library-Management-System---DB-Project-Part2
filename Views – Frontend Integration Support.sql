use Library_Management_System
--ViewPopularBooks 
create view ViewPopularBooksDescription AS
select B.Book_ID,B.Title,AVG(R.Rating) AS AvgRating, COUNT(L.Loan_ID) AS TotallLoans
From Book B
Left join Review R ON B.Book_ID=R.Book_ID
Left join Loan L ON B.Book_ID=L.Book_ID
Group by B.Book_Id,B.Title
having AVG(R.Rating)>4.5;

SELECT * FROM ViewPopularBooksDescription;

--ViewMemberLoanSummary
Create View ViewMemberLoanSummary AS 
SElect M.member_Id, M.F_Name + ' ' + M.L_Name AS MemberName,COUNT(L.Loan_ID) AS LoanCount,  ISNULL(SUM(FP.Amount), 0) AS TotalFinesPaid
FRom Member M
Left join Loan L On M.Member_Id=L.Member_Id
Left join Fine_Payment FP ON L.Loan_ID=FP.Loan_ID
Group By M.Member_Id,M.F_Name,M.L_Name;
   
SELECT * FROM ViewMemberLoanSummary;

--ViewAvailableBooks
Create View ViewAvailableBooks AS
select Book_ID,Title,Genre, Price,Library_ID
from Book
where AvailableStatus = 1
--Order by Genre, Price;
select * 
from ViewAvailableBooks
Order by Genre, Price;

--ViewLoanStatusSummary 
Create View ViewLoanStatusSummary AS
select Lib.Library_ID,Lib.Name AS LibraryName,
SUM(CASE WHEN L.Status = 'Issued' THEN 1 ELSE 0 END) AS IssuedCount,
SUM(CASE WHEN L.Status = 'Returned' THEN 1 ELSE 0 END) AS ReturnedCount,
SUM(CASE WHEN L.Status IS NULL AND L.DueDate < GETDATE() THEN 1 ELSE 0 END) AS OverdueCount
from Library Lib
Left join Book B on Lib.Library_ID = B.Library_ID
Left join Loan L on B.Book_ID = L.Book_ID
Group By Lib.Library_ID, Lib.Name;

SELECT * FROM ViewLoanStatusSummary;

--ViewPaymentOverview
Create View ViewPaymentOverview AS
select FP.Fine_Payment_Id,FP.PaymentDate,FP.Method,FP.Amount,M.Member_Id,M.F_Name + ' ' + M.L_Name AS MemberName,B.Book_ID,B.Title AS BookTitle,L.Status AS LoanStatus
from Fine_Payment FP
Join Loan L ON FP.Loan_ID = L.Loan_ID
Join Member M ON L.Member_Id = M.Member_Id
Join Book B ON L.Book_ID = B.Book_ID;

SELECT * FROM ViewPaymentOverview;