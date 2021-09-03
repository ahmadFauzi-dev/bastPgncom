<?php 
header("Content-type: application/octet-stream");
header("Content-Disposition: attachment; filename=exceldata.xls");
header("Pragma: no-cache");
header("Expires: 0");

?>
<table border='1' width="70%">
<tr>
<td>No Referensi</td>
<td>Costumer Type</td>
<td>Kode Area</td>
<td>NO HP</td>
<td>Pesan</td>
<td>Tanggal Pengiriman</td>
<td>Jenis Pesan</td>
<td>Status Message</td>
</tr>

<?php 
	foreach($data as $row)
	{
		echo "<tr><td>".$row->NoreffPelanggan."</td>";
		echo "<td>".$row->costType."</td>";
		echo "<td>".$row->areaCode."</td>";
		echo "<td>".$row->mobileNumber."</td>";
		echo "<td>".$row->Message."</td>";
		echo "<td>".$row->TglPengiriman."</td>";
		echo "<td>".$row->Mtype."</td>";
		echo "<td>".$row->STATMESSAGE."</td></tr>";
	}
?>

</table>