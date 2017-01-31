SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_individus_zones_transfer] (
		[id_acte]             [uniqueidentifier] NOT NULL,
		[id_individu]         [bigint] NOT NULL,
		[id_zone]             [int] NOT NULL,
		[date_creation]       [datetime] NULL,
		[id_individu_xml]     [varchar](255) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_individus_zones_transfer]
	ADD
	CONSTRAINT [PK_saisie_donnees_individus_zones_transfer]
	PRIMARY KEY
	CLUSTERED
	([id_acte], [id_individu], [id_zone])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_individus_zones_transfer]
	ADD
	CONSTRAINT [DF_saisie_donnees_individus_zones_date_creation1]
	DEFAULT (getdate()) FOR [date_creation]
GO
ALTER TABLE [dbo].[saisie_donnees_individus_zones_transfer] SET (LOCK_ESCALATION = TABLE)
GO
