SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[temp_actes_production] (
		[id_acte]             [uniqueidentifier] NOT NULL,
		[id_acte_ithaque]     [int] NULL,
		[id_fichier_xml]      [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[temp_actes_production] SET (LOCK_ESCALATION = TABLE)
GO
