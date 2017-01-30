SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Images_Traitements_zonage_06] (
		[id_image]     [uniqueidentifier] NULL,
		[chemin]       [varchar](500) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Images_Traitements_zonage_06] SET (LOCK_ESCALATION = TABLE)
GO
