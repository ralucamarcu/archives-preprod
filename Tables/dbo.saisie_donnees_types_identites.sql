SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_types_identites] (
		[id_type_identite]     [int] IDENTITY(1, 1) NOT NULL,
		[nom]                  [varchar](100) COLLATE French_CI_AS NULL,
		[nom_DTD]              [varchar](100) COLLATE French_CI_AS NULL,
		[date_creation]        [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_types_identites]
	ADD
	CONSTRAINT [PK_saisie_donnees_types_identites]
	PRIMARY KEY
	CLUSTERED
	([id_type_identite])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_types_identites]
	ADD
	CONSTRAINT [DF_saisie_donnees_types_identites_date_creation]
	DEFAULT (getdate()) FOR [date_creation]
GO
ALTER TABLE [dbo].[saisie_donnees_types_identites] SET (LOCK_ESCALATION = TABLE)
GO
