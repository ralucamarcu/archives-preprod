SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAJ_MEP_acte_xml_traitements_RejetEchantillon] (
		[id_acte]              [bigint] NOT NULL,
		[id_acte_archives]     [uniqueidentifier] NOT NULL,
		[id_acte_xml]          [nvarchar](50) COLLATE French_CI_AS NULL,
		[type_acte]            [nvarchar](50) COLLATE French_CI_AS NULL,
		[annee_acte]           [nvarchar](50) COLLATE French_CI_AS NULL,
		[nom_fichier]          [varchar](250) COLLATE French_CI_AS NULL,
		[id_fichier]           [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MAJ_MEP_acte_xml_traitements_RejetEchantillon] SET (LOCK_ESCALATION = TABLE)
GO
