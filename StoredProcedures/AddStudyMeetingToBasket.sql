USE [u_konior]
GO
/****** Object:  StoredProcedure [dbo].[AddStudyMeetingToBasket]    Script Date: 21.01.2024 18:44:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[AddStudyMeetingToBasket]
	@OrderID nvarchar(50), 
	@StudentID int,
	@StudyMeetingID int,
	@isPartOfStudies bit,
	@PaymentHyperlink nvarchar(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON
    -- Insert statements for procedure here
	-- sprawdzamy czy takie studium i taki student istnieją
BEGIN TRY
	IF (NOT EXISTS (select 1 from StudyMeetings where StudyMeetingID=@StudyMeetingID )) OR
		(NOT EXISTS (select 1 from Students where StudentID=@StudentID))
		THROW 50001,'Nie istnieje Zjazd albo Student o takim ID',1;
	-- weryfikujemy, czy dany student nie ma już zamówionego tego zjazdu
	IF EXISTS (SELECT 1 FROM OrderedStudyMeetings 
				JOIN Orders on OrderedStudyMeetings.OrderID=Orders.OrderID
				WHERE StudentID=@StudentID AND StudyMeetingID=@StudyMeetingID)
		THROW 50004, 'Ten zjazd znajduje sie juz na liscie twoich produktow',1;
	DECLARE @limit_exceeded bit;
	DECLARE @max_limit int;
	SELECT @max_limit = SeatCount FROM StudyMeetings WHERE StudyMeetingID=@StudyMeetingID;
	
	IF (SELECT COUNT(*)
		FROM OrderedStudyMeetings
		WHERE StudyMeetingID = @StudyMeetingID) >= @max_limit
		SET @limit_exceeded = 1
	ELSE
		SET @limit_exceeded = 0
    
	IF (@limit_exceeded=1)
		THROW 50001,'Limit uczestnikow przekroczony',1;

	DECLARE @date_ok bit; -- weryfikujemy, czy na pewno nadal można kupić studium(trzeba dokonać wpłaty na 3 dni przed 
	-- rozpoczęciem)
	SELECT @date_ok = CASE 
						WHEN DATEDIFF(second, GETDATE(), BeginningDate) > 259200 THEN 1 -- 259200s = 72h = 3 dni
						ELSE 0
						END
					FROM 
					StudyMeetings
					WHERE StudyMeetingID=@StudyMeetingID;
	
	IF (@date_ok=0)
	BEGIN
		THROW 50001,'Za późno na kupienie tego zjazdu',1;
	END;
	
	-- sprawdzamy, czy koszyk już istnieje, jeśli nie, tworzymy go
	DECLARE @order_exists bit = 0;
	SET @order_exists = dbo.DoesOrderExist(@OrderID);
	IF (@order_exists=0)
	BEGIN
		INSERT INTO Orders (OrderID, StudentID, Status, AdditionToBasketDate, PaymentHyperlink)
		VALUES (@OrderID, @StudentID, 'Pending', GETDATE(), @PaymentHyperlink);
	END
	INSERT INTO OrderedStudyMeetings(OrderID, StudyMeetingID, HasBeenPaidFor, IsPartOfStudies)
	VALUES (@OrderID, @StudyMeetingID, 0, @isPartOfStudies);
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() as ErrorNumber,
			ERROR_MESSAGE() as ErrorMessage
END CATCH
END