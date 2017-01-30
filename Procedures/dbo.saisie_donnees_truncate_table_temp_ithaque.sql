SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[saisie_donnees_truncate_table_temp_ithaque] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    TRUNCATE TABLE dbo.DataXmlRC_actes
	TRUNCATE TABLE dbo.DataXmlRC_individus_identites
	TRUNCATE TABLE dbo.DataXmlRC_individus
	TRUNCATE TABLE dbo.DataXmlRC_individus_zones
	TRUNCATE TABLE dbo.DataXmlRC_marges
	TRUNCATE TABLE dbo.DataXmlRC_relations_individus
	TRUNCATE TABLE dbo.DataXmlRC_zones
END
GO
