USE [u_konior]
GO
/****** Object:  StoredProcedure [dbo].[RegisterModuleAbsence]    Script Date: 02.01.2024 21:12:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[RegisterModuleAbsence]
	@module_id int,
	@student_id int
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- Sprawdzamy, czy dany student zamówił kurs z danym modułem
	IF ((SELECT COUNT(*) FROM OrderedCourses
						JOIN Courses on Courses.CourseID=OrderedCourses.CourseID
						JOIN CoursesModules on Courses.CourseID=CoursesModules.CourseID
						JOIN Orders on Orders.OrderID = OrderedCourses.CourseID
						WHERE ModuleID=@module_id AND StudentID=@student_id) > 0)
	BEGIN
		INSERT INTO ModulesAbsences (ModuleID, StudentID)
		VALUES (@module_id, @student_id);
	END;
END
