SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_reconciliation_prenoms] (
		[id]               [int] NOT NULL,
		[prenom]           [varchar](50) COLLATE French_CI_AS NULL,
		[frequence]        [int] NULL,
		[correction_H]     [varchar](50) COLLATE French_CI_AS NULL,
		[correction_F]     [varchar](50) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_reconciliation_prenoms] SET (LOCK_ESCALATION = TABLE)
GO
