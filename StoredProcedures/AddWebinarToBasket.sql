USE [u_konior]
GO
/****** Object:  StoredProcedure [dbo].[AddWebinarToBasket]    Script Date: 13.01.2024 16:12:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[AddWebinarToBasket] 
	@WebinarID int, 
	@StudentID int,
	@OrderID nvarchar(50),
	@PaymentHyperlink nvarchar(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON
    -- Insert statements for procedure here
	-- sprawdzamy, czy taki webinar i taki student istnieją
BEGIN TRY
	IF (EXISTS (select 1 from Webinars where WebinarID=@WebinarID)) AND 
		(EXISTS (select 1 from Students where StudentID=@StudentID))
	BEGIN
		DECLARE @order_exists bit = 0;
		SET @order_exists = dbo.DoesOrderExist(@OrderID);
		IF (@order_exists=0)
		BEGIN
			INSERT INTO Orders (OrderID, StudentID, Status, AdditionToBasketDate, PaymentHyperlink)
			VALUES (@OrderID, @StudentID, 'Pending', GETDATE(), @PaymentHyperlink);
		END
		INSERT INTO OrderedWebinars (OrderID, WebinarID, HasBeenPaidFor)
		VALUES (@OrderID, @WebinarID, 0);
	END
	ELSE
	BEGIN
		THROW 50001,'Nie istnieje Webinar albo Student o takim ID',1;
	END
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() as ErrorNumber,
			ERROR_MESSAGE() as ErrorMessage
END CATCH
END