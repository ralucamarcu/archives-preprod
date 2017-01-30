SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tamas Andrea
-- Create date: 20.10.2015
-- Description:	<Description,,>
-- =============================================
--test run: [saisie_donnees_correction] 'F08A87A0-73C6-43FD-BCC8-2E1637BBE991' 

CREATE PROCEDURE [dbo].[saisie_donnees_correction]
	@id_projet uniqueidentifier = 'F08A87A0-73C6-43FD-BCC8-2E1637BBE991' 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @current_date datetime = GETDATE(), 
			@id_document uniqueidentifier,
			@id_utilisateur int=12,
			@id_source uniqueidentifier,
			@machine_traitement varchar(255)='Ithaque App',
			@id_tache_log int,
			@id_tache_log_details int,
			@IntegerResult int
	BEGIN TRY
---------------------------------------------------
-- get id_document, id_source
---------------------------------------------------
	SET @id_source = (SELECT id_source FROM Ithaque.dbo.sources_projets WITH (NOLOCK) WHERE id_projet = @id_projet) 
	SET @id_document = (SELECT id_document FROM Ithaque.dbo.AEL_Parametres_nouveau WITH (NOLOCK) WHERE id_projet=@id_projet)

---------------------------------------------------
-- create task -> Ithaque.dbo.TachesLogs
---------------------------------------------------

	EXEC [Ithaque].[dbo].[spInsertionTacheLog] 44, @id_utilisateur, @id_source, NULL, @machine_traitement
	SET @id_tache_log = (SELECT TOP 1 id_tache_log FROM [Ithaque].[dbo].Taches_Logs WITH (NOLOCK)
					WHERE id_source = @id_source AND id_utilisateur = @id_utilisateur
						AND id_tache = 44 
					ORDER BY date_creation DESC)
	EXEC [Ithaque].[dbo].[spInsertionTacheLogDetails] @id_tache_log
	SET @id_tache_log_details = (SELECT TOP 1 id_tache_log_details FROM [Ithaque].[dbo].Taches_Logs_Details WITH (NOLOCK)
					WHERE id_tache_log = @id_tache_log					
					ORDER BY date_debut DESC)

---------------------------------------------------
-- get all treatements from prod for the given projet
---------------------------------------------------

	IF OBJECT_ID('temp_actes_production') IS NOT NULL 
		BEGIN
			DROP TABLE temp_actes_production
		END 

	EXEC [192.168.0.76].archives.dbo.saisie_donnees_actes_document  @id_document 
		
	SELECT id_acte, id_acte_ithaque,id_fichier_xml
	INTO temp_actes_production
	FROM [192.168.0.76].archives.dbo.temp_actes_document

	CREATE INDEX idx_id_acte ON temp_actes_production(id_acte_ithaque)

---------------------------------------------------
-- Check for changes on actes/individus tables
---------------------------------------------------

	IF OBJECT_ID('MAJ_MEP_changes_on_actes_individus') IS NOT NULL 
	BEGIN
			DROP TABLE MAJ_MEP_changes_on_actes_individus
	END 

    SELECT id_acte, id_acte_ithaque, [changes],id_individu
	INTO MAJ_MEP_changes_on_actes_individus
	FROM
		(	--[changes] = 1 if the chenges are on acts and 2 if the changes are on individus
			SELECT tu.id_acte, tu.id_acte_ithaque,1 AS [changes], NULL AS id_individu
			FROM temp_actes_production tu WITH (NOLOCK)
			INNER JOIN [Ithaque].[dbo].[DataXmlRC_actes] a  WITH (NOLOCK) ON tu.id_acte_ithaque=a.id
			WHERE type_acte_Correction IS NOT NULL OR soustype_acte_Correction IS NOT NULL OR date_acte_Correction IS NOT NULL 
				OR annee_acte_Correction IS NOT NULL OR calendrier_date_acte_Correction IS NOT NULL 
				OR lieu_acte_Correction IS NOT NULL OR geonameid_acte_Correction IS NOT NULL 
				OR insee_acte_Correction IS NOT NULL
			UNION
			SELECT tu.id_acte, tu.id_acte_ithaque,2 AS [changes], i.id AS id_individu
			FROM temp_actes_production tu WITH (NOLOCK)
			INNER JOIN [Ithaque].[dbo].[DataXmlRC_actes] a  WITH (NOLOCK) ON tu.id_acte_ithaque=a.id
			INNER JOIN [Ithaque].dbo.DataXmlRC_individus i  WITH (NOLOCK) ON i.id_acte=a.id
			WHERE nom_Correction IS NOT NULL 
				OR prenom_Correction IS NOT NULL OR age_Correction IS NOT NULL
				OR date_naissance_Correction IS NOT NULL OR annee_naissance_Correction IS NOT NULL 
				OR calendrier_date_naissance_Correction IS NOT NULL OR lieu_naissance_Correction IS NOT NULL
				OR insee_naissance_Correction IS NOT NULL OR geonameid_naissance_Correction IS NOT NULL
		) AS actes_with_changed
	
	CREATE INDEX idx_id_acte_ithaque ON MAJ_MEP_changes_on_actes_individus(id_acte_ithaque)
	CREATE INDEX idx_id_acte ON MAJ_MEP_changes_on_actes_individus(id_acte)
	CREATE INDEX idx_modif ON MAJ_MEP_changes_on_actes_individus([changes])

---------------------------------------------------
-- Reecriture process
---------------------------------------------------

	EXEC [Ithaque_Reecriture].[dbo].[spReecritureTacheGeneral_MAJ_MEP] @id_projet

---------------------------------------------------
-- Importation saisie process
---------------------------------------------------

	IF OBJECT_ID('MAJ_MEP_actes') IS NOT NULL 
	BEGIN
		DROP TABLE MAJ_MEP_actes
	END 

	IF OBJECT_ID('MAJ_MEP_individus') IS NOT NULL 
	BEGIN
		DROP TABLE MAJ_MEP_individus
	END 

	IF OBJECT_ID('MAJ_MEP_individus_identites') IS NOT NULL 
	BEGIN
		DROP TABLE MAJ_MEP_individus_identites
	END 

	IF OBJECT_ID('tmp_actes_soustypes_actes') IS NOT NULL 
	BEGIN
		DROP TABLE tmp_actes_soustypes_actes
	END 
	
---------------------------------------------------
-- Update type acte
---------------------------------------------------
	CREATE TABLE tmp_actes_soustypes_actes (id_acte int, type_acte varchar(150), soustype_acte varchar(150),type_acte_Correction varchar(150),soustype_acte_Correction  varchar(150)
		, type_acte_updated varchar(150) )
	INSERT INTO tmp_actes_soustypes_actes
	SELECT dxa.id, dxa.type_acte, dxa.soustype_acte,dxa.type_acte_Correction,dxa.soustype_acte_Correction, null
	FROM MAJ_MEP_changes_on_actes_individus ai (nolock)
	INNER JOIN Ithaque.dbo.DataXmlRC_actes dxa WITH (nolock) on ai.id_acte_ithaque=dxa.id
	INNER JOIN Ithaque.dbo.dataxml_fichiers dxf with (nolock) on dxa.id_fichier = dxf.id_fichier
	INNER JOIN Ithaque.dbo.traitements t with (nolock) on dxf.id_traitement = t.id_traitement
	WHERE (type_acte_Correction IS NOT NULL OR soustype_acte_Correction IS NOT NULL)
		AND (CASE WHEN dxa.type_acte_Correction IS NOT NULL THEN type_acte_Correction ELSE type_acte END) + ' ' 
				+ (CASE WHEN soustype_acte_Correction IS NOT NULL THEN soustype_acte_Correction ELSE soustype_acte END) <> 'naissance naissance'
		AND (CASE WHEN dxa.type_acte_Correction IS NOT NULL THEN type_acte_Correction ELSE type_acte END) + ' ' 
				+ (CASE WHEN soustype_acte_Correction IS NOT NULL THEN soustype_acte_Correction ELSE soustype_acte END) <> 'deces deces'
		AND (CASE WHEN dxa.type_acte_Correction IS NOT NULL THEN type_acte_Correction ELSE type_acte END) + ' ' 
				+ (CASE WHEN soustype_acte_Correction IS NOT NULL THEN soustype_acte_Correction ELSE soustype_acte END) <> 'mariage mariage'
		AND ((CASE WHEN dxa.type_acte_Correction IS NOT NULL THEN type_acte_Correction ELSE type_acte END) = 'naissance' 
				OR (CASE WHEN dxa.type_acte_Correction IS NOT NULL THEN type_acte_Correction ELSE type_acte END) = 'deces' 
				OR (CASE WHEN dxa.type_acte_Correction IS NOT NULL THEN type_acte_Correction ELSE type_acte END) = 'mariage')
	GROUP BY dxa.id, dxa.type_acte, dxa.soustype_acte,dxa.type_acte_Correction,dxa.soustype_acte_Correction
	ORDER BY type_acte

	UPDATE [tmp_actes_soustypes_actes]
	SET type_acte_updated = st.id_type_acte
	FROM [tmp_actes_soustypes_actes] t with (nolock)
	INNER JOIN [192.168.0.76].archives.dbo.saisie_donnees_types_actes ST WITH (NOLOCK) 
	ON (CASE WHEN t.soustype_acte_Correction IS NOT NULL THEN t.soustype_acte_Correction ELSE t.soustype_acte END) COLLATE DATABASE_DEFAULT = st.nom_type_acte_DTD
	where nom_type_acte_DTD <> 'jugement' and nom_type_acte_DTD <> 'transcription' and nom_type_acte_DTD <> 'acte_autre'

	UPDATE [tmp_actes_soustypes_actes]
	SET type_acte_updated = st.id_type_acte
	FROM [tmp_actes_soustypes_actes] t with (nolock) 
	INNER JOIN saisie_donnees_types_actes ST WITH (NOLOCK) 
	ON (CASE WHEN t.soustype_acte_Correction IS NOT NULL THEN t.soustype_acte_Correction ELSE t.soustype_acte END) = st.nom_type_acte_DTD
	where (CASE WHEN t.type_acte_Correction IS NOT NULL THEN t.type_acte_Correction ELSE type_acte END) = 'naissance' 
		and st.nom_type_acte like '%naissance%'
		and (nom_type_acte_DTD = 'jugement' or nom_type_acte_DTD = 'transcription' or nom_type_acte_DTD = 'acte_autre')

	UPDATE [tmp_actes_soustypes_actes]
	SET type_acte_updated = st.id_type_acte
	FROM [tmp_actes_soustypes_actes] t with (nolock)
	INNER JOIN [192.168.0.76].archives.dbo.saisie_donnees_types_actes ST WITH (NOLOCK) 
	ON (CASE WHEN t.soustype_acte_Correction IS NOT NULL THEN t.soustype_acte_Correction ELSE t.soustype_acte END) COLLATE DATABASE_DEFAULT = st.nom_type_acte_DTD
	where (CASE WHEN t.type_acte_Correction IS NOT NULL THEN t.type_acte_Correction ELSE type_acte END) = 'mariage' 
		and st.nom_type_acte like '%mariage%'
		and (nom_type_acte_DTD = 'jugement' or nom_type_acte_DTD = 'transcription' or nom_type_acte_DTD = 'acte_autre')

	UPDATE [tmp_actes_soustypes_actes]
	SET type_acte_updated = st.id_type_acte
	FROM [tmp_actes_soustypes_actes] t with (nolock)
	INNER JOIN [192.168.0.76].archives.dbo.saisie_donnees_types_actes ST WITH (NOLOCK) 
	ON (CASE WHEN t.soustype_acte_Correction IS NOT NULL THEN t.soustype_acte_Correction ELSE t.soustype_acte END) COLLATE DATABASE_DEFAULT = st.nom_type_acte_DTD
	where  (CASE WHEN t.type_acte_Correction IS NOT NULL THEN t.type_acte_Correction ELSE type_acte END) = 'deces' 
		and st.nom_type_acte like '%décès%'
		and (nom_type_acte_DTD = 'jugement' or nom_type_acte_DTD = 'transcription' or nom_type_acte_DTD = 'acte_autre')

---------------------------------------------------
-- acts with correction column filled
---------------------------------------------------

	SELECT	dxrat.date_acte_Correction_Reecriture, dxrat.annee_acte_Correction_Reecriture, @current_date AS date_creation, dxa.id_acte_xml,
			dxrat.id AS id_acte_ithaque,dxa.lieu_acte_Correction, dxa.geonameid_acte_Correction, dxa.insee_acte_Correction, t.id_acte, dxa.date_acte_Correction,dxa.annee_acte_Correction,id_individu,
			sa.type_acte_updated,dxa.type_acte_Correction, dxa.soustype_acte_Correction 
	INTO MAJ_MEP_actes
	FROM MAJ_MEP_changes_on_actes_individus t WITH (nolock) 
	INNER JOIN [Ithaque_Reecriture].[dbo].[DataXmlRC_actes_maj_mep] dxrat WITH (nolock) on t.[id_acte_ithaque]=dxrat.id
	INNER JOIN Ithaque.dbo.DataXmlRC_actes dxa (NOLOCK) ON dxrat.id=dxa.id
	LEFT JOIN [tmp_actes_soustypes_actes] sa ON sa.id_acte=dxa.id
--	WHERE [changes]=1

	CREATE INDEX idx_id_acte_ithaque ON MAJ_MEP_actes (id_acte_ithaque)
	CREATE INDEX idx_id_acte_archives ON MAJ_MEP_actes (id_acte)

---------------------------------------------------
-- individus with correction column filled
---------------------------------------------------
	SELECT   nom,nom_Correction_Reecriture,nom_Correction,prenom
			,prenom_Correction_Reecriture,prenom_Correction, dxrit.id_individu_xml, dxrit.id AS id_individu_ithaque,dxrit.id_acte as id_acte_ithaque, sda.id_acte
	INTO MAJ_MEP_individus
	FROM MAJ_MEP_changes_on_actes_individus sda  WITH (NOLOCK)
	INNER JOIN [Ithaque_Reecriture].[dbo].[DataXmlRC_individus_maj_mep] dxrit WITH (nolock) ON dxrit.id_acte = sda.id_acte_ithaque 
--	WHERE [changes]=2 AND (nom_correction IS NOT NULL OR prenom_correction IS NOT null)

	CREATE INDEX idx_id_acte_archives ON MAJ_MEP_individus (id_acte)
	CREATE INDEX idx_id_individu_ithaque ON MAJ_MEP_individus (id_individu_ithaque)

---------------------------------------------------
-- individus identites
---------------------------------------------------

	SELECT  id_individu, dxriit.id_type_identite, dxriit.ordre, dxriit.nom, dxriit.prenom, @current_date AS date_creation
		, dxriit.id_acte as id_acte_ithaque, dxriit.id_individu as id_individu_ithaque,sdi.id_acte
	INTO MAJ_MEP_individus_identites
	from MAJ_MEP_individus sdi 
	INNER JOIN [Ithaque_Reecriture].[dbo].[DataXmlRC_individus_identites_maj_mep] dxriit WITH (nolock) ON dxriit.id_individu = sdi.id_individu_ithaque AND sdi.id_acte_ithaque=dxriit.id_acte

	CREATE INDEX idx_id_acte_archives ON MAJ_MEP_individus_identites (id_acte)
	CREATE INDEX idx_id_individu_ithaque ON MAJ_MEP_individus_identites (id_individu_ithaque)

---------------------------------------------------
-- update production tables
---------------------------------------------------
	EXEC [192.168.0.76].[archives].[dbo].[saisie_donnees_importation_correction_saisie_MAJ_MEP] @id_document

	SET @IntegerResult=1
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SET @IntegerResult=-1
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
		EXEC Ithaque.dbo.spMAJTacheLogTerminee @id_tache_log, 1, NULL, NULL
		EXEC Ithaque.dbo.spMAJTacheLogDetailsTerminee @id_tache_log_details, 1, NULL
		EXEC saisie_donnees_correction_process_notification @id_projet,@id_document
	END
	ELSE
	BEGIN
		EXEC Ithaque.dbo.spMAJTacheLogTerminee @id_tache_log, 2, NULL, @ErrorMessage
		EXEC Ithaque.dbo.spMAJTacheLogDetailsTerminee @id_tache_log_details, 2, @ErrorMessage
	END
END


GO
