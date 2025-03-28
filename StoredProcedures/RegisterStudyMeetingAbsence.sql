USE [u_konior]
GO
/****** Object:  StoredProcedure [dbo].[RegisterStudyMeetingAbsence]    Script Date: 13.01.2024 16:51:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[RegisterStudyMeetingAbsence]
	@student_id int,
	@study_meeting_id int
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- sprawdzamy, czy dany student zamowil w ogole dany zjazd
	IF (EXISTS (SELECT 1 FROM OrderedStudyMeetings
						JOIN Orders on Orders.OrderID = OrderedStudyMeetings.OrderID
						WHERE StudyMeetingID=@study_meeting_id AND StudentID=@student_id))
	BEGIN
		INSERT INTO StudyMeetingsAbsences (StudyMeetingID, StudentID, HasBeenCaughtUp)
		VALUES (@study_meeting_id, @student_id, 0);
	END
	ELSE
		RAISERROR ('Student nie zamowil tego zjazdu',16,1);
END