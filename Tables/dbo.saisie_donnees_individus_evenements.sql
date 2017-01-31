SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_individus_evenements] (
		[id_individu_evenement]     [uniqueidentifier] NOT NULL,
		[id_acte]                   [uniqueidentifier] NOT NULL,
		[id_individu]               [bigint] NOT NULL,
		[id_type_evenement]         [int] NOT NULL,
		[ordre]                     [int] NOT NULL,
		[date]                      [varchar](50) COLLATE French_CI_AS NULL,
		[annee]                     [int] NULL,
		[annee_debut]               [int] NULL,
		[annee_fin]                 [int] NULL,
		[lieu]                      [varchar](255) COLLATE French_CI_AS NULL,
		[lieu_insee]                [varchar](50) COLLATE French_CI_AS NULL,
		[id_commune]                [int] NULL,
		[date_creation]             [datetime] NULL,
		[date_originale]            [varchar](100) COLLATE French_CI_AS NULL,
		[description]               [varchar](max) COLLATE French_CI_AS NULL,
		[principal]                 [bit] NULL,
		[a_supprimer]               [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_individus_evenements]
	ADD
	CONSTRAINT [PK_saisie_donnees_individus_evenements]
	PRIMARY KEY
	CLUSTERED
	([id_individu_evenement])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_individus_evenements]
	ADD
	CONSTRAINT [DF_saisie_donnees_individus_evenements_date_creation]
	DEFAULT (getdate()) FOR [date_creation]
GO
ALTER TABLE [dbo].[saisie_donnees_individus_evenements]
	ADD
	CONSTRAINT [DF_saisie_donnees_individus_evenements_id_individu_evenement]
	DEFAULT (newid()) FOR [id_individu_evenement]
GO
ALTER TABLE [dbo].[saisie_donnees_individus_evenements]
	ADD
	CONSTRAINT [DF_saisie_donnees_individus_evenements_ordre]
	DEFAULT ((1)) FOR [ordre]
GO
ALTER TABLE [dbo].[saisie_donnees_individus_evenements]
	WITH CHECK
	ADD CONSTRAINT [FK_saisie_donnees_individus_evenements_saisie_donnees_types_evenements]
	FOREIGN KEY ([id_type_evenement]) REFERENCES [dbo].[saisie_donnees_types_evenements] ([id_type_evenement])
ALTER TABLE [dbo].[saisie_donnees_individus_evenements]
	CHECK CONSTRAINT [FK_saisie_donnees_individus_evenements_saisie_donnees_types_evenements]

GO
ALTER TABLE [dbo].[saisie_donnees_individus_evenements] SET (LOCK_ESCALATION = TABLE)
GO
