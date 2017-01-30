SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Tamas Andrea>
-- Create date: <25-08-2016>
-- Description:	<Insert data from Archives 213 on Archives_preprod SQLSEARCH1 -> then Archives>
-- =============================================
--test run: [AEL_Create_Ithaque_archives_BCP_files_MAJ_MEP] '5154FF77-0BD9-4569-9109-AD0A789CEC89'
CREATE PROCEDURE [dbo].[AEL_Create_Ithaque_archives_BCP_files_MAJ_MEP] 
	-- Add the parameters for the stored procedure here
	@id_document uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @command varchar(1000)

	CREATE TABLE #tmp_creat_fich (command varchar(800))
	CREATE TABLE #valid_fichiers (subdirectory varchar(255), deprth int, [file] int)
	
	insert INTO #valid_fichiers
	EXEC xp_dirtree '\\10.1.0.196\bigvol\Jobs\MEP\MAJ_MEP_transfer_files\', 1,1

	if exists(SELECT * FROM #valid_fichiers t )
	begin
		EXEC xp_cmdshell 'DEL \\10.1.0.196\bigvol\Jobs\MEP\MAJ_MEP_transfer_files\*.dat'
	END		

	TRUNCATE TABLE [archives].[dbo].[saisie_donnees_zones_actes_MAJ_transfer]
	TRUNCATE TABLE [archives].[dbo].[saisie_donnees_individus_zones_MAJ_transfer]
	TRUNCATE TABLE [archives].[dbo].[saisie_donnees_individus_identites_MAJ_transfer]
	TRUNCATE TABLE [archives].[dbo].[saisie_donnees_individus_MAJ_transfer]
	TRUNCATE TABLE [archives].[dbo].[saisie_donnees_actes_MAJ_transfer]
	TRUNCATE TABLE [archives].[dbo].[saisie_donnees_pages_MAJ_transfer]
	TRUNCATE TABLE [archives].[dbo].[saisie_donnees_images_MAJ_transfer]
	TRUNCATE TABLE [archives].[dbo].[saisie_donnees_fichiers_XML_MAJ_transfer]
	TRUNCATE TABLE [archives].[dbo].[saisie_donnees_documents_MAJ_transfer]
	TRUNCATE TABLE [archives].[dbo].[saisie_donnees_bareme_unites_MAJ_transfer]
	

	INSERT INTO [saisie_donnees_documents_MAJ_transfer]([id_document],[titre],[description],[miniature_document]
			  ,[nb_page],[chemin_images_viewer],[chemin_miniatures],[nom_vue],[copyright],[sous_titre],[image_principale]
			  ,[image_secondaire],[publie],[date_mise_a_jour],[date_publication],[image_exemple],[annee_min],[annee_max]
			  ,[legende],[gratuit],[template_name],[image_haut_banniere],[colonne_droite],[titre_recherche],[department_code]
			  ,[department_logo_chemin],[latitude],[longitude],[zoom],[fields],[nb_actes])
	SELECT [id_document],[titre],[description],[miniature_document],[nb_page],[chemin_images_viewer],[chemin_miniatures],[nom_vue],[copyright],[sous_titre],[image_principale]
		  ,[image_secondaire],[publie],[date_mise_a_jour],[date_publication],[image_exemple],[annee_min],[annee_max],[legende],[gratuit],[template_name],[image_haut_banniere]
		  ,[colonne_droite],[titre_recherche],[department_code],[department_logo_chemin],[latitude],[longitude],[zoom],[fields],[nb_actes]
	FROM archives.dbo.saisie_donnees_documents (NOLOCK) WHERE id_document= @id_document

	set identity_insert [saisie_donnees_bareme_unites_MAJ_transfer] on
	INSERT INTO [saisie_donnees_bareme_unites_MAJ_transfer](id_bareme_unites, [id_document],[type_acte],[nb_unites])
    SELECT id_bareme_unites, [id_document],[type_acte],[nb_unites]
    FROM archives.dbo.[saisie_donnees_bareme_unites] WHERE id_document = @id_document
	set identity_insert [saisie_donnees_bareme_unites_MAJ_transfer] OFF
	
	INSERT INTO Saisie_donnees_images_MAJ_transfer ([path],[zones_a_traiter],[zones_traitees],[jp2_a_traiter],[jp2_traitee],[id_page],[id_document],[status],[date_status])
    SELECT [path],[zones_a_traiter],[zones_traitees],[jp2_a_traiter],[jp2_traitee],[id_page],[id_document],[status],[date_status]
	FROM archives.dbo.saisie_donnees_images (NOLOCK) WHERE id_document = @id_document

	INSERT INTO [saisie_donnees_pages_MAJ_transfer]([id_page],[description],[image_viewer],[image_miniature],[image_origine],[id_document],[ordre],[fenetre_navigation],[id_lot],[visible]
			   ,[date_creation],[affichage_image],[ordre_fichier_xml],[id_fichier_xml],[id_statut],[cote],[id_fichier_xml_test],[date_modification])
	SELECT [id_page],[description],[image_viewer],[image_miniature],[image_origine],[id_document],[ordre],[fenetre_navigation],[id_lot],[visible],[date_creation]
		  ,[affichage_image],[ordre_fichier_xml],[id_fichier_xml],[id_statut],[cote],[id_fichier_xml_test],[date_modification]
	FROM  archives.dbo.saisie_donnees_pages (NOLOCK) WHERE id_document = @id_document

	INSERT INTO [saisie_donnees_actes_MAJ_transfer] ([id_acte],[type_acte],[date_acte],[annee_acte],[lieu_acte],[insee_acte],[id_commune_acte],[id_individu_sujet],[id_individu_conjoint]
			   ,[id_individu_sujet_pere],[id_individu_sujet_mere],[id_individu_conjoint_pere],[id_individu_conjoint_mere],[info],[id_page],[zone_top],[zone_left],[zone_bottom]
			   ,[zone_right],[date_creation],[id_acte_xml],[detail_acte],[nb_unites],[date_acte_originale],[id_fichier_xml],[id_association],[id_statut_publication],[id_acte_ithaque])
	SELECT [id_acte],[type_acte],[date_acte],[annee_acte],[lieu_acte],[insee_acte],[id_commune_acte],[id_individu_sujet],[id_individu_conjoint],[id_individu_sujet_pere]
		  ,[id_individu_sujet_mere],[id_individu_conjoint_pere],[id_individu_conjoint_mere],[info],sda.[id_page],[zone_top],[zone_left],[zone_bottom],[zone_right],sda.[date_creation]
		  ,[id_acte_xml],[detail_acte],[nb_unites],[date_acte_originale],sda.[id_fichier_xml],[id_association],[id_statut_publication],[id_acte_ithaque]
	FROM archives.dbo.saisie_donnees_actes sda with (nolock) 
	INNER JOIN  saisie_donnees_pages_MAJ_transfer sdp on sda.id_page = sdp.id_page WHERE id_document = @id_document

	set identity_insert [saisie_donnees_fichiers_XML_MAJ_transfer] on
	INSERT INTO [saisie_donnees_fichiers_XML_MAJ_transfer]([id_fichier_xml],[chemin],[id_document],[statut],[date_statut],[date_creation],[id_fichier_ithaque])
	SELECT f.[id_fichier_xml],[chemin],[id_document],[statut],[date_statut],f.[date_creation],[id_fichier_ithaque]
	FROM [saisie_donnees_actes_MAJ_transfer] a (nolock) 
	INNER JOIN archives.dbo.saisie_donnees_fichiers_XML f(NOLOCK) ON a.id_fichier_xml=f.id_fichier_xml
	WHERE id_document = @id_document
	GROUP BY f.[id_fichier_xml],[chemin],[id_document],[statut],[date_statut],f.[date_creation],[id_fichier_ithaque]
	set identity_insert [saisie_donnees_fichiers_XML_MAJ_transfer] OFF

	INSERT INTO [saisie_donnees_individus_MAJ_transfer]([id_individu],[id_acte],[id_role_acte],[id_sexe],[nom_prefix],[nom],[nom_suffix],[prenom],[date_naissance],[annee_naissance],[lieu_naissance]
			   ,[lieu_insee_naissance],[id_commune_naissance],[date_mariage],[annee_mariage],[lieu_mariage],[lieu_insee_mariage],[id_commune_mariage],[date_deces],[annee_deces]
			   ,[lieu_deces],[lieu_insee_deces],[id_commune_deces],[id_relation],[id_individu_relation],[info],[zone_top],[zone_left],[zone_bottom],[zone_right],[id_page]
			   ,[id_detail],[individu_principal],[fam_num],[date_creation],[age],[id_zone],[id_individu_xml],[detail_individu],[nom_naissance],[prenom_naissance],[nom_origine]
			   ,[prenom_origine],[lieu_residence],[lieu_insee_residence],[id_commune_residence],[id_individu_ithaque],[id_acte_ithaque],[id_individu_relation_test])
	SELECT	 [id_individu],sdi.[id_acte],[id_role_acte],[id_sexe],[nom_prefix],[nom],[nom_suffix],[prenom],[date_naissance],[annee_naissance],[lieu_naissance]
			,[lieu_insee_naissance],[id_commune_naissance],[date_mariage],[annee_mariage],[lieu_mariage],[lieu_insee_mariage],[id_commune_mariage],[date_deces],[annee_deces]
			,[lieu_deces],[lieu_insee_deces],[id_commune_deces],[id_relation],[id_individu_relation],sdi.[info],sdi.[zone_top],sdi.[zone_left],sdi.[zone_bottom],sdi.[zone_right],sdi.[id_page]
			,[id_detail],[individu_principal],[fam_num],sdi.[date_creation],[age],[id_zone],[id_individu_xml],[detail_individu],[nom_naissance],[prenom_naissance],[nom_origine]
			,[prenom_origine],[lieu_residence],[lieu_insee_residence],[id_commune_residence],[id_individu_ithaque],sdi.[id_acte_ithaque],[id_individu_relation_test]
	FROM archives.dbo.saisie_donnees_individus sdi (NOLOCK) 
	INNER JOIN [saisie_donnees_actes_MAJ_transfer] sda ON  sdi.id_acte=sda.id_acte

	INSERT INTO [saisie_donnees_individus_identites_MAJ_transfer] ([id_individu_identite],[id_acte],[id_individu],[id_type_identite],[ordre],[nom],[prenom],[date_creation]
			   ,[id_acte_ithaque],[id_individu_ithaque])
	SELECT [id_individu_identite],sdi.[id_acte],[id_individu],[id_type_identite],sdi.[ordre],[nom],[prenom],sdi.[date_creation],sdi.[id_acte_ithaque],sdi.[id_individu_ithaque]
	FROM archives.dbo.saisie_donnees_individus_identites sdi (NOLOCK) 
	INNER JOIN [saisie_donnees_actes_MAJ_transfer] sda ON  sdi.id_acte=sda.id_acte 

	set identity_insert [saisie_donnees_zones_actes_MAJ_transfer] on		
	INSERT INTO  [saisie_donnees_zones_actes_MAJ_transfer] ([id_zone],[id_acte],[id_page],[zone_top],[zone_left],[zone_bottom],[zone_right],[marge],[date_creation]
				,[id_acte_ithaque],[id_zone_ithaque],sdi.[date_modification])
	SELECT [id_zone],sdi.[id_acte],sdi.[id_page],sdi.[zone_top],sdi.[zone_left],sdi.[zone_bottom],sdi.[zone_right],[marge],sdi.[date_creation],sdi.[id_acte_ithaque],[id_zone_ithaque],sdi.[date_modification]
	FROM archives.dbo.saisie_donnees_zones_actes sdi (NOLOCK) 
	INNER JOIN [saisie_donnees_actes_MAJ_transfer] sda  ON  sdi.id_acte=sda.id_acte 
	set identity_insert [saisie_donnees_zones_actes_MAJ_transfer] off

	INSERT INTO [saisie_donnees_individus_zones_MAJ_transfer] ([id_acte],[id_individu],[id_zone],[date_creation],[id_individu_xml])
	SELECT sdi.[id_acte],[id_individu],[id_zone],sdi.[date_creation],[id_individu_xml]
	FROM archives.dbo.saisie_donnees_individus_zones sdi (NOLOCK) 
	INNER JOIN [saisie_donnees_actes_MAJ_transfer] sda ON  sdi.id_acte=sda.id_acte 

	INSERT INTO #tmp_creat_fich(command)
	select '"C:\Program Files\Microsoft SQL Server\100\Tools\Binn\bcp.exe" '
		+  QUOTENAME(DB_NAME())+ '.' /* Current Database */
		+  QUOTENAME(SCHEMA_NAME(SCHEMA_ID))+'.'            
		+  QUOTENAME(name)  
		+  ' out \\10.1.0.196\bigvol\Jobs\MEP\MAJ_MEP_transfer_files\' 
		+  REPLACE(SCHEMA_NAME(schema_id),' ','') + '_' 
		+  REPLACE(name,' ','') 
		+ '.dat -T -E -SARDSQL02\ARDSQL02FR -n -t' /* ServerName, -E will take care of Identity, -n is for Native Format */
	from sys.tables
	where object_id IN (20195122,212195806,260195977,372196376,404196490,436196604,500196832,612197231,2103678542,900198257)

	DECLARE cursor_import_fich CURSOR FOR
	select command from #tmp_creat_fich tcf
	OPEN cursor_import_fich
	FETCH cursor_import_fich INTO @command
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC master..xp_CMDShell @command
		FETCH cursor_import_fich INTO @command
	END
	CLOSE cursor_import_fich
	DEALLOCATE cursor_import_fich

	
END


GO
