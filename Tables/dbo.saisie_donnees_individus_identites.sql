SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_individus_identites] (
		[id_individu_identite]     [uniqueidentifier] NOT NULL,
		[id_acte]                  [uniqueidentifier] NOT NULL,
		[id_individu]              [bigint] NOT NULL,
		[id_type_identite]         [int] NOT NULL,
		[ordre]                    [int] NOT NULL,
		[nom]                      [varchar](255) COLLATE French_CI_AS NULL,
		[prenom]                   [varchar](255) COLLATE French_CI_AS NULL,
		[date_creation]            [datetime] NULL,
		[id_acte_ithaque]          [int] NULL,
		[id_individu_ithaque]      [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_individus_identites]
	ADD
	CONSTRAINT [PK_saisie_donnees_individus_identites]
	PRIMARY KEY
	CLUSTERED
	([id_individu_identite])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_individus_identites]
	ADD
	CONSTRAINT [DF_saisie_donnees_individus_identites_date_creation]
	DEFAULT (getdate()) FOR [date_creation]
GO
ALTER TABLE [dbo].[saisie_donnees_individus_identites]
	ADD
	CONSTRAINT [DF_saisie_donnees_individus_identites_id_individu_identite]
	DEFAULT (newid()) FOR [id_individu_identite]
GO
ALTER TABLE [dbo].[saisie_donnees_individus_identites]
	ADD
	CONSTRAINT [DF_saisie_donnees_individus_identites_ordre]
	DEFAULT ((1)) FOR [ordre]
GO
ALTER TABLE [dbo].[saisie_donnees_individus_identites]
	WITH CHECK
	ADD CONSTRAINT [FK_saisie_donnees_individus_identites_saisie_donnees_types_identites]
	FOREIGN KEY ([id_type_identite]) REFERENCES [dbo].[saisie_donnees_types_identites] ([id_type_identite])
ALTER TABLE [dbo].[saisie_donnees_individus_identites]
	CHECK CONSTRAINT [FK_saisie_donnees_individus_identites_saisie_donnees_types_identites]

GO
ALTER TABLE [dbo].[saisie_donnees_individus_identites] SET (LOCK_ESCALATION = TABLE)
GO
