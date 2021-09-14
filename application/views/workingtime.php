<?php 
	include "header/header.php";
?>
	<div id="wrap">
			<div id="content">
				<table>
					<tr>
						<td>Tipe Shift</td>
						<td>:</td>
						<td><input type="text" class="input"></td>
					</tr>
					<tr>
						<td>Jobsite</td>
						<td>:</td>
						<td><input type="text" class="input"></td>
					</tr>
					<tr>
						<td>Dutty On</td>
						<td>:</td>
						<td><input type="text" class="input" id="duttyOn"></td>
					</tr>
					<tr>
						<td>Dutty Off</td>
						<td>:</td>
						<td><input type="text" class="input" id="duttyOff"></td>
					</tr>
					<tr>
						<td>Deskripsi</td>
						<td>:</td>
						<td><textarea rows="6" cols="60" class="inputtextarea"></textarea></td>
					</tr>
					<tr>
						<td colspan	= "3"><input type="submit" value="Tambah" class="submit"></td>
					</tr>
				</table>
			</div>
		</div>
<?php 
	include	"footer/footer.php";
?>