SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tamas Andrea
-- Create date: <22-08-2016>
-- Description:	<Description,,>
-- =============================================

-- test run: saisie_donnees_MAJ_MEP_process 'F08A87A0-73C6-43FD-BCC8-2E1637BBE991'

CREATE PROCEDURE [dbo].[saisie_donnees_MAJ_MEP_process]
	@id_projet uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @id_project_traitement uniqueidentifier,
			@id_traitement_maj int,
			@id_traitement_prod int,
			@id_document uniqueidentifier,
			@IntegerResult int,
			@id_utilisateur int=12,
			@machine_traitement varchar(255)='Ithaque App'
	
	DECLARE @current_date datetime = getdate(),
			@titre_document VARCHAR(255), 
			@id_association int,
			@id_image UNIQUEIDENTIFIER, 
			@id_tache_log INT, 
			@id_tache_log_details INT, 
			@id_source UNIQUEIDENTIFIER, 
			@chemin_dossier_v4 VARCHAR(255),
			@chemin_dossier_v5 VARCHAR(255),
			@chemin_xml VARCHAR(255),
			@chemin_dossier_v6 VARCHAR(255),
			@chemin_dossier_general VARCHAR(255)
	
	BEGIN

	BEGIN TRY
---------------------------------------------------
-- info from sources table
---------------------------------------------------

		SET @id_source = (SELECT id_source FROM Ithaque.dbo.sources_projets WITH (NOLOCK) WHERE id_projet = @id_projet) 

		SELECT @titre_document = s.nom_format_dossier, @chemin_dossier_v4 = s.chemin_dossier_general + 'V4\images', @chemin_dossier_v5 = s.chemin_dossier_general + 'V5\images',
			   @chemin_xml = s.chemin_dossier_general + 'V5\output\publication', @chemin_dossier_v6 = s.chemin_dossier_general + 'V5\images', @chemin_dossier_general = s.chemin_dossier_general
		FROM Ithaque.dbo.Sources s WITH (NOLOCK)
		WHERE s.id_source = @id_source

---------------------------------------------------
-- get id_document
---------------------------------------------------

	SET @id_document = (SELECT id_document FROM Ithaque.dbo.AEL_Parametres_nouveau WITH (NOLOCK) WHERE id_projet=@id_projet)

---------------------------------------------------
-- create task -> Ithaque.dbo.TachesLogs
---------------------------------------------------

		EXEC [Ithaque].[dbo].[spInsertionTacheLog] 42, @id_utilisateur, @id_source, NULL, @machine_traitement
		SET @id_tache_log = (SELECT TOP 1 id_tache_log FROM [Ithaque].[dbo].Taches_Logs WITH (NOLOCK)
					WHERE id_source = @id_source AND id_utilisateur = @id_utilisateur
						AND id_tache = 42 
					ORDER BY date_creation DESC)
		EXEC [Ithaque].[dbo].[spInsertionTacheLogDetails] @id_tache_log
		SET @id_tache_log_details = (SELECT TOP 1 id_tache_log_details FROM [Ithaque].[dbo].Taches_Logs_Details WITH (NOLOCK)
					WHERE id_tache_log = @id_tache_log					
					ORDER BY date_debut DESC)

		INSERT INTO MAJ_MEP_traitements (id_projet, id_document, id_tache_log,id_tache_log_details)
		SELECT @id_projet, @id_document, @id_tache_log,@id_tache_log_details

---------------------------------------------------
-- get all treatements from prod for the given projet
---------------------------------------------------
		
		IF OBJECT_ID('temp_actes_prod') IS NOT NULL 
		BEGIN
			DROP TABLE temp_actes_prod
		END 

		SELECT  sda.id_acte, sda.id_acte_ithaque,sda.id_fichier_xml,sdfx.id_fichier_ithaque,f.nom_fichier,t.id_traitement
		INTO temp_actes_prod
		FROM [192.168.0.76].archives.dbo.saisie_donnees_actes sda (nolock) 
		INNER JOIN [192.168.0.76].archives.dbo.saisie_donnees_pages sdp (nolock) ON sda.id_page=sdp.id_page
		INNER JOIN[192.168.0.76].archives.dbo.[saisie_donnees_fichiers_XML] sdfx (nolock) ON  sdfx.id_fichier_xml=sda.id_fichier_xml
		INNER JOIN Ithaque.[dbo].[DataXml_fichiers] f (nolock) ON id_fichier=sdfx.id_fichier_ithaque
		INNER JOIN ithaque.[dbo].[Traitements] t (nolock) ON f.id_traitement=t.id_traitement
		WHERE sdp.id_document= @id_document --'5154FF77-0BD9-4569-9109-AD0A789CEC89'

		CREATE INDEX idx_id_acte_ithaque ON temp_actes_prod(id_acte_ithaque)
		CREATE INDEX idx_id_fichier_ithaque ON temp_actes_prod(id_fichier_ithaque)
		CREATE INDEX dx_nom_fichier ON temp_actes_prod(nom_fichier)

---------------------------------------------------
-- get rejected files and acts
---------------------------------------------------

		IF OBJECT_ID('MAJ_MEP_acte_xml_traitements_RejetEchantillon') IS NOT NULL 
		BEGIN
				DROP TABLE MAJ_MEP_acte_xml_traitements_RejetEchantillon
		END 

		SELECT DISTINCT dxa.id AS id_acte,id_acte AS id_acte_archives,dxa.id_acte_xml, dxa.type_acte, dxa.annee_acte, af.nom_fichier,dxf.id_fichier
		INTO MAJ_MEP_acte_xml_traitements_RejetEchantillon
		FROM temp_actes_prod af 
		INNER JOIN Ithaque.dbo.DataXmlRC_actes dxa WITH (NOLOCK) ON af.id_acte_ithaque=dxa.id AND af.id_fichier_ithaque=dxa.id_fichier
		INNER JOIN Ithaque.dbo.DataXml_fichiers dxf WITH (NOLOCK) ON dxa.id_fichier = dxf.id_fichier
		INNER JOIN Ithaque.dbo.DataXmlEchantillonEntete dxee WITH (NOLOCK) ON dxf.id_lot = dxee.id_lot
		INNER JOIN Ithaque.dbo.DataXml_lots_fichiers dxlf WITH (NOLOCK) ON dxf.id_lot = dxlf.id_lot
		INNER JOIN Ithaque.dbo.Traitements t WITH (NOLOCK) ON dxf.id_traitement = t.id_traitement
		WHERE t.id_projet =@id_projet  AND dxee.id_statut = 2 --'F08A87A0-73C6-43FD-BCC8-2E1637BBE991'
		
		CREATE INDEX idx_id_acte ON MAJ_MEP_acte_xml_traitements_RejetEchantillon (id_acte)
		CREATE INDEX idx_id_acte_xml ON MAJ_MEP_acte_xml_traitements_RejetEchantillon (id_acte_xml)
		CREATE INDEX idx_nom_fichier ON MAJ_MEP_acte_xml_traitements_RejetEchantillon (nom_fichier)

---------------------------------------------------
-- get accepted files and acts
---------------------------------------------------
	
		IF OBJECT_ID('MAJ_MEP_acte_xml_traitements_AcceptedEchantillon') IS NOT NULL 
		BEGIN
				DROP TABLE MAJ_MEP_acte_xml_traitements_AcceptedEchantillon
		END 

		SELECT DISTINCT af.nom_fichier,f.id_fichier,t.id_traitement
		INTO MAJ_MEP_acte_xml_traitements_AcceptedEchantillon
		FROM MAJ_MEP_acte_xml_traitements_RejetEchantillon af 
		INNER JOIN Ithaque.dbo.DataXml_fichiers f  WITH (NOLOCK) ON af.nom_fichier=f.nom_fichier
		INNER JOIN Ithaque.dbo.DataXmlEchantillonEntete e  WITH (NOLOCK) ON f.id_lot=e.id_lot
		INNER JOIN Ithaque.dbo.DataXml_lots_fichiers lf  WITH (NOLOCK) ON e.id_lot=e.id_lot
		INNER JOIN Ithaque.dbo.Traitements t  WITH (NOLOCK) ON t.id_traitement = f.id_traitement
		WHERE t.id_projet = @id_projet AND e.id_statut IN (1,3) --'F08A87A0-73C6-43FD-BCC8-2E1637BBE991'
		
		CREATE INDEX idx_id_fichier ON MAJ_MEP_acte_xml_traitements_AcceptedEchantillon (id_fichier)
		CREATE INDEX idx_nom_fichier ON MAJ_MEP_acte_xml_traitements_AcceptedEchantillon (nom_fichier)

	BEGIN TRANSACTION MAJ_MEP_process  

---------------------------------------------------
-- Check if new valid files exists
---------------------------------------------------

	IF EXISTS (SELECT * FROM MAJ_MEP_acte_xml_traitements_AcceptedEchantillon)
	BEGIN
---------------------------------------------------
-- insert MAJ_MEP line in [AEL_Parametres_MAJ_MEP] 
-- for the given project 
---------------------------------------------------
		EXEC Ithaque.dbo.[AEL_Insertion_Parametres_MAJ_MEP] @titre_document = @titre_document,@description = NULL, @miniature_document = NULL, @sous_titre = NULL,@image_principale = NULL
					,@image_secondaire = NULL, @publie = 0, @date_publication = @current_date,@id_projet  = @id_projet
					,@chemin_dossier_v4 = @chemin_dossier_v4,@chemin_dossier_v5 = @chemin_dossier_v5,@chemin_xml  = @chemin_xml
					,@id_association  = @id_association,@date_creation_projet = null,@chemin_dossier_v6  = @chemin_dossier_v6
					,@chemin_dossier_general  = @chemin_dossier_general,@id_livraisons = null,@id_document=@id_document

		UPDATE Ithaque.[dbo].[AEL_Parametres_MAJ_MEP]
		SET id_tache_log=@id_tache_log
		WHERE id_projet=@id_projet AND id_document=@id_document
		
---------------------------------------------------
-- Import pages and images for given document
-- from SQLSEARCH1 to Itahque
---------------------------------------------------
			IF NOT EXISTS (SELECT * FROM dbo.saisie_donnees_documents sdd (nolock) WHERE sdd.id_document=@id_document)
			BEGIN
				INSERT INTO saisie_donnees_documents
				(
					[id_document],[titre],[description],[miniature_document],[nb_page],[chemin_images_viewer],[chemin_miniatures],[nom_vue],[copyright],[sous_titre],[image_principale]
					,[image_secondaire],[publie],[date_mise_a_jour],[date_publication],[image_exemple],[annee_min],[annee_max],[legende],[gratuit],[template_name],[image_haut_banniere]
					,[colonne_droite],[titre_recherche],[department_code],[department_logo_chemin],[latitude],[longitude],[zoom],[fields],[nb_actes]
				)
				SELECT	[id_document],[titre],[description],[miniature_document],[nb_page],[chemin_images_viewer],[chemin_miniatures],[nom_vue],[copyright],[sous_titre],[image_principale]
						,[image_secondaire],[publie],[date_mise_a_jour],[date_publication],[image_exemple],[annee_min],[annee_max],[legende],[gratuit],[template_name],[image_haut_banniere]
						,[colonne_droite],[titre_recherche],[department_code],[department_logo_chemin],[latitude],[longitude],[zoom],[fields],[nb_actes]
				FROM [192.168.0.76].archives.dbo.saisie_donnees_documents d (NOLOCK) WHERE id_document=@id_document
			END
			IF NOT EXISTS (SELECT id_page FROM dbo.saisie_donnees_pages sdp WITH (NOLOCK) WHERE id_document=@id_document)
			BEGIN
				INSERT INTO dbo.saisie_donnees_pages
				(
					id_page,[description],image_viewer,image_miniature,image_origine,id_document,ordre,fenetre_navigation,id_lot,visible,date_creation,affichage_image,
					ordre_fichier_xml,id_fichier_xml,id_statut,cote,id_fichier_xml_test,date_modification
				)
				SELECT  id_page,[description],image_viewer,image_miniature,image_origine,id_document,ordre,fenetre_navigation,id_lot,visible,date_creation,affichage_image,
					ordre_fichier_xml,id_fichier_xml,id_statut,cote,id_fichier_xml_test,date_modification
				FROM [192.168.0.76].archives.dbo.saisie_donnees_pages WITH (NOLOCK)
				WHERE id_document=@id_document
			END

			IF NOT EXISTS (SELECT id_page FROM dbo.Saisie_donnees_images  WITH (NOLOCK) WHERE id_document=@id_document)
			BEGIN
				SET IDENTITY_INSERT Saisie_donnees_images ON 
				INSERT INTO dbo.Saisie_donnees_images
				(
					id_image,[path],zones_a_traiter,zones_traitees,jp2_a_traiter,jp2_traitee,id_page,id_document,[status],date_status
				)
				SELECT id_image,[path],zones_a_traiter,zones_traitees,jp2_a_traiter,jp2_traitee,id_page,id_document,[status],date_status
				FROM [192.168.0.76].archives.dbo.Saisie_donnees_images WITH (NOLOCK) WHERE id_document=@id_document 
				SET IDENTITY_INSERT Saisie_donnees_images OFF 
			END
	END
	--DROP TABLE temp_actes_prod
		
	COMMIT TRANSACTION MAJ_MEP_process;
	
	SET @IntegerResult = 1 
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		ROLLBACK TRANSACTION MAJ_MEP_process;
		
		SET @IntegerResult = -1
		
		SELECT @ErrorMessage = ERROR_MESSAGE(),
			   @ErrorSeverity = ERROR_SEVERITY(),
			   @ErrorState = ERROR_STATE();

		RAISERROR (@ErrorMessage,
				   @ErrorSeverity, 
				   @ErrorState 
				   );
	END CATCH;	

	IF (@IntegerResult = 1)
	BEGIN
	PRINT 1
		EXEC msdb.dbo.sp_start_job 'MAJ MEP Importation Saisie'
	END
	ELSE
	BEGIN
		
		EXEC [Ithaque].[dbo].spMAJTacheLogTerminee @id_tache_log, 2, NULL, @ErrorMessage
		EXEC [Ithaque].[dbo].spMAJTacheLogDetailsTerminee @id_tache_log_details, 2, @ErrorMessage
	END

		
	END
    

END
GO
