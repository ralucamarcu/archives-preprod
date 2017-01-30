SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Saisie_donnees_images_MAJ_transfer] (
		[id_image]            [int] IDENTITY(1, 1) NOT NULL,
		[path]                [varchar](500) COLLATE French_CI_AS NULL,
		[zones_a_traiter]     [bit] NULL,
		[zones_traitees]      [datetime] NULL,
		[jp2_a_traiter]       [bit] NULL,
		[jp2_traitee]         [datetime] NULL,
		[id_page]             [uniqueidentifier] NULL,
		[id_document]         [uniqueidentifier] NULL,
		[status]              [int] NULL,
		[date_status]         [datetime] NULL,
		[thumb_a_traiter]     [bit] NULL,
		[date_creation]       [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Saisie_donnees_images_MAJ_transfer] SET (LOCK_ESCALATION = TABLE)
GO
