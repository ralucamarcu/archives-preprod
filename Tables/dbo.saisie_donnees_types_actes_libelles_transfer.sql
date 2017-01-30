SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_types_actes_libelles_transfer] (
		[id_type_acte]              [int] NOT NULL,
		[id_document]               [uniqueidentifier] NOT NULL,
		[libelle_type_acte]         [varchar](200) COLLATE French_CI_AS NULL,
		[description_type_acte]     [varchar](max) COLLATE French_CI_AS NULL,
		[date_creation]             [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_types_actes_libelles_transfer] SET (LOCK_ESCALATION = TABLE)
GO
