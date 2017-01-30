SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_informations_individus] (
		[id_info_individu]     [uniqueidentifier] NOT NULL,
		[id_individu]          [bigint] NOT NULL,
		[id_acte]              [uniqueidentifier] NULL,
		[id_type_info]         [int] NOT NULL,
		[valeur]               [varchar](max) COLLATE French_CI_AS NULL,
		[ordre_affichage]      [int] NULL,
		[date_creation]        [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_informations_individus] SET (LOCK_ESCALATION = TABLE)
GO
