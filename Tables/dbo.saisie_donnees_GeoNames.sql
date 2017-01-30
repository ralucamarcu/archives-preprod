SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_GeoNames] (
		[geonameid]             [int] NOT NULL,
		[name]                  [nvarchar](200) COLLATE French_CI_AS NULL,
		[asciiname]             [nvarchar](200) COLLATE French_CI_AS NULL,
		[alternatenames]        [nvarchar](max) COLLATE French_CI_AS NULL,
		[latitude]              [float] NULL,
		[longitude]             [float] NULL,
		[feature_class]         [char](2) COLLATE French_CI_AS NULL,
		[feature_code]          [nvarchar](10) COLLATE French_CI_AS NULL,
		[country_code]          [char](3) COLLATE French_CI_AS NULL,
		[cc2]                   [char](60) COLLATE French_CI_AS NULL,
		[admin1_code]           [nvarchar](20) COLLATE French_CI_AS NULL,
		[admin2_code]           [nvarchar](80) COLLATE French_CI_AS NULL,
		[admin3_code]           [nvarchar](20) COLLATE French_CI_AS NULL,
		[admin4_code]           [nvarchar](20) COLLATE French_CI_AS NULL,
		[population]            [bigint] NULL,
		[elevation]             [int] NULL,
		[gtopo30]               [int] NULL,
		[timezone]              [char](31) COLLATE French_CI_AS NULL,
		[modification_date]     [datetime] NULL,
		[id_ordonne]            [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_GeoNames] SET (LOCK_ESCALATION = TABLE)
GO
