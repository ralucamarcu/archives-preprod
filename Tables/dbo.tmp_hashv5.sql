SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_hashv5] (
		[ancien_chemin]      [varchar](500) COLLATE French_CI_AS NULL,
		[nouveau_chemin]     [varchar](500) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tmp_hashv5] SET (LOCK_ESCALATION = TABLE)
GO
