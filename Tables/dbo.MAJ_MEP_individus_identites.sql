SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAJ_MEP_individus_identites] (
		[id_individu]             [bigint] NOT NULL,
		[id_type_identite]        [int] NOT NULL,
		[ordre]                   [int] NOT NULL,
		[nom]                     [varchar](255) COLLATE French_CI_AS NULL,
		[prenom]                  [varchar](255) COLLATE French_CI_AS NULL,
		[date_creation]           [datetime] NULL,
		[id_acte_ithaque]         [int] NULL,
		[id_individu_ithaque]     [bigint] NOT NULL,
		[id_acte]                 [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_id_acte_archives]
	ON [dbo].[MAJ_MEP_individus_identites] ([id_acte])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_id_individu_ithaque]
	ON [dbo].[MAJ_MEP_individus_identites] ([id_individu_ithaque])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[MAJ_MEP_individus_identites] SET (LOCK_ESCALATION = TABLE)
GO
