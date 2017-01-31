SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[temp_actexml_page_saisie] (
		[id]                  [int] IDENTITY(1, 1) NOT NULL,
		[id_acte_ithaque]     [int] NULL,
		[image]               [varchar](255) COLLATE French_CI_AS NULL,
		[id_acte_xml]         [varchar](255) COLLATE French_CI_AS NULL,
		[id_page]             [uniqueidentifier] NULL,
		[id_fichier_xml]      [int] NULL,
		[id_fichier]          [uniqueidentifier] NULL,
		[date_creation]       [datetime] NULL,
		[image_viewer]        [varchar](800) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[temp_actexml_page_saisie]
	ADD
	CONSTRAINT [DF_temp_actexml_page_saisie_date_creation]
	DEFAULT (getdate()) FOR [date_creation]
GO
CREATE NONCLUSTERED INDEX [idx_fichier_acte_page]
	ON [dbo].[temp_actexml_page_saisie] ([id_fichier_xml])
	INCLUDE ([id_acte_ithaque], [id_acte_xml], [id_page])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_id_acte_ithaque]
	ON [dbo].[temp_actexml_page_saisie] ([id_acte_ithaque])
	ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [idx_id_fichier]
	ON [dbo].[temp_actexml_page_saisie] ([id_fichier])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_id_fichier_xml]
	ON [dbo].[temp_actexml_page_saisie] ([id_fichier_xml])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_image]
	ON [dbo].[temp_actexml_page_saisie] ([image])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_image_viewer]
	ON [dbo].[temp_actexml_page_saisie] ([image_viewer])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[temp_actexml_page_saisie] SET (LOCK_ESCALATION = TABLE)
GO
