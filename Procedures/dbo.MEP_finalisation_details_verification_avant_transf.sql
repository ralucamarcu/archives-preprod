SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[MEP_finalisation_details_verification_avant_transf]
	-- Add the parameters for the stored procedure here
	 @id_document uniqueidentifier
	,@id_projet uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
------ Calc Ithaque
	declare @nb_fichiers_xml_ithaque int, @nb_images_ithaque int, @nb_actes_ithaque int, @nb_individus_ithaque int
		, @nb_individus_zones_ithaque int, @nb_zones_ithaque int, @nb_marges_ithaque int, @actes_mariage int, @actes_deces int, @actes_naissance int 

	create table #tmp_fich_xml (id_fichier uniqueidentifier)
	insert into #tmp_fich_xml (id_fichier)
	select x.id_fichier from(
			select row_number() over (partition by dxf.nom_fichier order by dxf.date_creation desc) as row_num, dxf.* 
			from Ithaque.dbo.DataXml_fichiers dxf with (nolock)
			--INNER JOIN Ithaque.dbo.DataXml_lots_fichiers lf (nolock) on dxf.id_lot=lf.id_lot
			INNER JOIN Ithaque.dbo.Traitements t WITH (NOLOCK) ON dxf.id_traitement = t.id_traitement
			WHERE t.id_projet = @id_projet
				AND t.controle_livraison_conformite = 1 
				AND t.import_xml = 1 
				AND t.livraison_annulee = 0
				) as x
		where x.row_num = 1


	set @nb_fichiers_xml_ithaque = (select COUNT(*) from #tmp_fich_xml)

	set @nb_images_ithaque = (select count(tli.id_image)
		from ithaque.dbo.taches_images_logs tli with (nolock)
		inner join ithaque.dbo.images i with (nolock) on tli.id_image = i.id_image
		where i.id_projet = @id_projet
		and id_tache = 4)

	set @nb_actes_ithaque = (select COUNT(dxf.id)
		from ithaque.dbo.DataXmlRC_actes dxf with (nolock)
		inner join #tmp_fich_xml t on dxf.id_fichier = t.id_fichier)


	set @nb_individus_ithaque = (select COUNT(*)
		from ithaque.dbo.dataxmlrc_individus dxi with (nolock)where id_acte in ( select dxf.id
			from ithaque.dbo.DataXmlRC_actes dxf with (nolock)
			inner join #tmp_fich_xml t on dxf.id_fichier = t.id_fichier))

	set @nb_individus_zones_ithaque = (select COUNT(*)
		from ithaque.dbo.DataXmlRC_individus_zones dxi with (nolock)where id_zone in ( select dxz.id_zone
			from ithaque.dbo.DataXmlRC_zones dxz with (nolock)where id_acte in ( select dxf.id
			from ithaque.dbo.DataXmlRC_actes dxf with (nolock)
			inner join #tmp_fich_xml t on dxf.id_fichier = t.id_fichier)))
		
	set @nb_zones_ithaque = (select COUNT(*)
		from ithaque.dbo.DataXmlRC_zones with (nolock)where id_acte in ( select dxf.id
		from ithaque.dbo.DataXmlRC_actes dxf with (nolock)
		inner join #tmp_fich_xml t on dxf.id_fichier = t.id_fichier))

	set @nb_marges_ithaque = (select COUNT(*)
		from ithaque.dbo.DataXmlRC_marges with (nolock)where id_acte in ( select dxf.id
		from ithaque.dbo.DataXmlRC_actes dxf with (nolock)
		inner join #tmp_fich_xml t on dxf.id_fichier = t.id_fichier))

	drop table #tmp_fich_xml
	
	
--Calc Ithaque
	declare @titre varchar(100), @zonage_fichiers bit, @nb_unites int, @nb_fichiers_xml int, @nb_pages int, @nb_images int
			, @nb_actes int, @nb_individus int, @nb_identites int, @nb_individus_zones int, @nb_zones_actes int				
			
	select @titre = titre, @zonage_fichiers = zonage_fichier 
	from saisie_donnees_documents where id_document = @id_document
	
	set @nb_unites = (select COUNT(*) from dbo.saisie_donnees_bareme_unites with (nolock)
		where id_document = @id_document)
		
	set @nb_fichiers_xml = (select count(*) from dbo.saisie_donnees_fichiers_XML with (nolock)
		where id_document = @id_document)

	set @nb_pages = (select COUNT(*) from dbo.saisie_donnees_pages with (nolock)
		where id_document = @id_document)

	set @nb_images = (select COUNT(*) from dbo.saisie_donnees_images with (nolock)
		where id_document = @id_document)

	-----actes
	set @nb_actes = (select COUNT(*) from dbo.saisie_donnees_actes sda with (nolock)
		inner join dbo.saisie_donnees_pages sdp with (nolock) on sda.id_page = sdp.id_page
		where id_document = @id_document)

	set @nb_individus = (select COUNT(*) from dbo.saisie_donnees_individus sdi with (nolock)
		where sdi.id_acte in (
		select id_acte from dbo.saisie_donnees_actes sda with (nolock)
		inner join dbo.saisie_donnees_pages sdp with (nolock) on sda.id_page = sdp.id_page
		where id_document = @id_document))

	set @nb_identites = (select COUNT(*) from dbo.saisie_donnees_individus_identites sdi with (nolock)
		where sdi.id_acte in (
		select id_acte from dbo.saisie_donnees_actes sda with (nolock)
		inner join dbo.saisie_donnees_pages sdp with (nolock) on sda.id_page = sdp.id_page
		where id_document = @id_document))

	--de la indivizi
	set @nb_individus_zones = (select COUNT(*) from dbo.saisie_donnees_individus_zones sdi with (nolock)
		where sdi.id_acte in (
		select id_acte from dbo.saisie_donnees_actes sda with (nolock)
		inner join dbo.saisie_donnees_pages sdp with (nolock) on sda.id_page = sdp.id_page
		where id_document = @id_document))

	set @nb_zones_actes = (select COUNT(*) from dbo.saisie_donnees_zones_actes sdi with (nolock)
		where sdi.id_acte in (
		select id_acte from dbo.saisie_donnees_actes sda with (nolock)
		inner join dbo.saisie_donnees_pages sdp with (nolock) on sda.id_page = sdp.id_page
		where id_document = @id_document))

	SET @actes_mariage=(SELECT count(id_acte) FROM dbo.saisie_donnees_actes sda with (nolock)
		inner join dbo.saisie_donnees_pages sdp with (nolock) on sda.id_page = sdp.id_page
		where id_document = @id_document 
			AND type_acte IN ( 1,3,4,5,6,7,8,10,13,17,21,135,137,140) AND (CAST(annee_acte AS INT) >= 1792 AND CAST(annee_acte AS INT) > 1909) AND id_statut_publication in (1,5))
	
	SET  @actes_deces =(SELECT count(id_acte)  FROM dbo.saisie_donnees_actes sda with (nolock)
		inner join dbo.saisie_donnees_pages sdp with (nolock) on sda.id_page = sdp.id_page
		where id_document = @id_document 
			AND type_acte IN ( 2,105,136,138,141) AND (CAST(annee_acte AS INT) >= 1792 AND CAST(annee_acte AS INT) > 1938) AND id_statut_publication in (1,5))

	SET @actes_naissance=(SELECT count(id_acte)  FROM dbo.saisie_donnees_actes sda with (nolock)
		inner join dbo.saisie_donnees_pages sdp with (nolock) on sda.id_page = sdp.id_page
		where id_document = @id_document 
			AND type_acte IN ( 0, 24, 134, 139, 133, 142, 143)  AND (CAST(annee_acte AS INT) >= 1792 AND CAST(annee_acte AS INT) > 1893) AND id_statut_publication in (1,5)) 
		
		
	--ordre_fichier_xml
	declare @nb_ordre_fichier_null int, @nb_ordre_fichier_egale int, @nb_ordre_fichier_diff int
			,@ordre_fich_xml_exp varchar(800)
	create table #tmp_ordre_fich_xml (id_page uniqueidentifier, ordre_fichier_xml int, ordre_fichier_xml_new int)
	insert into #tmp_ordre_fich_xml(id_page, ordre_fichier_xml, ordre_fichier_xml_new)
	select id_page, ordre_fichier_xml,
	 ROW_NUMBER() over (PARTITION BY  id_fichier_xml ORDER BY ordre) as ordre_fichier_xml_new
	from saisie_donnees_pages with (nolock)
	where id_document = @id_document
	
	set @nb_ordre_fichier_null = (select COUNT(*) from #tmp_ordre_fich_xml where ordre_fichier_xml is null)
	set @nb_ordre_fichier_egale = (select COUNT(*) from #tmp_ordre_fich_xml 
					where isnull(ordre_fichier_xml,0) = isnull(ordre_fichier_xml_new,0))
	set @nb_ordre_fichier_diff = (select COUNT(*) from #tmp_ordre_fich_xml
					where isnull(ordre_fichier_xml,0) <> isnull(ordre_fichier_xml_new,0))
				
	set @ordre_fich_xml_exp = 'Le nombre total de fichiers xml avec le correct ordre est: ' 
			+ CAST(@nb_ordre_fichier_egale as varchar(50)) + ' ; '
			+ 'Le nombre total de fichiers xml avec l''ordre NULL est: ' 
			+ CAST(@nb_ordre_fichier_null as varchar(50)) + ' ; '
			+ 'Le nombre total de fichiers xml avec des ordres différents est: ' 
			+ CAST(@nb_ordre_fichier_diff as varchar(50)) + ' ; '
			
	insert into MEP_details_verif_avant_transf
		(id_document, id_projet, nb_fichiers_xml_ithaque, nb_images_ithaque, nb_actes_ithaque, nb_individus_ithaque
		, nb_individus_zones_ithaque,nb_zones_ithaque, nb_marges_ithaque, titre, zonage_fichiers, nb_unites, nb_fichiers_xml
		, nb_pages, nb_images, nb_actes, nb_individus, nb_identites, nb_individus_zones, nb_zones_actes
		, ordre_fich_xml_exp,nb_actes_nok_marriage,nb_actes_nok_naissance,nb_actes_nok_deces)
	values (@id_document, @id_projet, @nb_fichiers_xml_ithaque, @nb_images_ithaque, @nb_actes_ithaque, @nb_individus_ithaque
		, @nb_individus_zones_ithaque, @nb_zones_ithaque, @nb_marges_ithaque, @titre, @zonage_fichiers, @nb_unites, @nb_fichiers_xml
		, @nb_pages, @nb_images, @nb_actes, @nb_individus, @nb_identites, @nb_individus_zones, @nb_zones_actes
		, @ordre_fich_xml_exp,@actes_mariage,@actes_naissance,@actes_deces)


END





GO
