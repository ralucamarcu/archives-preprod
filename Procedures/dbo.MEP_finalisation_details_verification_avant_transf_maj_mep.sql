SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- test run: [MEP_finalisation_details_verification_avant_transf_maj_mep] '5154FF77-0BD9-4569-9109-AD0A789CEC89','F08A87A0-73C6-43FD-BCC8-2E1637BBE991'
CREATE PROCEDURE [dbo].[MEP_finalisation_details_verification_avant_transf_maj_mep]
	-- Add the parameters for the stored procedure here
	 @id_document uniqueidentifier 
	,@id_projet uniqueidentifier 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @nb_fichiers_xml_ithaque int, @nb_images_ithaque int, @nb_actes_ithaque int, @nb_individus_ithaque int
		, @nb_individus_zones_ithaque int, @nb_zones_ithaque int, @nb_marges_ithaque int , @actes_mariage int, @actes_deces int, @actes_naissance int 

---------------------------------------------
-- Production info
---------------------------------------------
		
	DECLARE @prod_traitements VARCHAR(100), @nb_fichiers_prod int, @nb_actes_prod int
	SELECT @prod_traitements = COALESCE(@prod_traitements + ', ', '') + id_traitement 
	FROM (SELECT DISTINCT CAST(id_traitement AS varchar(100)) AS id_traitement FROM temp_actes_prod) AS b

	SET @nb_fichiers_prod =(SELECT COUNT(DISTINCT id_fichier_ithaque) FROM temp_actes_prod)
	SET @nb_actes_prod =(SELECT COUNT(id_acte) FROM temp_actes_prod)

---------------------------------------------
-- Rejected files info
---------------------------------------------
	DECLARE  @nb_fichiers_rejected int, @nb_actes_rejected int

	SET @nb_fichiers_rejected =(SELECT COUNT(DISTINCT id_fichier) FROM MAJ_MEP_acte_xml_traitements_RejetEchantillon)
	SET @nb_actes_rejected =(SELECT COUNT(id_acte) FROM MAJ_MEP_acte_xml_traitements_RejetEchantillon)

---------------------------------------------
-- Accepted files info
---------------------------------------------
	DECLARE @accepted_traitements VARCHAR(100), @nb_actes_accepted int
	SELECT @accepted_traitements = COALESCE(@accepted_traitements + ', ', '') + id_traitement 
	FROM (SELECT DISTINCT CAST(id_traitement AS varchar(100)) AS id_traitement FROM MAJ_MEP_acte_xml_traitements_AcceptedEchantillon) AS b

	DECLARE  @titre varchar(100), @zonage_fichiers bit, @nb_unites int, @nb_fichiers_xml int, @nb_actes int		
			
	select @titre = titre, @zonage_fichiers = zonage_fichier 
	from saisie_donnees_documents where id_document = @id_document
	
	set @nb_unites = (select COUNT(*) from dbo.saisie_donnees_bareme_unites with (nolock)
		where id_document = @id_document)
		
	set @nb_fichiers_xml = (select count(*) from dbo.saisie_donnees_fichiers_XML with (nolock)
		where id_document = @id_document)

	set @nb_actes_accepted = (select COUNT(*) FROM dbo.saisie_donnees_pages sdp with (nolock) 
		inner JOIN  dbo.saisie_donnees_actes sda with (nolock) on sda.id_page = sdp.id_page
		where id_document = @id_document)

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
			
	INSERT INTO MEP_details_verif_avant_transf_maj_mep (id_document, id_projet, titre, zonage_fichiers, nb_unites, nb_fichiers_xml, nb_actes, nb_actes_nok_marriage,nb_actes_nok_naissance,
				nb_actes_nok_deces,accepted_traitements,nb_actes_accepted,nb_fichiers_rejected,nb_actes_rejected,prod_traitements,nb_fichiers_prod, nb_actes_prod)
	VALUES (@id_document, @id_projet, @titre, @zonage_fichiers, @nb_unites, @nb_fichiers_xml,@nb_actes,@actes_mariage,@actes_naissance,@actes_deces,@accepted_traitements,@nb_actes_accepted
			,@nb_fichiers_rejected,@nb_actes_rejected,@prod_traitements,@nb_fichiers_prod, @nb_actes_prod)



END

GO
