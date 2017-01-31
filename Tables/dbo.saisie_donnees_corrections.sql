SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_corrections] (
		[id_correction]       [int] IDENTITY(1, 1) NOT NULL,
		[id_acte]             [uniqueidentifier] NOT NULL,
		[text_modifie]        [text] COLLATE French_CI_AS NULL,
		[id_emplacement]      [int] NULL,
		[date_creation]       [datetime] NULL,
		[date_validation]     [datetime] NULL,
		[status]              [varchar](50) COLLATE French_CI_AS NULL,
		[text_original]       [text] COLLATE French_CI_AS NULL,
		[id]                  [int] NULL,
		[guid]                [uniqueidentifier] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_corrections]
	ADD
	CONSTRAINT [PK_saisie_donnees_corrections]
	PRIMARY KEY
	CLUSTERED
	([id_correction])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_corrections]
	WITH CHECK
	ADD CONSTRAINT [FK_saisie_donnees_corrections_saisie_donnees_emplacement_corrections]
	FOREIGN KEY ([id_emplacement]) REFERENCES [dbo].[saisie_donnees_emplacement_corrections] ([id_emplacement])
ALTER TABLE [dbo].[saisie_donnees_corrections]
	CHECK CONSTRAINT [FK_saisie_donnees_corrections_saisie_donnees_emplacement_corrections]

GO
ALTER TABLE [dbo].[saisie_donnees_corrections] SET (LOCK_ESCALATION = TABLE)
GO
