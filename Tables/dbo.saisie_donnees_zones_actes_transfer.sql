SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[saisie_donnees_zones_actes_transfer] (
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
ALTER TABLE [dbo].[saisie_donnees_zones_actes_transfer] SET (LOCK_ESCALATION = TABLE)
GO
