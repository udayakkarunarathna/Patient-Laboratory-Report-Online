<%@ page errorPage="/JSPErrorPage.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>

<%
String ErrorMessage = "Unable to process your request !";
String ErrorType = "ERROR";

if (request.getAttribute("ErrorMessage") != null)
	ErrorMessage = (String) request.getAttribute("ErrorMessage");

if (request.getAttribute("ErrorType") != null)
	ErrorType = (String) request.getAttribute("ErrorType");

// 12-08-2001 dishana add parameter for return url

String returnURL = "javascript:history.go(-1);";

//String returnURL  = "/eHospitalOPDOffice/home.jsp";

if (request.getAttribute("returnURL") != null)
	returnURL = (String) request.getAttribute("returnURL");
%>

<HTML>
<head>
<link rel="stylesheet" href="pop_style.css"></link>

<TITLE>Error Screen</TITLE>

<link href="/eHospitalLab/eHosLabStyles.css" rel="stylesheet"
	type="text/css">

</HEAD>

<body topmargin="80" leftmargin="0" class="optionsTop">

	<table border="1" width="300" cellspacing="1" bordercolor="#0064C9"
		cellpadding="0" align="center">
		<tr>
			<td>

				<table width="300" border="0" cellpadding="0" cellspacing="0">

					<tr bgcolor="#E6F2FE">
						<td height="25" colspan="2" class="errorTitles"><p
								style="margin-left: 10"><%=ErrorType.substring(0, 1).toUpperCase() + ErrorType.substring(1).toLowerCase()%></td>
					</tr>
					<tr bgcolor="#FFFFFF">
						<td width="68" height="54" align="center" valign="middle">
							<%
							if (ErrorType.equals("ERROR"))
								out.println("<img src=\"/eHospitalLab/images/error_icon.gif\" width=\"30\" height=\"32\">");
							else
								out.println("<img src=\"/eHospitalLab/images/warning_icon.gif\" width=\"30\" height=\"32\">");
							%>
						</td>
						<td width="232" height="54" align="left" valign="middle"><strong><%=ErrorMessage%>
						</strong></td>
					</tr>
					<tr bgcolor="#FFFFFF">
						<td height="28" colspan="2" align="right" valign="middle"><p
								style="margin-right: 10">
								<a href="<%=returnURL%>"><img
									src="/eHospital/Images/Back.gif" width="64" height="46"
									border="0" align="absmiddle"></a>
							</p></td>
					</tr>

					<tr bgcolor="#E6F2FE">
						<td height="25" colspan="2">&nbsp;</td>
					</tr>
				</table>

			</td>
		</tr>
	</table>

	<br>


</body>

</HTML>