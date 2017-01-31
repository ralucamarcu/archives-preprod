SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[saisie_donnees_zones_actes_MAJ_transfer] (
		[id_zone]               [int] IDENTITY(1, 1) NOT NULL,
		[id_acte]               [uniqueidentifier] NULL,
		[id_page]               [uniqueidentifier] NULL,
		[zone_top]              [int] NULL,
		[zone_left]             [int] NULL,
		[zone_bottom]           [int] NULL,
		[zone_right]            [int] NULL,
		[marge]                 [bit] NULL,
		[date_creation]         [datetime] NULL,
		[id_acte_ithaque]       [int] NULL,
		[id_zone_ithaque]       [int] NULL,
		[date_modification]     [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_zones_actes_MAJ_transfer]
	ADD
	CONSTRAINT [PK_saisie_donnees_zones_actes2MAJ_]
	PRIMARY KEY
	CLUSTERED
	([id_zone])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_zones_actes_MAJ_transfer]
	ADD
	CONSTRAINT [DF_saisie_donnees_zones_actes_date_creationMAJ_]
	DEFAULT (getdate()) FOR [date_creation]
GO
ALTER TABLE [dbo].[saisie_donnees_zones_actes_MAJ_transfer] SET (LOCK_ESCALATION = TABLE)
GO
