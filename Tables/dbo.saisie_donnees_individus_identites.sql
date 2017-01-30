SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_individus_identites] (
		[id_individu_identite]     [uniqueidentifier] NOT NULL,
		[id_acte]                  [uniqueidentifier] NOT NULL,
		[id_individu]              [bigint] NOT NULL,
		[id_type_identite]         [int] NOT NULL,
		[ordre]                    [int] NOT NULL,
		[nom]                      [varchar](255) COLLATE French_CI_AS NULL,
		[prenom]                   [varchar](255) COLLATE French_CI_AS NULL,
		[date_creation]            [datetime] NULL,
		[id_acte_ithaque]          [int] NULL,
		[id_individu_ithaque]      [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_individus_identites] SET (LOCK_ESCALATION = TABLE)
GO
