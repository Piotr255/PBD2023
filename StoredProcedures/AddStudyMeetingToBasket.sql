USE [u_konior]
GO
/****** Object:  StoredProcedure [dbo].[AddStudyMeetingToBasket]    Script Date: 02.01.2024 20:53:14 ******/
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
	DECLARE @date_ok bit; -- weryfikujemy, czy na pewno nadal można kupić studium(trzeba dokonać wpłaty na 3 dni przed 
	-- rozpoczęciem)
	SELECT @date_ok = CASE 
						WHEN DATEDIFF(day, BeginningDate, GETDATE()) > 3 THEN 1
						ELSE 0
						END
					FROM 
					StudyMeetings
					WHERE StudyMeetingID=@StudyMeetingID;

	IF (@date_ok=0)
	BEGIN
		RAISERROR ('Za późno na kupienie tego kursu',16,1) WITH NOWAIT;
	END;
	-- sprawdzamy czy takie studium i taki student istnieją
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