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
	<p style="text-align: right;font-family: 'Arial Black', 'Arial Bold'"><font size="16"><strong>MEMO</strong></font></p>
	<br/>
    <p align="right"><span style="font-size: 10pt;"><?php echo $data1['str_lokasi'] ?>, <?php echo $data1['tanggal_surat'] ?></span></p>
	<table>
	<tbody>
		<tr>
			<td width="100">
				<p>Yang Terhormat</p>
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
				<p>Di Tempat</p>
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
				<center><?php echo $data1['status_jabatan'].$data1['str_jabatan'] ?></center>
				<center><?php echo '<p><img src="'.$data1['ttd_approval'].'"alt="" width="100" height="100" /></p>'; ?></center>
				<center><?php echo $data1['namauser'] ?></center></p>
				</td>
			</tr>
		</tbody>
	</table>
</body>
