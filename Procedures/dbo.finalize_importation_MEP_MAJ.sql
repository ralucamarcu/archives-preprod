SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[finalize_importation_MEP_MAJ]
--Test Run : [finalize_importation_MEP_MAJ] '5154FF77-0BD9-4569-9109-AD0A789CEC89', 12858
@id_document UNIQUEIDENTIFIER
--@id_association INT=null
AS 
BEGIN 

--test
  
	DECLARE @IntegerResult INT, @id_tache_log INT, @id_tache_log_details INT, @id_projet UNIQUEIDENTIFIER,
	 @id_source UNIQUEIDENTIFIER, @id_tache INT = 14, @id_utilisateur int=12
	
	
	SET @id_projet = (SELECT id_projet FROM Ithaque.dbo.AEL_Parametres_MAJ_MEP WHERE id_document = @id_document )
	
	EXEC [Ithaque].[dbo].[spInsertionTacheLog] @id_tache, @id_utilisateur, NULL, @id_projet, NULL

	SET @id_tache_log = (SELECT TOP 1 id_tache_log FROM Ithaque.dbo.Taches_Logs WITH (NOLOCK)
					WHERE id_projet = @id_projet AND id_tache = 14					
					ORDER BY date_creation DESC)
	
	EXEC [Ithaque].[dbo].[spInsertionTacheLogDetails] @id_tache_log
	SET @id_tache_log_details = (SELECT TOP 1 id_tache_log_details FROM Ithaque.dbo.Taches_Logs_Details WITH (NOLOCK)
					WHERE id_tache_log = @id_tache_log					
					ORDER BY date_debut DESC)

	--SET @id_tache_log_details = (SELECT TOP 1 id_tache_log_details FROM [10.1.0.213].Ithaque.dbo.Taches_Logs_Details WITH (NOLOCK)
	--				WHERE id_tache_log = @id_tache_log					
	--				ORDER BY date_debut DESC)

	CREATE TABLE #tmp (id_page UNIQUEIDENTIFIER, row_num INT)
	CREATE TABLE #temp_pages(id_page UNIQUEIDENTIFIER,id_document UNIQUEIDENTIFIER,id_fichier_xml int,ordre int)
	INSERT INTO #tmp
	SELECT id_page, ROW_NUMBER() OVER(ORDER BY image_viewer ASC) AS row_num
	FROM saisie_donnees_pages  WITH (NOLOCK) 
	WHERE id_document = @id_document

	INSERT INTO #temp_pages
	SELECT id_page,id_document,id_fichier_xml,ordre	
	FROM saisie_donnees_pages  WITH (NOLOCK)
	WHERE id_document=@id_document

	CREATE INDEX id_page ON #temp_pages (id_page)
	CREATE INDEX id_page_document ON #temp_pages (id_document)

	SELECT sda.*
	INTO #temp_actes_pages
	FROM #temp_pages tp 
	INNER JOIN dbo.saisie_donnees_actes sda ON tp.id_page=sda.id_page

	CREATE INDEX id_page_type_acte ON #temp_actes_pages (type_acte)

	BEGIN TRY
	BEGIN TRANSACTION [finalize_importation];

		-- mise à jour du nombre d'unités par acte
		INSERT INTO [saisie_donnees_bareme_unites]([id_document],[type_acte])
		SELECT @id_document AS id_document, type_acte
		FROM #temp_actes_pages
		WHERE type_acte NOT IN (SELECT type_acte FROM saisie_donnees_bareme_unites WITH (NOLOCK)
								WHERE id_document = @id_document)
		GROUP BY type_acte
		
		UPDATE [saisie_donnees_bareme_unites]
		SET nb_unites = SG.nb_unites
		FROM [saisie_donnees_bareme_unites] su WITH (NOLOCK)
		INNER JOIN saisie_donnees_bareme_global SG WITH (NOLOCK) ON su.type_acte = SG.type_acte 
		WHERE su.id_document = @id_document AND ISNULL(su.nb_unites,0) = 0
		
		UPDATE saisie_donnees_actes
		SET nb_unites = b.nb_unites
		FROM #temp_pages a 
		INNER JOIN saisie_donnees_actes da WITH (NOLOCK) ON a.id_page = da.id_page 
		INNER JOIN [saisie_donnees_bareme_unites] b WITH (NOLOCK) ON da.type_acte = b.type_acte 
		WHERE a.id_document = @id_document
			  AND  ISNULL(da.nb_unites,0)=0 
			--  AND ISNULL(da.id_association,0) = 0			
		
			
		-- mise à jour de l'ordre des pages
		UPDATE dbo.saisie_donnees_pages 
		SET ordre = ROW_NUM
		FROM saisie_donnees_pages sdi WITH (NOLOCK)
		INNER JOIN #tmp t ON sdi.id_page = t.id_page
		WHERE id_document = @id_document
		
		-- mise à jour de l'ordre des pages dans un xml pour la pagination
		SELECT id_page, ROW_NUMBER () OVER (PARTITION BY  id_fichier_xml ORDER BY ordre) AS ordre
		INTO #ordrefichierxml
		FROM  #temp_pages WITH (NOLOCK)
		WHERE id_fichier_xml IS NOT NULL
		
		UPDATE saisie_donnees_pages
		SET ordre_fichier_xml = #ordrefichierxml.ordre
		FROM  saisie_donnees_pages WITH (NOLOCK)
		INNER JOIN #ordrefichierxml ON saisie_donnees_pages.id_page = #ordrefichierxml.id_page	
		WHERE id_document = @id_document 	

		UPDATE saisie_donnees_pages
		SET image_miniature = '/'+LOWER(CAST(p.id_document AS VARCHAR(50))+'/'+LEFT(CAST(p.id_page AS VARCHAR(50)),2)+'/'+SUBSTRING(CAST(p.id_page AS VARCHAR(50)),3,2)+'/'+CAST(p.id_page AS VARCHAR(50))+'.jpg')
		FROM saisie_donnees_pages p WITH (NOLOCK) 
		WHERE p.id_document=@id_document
		AND ISNULL(image_miniature,'')=''

		--mise à jour des années pour les dates révolutionnaire
		UPDATE saisie_donnees_actes
		SET annee_acte = SUBSTRING(date_acte,LEN(date_acte)-CHARINDEX('/',REVERSE(date_acte),0)+2,LEN(date_acte)-CHARINDEX('/',REVERSE(date_acte),0)+1)
		FROM #temp_pages p 
		INNER JOIN saisie_donnees_actes a WITH (NOLOCK) ON p.id_page = a.id_page 
		WHERE LEN(date_acte)-CHARINDEX('/',REVERSE(date_acte),0)-1=4
		AND annee_acte IS NULL
		AND ISNUMERIC(SUBSTRING(date_acte,LEN(date_acte)-CHARINDEX('/',REVERSE(date_acte),0)+2,LEN(date_acte)-CHARINDEX('/',REVERSE(date_acte),0)+1))=1
		AND p.id_document =@id_document
		
		--UPDATE saisie_donnees_actes
		--SET id_statut_publication = 1
		--FROM #temp_pages sdp 
		--INNER JOIN saisie_donnees_actes sda  WITH (NOLOCK) ON sda.id_page = sdp.id_page
		--WHERE ISNULL(id_statut_publication,0)=0
		--AND ISNUMERIC(sda.annee_acte) = 1 AND 
		--((sda.type_acte IN ( 0, 24, 134, 139) AND (CAST(sda.annee_acte AS INT) >= 1792 AND CAST(sda.annee_acte AS INT) <= 1893) )
		--OR (sda.type_acte IN ( 2,105,136,138,141) AND (CAST(sda.annee_acte AS INT) >= 1792 AND CAST(sda.annee_acte AS INT) <= 1938) )
		--OR (sda.type_acte IN ( 1,3,4,5,6,7,8,10,13,17,21,135,137,140)
		--	 AND (CAST(sda.annee_acte AS INT) >= 1792 AND CAST(sda.annee_acte AS INT) <=1909)))

		CREATE TABLE #temp_interval_year_ok (id_acte uniqueidentifier)
		INSERT INTO #temp_interval_year_ok 	(id_acte)
		SELECT sda.id_acte 
		FROM #temp_pages sdp
		INNER JOIN saisie_donnees_actes sda  WITH (NOLOCK) ON sda.id_page = sdp.id_page
		WHERE   ISNUMERIC(sda.annee_acte) = 1 AND ISNULL(id_statut_publication,0)=0
			AND sda.type_acte IN ( 0, 24, 134, 139) 
			AND CAST(sda.annee_acte AS INT) >= 1792 
			AND CAST(sda.annee_acte AS INT) <= 1893

		CREATE INDEX idx_id_acte ON #temp_interval_year_ok (id_acte)

		INSERT INTO #temp_interval_year_ok	(id_acte)
		SELECT id_acte 
		FROM #temp_pages sdp
		INNER JOIN saisie_donnees_actes sda  WITH (NOLOCK) ON sda.id_page = sdp.id_page
		WHERE ISNUMERIC(sda.annee_acte) = 1  AND ISNULL(id_statut_publication,0)=0
			AND sda.type_acte IN ( 2,105,136,138,141) 
			AND CAST(sda.annee_acte AS INT) >= 1792 
			AND CAST(sda.annee_acte AS INT) <= 1938

		INSERT INTO #temp_interval_year_ok	(id_acte)
		SELECT id_acte 
		FROM #temp_pages sdp
		INNER JOIN saisie_donnees_actes sda  WITH (NOLOCK) ON sda.id_page = sdp.id_page
		WHERE ISNUMERIC(sda.annee_acte) = 1 AND ISNULL(id_statut_publication,0)=0
			AND sda.type_acte IN ( 1,3,4,5,6,7,8,10,13,17,21,135,137,140)
			AND CAST(sda.annee_acte AS INT) >= 1792 
			AND CAST(sda.annee_acte AS INT) <= 1909
	
		UPDATE saisie_donnees_actes
		SET id_statut_publication = 1
		FROM #temp_interval_year_ok sdp 
		INNER JOIN saisie_donnees_actes sda  WITH (NOLOCK) ON sda.id_acte = sdp.id_acte

		
		UPDATE saisie_donnees_actes
		SET id_statut_publication = 2	
		FROM #temp_pages sdp 
		INNER JOIN saisie_donnees_actes sda  WITH (NOLOCK) ON sda.id_page = sdp.id_page
		WHERE id_document = @id_document AND isnull(sda.id_statut_publication,0) <> 1
		AND ISNULL(id_statut_publication,0)=0
			AND ((ISNUMERIC(sda.annee_acte) <> 1
					OR ISNULL(sda.annee_acte,0) = 0
					OR type_acte NOT IN (0,24,134,139,2,105,136,138,141,1,3,4,5,6,7,8,10,13,17,21,135,137,140)
					OR CAST(sda.annee_acte AS INT) < 1792
					OR CAST(sda.annee_acte AS INT) > 1938
				)
			OR ( (ISNUMERIC(sda.annee_acte) = 1
					OR ISNULL(sda.annee_acte,0) = 0
					OR CAST(sda.annee_acte AS INT) < 1792
					OR CAST(sda.annee_acte AS INT) > 1938)))


	DROP TABLE #temp_pages
	DROP TABLE #tmp


	COMMIT TRANSACTION [finalize_importation];
	
	SET @IntegerResult = 1 
	
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		ROLLBACK TRANSACTION [finalize_importation];
		
		SET @IntegerResult = -1
		
		SELECT @ErrorMessage = ERROR_MESSAGE(),
			   @ErrorSeverity = ERROR_SEVERITY(),
			   @ErrorState = ERROR_STATE();

		RAISERROR (@ErrorMessage,
				   @ErrorSeverity, 
				   @ErrorState 
				   );
	END CATCH;
	
	--si l'insertion d'images a terminé avec succès / erreur (IntegerResult = 1/-1), mettre à jour le log de tâche	
	IF (@IntegerResult = 1)
	BEGIN
		EXEC Ithaque.dbo.spMAJTacheLogTerminee @id_tache_log, 1, NULL, NULL
		EXEC Ithaque.dbo.spMAJTacheLogDetailsTerminee @id_tache_log_details, 1, NULL
	END
	ELSE
	BEGIN
		EXEC Ithaque.dbo.spMAJTacheLogTerminee @id_tache_log, 2, NULL, @ErrorMessage
		EXEC Ithaque.dbo.spMAJTacheLogDetailsTerminee @id_tache_log_details, 2, @ErrorMessage
	END
END
GO
