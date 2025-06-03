use Library_Management_System
--====================Transactions – Ensuring Consistency ========================
--Borrowing a book (loan insert + update availability) 
Begin Transaction
Begin TRY
Insert Into Loan(Book_ID, Member_ID, LoanDate, DueDate)
Values (5, 2, GETDATE(), DATEADD(DAY, 14, GETDATE()));
Update Book
SEt AvailableStatus=0
where Book_ID=5;
commit;
end try
Begin catch
rollback;
End catch;

--=====================================================================================
--Returning a book (update status, return date, availability) 
Begin Transaction
Update Loan
Set Status= 'Returned',ReturnDate=GETDATE()
Where Loan_ID=3;
Update Book
Set AvailableStatus=1
where Book_ID = (select Book_ID from Loan where Loan_ID = 3);

select * from Loan
select * from Book
select * from Member

--=====================================================================================
--Registering a payment (with validation) 
Begin Transaction
Insert Into Fine_Payment (Loan_ID, Amount, PaymentDate)
Values (7, 25.00, GETDATE());
commit;

--=====================================================================================
--Batch loan insert with rollback on failure 
Begin try
Begin Transaction
Insert Into Loan (Book_ID, Member_ID, LoanDate, DueDate)
Values(8, 2, GETDATE(), DATEADD(DAY, 10, GETDATE())),
      (10, 1, GETDATE(), DATEADD(DAY, 10, GETDATE()));
commit;
end try
Begin catch
rollback;
End catch;