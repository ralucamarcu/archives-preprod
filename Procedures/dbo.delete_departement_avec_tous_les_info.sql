SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--test run [delete_departement_avec_tous_les_info] 'BC9B3EA8-4245-4847-86EB-7F7A91F5DDB4'

CREATE PROCEDURE [dbo].[delete_departement_avec_tous_les_info] 
	-- Add the parameters for the stored procedure here
	 @id_document uniqueidentifier
	,@pour_refaire BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEGIN TRY
	BEGIN TRANSACTION delete_departement;	
			delete from saisie_donnees_bareme_unites  where id_document =@id_document

			delete from saisie_donnees_zones_actes where id_acte in (select id_acte from dbo.saisie_donnees_actes sda with (nolock)
			inner join dbo.saisie_donnees_pages sdp with (nolock) on sda.id_page = sdp.id_page
			where id_document = @id_document)

			delete from saisie_donnees_individus_zones where id_acte in (select id_acte from dbo.saisie_donnees_actes sda with (nolock)
			inner join dbo.saisie_donnees_pages sdp with (nolock) on sda.id_page = sdp.id_page
			where id_document = @id_document)

			delete from saisie_donnees_individus_identites where id_acte in (select id_acte from dbo.saisie_donnees_actes sda with (nolock)
			inner join dbo.saisie_donnees_pages sdp with (nolock) on sda.id_page = sdp.id_page
			where id_document = @id_document)

			delete from saisie_donnees_individus where id_acte in (select id_acte from dbo.saisie_donnees_actes sda with (nolock)
			inner join dbo.saisie_donnees_pages sdp with (nolock) on sda.id_page = sdp.id_page
			where id_document = @id_document)

			delete from saisie_donnees_actes where id_acte in(
			select id_acte from dbo.saisie_donnees_actes sda with (nolock)
			inner join dbo.saisie_donnees_pages sdp with (nolock) on sda.id_page = sdp.id_page
			where id_document = @id_document)

			delete from saisie_donnees_pages  where id_document = @id_document

			delete from saisie_donnees_images  where id_document = @id_document

			delete from saisie_donnees_fichiers_XML  where id_document = @id_document

			delete from dbo.saisie_donnees_fichiers_xml_temp  where id_document = @id_document
			 
			delete from saisie_donnees_documents  where id_document = @id_document

			if (@pour_refaire = 1)
			begin
				delete from ithaque.dbo.AEL_Parametres_nouveau where id_document = @id_document
			end
	COMMIT TRANSACTION delete_departement;
	
	print 'Departement: ' + cast(@id_document as varchar(100)) + 'a ete supprime'
	
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		ROLLBACK TRANSACTION delete_departement;
		
		print 'Erreur suppression pour le departement: ' + cast(@id_document as varchar(100)) 
			+ 'l''erreur: ' +  cast(@id_document as varchar(2000)) 
		
		
		SELECT @ErrorMessage = ERROR_MESSAGE(),
			   @ErrorSeverity = ERROR_SEVERITY(),
			   @ErrorState = ERROR_STATE();

		RAISERROR (@ErrorMessage,
				   @ErrorSeverity, 
				   @ErrorState 
				   );
	END CATCH;
 
END
GO
