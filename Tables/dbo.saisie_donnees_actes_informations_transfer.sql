SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_actes_informations_transfer] (
		[id_info_acte]        [uniqueidentifier] NOT NULL,
		[id_acte]             [uniqueidentifier] NULL,
		[id_type_info]        [int] NOT NULL,
		[valeur]              [varchar](max) COLLATE French_CI_AS NULL,
		[ordre_affichage]     [int] NULL,
		[date_creation]       [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_actes_informations_transfer]
	ADD
	CONSTRAINT [PK_saisie_donnees_actes_informations_transfer]
	PRIMARY KEY
	CLUSTERED
	([id_info_acte])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_actes_informations_transfer]
	ADD
	CONSTRAINT [DF_saisie_donnees_actes_informations_date_creation1]
	DEFAULT (getdate()) FOR [date_creation]
GO
ALTER TABLE [dbo].[saisie_donnees_actes_informations_transfer]
	ADD
	CONSTRAINT [DF_saisie_donnees_actes_informations_id_info_acte1]
	DEFAULT (newid()) FOR [id_info_acte]
GO
ALTER TABLE [dbo].[saisie_donnees_actes_informations_transfer] SET (LOCK_ESCALATION = TABLE)
GO
