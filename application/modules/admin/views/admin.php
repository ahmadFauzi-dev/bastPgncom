<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>BAST | PGASCOM</title>
	<script type="text/javascript">
		var base_url = "<?php echo base_url();?>";
		var nama_karyawan = "<?php echo $nama_karyawan ?>";
		var myuser_id = "<?php echo $user_id ?>";
		var group_id = "<?php echo $group_id ?>";
		var username = "<?php echo $username ?>";
		var role_event;
		var rolevent2;
		var idmenu;
		var sess_reffjabatan = "<?php echo $reffjabatan ?>";
		var sess_namajabatan = "<?php echo $namajabatan ?>";
		var mydivisi_id = "<?php echo $divisi_id ?>";
		var mynama_divisi = "<?php echo $nama_divisi ?>";
		var myid_perusahaan = "<?php echo $id_perusahaan ?>";
		var mynama_perusahaan = "<?php echo $nama_perusahaan ?>";
		var host_name = "<?php echo "http://".$_SERVER['HTTP_HOST'] ?>";
		
		function FunctionThatCalledMe(val)
		{
			rolevent2 = val;
			return rolevent2;
		}
	</script>
	<link rel="stylesheet" type="text/css" href="<?php echo base_url();?>asset/ext/resources/css/ext-all.css">
	<script type="text/javascript" src="<?php echo base_url();?>asset/ext/ext-all.js"></script>
	<link rel="stylesheet" type="text/css" href="<?php echo base_url();?>asset/style/style.css" />
	<!--<link rel="icon" type="image/png" href="<?php echo base_url();?>asset/icons/pgn.png" />-->
	<link rel="stylesheet" type="text/css" href="<?php echo base_url();?>asset/style/icons.css" />
	
	<script type="text/javascript" src="<?php echo base_url();?>asset/js/admin/admin.js"></script>
	<script type="text/javascript" src="<?php echo base_url();?>asset/third_party/ckeditor/ckeditor.js"></script>

	<!--<script src="https://cdn.ckeditor.com/4.8.0/full-all/ckeditor.js"></script>-->
	<script type="text/javascript" src="<?php echo base_url();?>asset/third_party/CKEditor.js"></script>
	<style>
		#main_menu {
			float	: left;
		}
		#pageHome h2 {
			font-size: 12px;
			color: #555;
			padding-bottom:5px;
			border-bottom:1px solid #C3D0DF;
		}
		body {
			font-family:'lucida grande',tahoma,arial,sans-serif;
			font-size:11px;
		}
	</style>
	
	
</head>
<body>	
	<div id="pageHome">
      <!-- <img src="<?php echo base_url() ?>asset/image/EMlogo.png" width="400px"/>-->
        </div>
		
	</body>
</html>