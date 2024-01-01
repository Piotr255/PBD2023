USE [u_konior]
GO
/****** Object:  StoredProcedure [dbo].[AddCourseToBasket]    Script Date: 30.12.2023 18:20:11 ******/
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
	-- Add the parameters for the stored procedure here
	@OrderID nvarchar(50), 
	@StudentID int,
	@CourseID int,
	@PaymentHyperlink nvarchar(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
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
		RAISERROR ('Nie istnieje Kurs albo Student o takim ID',16,1) WITH NOWAIT;
	END
END
