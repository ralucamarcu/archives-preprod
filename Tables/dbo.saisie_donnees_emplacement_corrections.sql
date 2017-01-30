SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_emplacement_corrections] (
		[id_emplacement]     [int] IDENTITY(1, 1) NOT NULL,
		[nom_table]          [varchar](50) COLLATE French_CI_AS NULL,
		[nom_colonne]        [varchar](50) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_emplacement_corrections] SET (LOCK_ESCALATION = TABLE)
GO
