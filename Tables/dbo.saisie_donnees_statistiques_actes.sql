SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_statistiques_actes] (
		[DOCUMENT]              [varchar](255) COLLATE French_CI_AS NULL,
		[nb_actes_valide_n]     [int] NULL,
		[nb_actes_valide_d]     [int] NULL,
		[nb_actes_valide_m]     [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_statistiques_actes] SET (LOCK_ESCALATION = TABLE)
GO
