USE [u_konior]
GO
/****** Object:  StoredProcedure [dbo].[AddCourseToBasket]    Script Date: 21.01.2024 18:30:42 ******/
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
	SET XACT_ABORT ON; -- !!!
	-- weryfikujemy, czy podany kurs i student istnieją
BEGIN TRY
	IF NOT EXISTS (SELECT 1 FROM Courses WHERE CourseID = @CourseID) OR 
		NOT EXISTS (select 1 from Students where StudentID=@StudentID)
		THROW 50002,'Nie istnieje Kurs albo Student o takim ID',1;
	-- weryfikujemy, czy dany student nie ma już zamówionego tego kursu
	IF EXISTS (SELECT 1 FROM OrderedCourses 
				JOIN Orders on OrderedCourses.OrderID=Orders.OrderID
				WHERE StudentID=@StudentID AND CourseID=@CourseID)
		THROW 50004, 'Ten kurs znajduje sie juz na liscie twoich produktow',1;
	-- weryfikujemy, czy zamówienie tego kursu nie spowodowałoby przekroczenia limitu uczestników danego kursu
	DECLARE @limit_exceeded bit = 0;
	DECLARE @max_limit int;
	SELECT @max_limit = Limit FROM Courses WHERE CourseID=@CourseID;

	IF (SELECT COUNT(*)
		FROM OrderedCourses
		WHERE CourseID = @CourseID) >= @max_limit
		SET @limit_exceeded = 1
    
	IF (@limit_exceeded=1)
		THROW 50001,'Limit uczestnikow przekroczony',1;
	DECLARE @date_ok bit; -- weryfikujemy, czy na pewno nadal można kupić kurs(u nas kurs można dodać do koszyka najpóźniej
	-- 3 dni przed jego rozpoczęciem, można opłacić go później, ale wtedy jest się dłużnikiem)
	SELECT @date_ok = CASE 
						WHEN DATEDIFF(second, GETDATE(), StartDate) > 259200 THEN 1 -- 259200s = 72h = 3 dni
						ELSE 0
						END
					FROM 
					Courses
					WHERE CourseID=@CourseID;
	
	IF (@date_ok=0)
	BEGIN
		THROW 50003,'Za późno na kupienie tego kursu',1;
	END;
	
	DECLARE @order_exists bit = 0;
	SET @order_exists = dbo.DoesOrderExist(@OrderID);
	IF (@order_exists=0)
	BEGIN
		INSERT INTO Orders (OrderID, StudentID, Status, AdditionToBasketDate, PaymentHyperlink)
		VALUES (@OrderID, @StudentID, 'Pending', GETDATE(), @PaymentHyperlink);
	END
	INSERT INTO OrderedCourses (OrderID, CourseID, HasBeenPaidFor)
	VALUES (@OrderID, @CourseID, 0);
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() as ErrorNumber,
			ERROR_MESSAGE() as ErrorMessage
END CATCH
END