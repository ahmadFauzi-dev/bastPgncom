<html>
	<head>
		<title>HRF(HPU Report Finger)</title>
		
		<link href="<?php echo base_url()?>asset/style/admin.css" rel="stylesheet">
		<link rel="stylesheet" href="<?php echo base_url()?>asset/js/themes/base/jquery.ui.all.css">
		<link rel="stylesheet" href="<?php echo base_url()?>asset/style/demos.css">
		<script src="<?php echo base_url()?>asset/js/jquery-1.8.2.js"></script>
		<script src="<?php echo base_url()?>asset/js/ui/jquery.ui.core.js"></script>
		<script src="<?php echo base_url()?>asset/js/ui/jquery.ui.widget.js"></script>
		<script src="<?php echo base_url()?>asset/js/ui/jquery.ui.datepicker.js"></script>
		<script src="<?php echo base_url()?>asset/js/jquery-ui-timepicker-addon.js"></script>
		<script src="<?php echo base_url()?>asset/js/jquery-ui-sliderAccess.js"></script>
		<script type="text/javascript">
			$(function(){
				$("#duttyOn" ).datetimepicker({
					dateFormat	: "yy-mm-dd"
				});
				$("#duttyOff").timepicker();
			});
		</script>
	</head>
	<body>
		<div id="header">
			<div class="menu2">
				<ul>
					<li><a href="#">Master Work Schedule</a></li>
					<li><a href="<?php echo base_url()?>master/workingtime">Working Time</a></li>
					<li><a href="<?php echo base_url()?>master/workingshift">Working Shift</a></li>
				</ul>
			</div>
		</div>
		<div id="header2">
			<div id="menuIco">
				<ul>
					<li><img src="<?php echo base_url()?>asset/image/import-export-icon.png" alt="Import Data">
					<br />
					Import Data
					</li>
					<li><img src="<?php echo base_url()?>asset/image/reports-icon.png"> <br />
					Report
					</li>
					<li>
						<img src="<?php echo base_url()?>asset/image/schedule-icon.png">
					<br />
					Work Schedule</li>
				</ul>
			</div>
		</div>