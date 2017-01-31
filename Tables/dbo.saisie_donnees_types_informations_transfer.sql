SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_types_informations_transfer] (
		[id_type_info]          [int] NOT NULL,
		[libelle_info]          [varchar](100) COLLATE French_CI_AS NULL,
		[date_creation]         [datetime] NULL,
		[nom_type_info_DTD]     [varchar](50) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_types_informations_transfer]
	ADD
	CONSTRAINT [PK_saisie_donnees_types_informations_transfer]
	PRIMARY KEY
	CLUSTERED
	([id_type_info])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_types_informations_transfer]
	ADD
	CONSTRAINT [DF_saisie_donnees_types_informations_date_creation1]
	DEFAULT (getdate()) FOR [date_creation]
GO
ALTER TABLE [dbo].[saisie_donnees_types_informations_transfer] SET (LOCK_ESCALATION = TABLE)
GO
