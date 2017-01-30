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
ALTER TABLE [dbo].[saisie_donnees_individus_evenements] SET (LOCK_ESCALATION = TABLE)
GO
