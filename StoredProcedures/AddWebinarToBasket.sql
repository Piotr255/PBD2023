USE [u_konior]
GO
/****** Object:  StoredProcedure [dbo].[AddWebinarToBasket]    Script Date: 02.01.2024 20:56:19 ******/
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
	IF ((select count(WebinarID) from Webinars where WebinarID=@WebinarID) > 0) AND 
		((select count(StudentID) from Students where StudentID=@StudentID) > 0)
	BEGIN
		INSERT INTO Orders (OrderID, StudentID, Status, AdditionToBasketDate, PaymentHyperlink)
		VALUES (@OrderID, @StudentID, 'Pending', GETDATE(), @PaymentHyperlink);
		INSERT INTO OrderedWebinars (OrderID, WebinarID, HasBeenPaidFor)
		VALUES (@OrderID, @WebinarID, 0);
	END
	ELSE
	BEGIN
		RAISERROR ('Nie istnieje Webinar albo Student o takim ID',16,1) WITH NOWAIT;
	END
END