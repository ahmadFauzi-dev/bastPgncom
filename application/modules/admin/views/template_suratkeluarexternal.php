<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>SIMPEL</title>

<style type="text/css">

body {
 background-color: #fff;
 margin : 40px; 
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

</head>
<!--<table style="margin-top : 10px">
	<tbody>
		<tr>
			<td width="100">
				<p>Jenis Surat</p>
			</td>
			<td width="19">
					<p>:</p>
			</td>
			<td width="425">
					<p><?php //echo $data1['str_jenissurat'] ?></p>
			</td>
		</tr>
	</tbody>
</table>-->
<table style="margin-top : -30px">
	<tbody>
		<tr>
			<td width="100">
				<p>Nomor</p>
			</td>
			<td width="19">
					<p>:</p>
			</td>
			<td width="425">
					<p><?php echo $data1['klasifikasi'] ?></p>
			</td>
		</tr>
	</tbody>
</table>
<!--<table style="margin-top : -30px">
	<tbody>
		<tr>
			<td width="100">
				<p>Dari</p>
			</td>
			<td width="19">
				<p>:</p>
			</td>
			<td width="425">
				<p><?php //echo $data1['str_jabatan'] ?></p>
			</td>
		</tr>
	</tbody>
</table>-->

<table style="margin-top : -30px">
	<tbody>
	<tr>
		<td width="100">
			<p>Perihal</p>
		</td>
		<td width="19">
			<p>:</p>
		</td>
		<td width="425">
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
			<td width="425">
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
			<td width="425">
				<p><?php echo $data1['lampiran'] ?> Berkas</p>
			</td>
		</tr>
</tbody>
</table>
<p style="align:center"><?php echo $data1['str_lokasi'] ?>, <?php echo $data1['tanggal_surat'] ?></p>
<table style="margin-top : -10px">
	<tbody>
		<tr>
			<td width="100">
				<p>Yang Terhormat,</p>
			</td>
		</tr>
	</tbody>
</table>
</br>
<table>
	<tbody>
		<tr>
			<td width="425">
					<p><?php echo $data1['tujuan_external'] ?></p>
			</td>
		</tr>
</tbody>
</table>
<div class="container" style="width: 750px; margin: 0 auto;">
			<?php echo str_replace('align="left"','',$data1['isi_surat'])?>
</div>
<br/>
<div>
	<table style="margin-left:-250px">
		<tbody>
			<tr>
				<td width="246">
				<p>&nbsp;</p>
				</td>
				<td width="355" style="border: 0px;">
				<p><?php echo $data1['status_jabatan'].$data1['str_jabatan'] ?></p>
				<p><?php //echo $data1['divisi_approval'] ?></p>
				<div style="width:100px;height:100px">
				</div>
				<p><?php echo $data1['namauser'] ?></p>
				</td>
			</tr>
		</tbody>
	</table>
</div>
