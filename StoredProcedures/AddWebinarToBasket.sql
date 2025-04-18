USE [u_konior]
GO
/****** Object:  StoredProcedure [dbo].[AddWebinarToBasket]    Script Date: 21.01.2024 18:52:43 ******/
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
	-- w przypadku webinaru sprawdzam tylko, czy dany webinar nie znajduje sie juz w aktualnym koszyku danego 
	-- studenta, a nie czy w ogole go zamowil, bo student moze chciec przedluzyc okres posiadania danego 
	-- webinaru
		IF EXISTS (select 1 from Orders
				JOIN OrderedWebinars on Orders.OrderID=OrderedWebinars.OrderID
				WHERE Orders.OrderID=@OrderID AND WebinarID=@WebinarID AND StudentID=@StudentID)
			THROW 50002, 'Ten webinar znajduje sie juz w Twoim koszyku', 1;
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