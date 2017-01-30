SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Raluca Marcu
-- Create date: 22.08.2016
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [dbo].[saisie_donnees_maj_images_actes_geonames_MAJ_MEP]
	-- Add the parameters for the stored procedure here
	-- Test Run : [saisie_donnees_maj_images_actes_geonames_MAJ_MEP]  '5154FF77-0BD9-4569-9109-AD0A789CEC89' 
	@id_document UNIQUEIDENTIFIER 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    DECLARE @id_projet UNIQUEIDENTIFIER, @id_tache_log INT, @id_tache_log_details INT, @IntegerResult INT
		, @nom_prestataire VARCHAR(255), @code_departement VARCHAR(50),@id_tache int=16,@id_utilisateur int=12
	
	SET @id_projet = (SELECT id_projet FROM Ithaque.dbo.AEL_Parametres_MAJ_MEP WHERE id_document = @id_document AND principal = 1 )
	SET @nom_prestataire = (SELECT pm.nom FROM Ithaque.dbo.Projets_Maitres pm WITH (NOLOCK)
					INNER JOIN Ithaque.dbo.Projets p WITH (NOLOCK) ON pm.id_projet_maitre = p.id_projet_maitre
					WHERE p.id_projet = @id_projet)
	SET @code_departement = (SELECT id_departement FROM Ithaque.dbo.Projets WHERE id_projet = @id_projet)
	
		
	CREATE TABLE #temp_pages (id_page uniqueidentifier)
	
	INSERT INTO #temp_pages
	SELECT id_page 
	FROM saisie_donnees_pages WITH (NOLOCK) WHERE id_document=@id_document
	CREATE INDEX id_page ON #temp_pages (id_page)

	BEGIN TRY
	BEGIN TRANSACTION actes_geonames;
		
		UPDATE saisie_donnees_actes
		SET id_commune_acte = (CASE WHEN ISNUMERIC(d.geonameid)= 1 THEN CAST(d.geonameid AS INT) ELSE id_commune_acte END) 
		FROM  #temp_pages p 
		INNER JOIN saisie_donnees_actes a WITH (NOLOCK) ON p.id_page=a.id_page
		INNER JOIN dbo.dico_ALLCOM d WITH (NOLOCK) ON a.insee_acte = d.INSEE
		WHERE id_commune_acte IS NULL
		
		UPDATE saisie_donnees_pages
		SET image_origine = '\indexing_' + @nom_prestataire + @code_departement + '\images'+ image_origine
		WHERE id_document=@id_document
			AND image_origine not like '\indexing_%'

		DROP TABLE #temp_pages
	
	COMMIT TRANSACTION actes_geonames;

	SET @IntegerResult = 1 
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		ROLLBACK TRANSACTION actes_geonames;
		
		SET @IntegerResult = -1
		
		SELECT @ErrorMessage = ERROR_MESSAGE(),
			   @ErrorSeverity = ERROR_SEVERITY(),
			   @ErrorState = ERROR_STATE();

		RAISERROR (@ErrorMessage,
				   @ErrorSeverity, 
				   @ErrorState 
				   );
	END CATCH;
	

END
GO
