USE [u_konior]
GO
/****** Object:  StoredProcedure [dbo].[AddStudyToBasket]    Script Date: 21.01.2024 18:46:43 ******/
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
BEGIN TRY
	IF (NOT EXISTS (select 1 from Studies where StudyID=@StudyID)) OR
		(NOT EXISTS (select 1 from Students where StudentID=@StudentID))
		THROW 50002,'Nie istnieje Studium albo Student o takim ID',1;
	-- weryfikujemy, czy dany student nie ma już zamówionego tego studium
	IF EXISTS (SELECT 1 FROM OrderedStudies 
				JOIN Orders on OrderedStudies.OrderID=Orders.OrderID
				WHERE StudentID=@StudentID AND StudyID=@StudyID)
		THROW 50004, 'Te studium znajduje sie juz na liscie twoich produktow',1;
	DECLARE @limit_exceeded bit;
	DECLARE @max_limit int;
	SELECT @max_limit = Limit FROM Studies WHERE StudyID=@StudyID;

	IF (SELECT COUNT(*)
		FROM OrderedStudies
		WHERE StudyID = @StudyID) >= @max_limit
		SET @limit_exceeded = 1
	ELSE
		SET @limit_exceeded = 0
    
	IF (@limit_exceeded=1)
		THROW 50001,'Limit uczestnikow przekroczony',1;

	-- sprawdzamy, czy takie studium i taki student istnieją
	DECLARE @order_exists bit = 0;
	SET @order_exists = dbo.DoesOrderExist(@OrderID);
	IF (@order_exists=0)
	BEGIN
		INSERT INTO Orders (OrderID, StudentID, Status, AdditionToBasketDate, PaymentHyperlink)
		VALUES (@OrderID, @StudentID, 'Pending', GETDATE(), @PaymentHyperlink);
	END
	INSERT INTO OrderedStudies (OrderID, StudyID, EntryFeePaid)
	VALUES (@OrderID, @StudyID, 0);
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() as ErrorNumber,
			ERROR_MESSAGE() as ErrorMessage
END CATCH
END