SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		
-- Create date: /10/2015
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[saisie_donnees_importation_document_page_nouveau]	
AS
BEGIN
	DECLARE  @image varchar(500),@id_acte uniqueidentifier,@id_page1 uniqueidentifier=NULL,  @id_acte_xml varchar(255), @id_page uniqueidentifier, @id_fichier_xml int
			,@current_date_imp datetime = getdate(), @id_document [uniqueidentifier],@type_acte int, @id_role int, @id_acte_ithaque int, @zone_top int, @zone_left int
			,@zone_bottom int, @zone_right int, @nb_marges int, @marge_zones_indiv bit, @image_origine varchar(500), @primaire bit, @ordre_zones int,@id_individu_xml varchar(255)
			,@id_individu bigint, @id_type_identite int, @ordre int, @nom varchar(255), @prenom varchar(255), @id_individu_ithaque bigint,@current_date datetime = getdate()
			,@id_zone_individu int, @id_acte_xml_comp varchar(255), @id_zone int, @id_zone_ithaque int, @id_zone_acte int,@id_zone_min int, @isAD bit
	CREATE TABLE #tmp_saisie_donnees_actes (id_acte [uniqueidentifier], id_fichier_xml int, id_acte_ithaque [int]
		, id_acte_xml varchar(255), id_page [uniqueidentifier])
	CREATE TABLE #tmp_saisie_donnees_individus (id_individu int, id_acte [uniqueidentifier], id_individu_ithaque int, id_individu_xml varchar(255))
	CREATE TABLE #temp_import (id_type_acte int, date_acte nvarchar(50),  annee_acte nvarchar(50), lieu_acte nvarchar(100)
		,insee_acte nvarchar(10), id_individu_sujet int, id_individu_conjoint int, id_page uniqueidentifier
		, date_creation datetime, id_acte_xml varchar(255), id_fichier_xml INT, id_acte_ithaque INT)
	
	
	SELECT @id_document = id_document,@isAD=isAD FROM Ithaque.dbo.AEL_Parametres_nouveau WITH (NOLOCK) WHERE principal = 1

	IF OBJECT_ID('temp_actexml_page_saisie') IS NOT NULL 
	BEGIN
			DROP TABLE temp_actexml_page_saisie
	END  
	
	CREATE TABLE [dbo].[temp_actexml_page_saisie]([id] [int] IDENTITY (1,1),[id_acte_ithaque] [int],[image] [varchar](255),[id_acte_xml] [varchar](255),[id_page] [uniqueidentifier]
			,[id_fichier_xml] [int] ,[id_fichier] [uniqueidentifier],[date_creation] [datetime],image_viewer [VARCHAR] (800))
	
	ALTER TABLE [dbo].[temp_actexml_page_saisie] ADD  CONSTRAINT [DF_temp_actexml_page_saisie_date_creation]  DEFAULT (getdate()) FOR [date_creation]	


	INSERT INTO temp_actexml_page_saisie(id_acte_ithaque,image,id_acte_xml,id_page,id_fichier_xml, id_fichier)
	SELECT da.id as id_acte_ithaque,dz.image,da.id_acte_xml,NULL as id_page,NULL as id_fichier_xml, da.id_fichier
	FROM Ithaque_Reecriture.dbo.DataXmlRC_actes da WITH (NOLOCK)
	INNER JOIN  Ithaque_Reecriture.[dbo].[DataXmlRC_zones] dz WITH (NOLOCK) ON dz.id_acte=da.id
	GROUP BY da.id,dz.image,da.id_acte_xml, da.id_fichier


	CREATE CLUSTERED INDEX idx_id_fichier ON temp_actexml_page_saisie (id_fichier)
	CREATE INDEX idx_image ON temp_actexml_page_saisie (image)
	CREATE INDEX idx_id_acte_ithaque ON temp_actexml_page_saisie (id_acte_ithaque)


	UPDATE temp_actexml_page_saisie
	SET image_viewer=replace(replace(image, '/images', ''), '/', '\')

	CREATE INDEX idx_image_viewer ON temp_actexml_page_saisie(image_viewer)

	CREATE TABLE #temp_pages_viewer(id_page uniqueidentifier,image_viewer varchar(500),id_fichier_xml bigint)
	INSERT INTO #temp_pages_viewer(id_page,image_viewer,id_fichier_xml)
	SELECT id_page, image_viewer,id_fichier_xml 
	FROM  saisie_donnees_pages with (NOLOCK) where id_document = @id_document  

	CREATE INDEX idx_temp_temp_pages_viewer ON #temp_pages_viewer (image_viewer)
	CREATE INDEX idx_temp_temp_pages_id_page ON #temp_pages_viewer (id_page)

	UPDATE saisie_donnees_pages
	SET  saisie_donnees_pages.id_fichier_xml = sdfx.id_fichier_xml
		,date_modification = @current_date
	FROM  temp_actexml_page_saisie tf WITH  (NOLOCK) 
	INNER JOIN dbo.saisie_donnees_pages sdp WITH  (NOLOCK) ON sdp.image_viewer = tf.image_viewer
	INNER JOIN dbo.saisie_donnees_fichiers_XML sdfx with (NOLOCK) ON tf.id_fichier = sdfx.id_fichier_ithaque AND sdp.id_document=sdfx.id_document
	WHERE  sdp.id_document = @id_document AND sdp.id_fichier_xml IS NULL 
 
	SELECT id_page,id_fichier_xml
	INTO #temp_pages_id_fichier_xml
	FROM saisie_donnees_pages(NOLOCK)
	WHERE id_document = @id_document

	CREATE INDEX idx_temp_page ON #temp_pages_id_fichier_xml (id_page)

	UPDATE temp_actexml_page_saisie
	SET id_page = t1.id_page, id_fichier_xml=sdp.id_fichier_xml
	FROM --temp_actexml_page_saisie t1
	--INNER JOIN #temp_pages_viewer t2 ON t2.image_viewer COLLATE database_default  = t1.image_viewer 
	temp_actexml_page_saisie tf WITH  (NOLOCK) 
	INNER JOIN #temp_pages_viewer t1 ON t1.image_viewer COLLATE database_default = tf.image_viewer
	INNER JOIN #temp_pages_id_fichier_xml sdp WITH  (NOLOCK) ON t1.id_page=sdp.id_page
	--INNER JOIN dbo.saisie_donnees_fichiers_XML sdfx with (NOLOCK) ON tf.id_fichier = sdfx.id_fichier_ithaque
	--WHERE sdp.id_document = @id_document

	CREATE NONCLUSTERED INDEX idx_fichier_acte_page ON [dbo].[temp_actexml_page_saisie] ([id_fichier_xml]) INCLUDE ([id_acte_ithaque],[id_acte_xml],[id_page])
	CREATE INDEX idx_id_fichier_xml ON temp_actexml_page_saisie (id_fichier_xml)
	
---- actes		
	IF (@id_document <>  '685bc6f3-95cf-41ae-a681-dea7c4c2305f' AND @id_document <> 'E36BAB6F-42F2-47E7-B54E-C45C907BCE38')
	BEGIN
	print 'var 1'

		IF(@isAD=0) -- recensements
		BEGIN
		INSERT INTO #temp_import(id_type_acte, date_acte,  annee_acte, lieu_acte,insee_acte, id_individu_sujet
								, id_individu_conjoint , id_page , date_creation, id_acte_xml, id_fichier_xml, id_acte_ithaque)
		SELECT id_type_acte, date_acte,  annee_acte, lieu_acte,insee_acte, id_individu_sujet, id_individu_conjoint , id_page , date_creation, id_acte_xml, id_fichier_xml, id_acte_ithaque
		FROM (SELECT  ROW_NUMBER() OVER (PARTITION BY t.id_acte_xml ORDER BY t.id_acte_ithaque DESC) AS rn ,sdta.id_type_acte,
				CASE WHEN dxrat.date_acte_Correction_Reecriture IS NOT NULL THEN dxrat.date_acte_Correction_Reecriture ELSE date_acte END AS date_acte,
				CASE WHEN dxrat.annee_acte_Correction_Reecriture IS NOT NULL THEN dxrat.annee_acte_Correction_Reecriture ELSE  annee_acte END AS annee_acte,
				dxrat.lieu_acte, dxrat.insee_acte, 1 AS id_individu_sujet, (CASE WHEN dxrat.type_acte = 'mariage' THEN 2 ELSE NULL end) AS id_individu_conjoint, 
				t.id_page , @current_date AS date_creation, t.id_acte_xml, t.id_fichier_xml, dxrat.id AS id_acte_ithaque
			  FROM temp_actexml_page_saisie t WITH (nolock) 
			  INNER JOIN Ithaque_Reecriture.dbo.DataXmlRC_actes dxrat WITH (nolock) on t.[id_acte_ithaque]=dxrat.id
			  INNER JOIN dbo.saisie_donnees_types_actes sdta WITH (nolock) ON (case when dxrat.type_acte = 'deces' THEN 'Décès' else dxrat.type_acte end) = sdta.nom_type_acte ) AS temp
		WHERE rn=1
		END
		ELSE
		BEGIN
		-- AD
		INSERT INTO #temp_import(id_type_acte, date_acte,  annee_acte, lieu_acte,insee_acte, id_individu_sujet 
								, id_individu_conjoint , id_page , date_creation, id_acte_xml, id_fichier_xml, id_acte_ithaque)
		SELECT id_type_acte, date_acte,  annee_acte, lieu_acte,insee_acte, id_individu_sujet, id_individu_conjoint , id_page , date_creation, id_acte_xml, id_fichier_xml, id_acte_ithaque
		FROM (SELECT  ROW_NUMBER() OVER (PARTITION BY t.id_acte_xml ORDER BY t.id_acte_ithaque DESC) AS rn ,sdta.id_type_acte, dxrat.date_acte_Correction_Reecriture AS date_acte, dxrat.annee_acte_Correction_Reecriture AS annee_acte
			         , dxrat.lieu_acte, dxrat.insee_acte, 1 AS id_individu_sujet, (CASE WHEN dxrat.type_acte = 'mariage' THEN 2 ELSE NULL end) AS id_individu_conjoint 
					 ,t.id_page , @current_date AS date_creation, t.id_acte_xml, t.id_fichier_xml, dxrat.id AS id_acte_ithaque
			   FROM temp_actexml_page_saisie t WITH (nolock) 
			   INNER JOIN Ithaque_Reecriture.dbo.DataXmlRC_actes dxrat WITH (nolock) on t.[id_acte_ithaque]=dxrat.id
			   INNER JOIN dbo.saisie_donnees_types_actes sdta WITH (nolock) ON (case when dxrat.type_acte = 'deces' THEN 'Décès' else dxrat.type_acte end) = sdta.nom_type_acte ) AS temp
		WHERE rn=1
		END

		INSERT INTO saisie_donnees_actes (type_acte ,date_acte ,annee_acte ,lieu_acte ,insee_acte 
			,id_individu_sujet ,id_individu_conjoint,id_page,date_creation,id_acte_xml,id_fichier_xml
			,id_acte_ithaque)
		SELECT id_type_acte ,CAST(date_acte as varchar(50)) as date_acte, CAST(annee_acte AS INT) AS annee_acte
			,CAST(lieu_acte AS varchar(255)) as lieu_acte, CAST(insee_acte AS varchar(50)) AS insee_acte
			, id_individu_sujet, id_individu_conjoint, id_page, date_creation, id_acte_xml, id_fichier_xml
			, id_acte_ithaque
		FROM #temp_import		
	END
	ELSE
	BEGIN
			DECLARE cursor_1 CURSOR FOR
			SELECT T.id_acte_xml, T.id_page
			from temp_actexml_page_saisie T WITH (NOLOCK)
			WHERE t.id_fichier_xml = @id_fichier_xml
			OPEN cursor_1
			FETCH cursor_1 INTO @id_acte_xml, @id_page
			WHILE @@FETCH_STATUS = 0
			BEGIN
			PRINT 1
				EXEC [saisie_donnees_importation_saisie_insertion_acte] @id_acte_xml = @id_acte_xml, @id_page = @id_page, @id_fichier_xml = @id_fichier_xml
				FETCH cursor_1 INTO @id_acte_xml, @id_page
			END
			CLOSE cursor_1
			DEALLOCATE cursor_1
	END

	INSERT INTO #tmp_saisie_donnees_actes (id_acte, id_fichier_xml, id_acte_ithaque,id_acte_xml, id_page) 
	SELECT id_acte, sda.id_fichier_xml, sda.id_acte_ithaque,sda.id_acte_xml, sda.id_page
	FROM temp_actexml_page_saisie tfx  
	INNER JOIN dbo.saisie_donnees_actes sda WITH (nolock) ON sda.id_fichier_xml=tfx.id_fichier_xml
	GROUP BY  sda.id_acte, sda.id_fichier_xml, sda.id_acte_ithaque,sda.id_acte_xml, sda.id_page

	CREATE CLUSTERED INDEX idx_id_acte ON #tmp_saisie_donnees_actes(id_acte)
	CREATE NONCLUSTERED INDEX idx_id_fichier_xml ON #tmp_saisie_donnees_actes(id_fichier_xml)
	CREATE NONCLUSTERED INDEX idx_id_acte_ithaque ON #tmp_saisie_donnees_actes(id_acte_ithaque)

-- individus
	SELECT row_number() over(PARTITION BY dxrit.id_acte order by dxrit.id_individu_xml) AS id_individu, sda.id_acte AS id_acte
		, (case when dxrit.nom_Correction_Reecriture IS NULL THEN dxrit.nom ELSE dxrit.nom_Correction_Reecriture end) AS nom
		, (case when dxrit.prenom_Correction_Reecriture IS NULL THEN dxrit.prenom ELSE dxrit.prenom_Correction_Reecriture end) AS prenom
		, 1 AS individu_principal, dxrit.id_individu_xml, dxrit.id AS id_individu_ithaque,dxrit.id_acte as id_acte_ithaque
	INTO #temp_individus
	FROM #tmp_saisie_donnees_actes sda  
	INNER JOIN Ithaque_Reecriture.dbo.DataXmlRC_individus dxrit WITH (nolock) ON dxrit.id_acte = sda.id_acte_ithaque

	INSERT INTO dbo.saisie_donnees_individus (id_individu,id_acte,nom,prenom,individu_principal, id_individu_xml, id_individu_ithaque,id_acte_ithaque)
	SELECT id_individu,id_acte,nom,prenom,individu_principal, id_individu_xml, id_individu_ithaque,id_acte_ithaque
	FROM #temp_individus

	INSERT INTO #tmp_saisie_donnees_individus (id_individu, id_acte, id_individu_ithaque, id_individu_xml)
	SELECT sdi.id_individu, sdi.id_acte, sdi.id_individu_ithaque, id_individu_xml
	FROM #tmp_saisie_donnees_actes sda 
	INNER JOIN dbo.saisie_donnees_individus sdi WITH (nolock) ON sdi.id_acte = sda.id_acte
	GROUP BY sdi.id_individu, sdi.id_acte, sdi.id_individu_ithaque, id_individu_xml

	CREATE NONCLUSTERED INDEX idx_id_individu ON #tmp_saisie_donnees_individus(id_individu)
	CREATE NONCLUSTERED INDEX idx_id_individu_acte ON #tmp_saisie_donnees_individus(id_acte)
	CREATE NONCLUSTERED INDEX idx_id_individu_ithaque ON #tmp_saisie_donnees_individus(id_individu_ithaque)

	UPDATE dbo.saisie_donnees_individus
	SET id_role_acte = 0
	FROM  #tmp_saisie_donnees_actes sda 
	INNER JOIN dbo.saisie_donnees_individus sdi WITH (NOLOCK) ON sdi.id_acte = sda.id_acte
	WHERE  sdi.id_individu  = 1

	UPDATE saisie_donnees_individus
	SET id_role_acte = (CASE WHEN sdr.nom_relation_DTD = 'famille_pere' THEN 1
		WHEN sdr.nom_relation_DTD = 'famille_mere' THEN 2 
		WHEN sdr.nom_relation_DTD = 'famille_conjoint' THEN 3
		WHEN sdr.nom_relation_DTD = 'famille_beau_pere' THEN 4
		WHEN sdr.nom_relation_DTD = 'famille_belle_mere' THEN 5
			else 6 end)
		, id_individu_relation = 1, id_relation = sdr.id_relation
	FROM #tmp_saisie_donnees_actes sda  
	INNER JOIN saisie_donnees_individus sdi with (nolock) ON sdi.id_acte = sda.id_acte
	INNER JOIN Ithaque_Reecriture.dbo.DataXmlRC_relations_individus dxrrit WITH (nolock) ON dxrrit.id_individu_relation_xml = sdi.id_individu_xml		
	INNER JOIN dbo.saisie_donnees_relations sdr WITH (nolock) ON dxrrit.nom_relation = sdr.nom_relation_DTD
	WHERE id_role_acte IS NULL AND sdi.id_individu  <> 1

	UPDATE saisie_donnees_individus
	SET annee_naissance = sda.annee_acte
		,lieu_naissance = sda.lieu_acte
	FROM #tmp_saisie_donnees_actes a
	INNER JOIN saisie_donnees_actes sda WITH (nolock) ON a.id_acte=sda.id_acte
	INNER JOIN saisie_donnees_individus sdi WITH (nolock) on sdi.id_acte = sda.id_acte and sdi.id_individu = sda.id_individu_sujet
	WHERE sda.type_acte in (0,24,133,134,139,142,143)

	UPDATE saisie_donnees_individus
	SET annee_mariage = sda.annee_acte
	 ,lieu_mariage = sda.lieu_acte
	FROM #tmp_saisie_donnees_actes a
	INNER JOIN saisie_donnees_actes sda WITH (nolock) ON a.id_acte=sda.id_acte
	INNER JOIN saisie_donnees_individus sdi WITH (nolock) ON  sdi.id_acte = sda.id_acte and sdi.id_role_acte in (0,3)
	WHERE sda.type_acte in (1,3,7,135,137,140)

	UPDATE saisie_donnees_individus
	SET annee_deces = sda.annee_acte
	 ,lieu_deces = sda.lieu_acte
	FROM #tmp_saisie_donnees_actes a
	INNER JOIN saisie_donnees_actes sda WITH (nolock) ON a.id_acte=sda.id_acte
	INNER JOIN saisie_donnees_individus sdi WITH (nolock) ON  sdi.id_acte = sda.id_acte and sdi.id_individu = sda.id_individu_sujet
	WHERE sda.type_acte in (2,105,136,138,141)

-- indentites
	INSERT INTO dbo.saisie_donnees_individus_identites(id_acte,id_individu,id_type_identite,ordre,nom,prenom,date_creation, id_acte_ithaque, id_individu_ithaque)
	SELECT sda.id_acte AS id_acte, sdi.id_individu AS id_individu, dxriit.id_type_identite, dxriit.ordre, dxriit.nom, dxriit.prenom, @current_date AS date_creation
		, dxriit.id_acte as id_acte_ithaque, dxriit.id_individu as id_individu_ithaque
	from #tmp_saisie_donnees_individus sdi 
	INNER JOIN Ithaque_Reecriture.dbo.DataXmlRC_individus_identites dxriit WITH (nolock) ON dxriit.id_individu = sdi.id_individu_ithaque
	INNER JOIN #tmp_saisie_donnees_actes sda  ON sdi.id_acte = sda.id_acte

-- zones actes
	declare @contor int = (select max(id_zone) from PRESQL04.Archives_Preprod.dbo.saisie_donnees_zones_actes)
	declare @contor_ithaque int = (select max(id_zone) from saisie_donnees_zones_actes)

	SELECT sda.id_acte, sdp.id_page,  dxrzt.rect_y1 AS zone_top, dxrzt.rect_x1 AS zone_left, dxrzt.rect_x2 AS zone_right
		, dxrzt.rect_y2 AS zone_bottom, 0 AS marge, @current_date as date_creation, dxrzt.id_acte AS id_acte_ithaque
		, dxrzt.id_zone AS id_zone_ithaque
	INTO #temp_saisie_donnees_zones_actes
	from #tmp_saisie_donnees_actes sda 
	INNER JOIN Ithaque_Reecriture.dbo.DataXmlRC_zones dxrzt with (nolock) ON dxrzt.id_acte = sda.id_acte_ithaque
	INNER JOIN temp_actexml_page_saisie sdp with (nolock) ON sdp.image = dxrzt.image AND sda.id_acte_xml COLLATE database_default = sdp.id_acte_xml
	GROUP BY sda.id_acte, sdp.id_page, dxrzt.rect_y1, dxrzt.rect_x1, dxrzt.rect_x2, dxrzt.rect_y2, dxrzt.id_acte, dxrzt.id_zone
	ORDER BY dxrzt.id_zone
	
	if(@contor_ithaque > @contor)	
	begin
		set identity_insert saisie_donnees_zones_actes on
		INSERT INTO saisie_donnees_zones_actes(id_zone,id_acte,id_page,zone_top,zone_left,zone_bottom,zone_right,marge
			,date_creation,id_acte_ithaque, id_zone_ithaque)
		SELECT @contor_ithaque + row_number() over(partition by date_creation order by id_zone_ithaque) as id_zone
			,id_acte,id_page,zone_top,zone_left,zone_bottom,zone_right,marge,date_creation,id_acte_ithaque, id_zone_ithaque
		FROM #temp_saisie_donnees_zones_actes tsdza
		set identity_insert saisie_donnees_zones_actes off
	end
	else
	begin
		set identity_insert saisie_donnees_zones_actes on
		INSERT INTO saisie_donnees_zones_actes(id_zone,id_acte,id_page,zone_top,zone_left,zone_bottom,zone_right,marge
			,date_creation,id_acte_ithaque, id_zone_ithaque)
		SELECT @contor + row_number() over(partition by date_creation order by id_zone_ithaque) as id_zone
			,id_acte,id_page,zone_top,zone_left,zone_bottom,zone_right,marge,date_creation,id_acte_ithaque, id_zone_ithaque
		FROM #temp_saisie_donnees_zones_actes tsdza
		set identity_insert saisie_donnees_zones_actes off
	end

-- individus_actes
	IF EXISTS( SELECT  sda.id_acte 
				FROM  #tmp_saisie_donnees_actes sda 
				INNER JOIN dbo.saisie_donnees_zones_actes sdza WITH (nolock) ON sdza.id_acte = sda.id_acte
				INNER JOIN Ithaque_Reecriture.dbo.DataXmlRC_individus_zones dxrizt WITH (nolock) ON dxrizt.id_zone =sdza.id_zone_ithaque)
	BEGIN
		SELECT sdza.id_acte, sdi.id_individu, sdza.id_zone, @current_date AS date_creation , dxrizt.id_individu_xml
		INTO #temp_saisie_donnees_individus_zones
		FROM #tmp_saisie_donnees_actes sda
		INNER JOIN dbo.saisie_donnees_zones_actes sdza  (nolock) ON sdza.id_acte = sda.id_acte
		INNER JOIN Ithaque_Reecriture.dbo.DataXmlRC_individus_zones dxrizt  WITH (nolock)   ON dxrizt.id_zone = sdza.id_zone_ithaque
		INNER JOIN #tmp_saisie_donnees_individus sdi  ON dxrizt.id_individu_xml COLLATE database_default= sdi.id_individu_xml  
		GROUP by sdza.id_acte, sdi.id_individu, sdza.id_zone, dxrizt.id_individu_xml

		INSERT INTO dbo.saisie_donnees_individus_zones(id_acte,id_individu,id_zone,date_creation, id_individu_xml)
		SELECT id_acte,id_individu,id_zone,date_creation, id_individu_xml
		FROM #temp_saisie_donnees_individus_zones
	END

-- marges
	
	INSERT INTO dbo.saisie_donnees_zones_actes(id_acte,id_page,zone_top,zone_left,zone_bottom,zone_right,marge,date_creation, id_acte_ithaque, id_zone_ithaque)
	SELECT sda.id_acte AS id_acte, sda.id_page AS id_page, dxrmt.rect_y1 AS zone_top, dxrmt.rect_x1 AS zone_left, dxrmt.rect_y2 AS zone_bottom
		, dxrmt.rect_x2 AS zone_right, 1 AS marge, @current_date AS date_creation
		, sda.id_acte_ithaque AS id_acte_ithaque, dxrmt.id_marge AS id_zone_ithaque
	from Ithaque_Reecriture.dbo.DataXmlRC_marges dxrmt WITH (nolock)
	INNER JOIN #tmp_saisie_donnees_actes sda ON dxrmt.id_acte = sda.id_acte_ithaque
	
-- cursor  -> test
	SELECT MIN(sdza.id_zone) as id_zone_min,sda.id_acte
	INTO #temp_zone_min_actes
	FROM #tmp_saisie_donnees_actes sda 
	INNER JOIN saisie_donnees_zones_actes sdza WITH(NOLOCK) on sda.id_acte=sdza.id_acte
	GROUP BY sda.id_acte

	CREATE INDEX idx_zone_min_actes ON #temp_zone_min_actes (id_acte)
	CREATE INDEX idx_zone_min ON #temp_zone_min_actes (id_zone_min)

	UPDATE dbo.saisie_donnees_individus
	SET dbo.saisie_donnees_individus.id_zone = tzma.id_zone_min
	FROM #temp_zone_min_actes tzma 
	INNER JOIN dbo.saisie_donnees_individus sdi WITH (NOLOCK) ON tzma.id_acte=sdi.id_acte

	UPDATE dbo.saisie_donnees_actes
	SET  zone_top = sdza.zone_top
		,zone_left = sdza.zone_left
		,zone_bottom = sdza.zone_bottom
		,zone_right = sdza.zone_right
	FROM #temp_zone_min_actes tzma 
	INNER JOIN dbo.saisie_donnees_actes sda WITH  (nolock) ON sda.id_acte= tzma.id_acte
	INNER JOIN dbo.saisie_donnees_zones_actes sdza WITH  (nolock) ON sda.id_acte = sdza.id_acte  
	WHERE sdza.id_zone = tzma.id_zone_min

	UPDATE dbo.saisie_donnees_actes
	SET dbo.saisie_donnees_actes.id_individu_sujet = NULL
	FROM #tmp_saisie_donnees_actes tsda 
	INNER JOIN dbo.saisie_donnees_actes sda WITH (nolock) ON sda.id_acte = tsda.id_acte
	WHERE tsda.id_acte NOT IN (SELECT id_acte from #tmp_saisie_donnees_individus)

	SELECT DISTINCT taps.id_fichier_xml
	INTO #temp
	FROM temp_actexml_page_saisie taps
	INNER JOIN saisie_donnees_actes sda WITH (NOLOCK) ON taps.id_fichier_xml=sda.id_fichier_xml

	CREATE index id_fichier_xml on #temp(id_fichier_xml)

	SELECT DISTINCT t.id_fichier_xml
	INTO #temp_fichiers_xml
	FROM #temp t
	INNER JOIN saisie_donnees_fichiers_XML sdf WITH (NOLOCK) ON t.id_fichier_xml=sdf.id_fichier_xml

	CREATE index id_fichier_xml on #temp_fichiers_xml(id_fichier_xml)

	UPDATE saisie_donnees_fichiers_XML
	SET statut = 2,
		date_statut = GETDATE()
	FROM --temp_actexml_page_saisie taps
	--INNER JOIN saisie_donnees_actes sda WITH (NOLOCK) ON taps.id_fichier_xml=sda.id_fichier_xml
	#temp_fichiers_xml t
	INNER JOIN saisie_donnees_fichiers_XML sdf WITH (NOLOCK) ON t.id_fichier_xml=sdf.id_fichier_xml
	
	--EXEC spImportationSaisie_EnableDisableDifferentialBackupJob  @enabled=1 -- enable backup job
	
	DROP TABLE #temp_pages_viewer
	DROP TABLE #tmp_saisie_donnees_actes
	DROP TABLE #tmp_saisie_donnees_individus
	DROP TABLE #temp_import
	DROP TABLE #temp_fichiers_xml
	DROP TABLE #temp
	
END
GO
