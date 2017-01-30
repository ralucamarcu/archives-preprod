SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Raluca Marcu
-- Create date: 18.11.2014
-- Description:	<Description,,>
-- =============================================
--testrun: [dbo].[saisie_donnees_maj_saisie_donnees_images_pages] 'C0314790-F5D0-454E-A999-A64C37A8CCD2'
create PROCEDURE [dbo].[saisie_donnees_maj_saisie_donnees_images_pages] 
	-- Add the parameters for the stored procedure here
	@id_document UNIQUEIDENTIFIER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE Saisie_donnees_images
	SET id_page = sdp.id_page
	FROM Saisie_donnees_images sdi WITH (NOLOCK)
	INNER JOIN saisie_donnees_pages sdp WITH (NOLOCK) ON sdp.image_origine = sdi.[path]
	WHERE sdi.id_document = @id_document AND sdp.id_document = @id_document and sdi.id_page is null
END
GO
