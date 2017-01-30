SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[saisie_donnees_documents_collections] (
		[id]              [int] IDENTITY(1, 1) NOT NULL,
		[id_document]     [uniqueidentifier] NOT NULL,
		[id_cat1]         [int] NULL,
		[id_cat2]         [int] NULL,
		[id_cat3]         [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_documents_collections] SET (LOCK_ESCALATION = TABLE)
GO
