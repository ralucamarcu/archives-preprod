SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_fichiers_XML] (
		[id_fichier_xml]         [int] IDENTITY(1, 1) NOT NULL,
		[chemin]                 [varchar](500) COLLATE French_CI_AS NULL,
		[id_document]            [uniqueidentifier] NULL,
		[statut]                 [int] NULL,
		[date_statut]            [datetime] NULL,
		[date_creation]          [datetime] NULL,
		[id_fichier_ithaque]     [uniqueidentifier] NULL,
		[id_fichier_xml2]        [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_fichiers_XML]
	ADD
	CONSTRAINT [PK_saisie_donnees_xml]
	PRIMARY KEY
	CLUSTERED
	([id_fichier_xml])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [id_document]
	ON [dbo].[saisie_donnees_fichiers_XML] ([id_document])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [id_fichier_ithaque]
	ON [dbo].[saisie_donnees_fichiers_XML] ([id_fichier_ithaque])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_fichiers_XML] SET (LOCK_ESCALATION = TABLE)
GO
