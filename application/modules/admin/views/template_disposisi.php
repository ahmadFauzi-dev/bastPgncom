<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>SIMPEL</title>

<style type="text/css">

body {
 background-color: #fff;
 margin: 40px;
 font-family: Lucida Grande, Verdana, Sans-serif;
 font-size: 14px;
 color: #4F5155;
}

a {
 color: #003399;
 background-color: transparent;
 font-weight: normal;
}

h1 {
 color: #444;
 background-color: transparent;
 border-bottom: 1px solid #D0D0D0;
 font-size: 16px;
 font-weight: bold;
 margin: 24px 0 2px 0;
 padding: 5px 0 6px 0;
}

code {
 font-family: Monaco, Verdana, Sans-serif;
 margin-top : -20px;
 font-size: 12px;
 background-color: #f9f9f9;
 border: 1px solid #D0D0D0;
 color: #002166;
 display: block;
 margin: 14px 0 14px 0;
 padding: 12px 10px 12px 10px;
}

table {
    border-collapse: collapse;
}
</style>

<?php 		//	var_dump($data3);
	foreach ($data1 as $nav1) {
	    $no_agenda = $nav1->no_agenda;
		$no_surat = $nav1->no_surat;
		$perihal = $nav1->perihal;
		$tanggal_penerimaan = $nav1->tanggal_penerimaan;
		$tanggal_surat = $nav1->tanggal_surat;
		$create_by = $nav1->create_by;
		$create_date = $nav1->create_date;
		$comments = $nav1->comments;
		$div_pengirim = $nav1->div_pengirim;
		$sifat = $nav1->sifat;
		$no_suratmasuk = $nav1->no_suratmasuk;
		$no_suratkeluar = $nav1->no_suratkeluar;
		$satuan_kerja = $nav1->satuan_kerja;
		$nama_perusahaan = $nav1->nama_perusahaan;
		$jabatan_pengirim = $nav1->jabatan_pengirim;
	}
?>

<p style="text-align: center;"><strong><span style="font-size: 16.0pt; line-height: 107%;">Lembar Disposisi</span></strong></p>
<table>
	<tr>
		<td width="80">
			<p><span style="font-size: 10pt;">Lembar Disposisi</span></p>
		</td>
		<td width="20">
			<p style="line-height: normal;"><span style="font-size: 10pt;"></span></p>
		</td>
		<td width="100">
			<p><span style="font-size: 10pt;"></span></p>
		</td>
		<td width="80">
			<p><span style="font-size: 10pt;">Satuan Kerja</span></p>
		</td>
		<td width="20">
			<p><span style="font-size: 10pt;">:</span></p>
		</td>
		<td width="180">
			<p><span style="font-size: 10pt;"><?php echo $satuan_kerja; ?></span></p>
		</td>
	</tr>
</table>

<table style="margin-top : -30px">
	<tr>
		<td width="80">
			<p style="line-height: normal;"><span style="font-size: 10pt;">Tgl Penerimaan</span></p>
		</td>
		<td width="20">
			<p style="line-height: normal;"><span style="font-size: 10pt;">:</span></p>
		</td>
		<td width="100">
			<p style="line-height: normal;"><span style="font-size: 10pt;"><?php echo $create_date; ?></span></p>
		</td>
		<td width="80">
			<p style="line-height: normal;"><span style="font-size: 10pt;">No Agenda</span></p>
		</td>
		<td width="20">
			<p style="line-height: normal;"><span style="font-size: 10pt;">:</span></p>
		</td>
		<td width="180">
			<p style="line-height: normal;"><span style="font-size: 10pt;"><?php echo $no_agenda; ?></span></p>
		</td>
	</tr>
</table>
<table style="margin-top : -30px">
	<tr>
		<td width="80">
			<p style="line-height: normal;"><span style="font-size: 10pt;">Pengirim</span></p>
		</td>
		<td width="20">
			<p style="line-height: normal;"><span style="font-size: 10pt;">:</span></p>
		</td>
		<td width="100">
			<p style="line-height: normal;"><span style="font-size: 10pt;"><?php echo $nama_perusahaan; ?></span></p>
		</td>
		<td width="80">
			<p style="line-height: normal;"><span style="font-size: 10pt;">No Surat</span></p>
		</td>
		<td width="20">
			<p style="line-height: normal;"><span style="font-size: 10pt;">:</span></p>
		</td>
		<td width="180">
			<p style="line-height: normal;"><span style="font-size: 10pt;"><?php echo $no_surat; ?></span></p>
		</td>
	</tr>
</table>
<table style="margin-top : -30px">
	<tr>
		<td width="80">
			<p style="line-height: normal;"><span style="font-size: 10pt;">Asal Surat</span></p>
		</td>
		<td width="20">
			<p style="line-height: normal;"><span style="font-size: 10pt;">:</span></p>
		</td>
		<td width="100">
			<p style="line-height: normal;"><span style="font-size: 10pt;"><?php echo $jabatan_pengirim; ?></span></p>
		</td>
		<td width="80">
			<p style="line-height: normal;"><span style="font-size: 10pt;">Tgl Surat</span></p>
		</td>
		<td width="20">
			<p style="line-height: normal;"><span style="font-size: 10pt;">:</span></p>
		</td>
		<td width="180">
			<p style="line-height: normal;"><span style="font-size: 10pt;"><?php echo $tanggal_surat; ?></span></p>
		</td>
	</tr>
</table>

<table style="margin-top : -30px">
	<tr>
		<td width="80">
			<p style="line-height: normal;"><span style="font-size: 10pt;">Sifat</span></p>
		</td>
		<td width="20">
			<p style="line-height: normal;"><span style="font-size: 10pt;">:</span></p>
		</td>
		<td width="100">
			<p style="line-height: normal;"><span style="font-size: 10pt;"><?php echo $sifat; ?></span></p>
		</td>
		<td width="80">
			<p style="line-height: normal;"><span style="font-size: 10pt;">Perihal</span></p>
		</td>
		<td width="20">
			<p style="line-height: normal;"><span style="font-size: 10pt;">:</span></p>
		</td>
		<td width="180">
			<p style="line-height: normal;"><span style="font-size: 10pt;"><?php echo $perihal; ?></span></p>
		</td>
	</tr>
</table>

<table style="border-collapse: collapse; border: none;">
<tbody>
<tr style="">
	<td style="border: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt;" width="300">
		<p style="margin-bottom: .0001pt; text-align: center; line-height: normal;"><center><span style="font-size: 10pt;">Anggota</span></center></p>
	</td>
	<td style="border: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt;" width="80">
		<p style="margin-bottom: .0001pt; text-align: center; line-height: normal;"><center><span style="font-size: 10pt;">Status</span></center></p>
	</td>
	<td style="border: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt;" width="80">
		<p style="margin-bottom: .0001pt; text-align: center; line-height: normal;"><center><span style="font-size: 10pt;">Tanggal</span></center></p>
	</td>
</tr>
<?php 		//	var_dump($data3);
	foreach ($data2 as $nav2) {
?>
<tr style="">
	<td>
		<p style="margin-bottom: .0001pt; text-align: left; line-height: normal;"><left><span style="font-size: 10pt;"><?php echo $nav2->anggota; ?></span></left></p>
	</td>
	<td>
		<p style="margin-bottom: .0001pt; text-align: center; line-height: normal;"><center><span style="font-size: 10pt;"><?php echo $nav2->status; ?></span></center></p>
	</td>
	<td>
		<p style="margin-bottom: .0001pt; text-align: center; line-height: normal;"><center><span style="font-size: 10pt;"><?php echo $nav2->tanggal; ?></span></center></p>
	</td>
</tr>
<?php
	}
?>
</tbody>
</table>
<p><span style="font-size: 10.0pt; line-height: 107%;">&nbsp;</span></p>
<p><span style="font-size: 10.0pt; line-height: 107%;">Komentar :</span></p>
<br/>
<table style="border-collapse: collapse; border: none;">		
		<?php 		//	var_dump($data3);
			foreach ($data4 as $nav4) {			
		?>
		<tr>
			<td width="12">		
					<?php echo $nav4->komentar; ?>		
			</td>
		</tr>
	<?php } ?>
</table>
<p><span style="font-size: 10.0pt; line-height: 107%;">&nbsp;</span></p>
<?php 		//	var_dump($data3);
	foreach ($data3 as $nav3) {
?>
<table style="border-collapse: collapse; border: none;margin-top : -25px">
<tr>
	<td width="12">
		<?php
						echo '<p><img src="http://localhost/simpel/asset/image/checkbox-'.$nav3->v_radio.'.png"alt="" width="15" height="15" /></p>';
						//echo $nav3->v_radio;				
		?>
	</td>
	<td>
		<p style="margin-bottom: .0001pt; line-height: normal;"><span style="font-size: 10pt;"><?php echo $nav3->nama; ?></span></p>
	</td>
</tr>
</table>
<?php
	}
?>