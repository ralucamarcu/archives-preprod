SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		select * from saisie_donnees_documents where isnull(zonage_fichier,0) = 0
-- Create date: <Create Date,,>
-- Description:	zonage table
-- =============================================
CREATE PROCEDURE [dbo].[create_zonage_table] 
	-- Add the parameters for the stored procedure here
	@id_document uniqueidentifier 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	create table Images_Traitements_zonage(id_image uniqueidentifier, chemin varchar(500))
	declare @nom_projet_dossier varchar(255), @id_projet uniqueidentifier, @command varchar(800), @nom_fichier varchar(50)
		, @id_departement varchar(10), @nb_images_zonage int
	
	set @id_projet = (select id_projet from Ithaque.dbo.AEL_Parametres_nouveau where id_document = @id_document )
	select @nom_projet_dossier = nom_projet_dossier, @id_departement = id_departement 
	from ithaque.dbo.projets (nolock)
	where id_projet  = @id_projet
	
	set @nom_fichier = 'zonage_dept' + @id_departement
	 
	INSERT INTO Images_Traitements_zonage(id_image, chemin)
	SELECT dxz.id_image, m.[image] AS chemin
	FROM Ithaque.dbo.DataXmlRC_marges m(NOLOCK)
	INNER JOIN Ithaque.dbo.DataXmlRC_zones dxz WITH (NOLOCK) ON m.[image] = dxz.[image]
	INNER JOIN archives.dbo.saisie_donnees_actes a WITH (NOLOCK) ON m.id_acte = a.id_acte_ithaque
	WHERE m.id_marge IN (
		SELECT m.id_marge FROM Ithaque.dbo.DataXmlRC_marges m(NOLOCK)
		INNER JOIN archives.dbo.saisie_donnees_actes a WITH (NOLOCK) ON m.id_acte = a.id_acte_ithaque	
		INNER JOIN archives.dbo.saisie_donnees_pages p with (nolock) on a.id_page = p.id_page 
		WHERE id_document = @id_document
		)
		AND dxz.id_image is not null
	GROUP BY dxz.id_image, m.[image] 
  
	 create table tmp_zonage (text_zonage varchar(2000))
	 declare @id_image uniqueidentifier, @source varchar(255)=null, @dest varchar(255)=null
		,@path varchar(255), @zone_left int, @zone_top int, @zone_right int, @zone_bottom int
		,@text_zonage varchar(2000) = null,@path1 varchar(255) = null
	  declare cursor_1 cursor for
	 select id_image from Images_Traitements_zonage
	-- where id_image = 'F6716F04-0668-4E51-9407-79E6558D583B'
	 open cursor_1
	 fetch cursor_1 into @id_image
	 while @@FETCH_STATUS = 0
	 begin
		set @source = replace(@nom_projet_dossier + '\V3\images\', '\','/')
		set @dest = replace(@nom_projet_dossier + '\images\', '\','/')
		
		
		set @path1 = (select distinct [image] from Ithaque.dbo.DataXmlRC_zones with (nolock) where id_image = @id_image)
		set @path1 = REPLACE (@path1, '/images/', '')
		set @text_zonage = '$SRC/' + @source + @path1 + ';'
		
		declare cursor_2 cursor for
		select  distinct dxz.image as path, dxm.rect_x1 as zone_left,dxm.rect_y1 as zone_top
			,dxm.rect_x2 as zone_right,dxm.rect_x2 as zone_bottom 
		from Ithaque.dbo.DataXmlRC_marges dxm with (nolock) 
		inner join Ithaque.dbo.DataXmlRC_zones dxz with (nolock) on dxm.[image] = dxz.[image] 
		where dxz.id_image = @id_image
		
		 open cursor_2
		 fetch cursor_2 into @path, @zone_left, @zone_top, @zone_right, @zone_bottom
		 while @@FETCH_STATUS = 0
		 begin
			set @text_zonage = @text_zonage + '-draw "rectangle ' 
				+ cast(@zone_left as varchar(50)) + ',' + cast(@zone_top as varchar(50)) + ' ' 
				+ cast(@zone_right as varchar(50))+ ',' + cast(@zone_bottom as varchar(50)) + '" ' 
			fetch cursor_2 into @path, @zone_left, @zone_top, @zone_right, @zone_bottom
		 end
		 close cursor_2
		 deallocate cursor_2
		 
		 set @path1 = REPLACE(@path1, '.jpg', '.jg2')
		 set @text_zonage = rtrim(ltrim(@text_zonage)) 
		 set @text_zonage = @text_zonage + ';$DEST/'
			+ @dest + @path1
			
		insert into tmp_zonage (text_zonage)
		select @text_zonage
		
		set @source = null
		set @dest = null
		set @path1 = null
		set @text_zonage = null
		fetch cursor_1 into @id_image
	 end
	 close cursor_1
	 deallocate cursor_1
	 
	 set @nb_images_zonage = (select count(*) from tmp_zonage)
 
	IF (@nom_projet_dossier LIKE '%-RC')
	BEGIN
		set @command = '"C:\Program Files\Microsoft SQL Server\100\Tools\Binn\bcp.exe" [archives].[dbo].[tmp_zonage] out \\10.1.0.196\bigvol\zonage_fichiers_recensement\' 
		+ @nom_fichier + '.txt -T -E -SARDSQL02\ARDSQL02FR -n -t'
	END
	ELSE
	BEGIN
	 set @command = '"C:\Program Files\Microsoft SQL Server\100\Tools\Binn\bcp.exe" [archives].[dbo].[tmp_zonage] out \\10.1.0.196\bigvol\zonage_fichiers\' 
		+ @nom_fichier + '.txt -T -E -SARDSQL02\ARDSQL02FR -n -t'
	END
	
	EXEC master..xp_CMDShell @command
	
	print 'Pour id_document: ' + cast(@id_document as varchar(255)) + '  id_departement: ' + @id_departement 
		+ ' et nom_projet_dossier:' + @nom_projet_dossier
		+ ' -> nb_images_zonage = ' + cast(@nb_images_zonage as varchar(50))
	
	
	create table #tmp (subdirectory varchar(160), depth int, [file] int)
	insert into #tmp		
	exec xp_dirtree '\\10.1.0.196\bigvol\zonage_fichiers',1,1

	if (select count(*) from #tmp where subdirectory = @nom_fichier + '.txt') > 0
	begin
		update saisie_donnees_documents
		set zonage_fichier = 1
		where id_document = @id_document
	end
	
	drop table #tmp

	drop table Images_Traitements_zonage
	drop table tmp_zonage
END
GO
