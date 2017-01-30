SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spIndexRebuildApresImportationSaisieSurProduction]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select * from sys.tables
	
	SELECT OBJECT_NAME(i.object_id)  as Tablename,name as idxname,s.TABLE_SCHEMA
	INTO #idx
	FROM sys.indexes i INNER JOIN INFORMATION_SCHEMA.TABLES s ON OBJECT_NAME(i.object_id)=s.TABLE_NAME
	WHERE name IS NOT null
	AND i.object_id IN (20195122,21575115,133575514,197575742,210099789,212195806,260195977,261575970,306100131
						,325576198,357576312,372196376,402100473,404196490,436196604,500196832,517576882,581577110
						,612197231,772197801,804197915,1205579333,900198257,996198599,1237579447,1333579789,1365579903
						,1735677231,1783677402,1815677516,1911677858,1959678029,2023678257,2103678542)


	DECLARE @tablename VARCHAR(255)
	DECLARE @idxname VARCHAR(255)
	DECLARE @table_schema VARCHAR(255)
	DECLARE @cmd NVARCHAR(500)

	DECLARE IndexListCursor cursor FOR
	SELECT Tablename, idxname, TABLE_SCHEMA 
	FROM #idx

	OPEN IndexListCursor

	FETCH NEXT FROM IndexListCursor INTO @tablename, @idxname, @table_schema
	WHILE @@FETCH_STATUS = 0
	BEGIN

	SET @cmd = 'ALTER INDEX [' + @idxname + '] on '+@table_schema+'.'+@tablename + ' rebuild'
	PRINT @cmd
	EXEC (@cmd)

	FETCH NEXT FROM IndexListCursor INTO @tablename, @idxname, @table_schema
	END
	CLOSE IndexListCursor
	DEALLOCATE IndexListCursor

	DROP TABLE #idx
END


GO
