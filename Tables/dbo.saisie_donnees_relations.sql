SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_relations] (
		[id_relation]          [int] NOT NULL,
		[nom_relation]         [varchar](50) COLLATE French_CI_AS NULL,
		[nom_relation_DTD]     [varchar](50) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_relations] SET (LOCK_ESCALATION = TABLE)
GO
