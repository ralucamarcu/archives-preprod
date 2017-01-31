SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[saisie_donnees_bareme_unites] (
		[id_bareme_unites]     [int] IDENTITY(1, 1) NOT NULL,
		[id_document]          [uniqueidentifier] NULL,
		[type_acte]            [int] NULL,
		[nb_unites]            [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_bareme_unites]
	ADD
	CONSTRAINT [PK_saisie_donnees_bareme_unites]
	PRIMARY KEY
	CLUSTERED
	([id_bareme_unites])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_bareme_unites] SET (LOCK_ESCALATION = TABLE)
GO
