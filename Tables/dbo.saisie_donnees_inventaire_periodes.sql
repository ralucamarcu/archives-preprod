SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_inventaire_periodes] (
		[id_document]     [uniqueidentifier] NOT NULL,
		[commune]         [varchar](255) COLLATE French_CI_AS NULL,
		[nmd]             [varchar](100) COLLATE French_CI_AS NULL,
		[type_ec]         [varchar](50) COLLATE French_CI_AS NULL,
		[periodes]        [varchar](500) COLLATE French_CI_AS NULL,
		[geonameid]       [int] NULL,
		[a_supprimer]     [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_inventaire_periodes] SET (LOCK_ESCALATION = TABLE)
GO
