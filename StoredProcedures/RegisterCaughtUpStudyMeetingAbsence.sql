USE [u_konior]
GO
/****** Object:  StoredProcedure [dbo].[RegisterCaughtUpStudyMeetingAbsence]    Script Date: 13.01.2024 17:12:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[RegisterCaughtUpStudyMeetingAbsence]
	-- Add the parameters for the stored procedure here
	@study_meeting_id int,
	@student_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF (exists (select 1 from StudyMeetingsAbsences where StudentID=@student_id and StudyMeetingID=@study_meeting_id))
		UPDATE StudyMeetingsAbsences 
		SET HasBeenCaughtUp=1 
		where StudentID=@student_id and StudyMeetingID=@study_meeting_id;
	ELSE
		RAISERROR ('Student nie zakupil tego zjazdu',16,1);
END
