SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_actes_transfer] (
		[id_acte]                       [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[type_acte]                     [int] NULL,
		[date_acte]                     [varchar](50) COLLATE French_CI_AS NULL,
		[annee_acte]                    [int] NULL,
		[lieu_acte]                     [varchar](255) COLLATE French_CI_AS NULL,
		[insee_acte]                    [varchar](50) COLLATE French_CI_AS NULL,
		[id_commune_acte]               [int] NULL,
		[id_individu_sujet]             [int] NULL,
		[id_individu_conjoint]          [int] NULL,
		[id_individu_sujet_pere]        [int] NULL,
		[id_individu_sujet_mere]        [int] NULL,
		[id_individu_conjoint_pere]     [int] NULL,
		[id_individu_conjoint_mere]     [int] NULL,
		[info]                          [varchar](max) COLLATE French_CI_AS NULL,
		[id_page]                       [uniqueidentifier] NULL,
		[zone_top]                      [int] NULL,
		[zone_left]                     [int] NULL,
		[zone_bottom]                   [int] NULL,
		[zone_right]                    [int] NULL,
		[date_creation]                 [datetime] NULL,
		[id_acte_xml]                   [varchar](50) COLLATE French_CI_AS NULL,
		[detail_acte]                   [varchar](255) COLLATE French_CI_AS NULL,
		[nb_unites]                     [int] NULL,
		[date_acte_originale]           [varchar](100) COLLATE French_CI_AS NULL,
		[id_fichier_xml]                [int] NULL,
		[id_association]                [int] NULL,
		[id_statut_publication]         [tinyint] NULL,
		[id_acte_ithaque]               [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_actes_transfer] SET (LOCK_ESCALATION = TABLE)
GO
