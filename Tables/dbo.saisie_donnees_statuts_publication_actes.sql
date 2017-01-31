SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_statuts_publication_actes] (
		[id_statut_publication]          [tinyint] NOT NULL,
		[libelle_statut_publication]     [varchar](1000) COLLATE French_CI_AS NULL,
		[date_creation]                  [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_statuts_publication_actes]
	ADD
	CONSTRAINT [PK_saisie_donnees_statuts_publication_actes]
	PRIMARY KEY
	CLUSTERED
	([id_statut_publication])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_statuts_publication_actes]
	ADD
	CONSTRAINT [DF_saisie_donnees_statuts_publication_actes_date_creation]
	DEFAULT (getdate()) FOR [date_creation]
GO
ALTER TABLE [dbo].[saisie_donnees_statuts_publication_actes] SET (LOCK_ESCALATION = TABLE)
GO
