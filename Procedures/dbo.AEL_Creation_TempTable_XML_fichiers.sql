SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[AEL_Creation_TempTable_XML_fichiers]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DBCC FREEPROCCACHE
	IF OBJECT_ID('saisie_donnees_fichiers_xml_temp') IS NOT NULL 
		TRUNCATE TABLE saisie_donnees_fichiers_xml_temp
   	--CREATE TABLE saisie_donnees_fichiers_xml_temp (id_document uniqueidentifier, chemin varchar(255))
END
GO
