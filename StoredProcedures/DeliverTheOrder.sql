USE [u_konior]
GO
/****** Object:  StoredProcedure [dbo].[DeliverTheOrder]    Script Date: 14.01.2024 10:41:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[DeliverTheOrder]
	@order_id nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	DECLARE @current_status nvarchar(50);
	SELECT @current_status = Status
								from Orders
								where OrderID=@order_id;
	IF (@current_status='Pending')
	BEGIN
		UPDATE Orders
		SET Status='Delivered', OrderDate=GETDATE()
		WHERE OrderID=@order_id;
		INSERT INTO OrderedStudyMeetings (OrderID, StudyMeetingID, IsPartOfStudies, HasBeenPaidFor)
		(select OrderID, StudyMeetingID, 1, 0 
				FROM Studies
				JOIN OrderedStudies on Studies.StudyID=OrderedStudies.StudyID
				JOIN StudyMeetings on Studies.StudyID = StudyMeetings.StudyID
				WHERE OrderID=@order_id);
	END;
	ELSE
	BEGIN
		RAISERROR ('Podane zamówienie zostało już dostarczone',16,1);
	END;
END