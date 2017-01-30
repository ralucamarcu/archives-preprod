SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_documents] (
		[id_document]                [uniqueidentifier] NOT NULL,
		[titre]                      [varchar](150) COLLATE French_CI_AS NULL,
		[description]                [varchar](max) COLLATE French_CI_AS NULL,
		[miniature_document]         [varchar](255) COLLATE French_CI_AS NULL,
		[nb_page]                    [int] NULL,
		[chemin_images_viewer]       [varchar](255) COLLATE French_CI_AS NULL,
		[chemin_miniatures]          [varchar](255) COLLATE French_CI_AS NULL,
		[nom_vue]                    [varchar](50) COLLATE French_CI_AS NULL,
		[copyright]                  [varchar](1024) COLLATE French_CI_AS NULL,
		[sous_titre]                 [varchar](1024) COLLATE French_CI_AS NULL,
		[image_principale]           [varchar](255) COLLATE French_CI_AS NULL,
		[image_secondaire]           [varchar](255) COLLATE French_CI_AS NULL,
		[publie]                     [bit] NOT NULL,
		[date_mise_a_jour]           [datetime] NULL,
		[date_publication]           [datetime] NULL,
		[image_exemple]              [varchar](255) COLLATE French_CI_AS NULL,
		[annee_min]                  [varchar](32) COLLATE French_CI_AS NULL,
		[annee_max]                  [varchar](32) COLLATE French_CI_AS NULL,
		[legende]                    [varchar](max) COLLATE French_CI_AS NULL,
		[gratuit]                    [bit] NULL,
		[template_name]              [varchar](124) COLLATE French_CI_AS NULL,
		[image_haut_banniere]        [varchar](255) COLLATE French_CI_AS NULL,
		[colonne_droite]             [varchar](max) COLLATE French_CI_AS NULL,
		[titre_recherche]            [varchar](255) COLLATE French_CI_AS NULL,
		[department_code]            [varchar](255) COLLATE French_CI_AS NULL,
		[department_logo_chemin]     [varchar](255) COLLATE French_CI_AS NULL,
		[latitude]                   [float] NULL,
		[longitude]                  [float] NULL,
		[zoom]                       [tinyint] NULL,
		[fields]                     [varchar](500) COLLATE French_CI_AS NULL,
		[nb_actes]                   [int] NULL,
		[transfer_prod]              [bit] NULL,
		[zonage_fichier]             [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_documents] SET (LOCK_ESCALATION = TABLE)
GO
