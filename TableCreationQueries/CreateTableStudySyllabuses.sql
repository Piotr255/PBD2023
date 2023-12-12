USE [u_konior]
GO

/****** Object:  Table [dbo].[StudySyllabusses]    Script Date: 03.12.2023 16:23:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[StudySyllabusses](
	[StudySyllabusID] [int] NOT NULL,
	[StudyID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
 CONSTRAINT [PK_StudySyllabusses] PRIMARY KEY CLUSTERED 
(
	[StudySyllabusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[StudySyllabusses]  WITH CHECK ADD  CONSTRAINT [FK_StudySyllabusses_Studies] FOREIGN KEY([StudyID])
REFERENCES [dbo].[Studies] ([StudyID])
GO

ALTER TABLE [dbo].[StudySyllabusses] CHECK CONSTRAINT [FK_StudySyllabusses_Studies]
GO


