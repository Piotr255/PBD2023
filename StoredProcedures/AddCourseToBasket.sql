USE [u_konior]
GO
/****** Object:  StoredProcedure [dbo].[AddCourseToBasket]    Script Date: 02.01.2024 20:41:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[AddCourseToBasket]
	@OrderID nvarchar(50), 
	@StudentID int,
	@CourseID int,
	@PaymentHyperlink nvarchar(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON
    
	DECLARE @date_ok bit; -- weryfikujemy, czy na pewno nadal można kupić kurs(trzeba dokonać wpłaty na 3 dni przed 
	-- rozpoczęciem kursu
	SELECT @date_ok = CASE 
						WHEN DATEDIFF(second, GETDATE(), StartDate) > 259200 THEN 1 -- 259200s = 72h = 3 dni
						ELSE 0
						END
					FROM 
					Courses
					WHERE CourseID=@CourseID;

	IF (@date_ok=0)
	BEGIN
		RAISERROR ('Za późno na kupienie tego kursu',16,1) WITH NOWAIT;
	END;
	-- weryfikujemy, czy podany kurs i student istnieją
	IF ((select count(CourseID) from Courses where CourseID=@CourseID) > 0) AND 
		((select count(StudentID) from Students where StudentID=@StudentID) > 0)
	BEGIN
		INSERT INTO Orders (OrderID, StudentID, Status, AdditionToBasketDate, PaymentHyperlink)
		VALUES (@OrderID, @StudentID, 'Pending', GETDATE(), @PaymentHyperlink);
		INSERT INTO OrderedCourses (OrderID, CourseID, HasBeenPaidFor)
		VALUES (@OrderID, @CourseID, 0);
	END
	ELSE
	BEGIN
		RAISERROR ('Nie istnieje Kurs albo Student o takim ID',16,1);
	END
END