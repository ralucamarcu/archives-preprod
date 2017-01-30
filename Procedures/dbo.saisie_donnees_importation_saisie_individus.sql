SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[saisie_donnees_importation_saisie_individus] 
	-- Add the parameters for the stored procedure here
	 @id_acte_xml varchar(255)
	,@id_acte [uniqueidentifier]
	,@current_date datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @id_acte_xml_comp varchar(255), @id_acte_ithaque int, @id_individu bigint, @id_individu_ithaque bigint
	SET @id_acte_xml_comp = @id_acte_xml + '%'	
	SET @id_acte_ithaque = (SELECT id FROM Ithaque_Reecriture.dbo.DataXmlRC_actes dxrat WITH (nolock) WHERE dxrat.id_acte_xml = @id_acte_xml)


	BEGIN	
		INSERT INTO dbo.saisie_donnees_individus
		(id_individu,id_acte,nom,prenom,individu_principal, id_individu_xml, id_individu_ithaque,id_acte_ithaque)
		SELECT row_number() over(PARTITION BY dxrit.id_acte order by dxrit.id_individu_xml) AS id_individu, @id_acte AS id_acte
			, (case when dxrit.nom_Correction_Reecriture IS NULL THEN dxrit.nom ELSE dxrit.nom_Correction_Reecriture end) AS nom
			, (case when dxrit.prenom_Correction_Reecriture IS NULL THEN dxrit.prenom ELSE dxrit.prenom_Correction_Reecriture end) AS prenom
			, 1 AS individu_principal, dxrit.id_individu_xml, dxrit.id AS id_individu_ithaque,dxrit.id_acte as id_acte_ithaque
		FROM Ithaque_Reecriture.dbo.DataXmlRC_individus dxrit WITH (nolock)	
		WHERE dxrit.id_individu_xml LIKE @id_acte_xml_comp		

		IF (select count(*) from saisie_donnees_individus WITH (nolock) WHERE dbo.saisie_donnees_individus.id_acte = @id_acte) > 1
		BEGIN

			UPDATE saisie_donnees_individus
			SET saisie_donnees_individus.id_role_acte = 0
			FROM saisie_donnees_individus sdi with (nolock) 
			INNER JOIN Ithaque_Reecriture.dbo.DataXmlRC_relations_individus dxrrit WITH (nolock) ON dxrrit.id_individu_xml = sdi.id_individu_xml
			WHERE sdi.id_acte = @id_acte

			UPDATE saisie_donnees_individus
			SET id_role_acte = (CASE WHEN sdr.nom_relation_DTD = 'famille_pere' THEN 1
						WHEN sdr.nom_relation_DTD = 'famille_mere' THEN 2 
						WHEN sdr.nom_relation_DTD = 'famille_conjoint' THEN 3
						WHEN sdr.nom_relation_DTD = 'famille_beau_pere' THEN 4
						WHEN sdr.nom_relation_DTD = 'famille_belle_mere' THEN 5
						else 6 end)
				, id_individu_relation = 1, id_relation = sdr.id_relation
			FROM saisie_donnees_individus sdi with (nolock) 
			INNER JOIN Ithaque_Reecriture.dbo.DataXmlRC_relations_individus dxrrit WITH (nolock) ON dxrrit.id_individu_relation_xml = sdi.id_individu_xml		
			INNER JOIN dbo.saisie_donnees_relations sdr WITH (nolock) ON dxrrit.nom_relation = sdr.nom_relation_DTD
			WHERE sdi.id_acte = @id_acte and id_role_acte IS NULL
		END
		ELSE
		BEGIN
			UPDATE saisie_donnees_individus
			SET saisie_donnees_individus.id_role_acte = 0
			where id_acte = @id_acte
		end
	END

	
	--identites
	
	IF EXISTS (SELECT * FROM Ithaque_Reecriture.dbo.DataXmlRC_individus_identites dxriit WITH (nolock) WHERE dxriit.id_acte = @id_acte_ithaque)
	begin
		DECLARE cursor_individus CURSOR FOR
		SELECT id_acte,id_individu, id_individu_ithaque FROM saisie_donnees_individus with(nolock) WHERE id_acte = @id_acte
		OPEN cursor_individus
		FETCH cursor_individus INTO @id_acte,@id_individu, @id_individu_ithaque
		WHILE @@FETCH_STATUS = 0
		BEGIN
		
			insert into dbo.saisie_donnees_individus_identites(id_acte,id_individu,id_type_identite,ordre,nom,prenom,date_creation, id_acte_ithaque, id_individu_ithaque)
			SELECT @id_acte AS id_acte, @id_individu AS id_individu, dxriit.id_type_identite, dxriit.ordre, dxriit.nom, dxriit.prenom, @current_date AS date_creation
				, dxriit.id_acte as id_acte_ithaque, dxriit.id_individu as id_individu_ithaque
			from Ithaque_Reecriture.dbo.DataXmlRC_individus_identites dxriit WITH (nolock)
			WHERE dxriit.id_individu = @id_individu_ithaque

			FETCH cursor_individus INTO @id_acte,@id_individu, @id_individu_ithaque
		END
		CLOSE cursor_individus
		DEALLOCATE cursor_individus
	end	
END
GO
