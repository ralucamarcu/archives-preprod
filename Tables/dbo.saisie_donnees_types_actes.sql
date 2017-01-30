SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_types_actes] (
		[id_type_acte]                   [int] NOT NULL,
		[nom_type_acte]                  [varchar](100) COLLATE French_CI_AS NULL,
		[id_type_acte_groupe]            [int] NULL,
		[nom_type_acte_DTD]              [varchar](500) COLLATE French_CI_AS NULL,
		[titre_type_acte]                [varchar](150) COLLATE French_CI_AS NULL,
		[description_type_acte]          [varchar](max) COLLATE French_CI_AS NULL,
		[miniature_type_acte]            [varchar](255) COLLATE French_CI_AS NULL,
		[nb_page_type_acte]              [int] NULL,
		[sous_titre_type_acte]           [varchar](512) COLLATE French_CI_AS NULL,
		[image_principale_type_acte]     [varchar](255) COLLATE French_CI_AS NULL,
		[annee_min_type_acte]            [varchar](32) COLLATE French_CI_AS NULL,
		[annee_max_type_acte]            [varchar](32) COLLATE French_CI_AS NULL,
		[image_secondaire_type_acte]     [varchar](255) COLLATE French_CI_AS NULL,
		[image_exemple_type_acte]        [varchar](255) COLLATE French_CI_AS NULL,
		[type_evenement_gedcom]          [varchar](10) COLLATE French_CI_AS NULL,
		[id_type_evenement_global]       [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_types_actes] SET (LOCK_ESCALATION = TABLE)
GO
