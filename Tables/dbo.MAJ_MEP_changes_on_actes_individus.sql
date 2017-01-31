SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[MAJ_MEP_changes_on_actes_individus] (
		[id_acte]             [uniqueidentifier] NOT NULL,
		[id_acte_ithaque]     [int] NULL,
		[changes]             [int] NOT NULL,
		[id_individu]         [bigint] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_id_acte]
	ON [dbo].[MAJ_MEP_changes_on_actes_individus] ([id_acte])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_id_acte_ithaque]
	ON [dbo].[MAJ_MEP_changes_on_actes_individus] ([id_acte_ithaque])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_modif]
	ON [dbo].[MAJ_MEP_changes_on_actes_individus] ([changes])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[MAJ_MEP_changes_on_actes_individus] SET (LOCK_ESCALATION = TABLE)
GO
