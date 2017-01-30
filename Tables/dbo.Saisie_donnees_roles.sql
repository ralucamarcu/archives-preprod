SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Saisie_donnees_roles] (
		[id_role]     [int] NOT NULL,
		[nom]         [varchar](50) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Saisie_donnees_roles] SET (LOCK_ESCALATION = TABLE)
GO
