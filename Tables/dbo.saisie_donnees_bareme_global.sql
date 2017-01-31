SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[saisie_donnees_bareme_global] (
		[type_acte]     [int] NOT NULL,
		[nb_unites]     [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_bareme_global]
	ADD
	CONSTRAINT [PK_saisie_donnees_bareme_global]
	PRIMARY KEY
	CLUSTERED
	([type_acte])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_bareme_global] SET (LOCK_ESCALATION = TABLE)
GO
