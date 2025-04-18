USE [u_konior]
GO
/****** Object:  StoredProcedure [dbo].[ApplyPaymentDeferralToOrderedProduct]    Script Date: 11.01.2024 20:22:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ApplyPaymentDeferralToOrderedProduct]
	@product_type nvarchar(50),
	@order_id nvarchar(50),
	@product_id int,
	@payment_deferral_reason nvarchar(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON; -- !!
    -- Insert statements for procedure here
	BEGIN TRY
		IF (@product_type='webinar')
		BEGIN
			IF ((select HasBeenPaidFor from OrderedWebinars where OrderID=@order_id and WebinarID=@product_id)=0)
			BEGIN
				UPDATE OrderedWebinars
				SET PaymentDeferral=1, PaymentDeferralReason=@payment_deferral_reason
				WHERE OrderID=@order_id and WebinarID=@product_id;
			END
			ELSE
			BEGIN
				THROW 50001, 'Ten produkt zostal juz oplacony', 1;
			END
		END
		IF (@product_type='course')
		BEGIN
			IF ((select HasBeenPaidFor from OrderedCourses where OrderID=@order_id and CourseID=@product_id)=0)
			BEGIN
				UPDATE OrderedCourses
				SET PaymentDeferral=1, PaymentDeferralReason=@payment_deferral_reason
				WHERE OrderID=@order_id and CourseID=@product_id;
			END
			ELSE
			BEGIN
				THROW 50002, 'Ten produkt zostal juz oplacony', 1;
			END
		END
		IF (@product_type='study')
		BEGIN
			IF ((select EntryFeePaid from OrderedStudies where OrderID=@order_id and StudyID=@product_id)=0)
			BEGIN
				UPDATE OrderedStudies
				SET PaymentDeferral=1, PaymentDeferralReason=@payment_deferral_reason
				WHERE OrderID=@order_id and StudyID=@product_id;
			END
			ELSE
			BEGIN
				THROW 50003, 'Ten produkt zostal juz oplacony', 1;
			END
		END
		IF (@product_type='study_meeting')
		BEGIN
			IF ((select HasBeenPaidFor from OrderedStudyMeetings where OrderID=@order_id and StudyMeetingID=@product_id)=0)
			BEGIN
				UPDATE OrderedStudyMeetings
				SET PaymentDeferral=1, PaymentDeferralReason=@payment_deferral_reason
				WHERE OrderID=@order_id and StudyMeetingID=@product_id;
			END
			ELSE
			BEGIN
				THROW 50004, 'Ten produkt zostal juz oplacony', 1;
			END
		END
	END TRY
	BEGIN CATCH
		SELECT ERROR_NUMBER() as ErrorNumber,
			   ERROR_MESSAGE() as ErrorMessage
	END CATCH
END