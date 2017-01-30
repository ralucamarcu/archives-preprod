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
ALTER TABLE [dbo].[temp_actexml_page_saisie] SET (LOCK_ESCALATION = TABLE)
GO
