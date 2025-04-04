USE [u_konior]
GO
/****** Object:  StoredProcedure [dbo].[GrantStudentCertificate]    Script Date: 11.01.2024 20:29:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GrantStudentCertificate]
	-- Add the parameters for the stored procedure here
	@student_id int,
	@certificate_hyperlink nvarchar(MAX),
	@study_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET XACT_ABORT ON
    -- Insert statements for procedure here
	-- Najpierw sprawdzamy, czy student zamówił studium o takim @study_id
	DECLARE @ordered_study_exists bit;
	SELECT @ordered_study_exists = CASE
									WHEN count(StudyID) > 0 then 1
									else 0
								  END
									from OrderedStudies
									join Orders on Orders.OrderID=OrderedStudies.OrderID
									where Orders.StudentID=@student_id and OrderedStudies.StudyID=@study_id;
	-- Teraz liczymy ilość wszystkich spotkań i ilość nieodrobionych absencji danego studenta na danym studium 
	DECLARE @total_study_meetings_count decimal;
	SELECT @total_study_meetings_count = count(StudyMeetingID) from StudyMeetings
										where StudyID=@study_id;
	DECLARE @absences_count decimal;
	SELECT @absences_count = count(StudyMeetingsAbsences.StudyMeetingID)
								from StudyMeetingsAbsences
								join StudyMeetings on StudyMeetings.StudyMeetingID = StudyMeetingsAbsences.StudyMeetingID
								where StudentID=@student_id and StudyID=@study_id and HasBeenCaughtUp=0;
	-- Sprawdzamy, czy student zdał egzamin końcowy z danego studium i czy zaliczył praktyki
	DECLARE @final_exam_passed bit;
	SELECT @final_exam_passed = FinalExamPassed
								from OrderedStudies
								join Orders on Orders.OrderID = OrderedStudies.OrderID
								where StudyID=@study_id and StudentID=@student_id; 
	DECLARE @failed_internship bit;
	SELECT @failed_internship = FailedInternship
								from OrderedStudies
								join Orders on Orders.OrderID = OrderedStudies.OrderID
								where StudyID=@study_id and StudentID=@student_id;
	-- Sprawdzamy dodatkowo, czy student opłacił wszelkie spotkania studyjne
	DECLARE @everything_paid bit;
	SELECT @everything_paid = CASE 
								WHEN COUNT(*) > 0 THEN 0
								ELSE 1
							  END
								from OrderedStudies
								join Orders on Orders.OrderID = OrderedStudies.OrderID
								join OrderedStudyMeetings on OrderedStudyMeetings.OrderID = Orders.OrderID
								where StudentID=@student_id and StudyID=@study_id and HasBeenPaidFor=0;
	-- Trzeba jeszcze sprawdzić, czy student uiścił wpisowe
	DECLARE @entry_fee_paid bit;
	SELECT @entry_fee_paid = CASE 
								WHEN EntryFeePaid=1 THEN 1
								ELSE 0
							  END
								from OrderedStudies
								join Orders on Orders.OrderID=OrderedStudies.OrderID
								where StudentID=@student_id and StudyID=@study_id;
	-- Ostateczna walidacja
	IF (@ordered_study_exists=1 and @total_study_meetings_count > 0 and @absences_count/@total_study_meetings_count<=0.2
		and @final_exam_passed=1 and @failed_internship=0 and @everything_paid=1 and @entry_fee_paid=1)
	BEGIN
		UPDATE OrderedStudies
		SET IsGrantedCertificate=1,
			CertificateHyperlink=@certificate_hyperlink
		FROM OrderedStudies
		join Orders on Orders.OrderID = OrderedStudies.OrderID
		where StudentID=@student_id and StudyID=@study_id;
	END;
	ELSE
	BEGIN
		RAISERROR ('Student nie spełnia kryteriów otrzymania certyfikatu z tego studium',16,1);
	END;
END