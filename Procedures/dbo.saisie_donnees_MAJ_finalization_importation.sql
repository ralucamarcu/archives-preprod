SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--test run: [saisie_donnees_MAJ_finalization_importation] '5154FF77-0BD9-4569-9109-AD0A789CEC89'
CREATE PROCEDURE [dbo].[saisie_donnees_MAJ_finalization_importation]
	@id_document uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		SELECT id_page INTO #temp_pages
		FROM saisie_donnees_pages  WITH (NOLOCK)
		WHERE id_document=@id_document

		CREATE INDEX idx_id_page ON #temp_pages(id_page)

		UPDATE saisie_donnees_actes
		SET id_statut_publication = 1
		FROM #temp_pages sdp 
		INNER JOIN saisie_donnees_actes sda  WITH (NOLOCK) ON sda.id_page = sdp.id_page
		WHERE ISNUMERIC(sda.annee_acte) = 1 AND 
		((sda.type_acte IN ( 0, 24, 134, 139,143,133,142) AND (CAST(sda.annee_acte AS INT) >= 1792 AND CAST(sda.annee_acte AS INT) <= 1893) )
		OR (sda.type_acte IN ( 2,105,136,138,141,25,100) AND (CAST(sda.annee_acte AS INT) >= 1792 AND CAST(sda.annee_acte AS INT) <= 1938) )
		OR (sda.type_acte IN ( 1,3,4,5,6,7,8,10,13,17,21,135,137,140)
			 AND (CAST(sda.annee_acte AS INT) >= 1792 AND CAST(sda.annee_acte AS INT) <= 1909)))

		UPDATE saisie_donnees_actes
		SET id_statut_publication = 2	
		FROM #temp_pages sdp 
		INNER JOIN saisie_donnees_actes sda  WITH (NOLOCK) ON sda.id_page = sdp.id_page
		WHERE ISNULL(id_statut_publication,0)=0
			AND ((ISNUMERIC(sda.annee_acte) <> 1
					OR ISNULL(sda.annee_acte,0) = 0
					OR type_acte NOT IN (0,24,134,139,2,105,136,138,141,1,3,4,5,6,7,8,10,13,17,21,135,137,140,25,100)
					OR CAST(sda.annee_acte AS INT) < 1792
					OR CAST(sda.annee_acte AS INT) > 1938
				)
			OR ( (ISNUMERIC(sda.annee_acte) = 1
					OR ISNULL(sda.annee_acte,0) = 0
					OR CAST(sda.annee_acte AS INT) < 1792
					OR CAST(sda.annee_acte AS INT) > 1938)))

	DROP TABLE #temp_pages
END

GO
