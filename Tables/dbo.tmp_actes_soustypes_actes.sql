SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_actes_soustypes_actes] (
		[id_acte]                      [int] NULL,
		[type_acte]                    [varchar](150) COLLATE French_CI_AS NULL,
		[soustype_acte]                [varchar](150) COLLATE French_CI_AS NULL,
		[type_acte_Correction]         [varchar](150) COLLATE French_CI_AS NULL,
		[soustype_acte_Correction]     [varchar](150) COLLATE French_CI_AS NULL,
		[type_acte_updated]            [varchar](150) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tmp_actes_soustypes_actes] SET (LOCK_ESCALATION = TABLE)
GO
