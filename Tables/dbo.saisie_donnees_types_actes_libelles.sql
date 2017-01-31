SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_types_actes_libelles] (
		[id_type_acte]              [int] NOT NULL,
		[id_document]               [uniqueidentifier] NOT NULL,
		[libelle_type_acte]         [varchar](200) COLLATE French_CI_AS NULL,
		[description_type_acte]     [varchar](max) COLLATE French_CI_AS NULL,
		[date_creation]             [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_types_actes_libelles]
	ADD
	CONSTRAINT [PK_saisie_donnees_types_actes_libelles]
	PRIMARY KEY
	CLUSTERED
	([id_type_acte], [id_document])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_types_actes_libelles]
	ADD
	CONSTRAINT [DF_saisie_donnees_types_actes_libelles_date_creation]
	DEFAULT (getdate()) FOR [date_creation]
GO
ALTER TABLE [dbo].[saisie_donnees_types_actes_libelles] SET (LOCK_ESCALATION = TABLE)
GO
