SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_types_informations_libelles_transfer] (
		[id_type_info]      [int] NOT NULL,
		[id_document]       [uniqueidentifier] NOT NULL,
		[libelle_info]      [varchar](100) COLLATE French_CI_AS NULL,
		[date_creation]     [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_types_informations_libelles_transfer] SET (LOCK_ESCALATION = TABLE)
GO
