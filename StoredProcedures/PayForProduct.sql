USE [u_konior]
GO
/****** Object:  StoredProcedure [dbo].[PayForProduct]    Script Date: 13.01.2024 16:14:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[PayForProduct]
	@product_type nvarchar(50),
	@product_id int,
	@student_id int,
	@payment_auth_code nvarchar(50),
	@error nvarchar(MAX)
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- Ta procedura jest wywoływana w momencie zatwierdzenia płatności przez naszą aplikację.
	
	IF (@product_type='webinar')
	BEGIN
		UPDATE OrderedWebinars
		SET HasBeenPaidFor=1, PaymentAuthCode=@payment_auth_code, Error=@error, PaymentDate=GETDATE()
		FROM OrderedWebinars
		JOIN Orders on OrderedWebinars.OrderID=Orders.OrderID
		WHERE WebinarID=@product_id and StudentID=@student_id;

	END;
	ELSE IF (@product_type='course')
	BEGIN
		UPDATE OrderedCourses
		SET HasBeenPaidFor=1, PaymentAuthCode=@payment_auth_code, Error=@error, PaymentDate=GETDATE()
		FROM OrderedCourses
		JOIN Orders on OrderedCourses.OrderID=Orders.OrderID
		WHERE CourseID=@product_id and StudentID=@student_id;

	END;
	ELSE IF (@product_type='study')
	BEGIN
		UPDATE OrderedStudies
		SET EntryFeePaid=1, PaymentAuthCode=@payment_auth_code, Error=@error,PaymentDate=GETDATE()
		FROM OrderedStudies
		JOIN Orders on OrderedStudies.OrderID=Orders.OrderID
		WHERE StudyID=@product_id and StudentID=@student_id;

	END;
	ELSE IF (@product_type='study_meeting')
	BEGIN
		UPDATE OrderedStudyMeetings
		SET HasBeenPaidFor=1, PaymentAuthCode=@payment_auth_code, Error=@error, PaymentDate=GETDATE()
		FROM OrderedStudyMeetings
		JOIN Orders on OrderedStudyMeetings.OrderID=Orders.OrderID
		WHERE StudyMeetingID=@product_id and StudentID=@student_id;

	END;
	ELSE
	BEGIN
		RAISERROR ('Podano bledny typ produktu',16,1);
	END
END