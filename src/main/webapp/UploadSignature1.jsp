<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<script language="javascript">
	function clickIE() {
		if (document.all) {
			(message);
			return false;
		}
	}
	function clickNS(e) {
		if (document.layers || (document.getElementById && !document.all)) {
			if (e.which == 2 || e.which == 3) {
				(message);
				return false;
			}
		}
	}
	if (document.layers) {
		document.captureEvents(Event.MOUSEDOWN);
		document.onmousedown = clickNS;
	} else {
		document.onmouseup = clickNS;
		document.oncontextmenu = clickIE;
	}
	document.oncontextmenu = new Function("return false");
	</script>
<head>
<title>Upload Signature</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body class="optionsTop" topmargin="0" leftmargin="0">

	<table width="100%" border="0" cellspacing="0" cellpadding="0">

		<tr>
			<td width="3%" height="30" align="left"
				background="/eHospitalSystemAdmin/images/titleMiddle.gif"
				class="titles"><img
				src="/eHospitalSystemAdmin/images/titleCorner.gif" width="30"
				height="30" border="0"></td>
			<td width="46%"
				background="/eHospitalSystemAdmin/images/titleMiddle.gif"
				valign="middle" class="titles"><p style="margin-right: 10">Upload
					Signature</p></td>
			<td width="51%"
				background="/eHospitalSystemAdmin/images/titleMiddle.gif">&nbsp;</td>
		</tr>
	</table>
	<br />
	<form METHOD="POST" ACTION="UploadSignature2.jsp"
		ENCTYPE="multipart/form-data">
		<table width="676" border="0" align="left" cellpadding="0"
			cellspacing="0" class="bodyTable" style="margin-left: 20px">
			<tr>
				<td width="674" align="left" class="rowgrey" colspan="3"><h3
						style="margin-left: 50px">
						<b>Select Signature</b>
					</h3></td>
			</tr>
			<tr>
				<td width="163" align="left" height="50" class="rowgrey"
					width="100%">&nbsp; <font color="#0000FF"><b></b></font></td>
				<td width="420" align="left" class="rowgrey" width="100%">&nbsp;<input
					type="FILE" name="FILE1" size="20">
				</td>
				<td width="91" align="left" class="rowgrey" width="100%"><input
					type="submit" value=" Upload "></td>
			</tr>		
		</table>
	</form>
</body>
<script type="text/javascript" language="JavaScript1.2"
	src="pop_events.js"></script>
</html>