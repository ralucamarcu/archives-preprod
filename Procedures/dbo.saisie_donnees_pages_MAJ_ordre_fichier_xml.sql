SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE saisie_donnees_pages_MAJ_ordre_fichier_xml 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    declare @id_document uniqueidentifier 
    set @id_document = (select top 1 id_document from Ithaque.dbo.ael_parametres_nouveau where principal = 1)
	CREATE TABLE #temp_pages(id_page UNIQUEIDENTIFIER,id_document UNIQUEIDENTIFIER,id_fichier_xml int,ordre int)
	INSERT INTO #temp_pages
	SELECT id_page,id_document,id_fichier_xml,ordre	
	FROM saisie_donnees_pages  WITH (NOLOCK)
	WHERE id_document=@id_document

 	SELECT id_page, ROW_NUMBER () OVER (PARTITION BY  id_fichier_xml ORDER BY ordre) AS ordre
	INTO #ordrefichierxml
	FROM  #temp_pages WITH (NOLOCK)
	WHERE id_fichier_xml IS NOT NULL
		
	UPDATE saisie_donnees_pages
	SET ordre_fichier_xml = #ordrefichierxml.ordre
	FROM  saisie_donnees_pages WITH (NOLOCK)
	INNER JOIN #ordrefichierxml ON saisie_donnees_pages.id_page = #ordrefichierxml.id_page	
	WHERE id_document = @id_document
		
	drop table #temp_pages
	drop table #ordrefichierxml
END
GO
