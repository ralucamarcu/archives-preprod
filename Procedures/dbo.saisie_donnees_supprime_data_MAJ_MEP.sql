SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <22.08.2016>
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[saisie_donnees_supprime_data_MAJ_MEP]
	@id_document uniqueidentifier
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE saisie_donnees_zones_actes
	SET a_supprimer=1
	FROM MAJ_MEP_acte_xml_traitements_RejetEchantillon re WITH (NOLOCK)
	INNER JOIN Saisie_donnees_zones_actes a (nolock) ON a.id_acte=re.id_acte_archives

	UPDATE saisie_donnees_individus_zones
	SET a_supprimer=1
	FROM MAJ_MEP_acte_xml_traitements_RejetEchantillon re WITH (NOLOCK)
	INNER JOIN Saisie_donnees_individus_zones a WITH (NOLOCK) ON a.id_acte=re.id_acte_archives

	UPDATE saisie_donnees_individus_identites
	SET a_supprimer=1
	FROM MAJ_MEP_acte_xml_traitements_RejetEchantillon re WITH (NOLOCK)
	INNER JOIN Saisie_donnees_individus_identites a WITH (NOLOCK) ON a.id_acte=re.id_acte_archives

	UPDATE saisie_donnees_individus
	SET a_supprimer=1
	FROM MAJ_MEP_acte_xml_traitements_RejetEchantillon re WITH (NOLOCK)
	INNER JOIN Saisie_donnees_individus a WITH (NOLOCK) ON a.id_acte=re.id_acte_archives
	
	UPDATE Saisie_donnees_actes
	SET a_supprimer=1
	FROM MAJ_MEP_acte_xml_traitements_RejetEchantillon re WITH (NOLOCK)
	INNER JOIN Saisie_donnees_actes a WITH (NOLOCK) ON a.id_acte=re.id_acte_archives

	UPDATE saisie_donnees_fichier_XML
	SET a_supprimer=1
	FROM MAJ_MEP_acte_xml_traitements_RejetEchantillon re WITH (NOLOCK)
	INNER JOIN Saisie_donnees_fichier_XML a WITH (NOLOCK) ON a.id_fichier=re.id_fichier

	UPDATE saisie_donnees_individus_evenements
	SET a_supprimer=1
	FROM MAJ_MEP_acte_xml_traitements_RejetEchantillon re WITH (NOLOCK)
	INNER JOIN saisie_donnees_individus_evenements a WITH (NOLOCK) ON a.id_acte=re.id_acte_archives

	UPDATE [saisie_donnees_inventaire_periodes]
	SET a_supprimer=1
	FROM [saisie_donnees_inventaire_periodes] re WITH (NOLOCK)
	WHERE id_document=@id_document

	UPDATE [saisie_donnees_bareme_unites]
	SET a_supprimer=1
	FROM [saisie_donnees_bareme_unites] re WITH (NOLOCK)
	WHERE id_document=@id_document
END
GO
