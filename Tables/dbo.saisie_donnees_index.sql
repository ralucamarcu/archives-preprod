SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_index] (
		[id_index]                       [uniqueidentifier] NOT NULL,
		[Nom]                            [varchar](255) COLLATE French_CI_AS NULL,
		[Prenom]                         [varchar](255) COLLATE French_CI_AS NULL,
		[Type_acte]                      [int] NULL,
		[annee]                          [int] NULL,
		[nb_individus]                   [int] NULL,
		[role]                           [int] NULL,
		[id_departement]                 [int] NULL,
		[id_commune]                     [int] NULL,
		[id_acte]                        [uniqueidentifier] NULL,
		[id_page]                        [uniqueidentifier] NULL,
		[id_document]                    [uniqueidentifier] NULL,
		[id_individu]                    [int] NULL,
		[recherche_nom]                  [int] NULL,
		[recherche_nom_prenom]           [int] NULL,
		[ordre_prenom]                   [varchar](255) COLLATE French_CI_AS NULL,
		[ordre_annee]                    [int] NULL,
		[ordre_commune]                  [int] NULL,
		[publie]                         [bit] NOT NULL,
		[recherche_nom_prenom_court]     [int] NULL,
		[date_creation]                  [datetime] NULL,
		[detail_acte]                    [varchar](255) COLLATE French_CI_AS NULL,
		[detail_individu]                [varchar](255) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_index]
	ADD
	CONSTRAINT [PK_saisie_donnees_index]
	PRIMARY KEY
	CLUSTERED
	([id_index])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_index]
	ADD
	CONSTRAINT [DF_saisie_donnees_index_date_creation]
	DEFAULT (getdate()) FOR [date_creation]
GO
ALTER TABLE [dbo].[saisie_donnees_index] SET (LOCK_ESCALATION = TABLE)
GO
