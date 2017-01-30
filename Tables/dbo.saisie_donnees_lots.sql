SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_lots] (
		[id_lot]               [int] NOT NULL,
		[id_document]          [uniqueidentifier] NOT NULL,
		[titre]                [varchar](150) COLLATE French_CI_AS NULL,
		[publie]               [bit] NOT NULL,
		[date_publication]     [datetime] NULL,
		[image]                [varchar](100) COLLATE French_CI_AS NULL,
		[legende]              [varchar](max) COLLATE French_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_lots] SET (LOCK_ESCALATION = TABLE)
GO
