use Library_Management_System
--========================Triggers – Real-Time Business Logic =========================================
--trg_UpdateBookAvailability 
--After new loan → set book to unavailable 
create trigger trg_UpdateBookAvailability
On loan
After Insert 
AS Begin 
Update B
set AvailableStatus=0
from Book B
join Inserted I on B.Book_ID=I.Book_ID;
End;

SELECT * FROM Member;

INSERT INTO Loan (Book_ID, Member_ID, LoanDate, DueDate)
VALUES (9, 2, GETDATE(), DATEADD(DAY, 7, GETDATE()));
SELECT * FROM Book;

--=============================================================================================
--trg_CalculateLibraryRevenue After new payment → update library revenue
create trigger trg_CalculateLibraryRevenue
on Fine_Payment
After Insert
AS Begin 
Update L
SEt L.TotalRevenue=ISNULL(L.TotalRevenue, 0) + FP.Amount
From Library L
Join Book B ON B.Library_ID=L.Library_ID
join Loan LN On LN.Book_ID=B.Book_ID
join inserted FP ON FP.Loan_ID=LN.Loan_ID;
end;

INSERT INTO Fine_Payment (PaymentDate, Method, Amount, Loan_ID)
VALUES ('2025-06-02', 'Cash', 15.00, 3);

SELECT Library_ID, Name, TotalRevenue
FROM Library;

--=============================================================================================
--trg_LoanDateValidation   Prevents invalid return dates on insert
create trigger trg_LoanDateValidation
on loan 
INSTEAD OF INSERT
AS BEGIN
if EXISTS (select 1 
from inserted  
where ReturnDate IS NOT NULL AND ReturnDate < LoanDate )
BEGIN
raiserror('ReturnDate cannot be earlier than LoanDate.', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END
INSERT INTO Loan (Status, ReturnDate, DueDate, LoanDate, Book_ID, Member_Id)
SELECT Status, ReturnDate, DueDate, LoanDate, Book_ID, Member_Id
FROM inserted;
END;

INSERT INTO Loan (Status, ReturnDate, DueDate, LoanDate, Book_ID, Member_Id)
VALUES ('Returned', '2025-06-10', '2025-06-08', '2025-06-01', 5, 2);

INSERT INTO Loan (Status, ReturnDate, DueDate, LoanDate, Book_ID, Member_Id)
VALUES ('Returned', '2025-05-01', '2025-05-10', '2025-06-01', 1, 1);
-- Error: ReturnDate cannot be earlier than LoanDate.
