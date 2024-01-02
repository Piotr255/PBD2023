USE [u_konior]
GO
/****** Object:  StoredProcedure [dbo].[AddStudyToBasket]    Script Date: 02.01.2024 20:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[AddStudyToBasket] 
	@OrderID nvarchar(50), 
	@StudentID int,
	@StudyID int,
	@PaymentHyperlink nvarchar(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON
    -- Insert statements for procedure here
	-- sprawdzamy, czy takie studium i taki student istnieją
	IF ((select count(StudyID) from Studies where StudyID=@StudyID) > 0) AND 
		((select count(StudentID) from Students where StudentID=@StudentID) > 0)
	BEGIN
		INSERT INTO Orders (OrderID, StudentID, Status, AdditionToBasketDate, PaymentHyperlink)
		VALUES (@OrderID, @StudentID, 'Pending', GETDATE(), @PaymentHyperlink);
		INSERT INTO OrderedStudies (OrderID, StudyID, EntryFeePaid)
		VALUES (@OrderID, @StudyID, 0);
	END
	ELSE
	BEGIN
		RAISERROR ('Nie istnieje Studium albo Student o takim ID',16,1) WITH NOWAIT;
	END
END