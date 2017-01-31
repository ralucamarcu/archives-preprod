SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Saisie_donnees_images] (
		[id_image]                   [int] IDENTITY(1, 1) NOT NULL,
		[path]                       [varchar](500) COLLATE French_CI_AS NULL,
		[zones_a_traiter]            [bit] NULL,
		[zones_traitees]             [datetime] NULL,
		[jp2_a_traiter]              [bit] NULL,
		[jp2_traitee]                [datetime] NULL,
		[id_page]                    [uniqueidentifier] NULL,
		[id_document]                [uniqueidentifier] NULL,
		[status]                     [int] NULL,
		[date_status]                [datetime] NULL,
		[id_fichier_xml_ithaque]     [uniqueidentifier] NULL,
		[date_creation]              [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Saisie_donnees_images]
	ADD
	CONSTRAINT [PK_Saisie_donnees_images]
	PRIMARY KEY
	CLUSTERED
	([id_image])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [id_document]
	ON [dbo].[Saisie_donnees_images] ([id_document])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [path]
	ON [dbo].[Saisie_donnees_images] ([path])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[Saisie_donnees_images] SET (LOCK_ESCALATION = TABLE)
GO
