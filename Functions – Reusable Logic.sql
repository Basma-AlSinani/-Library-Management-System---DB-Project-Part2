use Library_Management_System
--======================Functions – Reusable Logic =================
--GetBookAverageRating(BookID) 
create Function GetBookAverageRating(@BookID int)
RETURNS float
as begin 
Declare @AvgRating Float;
select @AvgRating=AVG(Rating)
from Review
Where Book_ID=@BookID;
RETURN @AvgRating;
END;

select dbo.GetBookAverageRating(5) AS AvgRating;

--===============================================================
--GetNextAvailableBook(Genre, Title, LibraryID)
create Function GetNextAvailableBook(@Genre NVARCHAR(100),@Title NVARCHAR(200),@LibraryID INT)
RETURNS int
as begin 
Declare  @BookID int;
select Top 1 @BookID=Book_ID
from Book
where Genre=@Genre And Title=@Title And Library_ID=@LibraryID And AvailableStatus=1
order by Book_ID;
RETURN @BookID;
END;

select dbo.GetNextAvailableBook('Science Fiction', 'Dune', 2) AS AvailableBookID;

--===============================================================
--CalculateLibraryOccupancyRate(LibraryID)
create Function CalculateLibraryOccupancyRate(@LibraryID INT) 
RETURNS float
as begin 
Declare @TotalBooks INT;
Declare @UnReturendBook Int;
Declare @LibraryLoad Float;

Select @TotalBooks =COUNT(*)
from Book
where Library_ID=@LibraryID;

select @UnReturendBook=COUNT(DISTINCT B.Book_ID)
from Book B
join Loan L On B.Book_ID=L.Book_ID
Where B.Library_ID=@LibraryID And L.ReturnDate IS NULL;

IF @TotalBooks=0 SET @LibraryLoad=0;
Else
Set @LibraryLoad=(@UnReturendBook*1.0/@TotalBooks)*100;
RETURN @LibraryLoad ;
End;

select dbo.CalculateLibraryOccupancyRate(3) AS OccupancyRate;

--===============================================================
--fn_GetMemberLoanCount 
create Function fn_GetMemberLoanCount (@MemberID INT)
RETURNS int
as Begin
Declare @LoanCount int;
select @LoanCount=COUNT(*)
from Loan
where Member_Id=@MemberID;
RETURN @LoanCount;
end;

SELECT dbo.fn_GetMemberLoanCount(2) AS TotalLoans;

--===============================================================
--fn_GetLateReturnDays
create Function fn_GetLateReturnDays (@LoanID INT)
RETURNS int
as Begin
Declare @LateDays int;
select @LateDays =Case when ReturnDate IS NOT NULL AND ReturnDate > DueDate THEN DATEDIFF(DAY, DueDate, ReturnDate)
else 0
end
from Loan
where Loan_ID=@LoanID;
return ISNULL (@LateDays, 0)
end;

SELECT dbo.fn_GetLateReturnDays(3) AS LateDays;

--===============================================================
--fn_ListAvailableBooksByLibrary Returns a table of available books from a specific library. 
create Function fn_ListAvailableBooksByLibrary (@LibraryID INT)
RETURNS TABLE As 
RETURN( 
select Book_ID,Title,Genre,Price,AvailableStatus
from Book
where Library_ID=@LibraryID
And AvailableStatus=1);

SELECT * FROM fn_ListAvailableBooksByLibrary(2);

--===============================================================
--fn_GetTopRatedBooks Returns books with average rating ≥ 4.5
create Function fn_GetTopRatedBooks()
RETURNS TABLE As 
RETURN(select B.Book_ID,B.Title,AVG(R.Rating)AS AvgRating
from BooK B
join Review R on B.Book_ID=R.Book_ID
group By B.Book_ID,B.Title
having AVG(R.Rating)>=4.5);

SELECT * FROM fn_GetTopRatedBooks();

--===============================================================
--fn_FormatMemberName Returns the full name formatted as "LastName, FirstName"
create Function fn_FormatMemberName (@FirstName NVARCHAR(50),@LastName NVARCHAR(50))
RETURNS NVARCHAR(101)
as Begin 
RETURN @LastName+', '+@FirstName;
end;

SELECT dbo.fn_FormatMemberName('Ali', 'Ahmed') AS FormattedName;

