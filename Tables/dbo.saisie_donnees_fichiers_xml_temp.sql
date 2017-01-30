SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_fichiers_xml_temp] (
		[id_document]     [uniqueidentifier] NULL,
		[chemin]          [varchar](255) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_fichiers_xml_temp] SET (LOCK_ESCALATION = TABLE)
GO
