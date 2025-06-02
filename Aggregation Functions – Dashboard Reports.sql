use Library_Management_System
--========================Aggregation Functions – Dashboard Reports =================
--Total fines per member 
select M.F_Name+' '+M.L_Name AS MemberName,SUM(FP.Amount) AS FinalTotal
from Member M
join Loan L On M.Member_Id=L.Member_Id
join Fine_Payment FP ON L.Loan_ID=FP.Loan_ID
Group By M.Member_Id,M.F_Name,M.L_Name
Order By FinalTotal DESC;

--==========================================================================================
--Most active libraries (by loan count) 
select L.Library_ID,L.Name ,COUNT(*) AS TotalLoan
from Loan LN
JOIN Book B ON LN.Book_ID = B.Book_ID
JOIN Library L ON B.Library_ID = L.Library_ID
Group By L.Library_ID,L.Name
Order By TotalLoan DESC;

--==========================================================================================
--Avg book price per genre 
select Genre,Avg(Price) AS AvgPrice
from Book
group by Genre
Order by AvgPrice;

--==========================================================================================
--Top 3 most reviewed books 
select B.Title,COUNT(R. Review_Id) As ReviewCount
from Review R
join Book B ON R.Book_ID=B.Book_ID
Group By B.Title
Order By ReviewCount;

--==========================================================================================
--Library revenue report
select L.Library_ID,L.Name AS Library_Name,ISNULL(SUM(FP.Amount), 0) AS Total_Revenue
from Library L
Left join Book B ON B.Library_ID = L.Library_ID
Left join Loan LN ON LN.Book_ID = B.Book_ID
Left join Fine_Payment FP ON FP.Loan_ID = LN.Loan_ID
Group By L.Library_ID, L.Name
Order By Total_Revenue DESC;

--==========================================================================================
--Member Activity Summary (Loans + Fines)
select M.Member_Id, M.F_Name + ' ' + M.L_Name AS Member_Name,COUNT(DISTINCT L.Loan_ID) AS Total_Loans,ISNULL(SUM(FP.Amount), 0) AS Total_Fines
from Member M
Left join Loan L ON M.Member_Id = L.Member_Id
Left join Fine_Payment FP ON L.Loan_ID = FP.Loan_ID
Group By M.Member_Id, M.F_Name, M.L_Name
Order By Total_Loans DESC, Total_Fines ;