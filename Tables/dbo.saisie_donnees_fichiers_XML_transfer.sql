SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_fichiers_XML_transfer] (
		[id_fichier_xml]         [int] IDENTITY(1, 1) NOT NULL,
		[chemin]                 [varchar](500) COLLATE French_CI_AS NULL,
		[id_document]            [uniqueidentifier] NULL,
		[statut]                 [int] NULL,
		[date_statut]            [datetime] NULL,
		[date_creation]          [datetime] NULL,
		[id_fichier_ithaque]     [uniqueidentifier] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_fichiers_XML_transfer]
	ADD
	CONSTRAINT [PK_saisie_donnees_xml_transfer]
	PRIMARY KEY
	CLUSTERED
	([id_fichier_xml])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_fichiers_XML_transfer] SET (LOCK_ESCALATION = TABLE)
GO
