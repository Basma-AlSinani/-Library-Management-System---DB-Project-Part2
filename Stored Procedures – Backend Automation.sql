use Library_Management_System
--==========================. Stored Procedures – Backend Automation ===============
--sp_MarkBookUnavailable(BookID)
create Procedure sp_MarkBookUnavailable @BookID INT
as begin 
Update Book 
set AvailableStatus=0
where Book_ID=@BookID;
End;

EXEC sp_MarkBookUnavailable @BookID = 5;
EXEC sp_MarkBookUnavailable @BookID = 2;
SELECT * FROM Book

--==================================================================================
--sp_UpdateLoanStatus() Checks dates and updates loan statuses
create Procedure p_UpdateLoanStatus
AS BEGIN
Update Loan
set Status='Returned'
where ReturnDate IS NOT NULL;

Update Loan
set Status='Overdue'
where ReturnDate IS NULL and DueDate<GETDATE();

Update Loan
set Status='Issued'
where ReturnDate IS NULL and DueDate<GETDATE();
end;
EXEC p_UpdateLoanStatus;

SELECT * FROM Loan

DROP PROCEDURE p_UpdateLoanStatus;

--==================================================================================
--sp_RankMembersByFines() Ranks members by total fines paid
create Procedure sp_RankMembersByFines
AS BEGIN
select M.Member_Id,M.F_Name+' '+M.L_Name,Sum(FP.Amount) AS TotalFinalPaid
from Member M
join Loan L On M.Member_Id=L.Member_Id
Join Fine_Payment FP On L.Loan_ID=FP.Loan_ID
Group By M.Member_Id,M.F_Name,M.L_Name
order by SUM(FP.Amount)DESC;
END;

EXEC sp_RankMembersByFines;

