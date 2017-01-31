SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[saisie_donnees_documents_plus_consultee] (
		[id]              [int] IDENTITY(1, 1) NOT NULL,
		[nombre]          [int] NOT NULL,
		[id_document]     [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_documents_plus_consultee]
	ADD
	CONSTRAINT [PK_saisie_donnees_documents_plus_consultee]
	PRIMARY KEY
	CLUSTERED
	([id])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_documents_plus_consultee] SET (LOCK_ESCALATION = TABLE)
GO
