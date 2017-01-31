SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Feuil1$] (
		[Dossier]             [nvarchar](255) COLLATE French_CI_AS NULL,
		[Nouveau Dossier]     [nvarchar](255) COLLATE French_CI_AS NULL,
		[Identique]           [nvarchar](255) COLLATE French_CI_AS NULL,
		[updated]             [bit] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_dossier]
	ON [dbo].[Feuil1$] ([Dossier])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Nouveau_Dossier]
	ON [dbo].[Feuil1$] ([Nouveau Dossier])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[Feuil1$] SET (LOCK_ESCALATION = TABLE)
GO
