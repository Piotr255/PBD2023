-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION DoesOrderExist
(
	-- Add the parameters for the function here
	@order_id nvarchar(50)
)
RETURNS bit
AS
BEGIN
	-- Declare the return variable here
	DECLARE @order_exists bit = 0;

	-- Add the T-SQL statements to compute the return value here
	IF (EXISTS (select 1 from Orders where OrderID=@order_id))
		SET @order_exists=1;

	-- Return the result of the function
	RETURN @order_exists

END
GO

