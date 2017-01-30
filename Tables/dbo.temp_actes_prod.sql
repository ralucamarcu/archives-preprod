SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[temp_actes_prod] (
		[id_acte]                [uniqueidentifier] NOT NULL,
		[id_acte_ithaque]        [int] NULL,
		[id_fichier_xml]         [int] NULL,
		[id_fichier_ithaque]     [uniqueidentifier] NULL,
		[nom_fichier]            [varchar](250) COLLATE French_CI_AS NULL,
		[id_traitement]          [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[temp_actes_prod] SET (LOCK_ESCALATION = TABLE)
GO
