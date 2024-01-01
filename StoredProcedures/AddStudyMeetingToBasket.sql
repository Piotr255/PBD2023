USE [u_konior]
GO
/****** Object:  StoredProcedure [dbo].[AddStudyMeetingToBasket]    Script Date: 30.12.2023 18:21:26 ******/
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
	-- Add the parameters for the stored procedure here
	@OrderID nvarchar(50), 
	@StudentID int,
	@StudyMeetingID int,
	@isPartOfStudies bit,
	@PaymentHyperlink nvarchar(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF ((select count(StudyID) from StudyMeetings where StudyMeetingID=@StudyMeetingID ) > 0) AND 
		((select count(StudentID) from Students where StudentID=@StudentID) > 0)
	BEGIN
		INSERT INTO Orders (OrderID, StudentID, Status, AdditionToBasketDate, PaymentHyperlink)
		VALUES (@OrderID, @StudentID, 'Pending', GETDATE(), @PaymentHyperlink);
		INSERT INTO OrderedStudyMeetings(OrderID, StudyMeetingID, HasBeenPaidFor, IsPartOfStudies)
		VALUES (@OrderID, @StudyMeetingID, 0, @isPartOfStudies);
	END
	ELSE
	BEGIN
		RAISERROR ('Nie istnieje Zjazd albo Student o takim ID',16,1) WITH NOWAIT;
	END
END
