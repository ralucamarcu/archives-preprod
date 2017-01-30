SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[MEP_finalisation_details_verification_avant_transf_body_mail]
	-- Add the parameters for the stored procedure here
	-- Test Run : [MEP_finalisation_details_verification_avant_transf_body_mail] '78A92ACC-EDDC-44F7-BCBE-F7F86238EC74'
	@id_document uniqueidentifier 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @nb_fichiers_xml_ithaque int, @nb_images_ithaque int, @nb_actes_ithaque int, @nb_individus_ithaque int
		, @nb_individus_zones_ithaque int, @nb_zones_ithaque int, @nb_marges_ithaque int 
		, @titre varchar(100), @zonage_fichiers bit, @nb_unites int, @nb_fichiers_xml int, @nb_pages int, @nb_images int
		, @nb_actes int, @nb_individus int, @nb_identites int, @nb_individus_zones int, @nb_zones_actes int	
		, @ordre_fich_xml_exp varchar(800), @text_zonage varchar(250), @text_unites varchar(150), @actes_mariage int, @actes_deces int, @actes_naissance int 
		
	select @nb_fichiers_xml_ithaque = nb_fichiers_xml_ithaque, @nb_images_ithaque = nb_images_ithaque
		, @nb_actes_ithaque = nb_actes_ithaque,@nb_individus_ithaque =  nb_individus_ithaque
		, @nb_individus_zones_ithaque = nb_individus_zones_ithaque, @nb_zones_ithaque = nb_zones_ithaque
		, @nb_marges_ithaque = nb_marges_ithaque, @titre = titre, @zonage_fichiers = zonage_fichiers, @nb_unites = nb_unites
		, @nb_fichiers_xml = nb_fichiers_xml, @nb_pages = nb_pages, @nb_images = nb_images, @nb_actes = nb_actes
		, @nb_individus = nb_individus, @nb_identites = nb_identites, @nb_individus_zones = nb_individus_zones
		, @nb_zones_actes = nb_zones_actes, @ordre_fich_xml_exp = ordre_fich_xml_exp, @actes_mariage= nb_actes_nok_marriage
		, @actes_deces =nb_actes_nok_deces, @actes_naissance = nb_actes_nok_naissance
	from MEP_details_verif_avant_transf
	where id_document = @id_document
	
	set @text_zonage = (case when ISNULL(@zonage_fichiers,0) = 1 then 'Fichier Zonage écrit sur BigVol'
			else 'Problème avec l''écriture de le fichier de zonage sur BigVol' end)
	set @text_unites = (case when ISNULL(@nb_unites,0) >= 1 then 'Les unités ont été créées'
			else 'Problème possible avec ImportationSaisie (il n''a peut-être pas fini correctement)' end)
		
		print @text_zonage
			
			
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
    <td></td>
    <td class="container" bgcolor="#FFFFFF">
      <div class="content">
      <table>
        <tr>
          <td>
			<h2>Le département <strong>' + @titre + '</strong> est fini d''être téléchargés sur ARDSQLO2 ! Importation Saisie Fini !</h2>
			<br>
			<br>
			<h3>Suivi des données:</h3>
            <table  style="font-family: arial, sans-serif;border-collapse: collapse;width: 100%;">
			  <tr>
				<th>Attribut</th>
				<th>Valeur Ithaque</th>
				<th>Valeur Archives</th>
				<th>Commentaire</th>
			  </tr>			 
			  <tr>
				<td>Nombre Fichiers XML</td>
				<td>' + Cast(@nb_fichiers_xml_ithaque as varchar(50)) + '</td>
				<td>' + Cast(@nb_fichiers_xml as varchar(50)) + '</td>
				<td> . </td>
			  </tr>	
			  <tr>
				<td>Nombre Pages</td>
				<td>' + Cast(@nb_images_ithaque as varchar(50)) + '</td>
				<td>' + Cast(@nb_pages as varchar(50)) + '</td>
				<td> . </td>
			  </tr>	
			  <tr>
				<td>Nombre Images</td>
				<td>' + Cast(@nb_images_ithaque as varchar(50)) + '</td>
				<td>' + Cast(@nb_images as varchar(50)) + '</td>
				<td> . </td>
			  </tr>				  
			  <tr>
				<td>Nombre Actes</td>
				<td>' + Cast(@nb_actes_ithaque as varchar(50)) + '</td>
				<td>' + Cast(@nb_actes as varchar(50)) + '</td>
				<td> . </td>
			  </tr>	
			  <tr>
				<td>Nombre Individus</td>
				<td>' + Cast(@nb_individus_ithaque as varchar(50)) + '</td>
				<td>' + Cast(@nb_individus as varchar(50)) + '</td>
				<td> . </td>
			  </tr>	
			  <tr>
				<td>Nombre Identités</td>
				<td> - </td>
				<td>' + Cast(@nb_identites as varchar(50)) + '</td>
				<td> . </td>
			  </tr>	
			  <tr>
				<td>Nombre Individus Zones</td>
				<td>' + Cast(@nb_individus_zones_ithaque as varchar(50)) + '</td>
				<td>' + Cast(@nb_individus_zones as varchar(50)) + '</td>
				<td> . </td>
			  </tr>	
			  <tr>
				<td>Nombre Zones Actes (Marges+Zones->Ithaque)</td>
				<td>' + Cast(@nb_zones_ithaque as varchar(50)) + ' + ' + Cast(@nb_marges_ithaque as varchar(50)) + '</td>
				<td>' + Cast(@nb_zones_actes as varchar(50)) + '</td>
				<td> . </td>
			  </tr>	
			   <tr>
				<td>Fichier Zonage</td>
				<td> - </td>
				<td> - </td>				
				<td><font color="red">'+ @text_zonage  + '</font></td>
			  
			  </tr>
			  <tr>
				<td>Nombre unités</td>
				<td> - </td>
				<td>' + Cast(@nb_unites as varchar(5)) + '</td>
				<td>' +  @text_unites + '</td>
			  </tr>	
			  <tr>
				<td>Ordre Fichier XML</td>
				<td> - </td>
				<td>' + Cast(ISNULL(@ordre_fich_xml_exp,0)as varchar(50)) + '</td>
				<td> . </td>
			  </tr>	
			 	  <tr>
				<td>Nombre totale des actes des mariage avec année hors période et avec id_statut_publication = 1</td>
				<td> - </td>
				<td> - </td>
				<td>'+ Cast(ISNULL(@actes_mariage,0)as varchar(50)) +'</td>
			  </tr>	
			  <tr>
				<td>Nombre totale des actes des naissance avec année hors période et avec id_statut_publication = 1</td>
				<td> - </td>
				<td> - </td>
				<td>'+ Cast(ISNULL(@actes_naissance,0)as varchar(50)) +'</td>
			  </tr>	
			  <tr>
				<td>Nombre totale des actes des deces avec année hors période et avec id_statut_publication = 1</td>
				<td> - </td>
				<td> - </td>
				<td>'+ Cast(ISNULL(@actes_deces,0)as varchar(50)) +'</td>
			  </tr>	
			</table>
          </td>
        </tr>
      </table>
      </div>
    </td>
    <td></td>
  </tr>
</table>
<table class="footer-wrap">
  <tr>
    <td></td>
    <td class="container">     
    </td>
    <td></td>
  </tr>
</table>
</body>
</html>'  as Text_Mail


END
GO
