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
ALTER TABLE [dbo].[saisie_donnees_pages] SET (LOCK_ESCALATION = TABLE)
GO
