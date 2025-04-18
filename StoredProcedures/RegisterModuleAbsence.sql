USE [u_konior]
GO
/****** Object:  StoredProcedure [dbo].[RegisterModuleAbsence]    Script Date: 13.01.2024 16:42:22 ******/
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
	IF (EXISTS (SELECT 1 FROM OrderedCourses
						JOIN Courses on Courses.CourseID=OrderedCourses.CourseID
						JOIN CoursesModules on Courses.CourseID=CoursesModules.CourseID
						JOIN Orders on Orders.OrderID = OrderedCourses.OrderID
						WHERE ModuleID=@module_id AND StudentID=@student_id))
	BEGIN
		INSERT INTO ModulesAbsences (ModuleID, StudentID)
		VALUES (@module_id, @student_id);
	END;
	ELSE
		RAISERROR ('Student nie posiada kursu z tym modulem',16,1);
END
