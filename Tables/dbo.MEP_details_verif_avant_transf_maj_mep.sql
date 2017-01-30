SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MEP_details_verif_avant_transf_maj_mep] (
		[id_document]                    [uniqueidentifier] NULL,
		[id_projet]                      [uniqueidentifier] NULL,
		[nb_fichiers_xml_ithaque]        [int] NULL,
		[nb_images_ithaque]              [int] NULL,
		[nb_actes_ithaque]               [int] NULL,
		[nb_individus_ithaque]           [int] NULL,
		[nb_individus_zones_ithaque]     [int] NULL,
		[nb_zones_ithaque]               [int] NULL,
		[nb_marges_ithaque]              [int] NULL,
		[titre]                          [varchar](100) COLLATE French_CI_AS NULL,
		[zonage_fichiers]                [bit] NULL,
		[nb_unites]                      [int] NULL,
		[nb_fichiers_xml]                [int] NULL,
		[nb_pages]                       [int] NULL,
		[nb_images]                      [int] NULL,
		[nb_actes]                       [int] NULL,
		[nb_individus]                   [int] NULL,
		[nb_identites]                   [int] NULL,
		[nb_individus_zones]             [int] NULL,
		[nb_zones_actes]                 [int] NULL,
		[ordre_fich_xml_exp]             [varchar](800) COLLATE French_CI_AS NULL,
		[nb_actes_nok_naissance]         [int] NULL,
		[nb_actes_nok_marriage]          [int] NULL,
		[nb_actes_nok_deces]             [int] NULL,
		[accepted_traitements]           [varchar](100) COLLATE French_CI_AS NULL,
		[nb_fichiers_rejected]           [int] NULL,
		[nb_actes_rejected]              [int] NULL,
		[prod_traitements]               [varchar](100) COLLATE French_CI_AS NULL,
		[nb_fichiers_prod]               [int] NULL,
		[nb_actes_prod]                  [int] NULL,
		[nb_actes_accepted]              [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MEP_details_verif_avant_transf_maj_mep] SET (LOCK_ESCALATION = TABLE)
GO
