<?php 
	include "header/header.php";
	
?>
	<div id="wrap">
			<div id="content">
			<form method="POST" action="master/insert_import"  enctype="multipart/form-data">
				<table class="table">
					<tr>
						<td>File</td>
						<td>:</td>
						<td><input type="file" value="Upload" class="input"></td>
					</tr>
					<tr>
						<td colspan="3"><input type="Submit" value="Upload" class="submit"></td>
					</tr>
				</table>
			</form>	
			</div>
		</div>
<?php 
	include	"footer/footer.php";
?>