SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_individus_identites_MAJ_transfer] (
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
ALTER TABLE [dbo].[saisie_donnees_individus_identites_MAJ_transfer]
	ADD
	CONSTRAINT [PK_saisie_donnees_individus_identitesMAJ_]
	PRIMARY KEY
	CLUSTERED
	([id_individu_identite])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_individus_identites_MAJ_transfer]
	ADD
	CONSTRAINT [DF_saisie_donnees_individus_identites_date_creationMAJ_]
	DEFAULT (getdate()) FOR [date_creation]
GO
ALTER TABLE [dbo].[saisie_donnees_individus_identites_MAJ_transfer]
	ADD
	CONSTRAINT [DF_saisie_donnees_individus_identites_id_individu_identiteMAJ_]
	DEFAULT (newid()) FOR [id_individu_identite]
GO
ALTER TABLE [dbo].[saisie_donnees_individus_identites_MAJ_transfer]
	ADD
	CONSTRAINT [DF_saisie_donnees_individus_identites_ordreMAJ_]
	DEFAULT ((1)) FOR [ordre]
GO
ALTER TABLE [dbo].[saisie_donnees_individus_identites_MAJ_transfer] SET (LOCK_ESCALATION = TABLE)
GO
