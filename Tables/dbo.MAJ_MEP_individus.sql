SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAJ_MEP_individus] (
		[nom]                              [varchar](255) COLLATE French_CI_AS NULL,
		[nom_Correction_Reecriture]        [varchar](255) COLLATE French_CI_AS NULL,
		[nom_Correction]                   [varchar](255) COLLATE French_CI_AS NULL,
		[prenom]                           [varchar](300) COLLATE French_CI_AS NULL,
		[prenom_Correction_Reecriture]     [varchar](255) COLLATE French_CI_AS NULL,
		[prenom_Correction]                [varchar](300) COLLATE French_CI_AS NULL,
		[id_individu_xml]                  [varchar](50) COLLATE French_CI_AS NULL,
		[id_individu_ithaque]              [bigint] NOT NULL,
		[id_acte_ithaque]                  [bigint] NULL,
		[id_acte]                          [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MAJ_MEP_individus] SET (LOCK_ESCALATION = TABLE)
GO
