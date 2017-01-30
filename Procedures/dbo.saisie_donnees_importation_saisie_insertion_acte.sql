SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[saisie_donnees_importation_saisie_insertion_acte]
	-- Add the parameters for the stored procedure here
	-- Test Run : saisie_donnees_importation_saisie_acte 'EC85008-0000-A-000283-0000000081'     , '52FF8168-41EE-457E-BC3C-3F3D74F13BD7', 111905
	 @id_acte_xml varchar(255)
	,@id_page uniqueidentifier
	,@id_fichier_xml int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--pt fiecare id_acte_xml existent -> pt o imagine/pagina, luam toate id_acte_xml existente
	DECLARE @id_acte [uniqueidentifier], @type_acte int, @id_role int, @id_acte_ithaque int
		, @zone_top int, @zone_left int, @zone_bottom int, @zone_right int, @nb_marges int, @marge_zones_indiv bit, @image_origine varchar(500), @primaire bit, @ordre_zones int
		,@id_individu_xml varchar(255), @id_individu bigint, @id_type_identite int, @ordre int, @nom varchar(255), @prenom varchar(255), @id_individu_ithaque bigint
		,@current_date datetime = getdate(), @id_zone_individu int, @id_acte_xml_comp varchar(255),@id_document uniqueidentifier, @id_zone int, @id_zone_ithaque int, @id_zone_acte int

	SET @id_acte_ithaque = (SELECT id FROM Ithaque_Reecriture.dbo.DataXmlRC_actes dxrat WITH (nolock) WHERE dxrat.id_acte_xml = @id_acte_xml)
	SET @id_document=(SELECT id_document FROM [dbo].[saisie_donnees_pages] WITH(NOLOCK)WHERE id_page=@id_page)

	--inserare in acte
	IF (@id_document='685bc6f3-95cf-41ae-a681-dea7c4c2305f')
	BEGIN 
		PRINT 2
		IF NOT EXISTS (SELECT * FROM dbo.saisie_donnees_actes sda with (nolock) WHERE sda.id_acte_xml = @id_acte_xml AND sda.id_fichier_xml = @id_fichier_xml AND sda.id_acte_ithaque = @id_acte_ithaque)
		BEGIN
			INSERT INTO dbo.saisie_donnees_actes(type_acte,date_acte,annee_acte,lieu_acte,insee_acte,id_individu_sujet,id_individu_conjoint,id_page,date_creation,id_acte_xml,
			id_fichier_xml,id_acte_ithaque)
			SELECT sdta.id_type_acte, dxrat.date_acte_Correction_Reecriture AS date_acte, dxrat.annee_acte_Correction_Reecriture AS annee_acte, dxrat.lieu_acte, dxrat.insee_acte
				, 1 AS id_individu_sujet, (CASE WHEN dxrat.type_acte = 'mariage' THEN 2 ELSE NULL end) AS id_individu_conjoint	
				,  @id_page AS id_page, @current_date AS date_creation, @id_acte_xml AS id_acte_xml, @id_fichier_xml AS id_fichier_xml, dxrat.id AS id_acte_ithaque
			FROM Ithaque_Reecriture.dbo.DataXmlRC_actes dxrat WITH (nolock)
			INNER JOIN dbo.saisie_donnees_types_actes sdta WITH (nolock) ON (case when dxrat.type_acte = 'liste_heros_mort' THEN 'Décès' else dxrat.type_acte end) = sdta.nom_type_acte 
				AND (CASE WHEN dxrat.soustype_acte='soldat_disparu' THEN 'deces_soldat_disparu' WHEN dxrat.soustype_acte='officier_disparu' THEN 'deces_officier_disparu' 
				WHEN dxrat.soustype_acte= 'officier_decede' THEN 'deces_officier_decede' WHEN dxrat.soustype_acte='soldat_decede' THEN 'deces_soldat_decede'
				WHEN dxrat.soustype_acte='civil_decede' THEN 'deces_civil_decede' ELSE dxrat.soustype_acte END) = sdta.nom_type_acte_DTD
			WHERE dxrat.id_acte_xml = @id_acte_xml

			SET @id_acte = (SELECT id_acte FROM dbo.saisie_donnees_actes sda WITH (nolock) WHERE sda.id_acte_xml = @id_acte_xml AND sda.id_page = @id_page AND sda.date_creation = @current_date)
			EXEC [saisie_donnees_importation_saisie_individus] @id_acte_xml = @id_acte_xml, @id_acte = @id_acte, @current_date = @current_date
		END
		SET @id_acte = (SELECT id_acte FROM dbo.saisie_donnees_actes sda WITH (nolock) WHERE sda.id_acte_xml = @id_acte_xml AND sda.id_fichier_xml = @id_fichier_xml AND sda.id_acte_ithaque = @id_acte_ithaque)
		SET @type_acte = (SELECT top 1 type_acte FROM dbo.saisie_donnees_actes sda with(nolock) WHERE id_acte = @id_acte)
	END
	ELSE
		IF (@id_document='E36BAB6F-42F2-47E7-B54E-C45C907BCE38')
		BEGIN
		PRINT 3
			IF NOT EXISTS (SELECT * FROM dbo.saisie_donnees_actes sda with (nolock) WHERE sda.id_acte_xml = @id_acte_xml AND sda.id_fichier_xml = @id_fichier_xml AND sda.id_acte_ithaque = @id_acte_ithaque)
			BEGIN
				INSERT INTO dbo.saisie_donnees_actes(type_acte,date_acte,annee_acte,lieu_acte,insee_acte,id_individu_sujet,id_individu_conjoint,id_page,date_creation,id_acte_xml,
				id_fichier_xml,id_acte_ithaque)
				SELECT sdta.id_type_acte, dxrat.date_acte_Correction_Reecriture AS date_acte, dxrat.annee_acte_Correction_Reecriture AS annee_acte, dxrat.lieu_acte, dxrat.insee_acte
					, 1 AS id_individu_sujet, (CASE WHEN dxrat.type_acte = 'mariage' THEN 2 ELSE NULL end) AS id_individu_conjoint	
					,  @id_page AS id_page, @current_date AS date_creation, @id_acte_xml AS id_acte_xml, @id_fichier_xml AS id_fichier_xml, dxrat.id AS id_acte_ithaque
				FROM Ithaque_Reecriture.dbo.DataXmlRC_actes dxrat WITH (nolock)
				INNER JOIN dbo.saisie_donnees_types_actes sdta WITH (nolock) ON (case when dxrat.soustype_acte='deces' OR dxrat.soustype_acte='deces_sepulture' THEN 'Décès'
					WHEN  dxrat.soustype_acte='mariage_publication_de_mariage' OR dxrat.soustype_acte='mariage' THEN 'mariage'
					WHEN dxrat.soustype_acte='naissance' OR dxrat.soustype_acte='naissance_bapteme' THEN 'naissance'  END) = sdta.nom_type_acte 
					AND (CASE WHEN dxrat.soustype_acte='naissance' THEN 'naissance_tables_decennales' 
					WHEN dxrat.soustype_acte='naissance_bapteme' THEN 'naissance_bapteme_tables_decennales'
					WHEN dxrat.soustype_acte= 'mariage' THEN 'mariage_tables_decennales'
					WHEN dxrat.soustype_acte='mariage_publication_de_mariage' THEN 'mariage_publication_de_mariage_tables_decennales' 
					WHEN dxrat.soustype_acte='deces' THEN 'deces_tables_decennales' 
					WHEN dxrat.soustype_acte='deces_sepulture' THEN 'deces_sepulture_tables_decennales' END) = sdta.nom_type_acte_DTD
				WHERE dxrat.id_acte_xml = @id_acte_xml

				SET @id_acte = (SELECT id_acte FROM dbo.saisie_donnees_actes sda WITH (nolock) WHERE sda.id_acte_xml = @id_acte_xml AND sda.id_page = @id_page AND sda.date_creation = @current_date)
				EXEC [saisie_donnees_importation_saisie_individus] @id_acte_xml = @id_acte_xml, @id_acte = @id_acte, @current_date = @current_date
			END
			SET @id_acte = (SELECT id_acte FROM dbo.saisie_donnees_actes sda WITH (nolock) WHERE sda.id_acte_xml = @id_acte_xml AND sda.id_fichier_xml = @id_fichier_xml AND sda.id_acte_ithaque = @id_acte_ithaque)
			SET @type_acte = (SELECT top 1 type_acte FROM dbo.saisie_donnees_actes sda with(nolock) WHERE id_acte = @id_acte)
		END
	ELSE
	BEGIN
	PRINT 4
		IF NOT EXISTS (SELECT * FROM dbo.saisie_donnees_actes sda with (nolock) WHERE sda.id_acte_xml = @id_acte_xml AND sda.id_fichier_xml = @id_fichier_xml 
				AND sda.id_acte_ithaque = @id_acte_ithaque)
		BEGIN
			INSERT INTO dbo.saisie_donnees_actes(type_acte,date_acte,annee_acte,lieu_acte,insee_acte,id_individu_sujet,id_individu_conjoint,id_page,date_creation,id_acte_xml,
			id_fichier_xml,id_acte_ithaque)
			SELECT top 1 sdta.id_type_acte, dxrat.date_acte_Correction_Reecriture AS date_acte, dxrat.annee_acte_Correction_Reecriture AS annee_acte, dxrat.lieu_acte, dxrat.insee_acte
				, 1 AS id_individu_sujet, (CASE WHEN dxrat.type_acte = 'mariage' THEN 2 ELSE NULL end) AS id_individu_conjoint	
				,  @id_page AS id_page, @current_date AS date_creation, @id_acte_xml AS id_acte_xml, @id_fichier_xml AS id_fichier_xml, dxrat.id AS id_acte_ithaque
			FROM Ithaque_Reecriture.dbo.DataXmlRC_actes dxrat WITH (nolock)
			INNER JOIN dbo.saisie_donnees_types_actes sdta WITH (nolock) ON (case when dxrat.type_acte = 'deces' THEN 'Décès' else dxrat.type_acte end) = sdta.nom_type_acte 
				--AND dxrat.soustype_acte = sdta.nom_type_acte_DTD
			WHERE dxrat.id_acte_xml = @id_acte_xml
			ORDER BY sdta.id_type_acte			
		END		
	END
	

	
END
GO
