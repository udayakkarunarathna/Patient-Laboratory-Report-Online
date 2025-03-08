<%@page import="com.model.db.DatabaseConnectionOut"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="com.model.db.DatabaseConnectionOut"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="icon" href="images/logo.png" type="image/x-icon">
<link href="css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet"
	href="font-awesome-4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="font-awesome-4.7.0/css/font-awesome.css">
<link rel="stylesheet" href="jquery/jquery-ui.css">
<script src="jquery/jquery-1.10.2.js"></script>
<script src="jquery/jquery-ui.js"></script>
<link href="css/select2.min.css" rel="stylesheet" />
<script src="js/select2.min.js"></script>
<%
String title = "Laboratory Portal";
%>
<title>Login | Nawaloka Hospital Laboratory Portal</title>
<style>
#content {
	margin: auto;
	width: 700pt;
	border: 0px solid #73AD21;
}
</style>
<script type="text/javascript">
	$(document).ready(function() {
		$('.js-example-basic-single').select2();
	});
</script>
</head>
<%
String main_unit = "";
if (request.getParameter("main_unit") != null) {
	main_unit = request.getParameter("main_unit");
}
String unit_code = "";
if (request.getParameter("unit_code") != null) {
	unit_code = request.getParameter("unit_code");
}
%>
<body>
	<form action="labreportsmcccview.jsp" method="post">
		<div id="content">
			<div class="text-center"
				style="background-color: #9edae2; border-radius: 0.5rem !important; padding-top: 8pt; padding-bottom: 5pt; margin: 2pt 3pt 0pt 3pt">
				<div align="center">
					<img src="images/logo.png" class="img-rounded"
						alt="Nawaloka Laboratory" height="40">&nbsp;&nbsp;NAWALOKA
					HOSPITALS PLC
					<div align="center" style="margin-top: -7pt; color: green">
						<b><%=title%></b>
					</div>
				</div>
			</div>
			<%
			DatabaseConnectionOut conn = new DatabaseConnectionOut(main_unit);
			try {
				conn.ConnectToDataBase();

				String query = "SELECT C.ID, TRIM(C.NAME), 1 AS LETTER_HEAD_STATUS FROM CREDIT_COMPANIES@COLOMBO_LIVE C WHERE C.STATUS = 1 "
				+ "UNION ALL "
				+ "SELECT L.CLINIC_ID, L.CLINIC_NAME, NVL(L.LETTER_HEAD_STATUS, 0) FROM METRO_LABS@COLOMBO_LIVE L "
				+ "ORDER BY 2";
				//out.println(query + "<br/><br/>");
				ResultSet rs = conn.query(query);
			%>
			<table class="table-sm" border="0" align="center"
				style="font-weight: bold; margin-top: 50pt;">
				<tr>
					<td>Select Branch</td>
					<td width="20pt"></td>
					<td><select class="js-example-basic-single"
						name="branch_code_name" id="branch_code_name" required
						style="font-weight: bold; width: 600px !important;">
							<option disabled="disabled">--- Select ---</option>
							<%
							while (rs.next()) {
							%>
							<option
								value="<%=rs.getString(1)%>~<%=rs.getString(2)%>~<%=rs.getInt(3)%>"
								<%if (unit_code.equals(rs.getString(1))) {%> selected="selected"
								<%}%>><%=rs.getString(2)%> ~
								<%=rs.getString(1)%></option>

							<%
							}
							%>
					</select></td>
				</tr>
				<tr>
					<td align="right" colspan="3" height="10pt"></td>
				</tr>
				<tr>
					<td>Password</td>
					<td></td>
					<td><input type="password" size="15" id="password"
						name="password" required
						style="font-weight: bold; text-align: left;"></td>
				</tr>
				<tr>
					<td align="right" colspan="3"><input type="submit"
						class="btn btn-primary" value="Sign In"></td>
				</tr>
			</table>
			<%
			} catch (Exception e) {
			System.out.println(e);
			} finally {
			conn.CloseDataBaseConnection();
			}
			%>
			<div
				style="background-color: #cceaef; border-radius: 0.5rem !important; padding-top: 10pt; padding-bottom: 10pt; margin: 100pt 3pt 0pt 3pt"><%@ include
					file="footer.jsp"%></div>
			<%@ include file="footerout.jsp"%>
		</div>
	</form>
</body>
</html>