SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: 12/10/2015
-- Description:	
-- =============================================
create PROCEDURE [dbo].[spImportationSaisie_VerificationProcessusJP2000MiniatureZonage]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	DECLARE @id_projet uniqueidentifier, @id_source uniqueidentifier, @jpg2000 bit, @miniatures bit, @zonage bit, @recipients VARCHAR(200),@profileaccount VARCHAR(500)
			,@subject varchar(500), @nom_departement varchar(100), @body varchar(max)
	
	SET @recipients = 'rmarcu@pitechnologies.ro;andrea.tamas@pitechnologies.ro'
	SET @profileaccount ='sysadmin'

	SET @id_projet=(SELECT id_projet FROM [Ithaque].[dbo].[AEL_Parametres] WITH (NOLOCK) WHERE principal=1)
	SET @id_source=(SELECT id_source FROM [Ithaque].[dbo].[Sources_Projets] WITH (NOLOCK) WHERE id_projet=@id_projet)

	SET @nom_departement=(SELECT  [nom_format_dossier] FROM [Ithaque].[dbo].[Sources] WITH (NOLOCK) WHERE id_source=@id_source)


	SET @jpg2000 =(SELECT termine FROM [Traitements_Images].[dbo].[Images_Traitements_Sources] WITH ( NOLOCK) WHERE id_source=@id_source AND [id_type_traitement] =1)
	SET @miniatures=(SELECT termine FROM [Traitements_Images].[dbo].[Images_Traitements_Sources] WITH ( NOLOCK) WHERE id_source=@id_source AND [id_type_traitement] =2)
	SET @zonage=(SELECT termine FROM [[Traitements_Images].[dbo].[Images_Traitements_Sources] WITH ( NOLOCK) WHERE id_source=@id_source AND [id_type_traitement] =3)
	
	IF ( @jpg2000 =0 OR @miniatures=0 OR @zonage=0)

	BEGIN
		SET @subject = N'Importation Saisie pour le département ' + CAST(@nom_departement AS  NVARCHAR(155)) + N' ne peut pas démarrer'
		SET @body= @subject + N' Parce que le processus ' + (CASE WHEN @jpg2000=0 THEN 'JP 2000 traitement, '  ELSE '' END) 
		+ (CASE WHEN  @miniatures=0 THEN 'miniatures traitement, ' ELSE '' END) + (CASE WHEN  @zonage=0 THEN 'zonage traitement, ' ELSE '' END) + N' n''a pas été achevé.'

		EXEC msdb.dbo.sp_send_dbmail
		 @recipients = @recipients,
		 @profile_name = @profileaccount,
		 @subject = @subject, 
		 @body = @body;
	
	END

END
GO
