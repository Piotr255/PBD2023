USE [u_konior]
GO

/****** Object:  Table [dbo].[InternshipAbsences]    Script Date: 03.12.2023 16:14:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[InternshipAbsences](
	[InternshipAbsenceID] [int] NOT NULL,
	[InternshipID] [int] NOT NULL,
	[StudentID] [int] NOT NULL,
	[AbsenceCount] [int] NOT NULL,
 CONSTRAINT [PK_InternshipAbsences] PRIMARY KEY CLUSTERED 
(
	[InternshipAbsenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[InternshipAbsences]  WITH CHECK ADD  CONSTRAINT [FK_InternshipAbsences_Internships] FOREIGN KEY([InternshipID])
REFERENCES [dbo].[Internships] ([InternshipID])
GO

ALTER TABLE [dbo].[InternshipAbsences] CHECK CONSTRAINT [FK_InternshipAbsences_Internships]
GO

ALTER TABLE [dbo].[InternshipAbsences]  WITH CHECK ADD  CONSTRAINT [FK_InternshipAbsences_Students] FOREIGN KEY([StudentID])
REFERENCES [dbo].[Students] ([StudentID])
GO

ALTER TABLE [dbo].[InternshipAbsences] CHECK CONSTRAINT [FK_InternshipAbsences_Students]
GO


