SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[saisie_donnees_actes_documents_informations] (
		[id_acte]         [uniqueidentifier] NULL,
		[id_page]         [uniqueidentifier] NULL,
		[id_document]     [uniqueidentifier] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_actes_documents_informations] SET (LOCK_ESCALATION = TABLE)
GO
