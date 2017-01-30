SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MAJ_MEP_traitements] (
		[id_projet]                [uniqueidentifier] NULL,
		[id_document]              [uniqueidentifier] NULL,
		[id_traitements_maj]       [varchar](800) COLLATE French_CI_AS NULL,
		[id_traitements_prod]      [varchar](800) COLLATE French_CI_AS NULL,
		[id_tache_log]             [int] NULL,
		[id_tache_log_details]     [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MAJ_MEP_traitements] SET (LOCK_ESCALATION = TABLE)
GO
