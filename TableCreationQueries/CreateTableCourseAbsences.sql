USE [u_konior]
GO

/****** Object:  Table [dbo].[CourseAbsences]    Script Date: 03.12.2023 16:08:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CourseAbsences](
	[CourseAbsenceID] [int] NOT NULL,
	[OrderedCourseID] [int] NOT NULL,
	[AbsenceCount] [int] NOT NULL,
 CONSTRAINT [PK_CourseAbsences] PRIMARY KEY CLUSTERED 
(
	[CourseAbsenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CourseAbsences]  WITH CHECK ADD  CONSTRAINT [FK_CourseAbsences_OrderedCourses] FOREIGN KEY([OrderedCourseID])
REFERENCES [dbo].[OrderedCourses] ([OrderedCourseID])
GO

ALTER TABLE [dbo].[CourseAbsences] CHECK CONSTRAINT [FK_CourseAbsences_OrderedCourses]
GO


