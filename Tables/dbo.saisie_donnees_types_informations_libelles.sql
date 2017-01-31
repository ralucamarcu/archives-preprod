SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_types_informations_libelles] (
		[id_type_info]      [int] NOT NULL,
		[id_document]       [uniqueidentifier] NOT NULL,
		[libelle_info]      [varchar](100) COLLATE French_CI_AS NULL,
		[date_creation]     [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_types_informations_libelles]
	ADD
	CONSTRAINT [PK_saisie_donnees_types_informations_libelles]
	PRIMARY KEY
	CLUSTERED
	([id_type_info], [id_document])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_types_informations_libelles]
	ADD
	CONSTRAINT [DF_saisie_donnees_types_informations_libelles_date_creation]
	DEFAULT (getdate()) FOR [date_creation]
GO
ALTER TABLE [dbo].[saisie_donnees_types_informations_libelles] SET (LOCK_ESCALATION = TABLE)
GO
