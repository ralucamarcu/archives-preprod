SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_actes_informations] (
		[id_info_acte]        [uniqueidentifier] NOT NULL,
		[id_acte]             [uniqueidentifier] NULL,
		[id_type_info]        [int] NOT NULL,
		[valeur]              [varchar](max) COLLATE French_CI_AS NULL,
		[ordre_affichage]     [int] NULL,
		[date_creation]       [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_actes_informations] SET (LOCK_ESCALATION = TABLE)
GO
