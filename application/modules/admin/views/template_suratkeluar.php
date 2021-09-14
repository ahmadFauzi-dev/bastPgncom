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
	<p style="text-align: center;"><font size="16"><strong><?php echo strtoupper($data1['str_jenissurat'])?></strong></font></p>
	<p style="text-align: center;">Nomor : <?php echo $data1['klasifikasi']?></p>
	<br/>

	<table>
	<tbody>
		<tr>
			<td width="100">
				<p>Yang Terhormat</p>
			</td>
			<td width="19">
					<p>:</p>
			</td> 
			<td width="350">
					<?php 
						$i = 1;
						foreach ($data2 as $nav) {
							echo $i.'.'.$nav.'<br/>';
							$i++;
						}
					?>
			</td>
		</tr>
	</tbody>
</table>

<table>
	<tbody>
		<tr>
			<td width="100">
				<p>Dari</p>
			</td>
			<td width="19">
				<p>:</p>
			</td>
			<td width="350">
				<?php echo $data1['str_jabatan'] ?>
			</td>
		</tr>
	</tbody>
</table>

<table style="margin-top : -30px">
	<tbody>
	<tr>
		<td width="100">
			<p>Perihal</p>
		</td>
		<td width="19">
			<p>:</p>
		</td>
		<td width="350">
			<p><?php echo $data1['perihal'] ?></p>
		</td>
	</tr>
	</tbody>
</table>

<table style="margin-top : -30px">
	<tbody>
		<tr>
			<td width="100">
				<p>Sifat</p>
			</td>
			<td width="19">
				<p>:</p>
			</td>
			<td width="350">
				<p><?php echo $data1['str_sifat'] ?></p>
			</td>
		</tr>
	</tbody>
</table>

<table style="margin-top : -30px">
	<tbody>
		<tr>
			<td width="100">
				<p>Lampiran</p>
			</td>
			<td width="19">
				<p>:</p>
			</td>
			<td width="350">
				<p><?php echo $data1['lampiran'] ?> Berkas</p> 
			</td>
		</tr>
</tbody>
</table>
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
