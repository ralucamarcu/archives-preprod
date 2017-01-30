SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_erreurs] (
		[id]                 [int] IDENTITY(1, 1) NOT NULL,
		[id_acte]            [uniqueidentifier] NULL,
		[date_creation]      [datetime] NULL,
		[message]            [varchar](max) COLLATE French_CI_AS NULL,
		[id_utilisateur]     [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_erreurs] SET (LOCK_ESCALATION = TABLE)
GO
