SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[temp_taches_images_logs] (
		[id_log]                            [int] NOT NULL,
		[id_image]                          [uniqueidentifier] NOT NULL,
		[path_origine]                      [varchar](500) COLLATE French_CI_AS NULL,
		[path_destination]                  [varchar](500) COLLATE French_CI_AS NULL,
		[id_tache]                          [int] NULL,
		[date_creation]                     [datetime] NOT NULL,
		[nom_fichier_image_origine]         [varchar](255) COLLATE French_CI_AS NULL,
		[nom_fichier_image_destination]     [varchar](255) COLLATE French_CI_AS NULL,
		[taille_image]                      [int] NULL,
		[id_status]                         [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[temp_taches_images_logs] SET (LOCK_ESCALATION = TABLE)
GO
