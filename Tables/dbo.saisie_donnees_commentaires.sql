SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[saisie_donnees_commentaires] (
		[id_commentaire]     [int] IDENTITY(1, 1) NOT NULL,
		[commentaire]        [varchar](max) COLLATE French_CI_AS NULL,
		[id_acte]            [uniqueidentifier] NOT NULL,
		[id_utilisateur]     [int] NOT NULL,
		[date_creation]      [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[saisie_donnees_commentaires] SET (LOCK_ESCALATION = TABLE)
GO
