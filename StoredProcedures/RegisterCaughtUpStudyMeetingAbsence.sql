USE [u_konior]
GO
/****** Object:  StoredProcedure [dbo].[RegisterCaughtUpStudyMeetingAbsence]    Script Date: 16.01.2024 19:32:47 ******/
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
	@student_id int,
	@is_caught_up bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF (exists (select 1 from StudyMeetingsAbsences where StudentID=@student_id and StudyMeetingID=@study_meeting_id))
		UPDATE StudyMeetingsAbsences 
		SET HasBeenCaughtUp=@is_caught_up 
		where StudentID=@student_id and StudyMeetingID=@study_meeting_id;
	ELSE
		RAISERROR ('Student nie zakupil tego zjazdu',16,1);
END