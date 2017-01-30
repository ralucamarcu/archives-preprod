SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAJ_MEP_actes] (
		[date_acte_Correction_Reecriture]      [nvarchar](50) COLLATE French_CI_AS NULL,
		[annee_acte_Correction_Reecriture]     [nvarchar](50) COLLATE French_CI_AS NULL,
		[date_creation]                        [datetime] NULL,
		[id_acte_xml]                          [nvarchar](50) COLLATE French_CI_AS NULL,
		[id_acte_ithaque]                      [bigint] NOT NULL,
		[lieu_acte_Correction]                 [nvarchar](100) COLLATE French_CI_AS NULL,
		[geonameid_acte_Correction]            [bigint] NULL,
		[insee_acte_Correction]                [nvarchar](10) COLLATE French_CI_AS NULL,
		[id_acte]                              [uniqueidentifier] NOT NULL,
		[date_acte_Correction]                 [nvarchar](50) COLLATE French_CI_AS NULL,
		[annee_acte_Correction]                [nvarchar](50) COLLATE French_CI_AS NULL,
		[id_individu]                          [bigint] NULL,
		[type_acte_updated]                    [varchar](150) COLLATE French_CI_AS NULL,
		[type_acte_Correction]                 [varchar](50) COLLATE French_CI_AS NULL,
		[soustype_acte_Correction]             [nvarchar](50) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MAJ_MEP_actes] SET (LOCK_ESCALATION = TABLE)
GO
