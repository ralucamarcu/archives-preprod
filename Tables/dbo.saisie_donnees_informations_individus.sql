SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_informations_individus] (
		[id_info_individu]     [uniqueidentifier] NOT NULL,
		[id_individu]          [bigint] NOT NULL,
		[id_acte]              [uniqueidentifier] NULL,
		[id_type_info]         [int] NOT NULL,
		[valeur]               [varchar](max) COLLATE French_CI_AS NULL,
		[ordre_affichage]      [int] NULL,
		[date_creation]        [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_informations_individus]
	ADD
	CONSTRAINT [PK_saisie_donnees_informations_individus]
	PRIMARY KEY
	CLUSTERED
	([id_info_individu])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_informations_individus]
	ADD
	CONSTRAINT [DF_saisie_donnees_informations_individus_date_creation]
	DEFAULT (getdate()) FOR [date_creation]
GO
ALTER TABLE [dbo].[saisie_donnees_informations_individus]
	ADD
	CONSTRAINT [DF_saisie_donnees_informations_individus_id_info_individu]
	DEFAULT (newid()) FOR [id_info_individu]
GO
ALTER TABLE [dbo].[saisie_donnees_informations_individus] SET (LOCK_ESCALATION = TABLE)
GO
