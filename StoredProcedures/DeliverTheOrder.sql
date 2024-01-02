USE [u_konior]
GO
/****** Object:  StoredProcedure [dbo].[DeliverTheOrder]    Script Date: 02.01.2024 20:59:24 ******/
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
	@order_id nvarchar(50),
	@payment_deferral bit,
	@payment_deferral_reason nvarchar(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	DECLARE @current_status nvarchar(50);
	SELECT @current_status = Status
								from Orders
								where OrderID=@order_id;
	if (@current_status='Pending')
	BEGIN
		UPDATE Orders
		SET Status='Delivered', OrderDate=GETDATE()
		WHERE OrderID=@order_id;
	
		UPDATE OrderedWebinars
		SET PaymentDeferral=@payment_deferral, PaymentDeferralReason=@payment_deferral_reason
		WHERE OrderID=@order_id;

		UPDATE OrderedCourses
		SET PaymentDeferral=@payment_deferral, PaymentDeferralReason=@payment_deferral_reason,
		IsGrantedCertificate=0
		WHERE OrderID=@order_id;

		UPDATE OrderedStudies
		SET PaymentDeferral=@payment_deferral, PaymentDeferralReason=@payment_deferral_reason,
		IsGrantedCertificate=0, FinalExamPassed=0, FailedInternship=0
		WHERE OrderID=@order_id;

		UPDATE OrderedStudyMeetings
		SET PaymentDeferral=@payment_deferral, PaymentDeferralReason=@payment_deferral_reason
		WHERE OrderID=@order_id;
	END;
END