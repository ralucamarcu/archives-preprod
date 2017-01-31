SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_individus_transfer] (
		[id_individu]                   [bigint] NOT NULL,
		[id_acte]                       [uniqueidentifier] NOT NULL,
		[id_role_acte]                  [int] NULL,
		[id_sexe]                       [varchar](1) COLLATE French_CI_AS NULL,
		[nom_prefix]                    [varchar](50) COLLATE French_CI_AS NULL,
		[nom]                           [varchar](255) COLLATE French_CI_AS NULL,
		[nom_suffix]                    [varchar](50) COLLATE French_CI_AS NULL,
		[prenom]                        [varchar](255) COLLATE French_CI_AS NULL,
		[date_naissance]                [varchar](50) COLLATE French_CI_AS NULL,
		[annee_naissance]               [int] NULL,
		[lieu_naissance]                [varchar](255) COLLATE French_CI_AS NULL,
		[lieu_insee_naissance]          [varchar](50) COLLATE French_CI_AS NULL,
		[id_commune_naissance]          [int] NULL,
		[date_mariage]                  [varchar](50) COLLATE French_CI_AS NULL,
		[annee_mariage]                 [int] NULL,
		[lieu_mariage]                  [varchar](255) COLLATE French_CI_AS NULL,
		[lieu_insee_mariage]            [varchar](50) COLLATE French_CI_AS NULL,
		[id_commune_mariage]            [int] NULL,
		[date_deces]                    [varchar](50) COLLATE French_CI_AS NULL,
		[annee_deces]                   [int] NULL,
		[lieu_deces]                    [varchar](255) COLLATE French_CI_AS NULL,
		[lieu_insee_deces]              [varchar](50) COLLATE French_CI_AS NULL,
		[id_commune_deces]              [int] NULL,
		[id_relation]                   [int] NULL,
		[id_individu_relation]          [int] NULL,
		[info]                          [varchar](max) COLLATE French_CI_AS NULL,
		[zone_top]                      [int] NULL,
		[zone_left]                     [int] NULL,
		[zone_bottom]                   [int] NULL,
		[zone_right]                    [int] NULL,
		[id_page]                       [uniqueidentifier] NULL,
		[id_detail]                     [int] NULL,
		[individu_principal]            [bit] NULL,
		[fam_num]                       [int] NULL,
		[date_creation]                 [datetime] NULL,
		[guid_bad]                      [uniqueidentifier] NULL,
		[age]                           [varchar](50) COLLATE French_CI_AS NULL,
		[id_zone]                       [bigint] NULL,
		[id_individu_xml]               [varchar](50) COLLATE French_CI_AS NULL,
		[detail_individu]               [varchar](255) COLLATE French_CI_AS NULL,
		[nom_naissance]                 [varchar](255) COLLATE French_CI_AS NULL,
		[prenom_naissance]              [varchar](255) COLLATE French_CI_AS NULL,
		[nom_origine]                   [varchar](255) COLLATE French_CI_AS NULL,
		[prenom_origine]                [varchar](255) COLLATE French_CI_AS NULL,
		[lieu_residence]                [varchar](255) COLLATE French_CI_AS NULL,
		[lieu_insee_residence]          [varchar](50) COLLATE French_CI_AS NULL,
		[id_commune_residence]          [int] NULL,
		[id_individu_ithaque]           [bigint] NULL,
		[id_acte_ithaque]               [int] NULL,
		[id_individu_relation_test]     [uniqueidentifier] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_individus_transfer]
	ADD
	CONSTRAINT [PK_saisie_donnees_individus_transfer]
	PRIMARY KEY
	CLUSTERED
	([id_individu], [id_acte])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_individus_transfer] SET (LOCK_ESCALATION = TABLE)
GO
