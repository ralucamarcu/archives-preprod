SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- select * from saisie_donnees_documents where titre like '%44%'
-- =============================================
-- Test Run : [create_miniatures_table_fichier_recensements] '66AE03ED-C303-47BB-A5B2-2452AF053BDC','2491E975-D438-4114-B87C-28A5DDC4A243'
CREATE PROCEDURE [dbo].[create_miniatures_table_fichier_recensements] 
	@id_document uniqueidentifier,
	@id_projet uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    declare @nom_projet_dossier varchar(255), @command varchar(800), @nom_fichier varchar(50)
		, @id_departement varchar(10), @nb_images_miniatures int, @id_page uniqueidentifier, @image_viewer varchar(255)
		, @source varchar(255)=null, @dest varchar(255)=null
		,@path varchar(255), @zone_left int, @zone_top int, @zone_right int, @zone_bottom int
		,@text_zonage varchar(2000) = null,@path1 varchar(255) = null
		,@id_source uniqueidentifier, @nom varchar(100)
	
	set @id_source = (select id_source from Ithaque.dbo.sources_projets with (nolock) where id_projet  = @id_projet)
	select @nom_projet_dossier = nom_format_dossier, @id_departement = id_departement 
	from ithaque.dbo.sources with (nolock)
	where id_source  = @id_source

	IF(@nom_projet_dossier LIKE '%-RC')
	BEGIN
		SET @nom = (SELECT nom FROM ithaque.dbo.Projets with(NOLOCK) WHERE id_projet=@id_projet)
		SET @nom_fichier = @nom+'_miniatures_dept' + @id_departement	
	END
	ELSE
	BEGIN
		set @nom_fichier = 'miniatures_dept' + @id_departement
	END

	 create table tmp_miniatures(text_zonage varchar(2000))
		
	set @source = @nom_projet_dossier + '/V3/images'
	set @dest = 'th/90x90/' + cast(@id_document as varchar(255)) + '/'


	SELECT id_page, image_viewer 
	INTO #temp_pages
	FROm archives.dbo.saisie_donnees_pages with (nolock) 
	where id_document = @id_document

	CREATE index idx_pages on #temp_pages (id_page, image_viewer)


	declare cursor_1 cursor for
	select id_page, image_viewer from #temp_pages
	 open cursor_1
	 fetch cursor_1 into @id_page, @image_viewer
	 while @@FETCH_STATUS = 0
	 begin
		set @text_zonage = '$SRC/' + @source + REPLACE(@image_viewer, '\', '/') + ';'
		set @text_zonage = @text_zonage + '$DEST/'
			+ @dest + SUBSTRING(cast(@id_page as varchar(255)),1,2) + '/' 
			+ SUBSTRING(cast(@id_page as varchar(255)),3,2) + '/' 
			+ cast(@id_page as varchar(255)) + '.jpg'
			
		insert into tmp_miniatures (text_zonage)
		select @text_zonage
		
		set @path1 = null
		set @text_zonage = null
		fetch cursor_1 into @id_page, @image_viewer
	 end
	 close cursor_1
	 deallocate cursor_1
	 
	set @nb_images_miniatures = (select count(*) from tmp_miniatures) 
	 
	IF (@nom_projet_dossier LIKE '%-RC')
	BEGIN
PRINT 1
		set @command = '"C:\Program Files\Microsoft SQL Server\100\Tools\Binn\bcp.exe" [archives].[dbo].[tmp_miniatures] out \\10.1.0.196\bigvol\Jobs\miniatures_fichiers_recensement\' 
			+ @nom_fichier + '.csv -T -E -SARDSQL02\ARDSQL02FR -t -c'	
	END
	ELSE
	BEGIN
PRINT 2
		set @command = '"C:\Program Files\Microsoft SQL Server\100\Tools\Binn\bcp.exe" [archives].[dbo].[tmp_miniatures] out \\10.1.0.196\bigvol\Jobs\miniatures_fichiers\' 
			+ @nom_fichier + '.csv -T -E -SARDSQL02\ARDSQL02FR -t -c'	
	END
 
	print @command
		
	EXEC master..xp_CMDShell @command
	
	print 'Pour id_document: ' + cast(@id_document as varchar(255)) + '  id_departement: ' + @id_departement 
		+ ' et nom_projet_dossier:' + @nom_projet_dossier
		+ ' -> nb_images_miniatures = ' + cast(@nb_images_miniatures as varchar(50))	
	 
	drop table tmp_miniatures


	create table #tmp (subdirectory varchar(160), depth int, [file] int)
	insert into #tmp		
	exec xp_dirtree '\\10.1.0.196\bigvol\Jobs\miniatures_fichiers',1,1

	--if (select count(*) from #tmp where subdirectory = @nom_fichier + '.csv') > 0
	--begin
	--	update saisie_donnees_documents
	--	set miniatures_fichier = 1
	--		, nb_images = @nb_images_miniatures
	--	where id_document = @id_document
	--end
	
	drop table #tmp
	 
END
GO
