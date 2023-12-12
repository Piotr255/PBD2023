USE [u_konior]
GO

/****** Object:  Table [dbo].[StudyAbsences]    Script Date: 03.12.2023 16:21:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[StudyAbsences](
	[StudyAbsenceID] [int] NOT NULL,
	[OrderedStudyID] [int] NOT NULL,
	[AbsenceCount] [int] NOT NULL,
 CONSTRAINT [PK_StudyAbsences] PRIMARY KEY CLUSTERED 
(
	[StudyAbsenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[StudyAbsences]  WITH CHECK ADD  CONSTRAINT [FK_StudyAbsences_OrderedStudies] FOREIGN KEY([OrderedStudyID])
REFERENCES [dbo].[OrderedStudies] ([OrderedStudyID])
GO

ALTER TABLE [dbo].[StudyAbsences] CHECK CONSTRAINT [FK_StudyAbsences_OrderedStudies]
GO


