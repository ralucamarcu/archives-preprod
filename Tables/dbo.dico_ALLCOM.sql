SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dico_ALLCOM] (
		[INSEE]                        [varchar](50) COLLATE French_CI_AS NULL,
		[LIBELLE]                      [varchar](50) COLLATE French_CI_AS NULL,
		[LIBELLE_INSEE]                [varchar](50) COLLATE French_CI_AS NULL,
		[LIBELLE_MAJUSCULES_INSEE]     [varchar](50) COLLATE French_CI_AS NULL,
		[GEONAMEID]                    [varchar](50) COLLATE French_CI_AS NULL,
		[SOURCE]                       [varchar](50) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dico_ALLCOM] SET (LOCK_ESCALATION = TABLE)
GO
