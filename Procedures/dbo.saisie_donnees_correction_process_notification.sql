SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Tamas Andrea 
-- Create date: 21.11.2015
-- Description:	<Description,,>
-- =============================================
--saisie_donnees_correction_process_notification 'F08A87A0-73C6-43FD-BCC8-2E1637BBE991','5154FF77-0BD9-4569-9109-AD0A789CEC89' 
CREATE PROCEDURE saisie_donnees_correction_process_notification
	@id_projet uniqueidentifier,
	@id_document uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @recipients1 VARCHAR(200), @recipients2 VARCHAR(200),@recipients3 VARCHAR(200), @recipients4 VARCHAR(200),@profileaccount VARCHAR(500)
		,@subject varchar(500), @titre varchar(100), @text_email varchar(max)
	DECLARE @Livraisons varchar(100), @nb_actes_prod int,@nb_fichiers_prod int, @nb_actes_with_correction int, @nb_individus_with_correction int
	SET @recipients1 = 'andrea.tamas@pitechnologies.ro'
	SET @recipients2 = 'rmarcu@pitechnologies.ro'
	SET @recipients3 ='frederic.robillard@filae.com'
	SET @recipients4 ='vincent.brossier@filae.com'
	SET @profileaccount ='Raluca'

	SEt  @titre=(SELECT titre FROM saisie_donnees_documents WITH (NOLOCK) WHERE id_document=@id_document)
	SET @subject= @titre +' - Corrections après MEP finalisé '

	SET @Livraisons=(SELECT STUFF((SELECT ',' + id_traitement
					 FROM ( SELECT DISTINCT CAST(t.id_traitement AS varchar(100)) AS id_traitement
							FROM temp_actes_production sda WITH (NOLOCK)
							INNER JOIN [192.168.0.76].[archives].[dbo].[saisie_donnees_fichiers_XML] sdfx (nolock) ON  sdfx.id_fichier_xml=sda.id_fichier_xml
							INNER JOIN Ithaque.[dbo].[DataXml_fichiers] f (nolock) ON id_fichier=sdfx.id_fichier_ithaque
							INNER JOIN ithaque.[dbo].[Traitements] t (nolock) ON f.id_traitement=t.id_traitement
					) AS b FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(100)'), 1, 1, ''))

	SET @nb_actes_prod =(SELECT COUNT(id_acte) FROM temp_actes_production WITH (NOLOCK))
	SET @nb_fichiers_prod =(SELECT COUNT(sdfx.id_fichier_xml) 
							FROM temp_actes_production sda WITH (NOLOCK)
							INNER JOIN [192.168.0.76].[archives].[dbo].[saisie_donnees_fichiers_XML] sdfx (nolock) ON  sdfx.id_fichier_xml=sda.id_fichier_xml)

	SELECT dxa.id, dxa.nb_erreurs_acte
	INTO #tmp1
	FROM  ithaque.[dbo].[DataXmlRC_actes] dxa WITH (NOLOCK)
	INNER JOIN ithaque.[dbo].[DataXml_fichiers] dxf WITH (NOLOCK) ON dxa.id_fichier = dxf.id_fichier
	INNER JOIN ithaque.[dbo].[DataXmlEchantillonEntete] dxee WITH (NOLOCK) ON dxf.id_lot = dxee.id_lot
	INNER JOIN ithaque.[dbo].Traitements t WITH (NOLOCK) ON t.id_traitement = dxf.id_traitement
	WHERE id_projet = @id_projet AND id_statut IN (1,3)
		AND (type_acte_Correction IS NOT NULL OR soustype_acte_Correction IS NOT NULL 
			OR date_acte_Correction IS NOT NULL OR annee_acte_Correction IS NOT NULL 
			OR calendrier_date_acte_Correction IS NOT NULL OR lieu_acte_Correction IS NOT NULL 
			OR geonameid_acte_Correction IS NOT NULL OR insee_acte_Correction IS NOT NULL )

	SET @nb_actes_with_correction =(SELECT COUNT(*) from #tmp1)

	SELECT DISTINCT dxa.id, dxi.nb_erreurs_individu
	INTO #tmp2 
	FROM ithaque.[dbo].[DataXmlRC_individus] dxi WITH (NOLOCK)
	INNER JOIN ithaque.[dbo].[DataXmlRC_actes] dxa WITH (NOLOCK) ON dxi.id_acte = dxa.id
	INNER JOIN ithaque.[dbo].[DataXml_fichiers] dxf WITH (NOLOCK) ON dxa.id_fichier = dxf.id_fichier
	INNER JOIN ithaque.[dbo].[DataXmlEchantillonEntete] dxee WITH (NOLOCK) ON dxf.id_lot = dxee.id_lot
	INNER JOIN ithaque.[dbo].Traitements t  WITH (NOLOCK) ON t.id_traitement = dxf.id_traitement
	WHERE id_projet = @id_projet AND id_statut IN (1,3)
		AND (nom_Correction IS NOT NULL OR prenom_Correction IS NOT NULL
			 OR age_Correction IS NOT NULL OR date_naissance_Correction IS NOT NULL 
			 OR annee_naissance_Correction IS NOT NULL OR calendrier_date_naissance_Correction IS NOT NULL 
			 OR lieu_naissance_Correction IS NOT NULL OR insee_naissance_Correction IS NOT NULL 
			 OR geonameid_naissance_Correction IS NOT NULL )

	SET @nb_individus_with_correction=(select count(*) from #tmp2)

	DROP TABLE #tmp2
	DROP TABLE #tmp1

	CREATE TABLE #tmp_txt_mail (Text_Mail varchar(max))
	INSERT INTO #tmp_txt_mail(Text_Mail)
	SELECT '<!doctype html>
<html>
<head>
<style>
* {font-family: "Helvetica Neue", "Helvetica", Helvetica, Arial, sans-serif;font-size: 100%;line-height: 1.6em;margin: 0;padding: 0;}
img {max-width: 600px;width: auto;}
body {-webkit-font-smoothing: antialiased;height: 100%;-webkit-text-size-adjust: none;width: 100% !important;}
a {color: #348eda;}
.btn-primary {Margin-bottom: 10px;width: auto !important;}
.btn-primary td {background-color: #348eda; border-radius: 25px;font-family: "Helvetica Neue", Helvetica, Arial, "Lucida Grande", sans-serif; font-size: 14px; text-align: center;vertical-align: top; }
.btn-primary td a {background-color: #348eda;border: solid 1px #348eda;border-radius: 25px;border-width: 10px 20px;display: inline-block;color: #ffffff;cursor: pointer;font-weight: bold;line-height: 2;text-decoration: none;}
.last {margin-bottom: 0;}
.first {margin-top: 0;}
.padding {padding: 10px 0;}
table.body-wrap {padding: 20px;width: 100%;}
table.body-wrap .container {border: 1px solid #f0f0f0;}
table.footer-wrap {clear: both !important;width: 100%;}
.footer-wrap .container p {color: #666666;font-size: 12px;}
table.footer-wrap a {color: #999999;}
h1,h2,h3 {color: #111111;font-family: "Helvetica Neue", Helvetica, Arial, "Lucida Grande", sans-serif;font-weight: 200;line-height: 1.2em;margin: 40px 0 10px;}
h1 {font-size: 36px;}
h2 {font-size: 28px;}
h3 {font-size: 22px;}
p, ul, ol {font-size: 14px;font-weight: normal;margin-bottom: 10px;}
ul li, ol li {margin-left: 5px;list-style-position: inside;}
.container {clear: both !important;display: block !important;Margin: 0 auto !important;max-width: 600px !important;}
.body-wrap .container {padding: 20px;}
.content {display: block;margin: 0 auto;max-width: 600px;}
.content table {width: 100%;}
td, th {border: 1px solid #dddddd;text-align: left;padding: 8px;}
</style>
</head>

<body bgcolor="#f6f6f6">
<table class="body-wrap" bgcolor="#f6f6f6">
  <tr>
    <td class="container" bgcolor="#FFFFFF">
      <div class="content">
      <table>
        <tr>
          <td>
			<h2> Le processus Corrections après MEP est finalisé pour le département <strong>' + @titre + '</strong> et téléchargés sur ARDSQLO2 !</h2>
			<br>
			<br>
			<h3>Toutes les données en prod pour le département <strong>' + @titre + '</strong></h3>
            <table  style="font-family: arial, sans-serif;border-collapse: collapse;width: 100%;">
			  <tr>
				<th>Attribut</th>
				<th>Valeur </th>
				<th>Commentaire</th>
			  </tr>			 
			  <tr>
				<td>Id Livraisons</td>
				<td>' +Cast(@Livraisons as varchar(50))+ '</td>
				<td> . </td>
			  </tr>	
			  <tr>
				<td>Nombre Fichiers</td>
				<td>' + Cast(@nb_fichiers_prod as varchar(50)) + '</td>
				<td> . </td>
			  </tr>	
			  <tr>
				<td>Nombre Actes</td>
				<td>' + Cast(@nb_actes_prod as varchar(50)) + '</td>
				<td> . </td>
			  </tr>				  
			</table>

			<h3>Corrections</h3>
			<table  style="font-family: arial, sans-serif;border-collapse: collapse;width: 100%";>
				<tr>
				<th>Attribut</th>
				<th>Valeur </th>
				<th>Commentaire</th>
			  </tr>			 
			  <tr>
				<td>Nombre d''actes avec colonnes corrigées</td>
				<td>' + Cast(@nb_actes_with_correction as varchar(50))  + '</td>
				<td> . </td>
			  </tr>	
			  <tr>
				<td>Nombre des individus avec colonnes corrigées</td>
				<td>' + Cast(@nb_individus_with_correction as varchar(50)) + '</td>
				<td> . </td>
			  </tr>	
			 </table>
		</table>
          </td>
        </tr>
      </table>
      </div>
    </td>
  </tr>
<table class="footer-wrap">
</table>
</body>
</html>' AS Text_Mail


	SET @text_email=(SELECT Text_Mail FROM #tmp_txt_mail)

	EXEC msdb.dbo.sp_send_dbmail
			@recipients = @recipients1,
			@profile_name = @profileaccount,
			@subject = @subject, 
			@body = @text_email,
			@body_format = 'HTML' ;

	EXEC msdb.dbo.sp_send_dbmail
			@recipients = @recipients2,
			@profile_name = @profileaccount,
			@subject = @subject, 
			@body = @text_email,
			@body_format = 'HTML' ;
	EXEC msdb.dbo.sp_send_dbmail
			@recipients = @recipients3,
			@profile_name = @profileaccount,
			@subject = @subject, 
			@body = @text_email,
			@body_format = 'HTML' ;
	EXEC msdb.dbo.sp_send_dbmail
			@recipients = @recipients4,
			@profile_name = @profileaccount,
			@subject = @subject, 
			@body = @text_email,
			@body_format = 'HTML' ;

	DROP TABLE #tmp_txt_mail

END
GO
