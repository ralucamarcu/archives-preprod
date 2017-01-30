SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_publications] (
		[id_publication]       [uniqueidentifier] NOT NULL,
		[titre]                [varchar](150) COLLATE French_CI_AS NULL,
		[sous_titre]           [varchar](1024) COLLATE French_CI_AS NULL,
		[description]          [varchar](max) COLLATE French_CI_AS NULL,
		[legende]              [varchar](8000) COLLATE French_CI_AS NULL,
		[nb_actes]             [int] NULL,
		[miniature]            [varchar](255) COLLATE French_CI_AS NULL,
		[image_principale]     [varchar](255) COLLATE French_CI_AS NULL,
		[image_secondaire]     [varchar](255) COLLATE French_CI_AS NULL,
		[image_exemple]        [varchar](255) COLLATE French_CI_AS NULL,
		[annee_min]            [varchar](32) COLLATE French_CI_AS NULL,
		[annee_max]            [nchar](10) COLLATE French_CI_AS NULL,
		[nom_vue]              [varchar](50) COLLATE French_CI_AS NULL,
		[publie]               [bit] NULL,
		[date_mise_a_jour]     [datetime] NULL,
		[date_publication]     [datetime] NULL,
		[date_creation]        [datetime] NULL,
		[url]                  [varchar](512) COLLATE French_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_publications] SET (LOCK_ESCALATION = TABLE)
GO
