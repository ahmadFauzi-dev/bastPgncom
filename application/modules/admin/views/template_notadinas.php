<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
<title>SIMPEL</title>
<style type="text/css">

body{
	 background-color: #fff;
	 <!--margin:40px;-->
	 font-family: Lucida Grande, Verdana, Sans-serif;
	 font-size: 14px;
	 color: #4F5155;
}

a{
 color: #003399;
 background-color: transparent;
 font-weight: normal;
}

h1{
 color: #444;
 background-color: transparent;
 border-bottom: 1px solid #D0D0D0;
 font-size: 16px;
 font-weight: bold;
 margin: 24px 0 2px 0;
 padding: 5px 0 6px 0;
}

code{
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

table{
    border-collapse: collapse; 
}


</style>

</head>
<body>
<table  style="margin-left : 40px">
	<tr>
		<td width="50">
			<p><span style="font-size: 10pt;">Yang Terhormat</span></p>
		</td>
		<td width="20">
			<p style="line-height: normal;"><span style="font-size: 10pt;"></span></p>
		</td>
		<td width="204">
			<p><span style="font-size: 10pt;"> <?php 
						$i = 1;
						foreach ($data2 as $nav) {
							echo $i.'.'.$nav.'<br/>';
							$i++;
						}
					?> </span></p>
		</td>
		<td width="100">
			<p><span style="font-size: 10pt;" colspan="3"><?php echo $data1['str_lokasi'] ?>, <?php echo $data1['tanggal_surat'] ?></span></p>
		</td>
	</tr>
</table>

<table style="margin-top : -30px;margin-left : 40px">
	<tr>
		<td width="50">
			<p style="line-height: normal;"><span style="font-size: 10pt;">Dari</span></p>
		</td>
		<td width="20">
			<p style="line-height: normal;"><span style="font-size: 10pt;">:</span></p>
		</td>
		<td width="220">
			<p style="line-height: normal;"><span style="font-size: 10pt;"><?php echo $data1['str_jabatan'] ?></span></p>
		</td>
		<td width="50">
			<p style="line-height: normal;"><span style="font-size: 10pt;">Sifat</span></p>
		</td>
		<td width="20">
			<p style="line-height: normal;"><span style="font-size: 10pt;">:</span></p>
		</td>
		<td width="80">
			<p style="line-height: normal;"><span style="font-size: 10pt;"><?php echo $data1['str_sifat'] ?></span></p>
		</td>
	</tr>
</table>
<table style="margin-top : -30px;margin-left : 40px">
	<tr>
		<td width="50">
			<p style="line-height: normal;"><span style="font-size: 10pt;">Perihal</span></p>
		</td>
		<td width="20">
			<p style="line-height: normal;"><span style="font-size: 10pt;">:</span></p>
		</td>
		<td width="220">
			<p style="line-height: normal;"><span style="font-size: 10pt;"><?php echo $data1['perihal'] ?></span></p>
		</td>
		<td width="50">
			<p style="line-height: normal;"><span style="font-size: 10pt;">Lampiran</span></p>
		</td>
		<td width="20">
			<p style="line-height: normal;"><span style="font-size: 10pt;">:</span></p>
		</td>
		<td width="80">
			<p style="line-height: normal;"><span style="font-size: 10pt;"><?php echo $data1['lampiran'] ?> Berkas</span></p>
		</td>
	</tr>
</table>
	<p style="text-align: center;"><img src= "<?php echo base_url().'gambar/notadinas.png' ?>" width="700" height="27"></p>
	<p style="text-align: center;">No : <?php echo $data1['klasifikasi']?></p>
	<br/>
    

	<?php echo str_replace('align="left"','',$data1['isi_surat'])?>

<table>
		<tbody>
			<tr>
				<td width="220">
				<p>&nbsp;</p>
				</td>
				<td width="355" style="border: 0px;">
				<center><?php echo $data1['str_lokasi'] ?>, <?php echo $data1['tanggal_surat'] ?></center>
				<center><?php echo $data1['status_jabatan'].$data1['str_jabatan'] ?></center>
				<center><?php echo '<p><img src="'.$data1['ttd_approval'].'"alt="" width="100" height="100" /></p>'; ?></center>
				<center><?php echo $data1['namauser'] ?></center></p>
				</td>
			</tr>
		</tbody>
</table>
</body>

