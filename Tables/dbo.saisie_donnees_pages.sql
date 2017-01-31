SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_pages] (
		[id_page]                 [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[description]             [varchar](50) COLLATE French_CI_AS NULL,
		[image_viewer]            [varchar](255) COLLATE French_CI_AS NULL,
		[image_miniature]         [varchar](255) COLLATE French_CI_AS NULL,
		[image_origine]           [varchar](300) COLLATE French_CI_AS NULL,
		[id_document]             [uniqueidentifier] NULL,
		[ordre]                   [int] NULL,
		[fenetre_navigation]      [int] NULL,
		[id_lot]                  [int] NOT NULL,
		[visible]                 [bit] NOT NULL,
		[date_creation]           [datetime] NULL,
		[affichage_image]         [bit] NOT NULL,
		[ordre_fichier_xml]       [int] NULL,
		[id_fichier_xml]          [int] NULL,
		[id_statut]               [int] NULL,
		[cote]                    [varchar](50) COLLATE French_CI_AS NULL,
		[id_fichier_xml_test]     [int] NULL,
		[date_modification]       [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_pages]
	ADD
	CONSTRAINT [PK_saisie_donnees_pages]
	PRIMARY KEY
	CLUSTERED
	([id_page])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_pages]
	ADD
	CONSTRAINT [DF_saisie_donnees_pages_affichage_image]
	DEFAULT ((1)) FOR [affichage_image]
GO
ALTER TABLE [dbo].[saisie_donnees_pages]
	ADD
	CONSTRAINT [DF_saisie_donnees_pages_date_creation]
	DEFAULT (getdate()) FOR [date_creation]
GO
ALTER TABLE [dbo].[saisie_donnees_pages]
	ADD
	CONSTRAINT [DF_saisie_donnees_pages_id_page]
	DEFAULT (newid()) FOR [id_page]
GO
ALTER TABLE [dbo].[saisie_donnees_pages]
	ADD
	CONSTRAINT [DF_saisie_donnees_pages_visible_1]
	DEFAULT ((1)) FOR [visible]
GO
CREATE NONCLUSTERED INDEX [id_document]
	ON [dbo].[saisie_donnees_pages] ([id_document])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [image_origine]
	ON [dbo].[saisie_donnees_pages] ([image_origine])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [image_viewer]
	ON [dbo].[saisie_donnees_pages] ([image_viewer])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_pages] SET (LOCK_ESCALATION = TABLE)
GO
