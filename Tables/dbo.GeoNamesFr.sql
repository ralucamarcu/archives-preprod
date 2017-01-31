SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GeoNamesFr] (
		[GeoNameid]          [int] NOT NULL,
		[ville]              [nvarchar](200) COLLATE French_CI_AS NULL,
		[id_departement]     [varchar](80) COLLATE French_CI_AS NULL,
		[departement]        [nvarchar](200) COLLATE French_CI_AS NULL,
		[id_region]          [varchar](20) COLLATE French_CI_AS NULL,
		[region]             [nvarchar](200) COLLATE French_CI_AS NULL,
		[id_pays]            [char](2) COLLATE French_CI_AS NULL,
		[pays]               [varchar](200) COLLATE French_CI_AS NULL,
		[Latitude]           [float] NULL,
		[Longitude]          [float] NULL,
		[type]               [nvarchar](50) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GeoNamesFr]
	ADD
	CONSTRAINT [PK_GeoNamesFr]
	PRIMARY KEY
	CLUSTERED
	([GeoNameid])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[GeoNamesFr] SET (LOCK_ESCALATION = TABLE)
GO
