SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_types_evenements] (
		[id_type_evenement]            [int] NOT NULL,
		[nom_type_evenement]           [varchar](100) COLLATE French_CI_AS NULL,
		[nom_type_evenement_DTD]       [varchar](500) COLLATE French_CI_AS NULL,
		[type_evenement_gedcom]        [varchar](10) COLLATE French_CI_AS NULL,
		[ordre_affichage]              [int] NULL,
		[date_creation]                [datetime] NULL,
		[id_type_evenement_global]     [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_types_evenements]
	ADD
	CONSTRAINT [PK_saisie_donnees_types_evenements]
	PRIMARY KEY
	CLUSTERED
	([id_type_evenement])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_types_evenements]
	ADD
	CONSTRAINT [DF_saisie_donnees_types_evenements_date_creation]
	DEFAULT (getdate()) FOR [date_creation]
GO
ALTER TABLE [dbo].[saisie_donnees_types_evenements] SET (LOCK_ESCALATION = TABLE)
GO
