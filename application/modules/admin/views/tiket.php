<html>
<head>
<title>Trusted Ticket Requester</title>
<script type="text/javascript">
function submitForm(){document.getElementById('form1').action = document.getElementById('server').value + "/trusted";}
</script>
<style type="text/css">
.style1 {width: 100%;}
.style2 {width: 429px;}
#server { width: 254px; }
</style>
</head>
<body>
<H3>Trusted Ticketer</H3>
<form method="POST" id="form1" onSubmit="submitForm()">
<table class="style1">
<tr>
<td class="style2">
Username:</td>
<td>
<input type="text" name="username" value="" /></td>
</tr>
<tr>
<td class="style2">
Server: </td>
<td>
<input type="text" id="server" name="server" value="http://" /></td>
</tr>
<tr>
<td class="style2">
Client IP (optional):</td>
<td>
<input type="text" id="client_ip" name="client_ip" value="" /></td>
</tr>
<tr>
<td class="style2">

Site: (leave blank for Default site, else NameOfSite if using sites)</td>

<td>

<input type="text" id="target_site" name="target_site" value="" /></td>

</tr>

<tr>

<td class="style2">

<input type="submit" name="submittable" value="Go" /></td>

<td>

</td>

</tr>

</table>

</form>

<H4>Be sure to add your IP as a Trusted IP address to the server</H4>

</body>

</html>