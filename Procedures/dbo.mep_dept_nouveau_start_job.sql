SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[mep_dept_nouveau_start_job]
	-- Add the parameters for the stored procedure here
	@id_projet uniqueidentifier,
	@isAD bit=1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    DECLARE @command_reecriture nvarchar(max), @command_import nvarchar(max)
	DECLARE @Date DATETIME = dateadd(minute, 5, Getdate())
	DECLARE @DateInt INT = CONVERT(VARCHAR(30), @Date, 112)
	DECLARE @TimeInt INT = REPLACE(CONVERT(VARCHAR(30), @Date, 108), ':', '')
	DECLARE @id_document uniqueidentifier, @create_fichiers_bcp nvarchar(max)
    
    set @command_reecriture = N'exec Ithaque_Reecriture.dbo.spReecritureTacheGeneral_nouveau
		@id_projet = ''' + cast(@id_projet as nvarchar(100)) + '''
		,@id_utilisateur = 12
		,@machine_traitement = ''Ithaque BD'''
	SET @command_import = N'exec Ithaque_Reecriture.dbo.spImportPrepareImportationSaisieDB_nouveau
		@id_projet = ''' + cast(@id_projet as nvarchar(100)) + '''
		,@id_utilisateur = 12
		,@machine_traitement = ''Ithaque BD''
		,@isAD=''' + cast(@isAD as nvarchar(100)) + ''''

	EXEC msdb.dbo.sp_update_jobstep
		@job_name = N'MEP_depart_nouveau',
		@step_id = 1,
		@step_name = N'reecriture',
		@command = @command_reecriture ;
	
	EXEC msdb.dbo.sp_update_jobstep
		@job_name = N'MEP_depart_nouveau',
		@step_id = 2,
		@step_name = N'prepare_importation_saisie',
		@command = @command_import ;

	EXEC msdb.dbo.sp_update_schedule
		@name = 'sch_dept_mep',
		@enabled = 1,
		@freq_type=1, 
		@freq_interval=0, 
		@freq_subday_type=0, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0,
		@active_start_date=@DateInt, 
		@active_end_date=99991231, 
		@active_start_time=@TimeInt, 
		@active_end_time=235959 ;
	
END
GO
