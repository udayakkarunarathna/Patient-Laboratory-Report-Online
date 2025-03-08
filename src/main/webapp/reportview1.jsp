<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="com.model.db.DatabaseConnection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="icon" href="images/logo.png" type="image/x-icon">

<!-- Bootstrap CSS -->
<link rel="stylesheet" href="css/bootstrap.min.css"
	integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm"
	crossorigin="anonymous">
<link rel="stylesheet"
	href="font-awesome-4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="font-awesome-4.7.0/css/font-awesome.css">
<%
String title = "Laboratory Portal";
%>
<title><%=title%> | Nawaloka Hospital</title>
</head>
<body>
	<div style="max-width: 1000px; margin: auto;">
		<div class="text-center"
			style="background-color: #9edae2; border-radius: 1rem !important; padding-top: 8pt; padding-bottom: 5pt; margin: 2pt 3pt 0pt 3pt">
			<img src="images/logo.png" class="img-rounded"
				alt="Nawaloka Laboratory" height="50">
			<div align="center">NAWALOKA HOSPITALS PLC</div>
			<div align="center">
				<b><%=title%></b>
			</div>
		</div>
		<%
	String ref = "", url_upin = "";

		if (request.getParameter("p") != null) {
			ref = request.getParameter("p").split("_")[0];
			url_upin = request.getParameter("p").split("_")[1];
		}

	DatabaseConnection conn = new DatabaseConnection();

	String date_from = "";
	int age_yy = 0, age_mm = 0, age_dd = 0;
	String address = "";
	int count1 = 0;

	try {
		conn.ConnectToDataBase();

		String query = "SELECT NVL((SELECT PR.SURNAME || PR.TITLE || PR.INITIALS FROM HOSPITAL_VISIT@COLOMBO_LIVE HV, PATIENT_REGISTRATION@COLOMBO_LIVE PR WHERE PR.REGISTRATION_NO = HV.REGISTRATION_NO AND HV.BHT = I.NAME_BHT),I.NAME_BHT) NAME "
		+ ", I.AGE_YY || 'Y ' || I.AGE_MM || 'M' AGE, REPLACE(NVL(I.UPIN,'-'), 'null', '-'), "
		+ "NVL(NVL((SELECT TO_CHAR(PR.DOB, 'YYYY/MM/DD') FROM HOSPITAL_VISIT@COLOMBO_LIVE HV, PATIENT_REGISTRATION@COLOMBO_LIVE PR WHERE PR.REGISTRATION_NO = HV.REGISTRATION_NO AND HV.BHT = I.NAME_BHT), "
		+ "(NVL(I.DOB, TO_CHAR(TO_DATE(REPLACE(I.DOB,'-',''), 'DD/MM/YYYY'),'YYYY/MM/DD')))), '-') DOB, TO_CHAR(I.TXN_DATE, 'YYYY/MM/DD HH12:MI AM') "
		+ "FROM LAB_TEST_INVOICES@COLOMBO_LIVE I " 
		+ "WHERE I.INVOICE_NO = '" + ref + "' AND I.UPIN = '" + url_upin + "' AND I.STATUS = 1";
		//out.println(query + "<br/><br/>");
		ResultSet rs = conn.query(query);

		while (rs.next()) {
			count1++;
	%>
		<table class="table-sm" border="0" width="99%" align="center"
			style="font-size: 9pt; margin-top: 10pt; margin-bottom: 0pt; border: 0pt solid black">
			<tr>
				<td valign="top">Name</td>
				<td valign="top" width="1pt">:</td>
				<td valign="top" colspan="4"><%=rs.getString(1)%></td>
			</tr>
			<%
		if (!rs.getString(4).equals("-")) {
		%>
			<tr>
				<td valign="top">Birth Date</td>
				<td valign="top" width="1pt">:</td>
				<td valign="top" colspan="4"><%=rs.getString(4)%></td>
			</tr>
			<%
		} else {
		%>
			<tr>
				<td valign="top">Age</td>
				<td valign="top" width="1pt">:</td>
				<td valign="top" colspan="4"><%=rs.getString(2)%></td>
			</tr>
			<%
		}
		%>
			<tr>
				<td valign="top" width="18%">Ref. No.</td>
				<td valign="top" width="1pt">:</td>
				<td valign="top"><%=ref%></td>
				<td valign="top" align="right">UPIN</td>
				<td valign="top" width="1pt">:</td>
				<td valign="top"><%=rs.getString(3)%></td>
			</tr>
			<tr>
				<td valign="top">Bill Date</td>
				<td valign="top" width="1pt">:</td>
				<td valign="top"colspan="3"><%=rs.getString(5)%></td>
				<td valign="top" align="right"><button
						type="button" style="font-size: 8pt" class="btn btn-info"
						onClick="window.location.reload(true)">Refresh</button></td>
			</tr>
		</table>
		<%
	}

	query = "SELECT UPPER(T.DESCRIPTION || P.DESCRIPTION) TEST, NVL(L.LAB_REF_NO,'-'), L.AUTHORIZED_STATUS, TO_CHAR(L.SAMPLE_COLLECTED_TIME, 'YYYY/MM/DD HH12:MI AM'), "
			+ "(nvl(T.report_ready_dates,'0')*24 + nvl(T.report_ready_hours,'0') + nvl(P.report_ready_dates,'0')*24 + nvl(P.report_ready_hours,'0')) X, "
			+ "L.TEST_PROFILE_CODE, TO_CHAR((L.SAMPLE_COLLECTED_TIME + (1/24* "
			+ "(nvl(T.report_ready_dates,'0')*24 + nvl(T.report_ready_hours,'0') + nvl(P.report_ready_dates,'0')*24 + nvl(P.report_ready_hours,'0')))),'Mon DD, HH12:MI AM') report_ready_hours "
			+ "FROM LAB_TEST_BREAKDOWN@COLOMBO_LIVE L, LAB_TEST_INVOICES@COLOMBO_LIVE I, LAB_TESTS@COLOMBO_LIVE T, LAB_PROFILE@COLOMBO_LIVE P "
			+ "WHERE "
			//+"L.REPORT_STATUS IN (1,2) AND "
			+ "L.LAB_REF_NO IS NOT NULL AND "
			+ "L.TEST_PROFILE_CODE = T.TEST_CODE(+) AND L.TEST_PROFILE_CODE = P.PROFILE_CODE(+) AND L.INVOICE_NO = I.INVOICE_NO AND I.INVOICE_NO IN ('"
			+ ref + "') " + " AND I.UPIN = '" + url_upin + "' AND I.STATUS = 1 AND L.STATUS = 1 " + "ORDER BY L.AUTHORIZED_STATUS DESC, 1";
	//out.println(query);

	rs = conn.query(query);
	%>
		<table class="table table-striped"
			style="font-size: 9pt; margin-top: 0pt;">
			<%
		int count = 0;
		while (rs.next()) {
			count++;
			if (count == 1) {
		%>
			<thead>
				<tr style="background-color: #CAC4FF; color: white">
					<th>Test</th>
					<th style="text-align: center;">Status</th>
					<th style="text-align: center;">View</th>
					<th style="text-align: center;">Print</th>
				</tr>
			</thead>
			<%
		}
		%>
			<tr>
				<td class="boldCls"><b> <%
				if (rs.getInt(3) == 1) {
				%><a style="color: blue" class="boldCls" target="_blank"
						title="View Lab Report"
						href="https://nawalokaepay.lk/labreport/labreport1.jsp?invoice=<%=ref%>&labno=<%=rs.getString(2)%>&lh=yes&ac=view"><%=rs.getString(1)%></a>
						<%
				} else {
				out.println(rs.getString(1));
				}
				%>
				</b><br /> <font style="font-size: 8pt">&nbsp;Ready Date :
						&nbsp; <b><%=rs.getString(7)%></b>
				</font></td>

				<%
				String status_color = "";
				if(rs.getInt(3) == 1){
					status_color = "#43c643";
				}else{
					status_color = "#f02b2b";
				}
			%>
				<td align="center" style="vertical-align: middle;">
					<%if(rs.getInt(3) == 1){ %> <span
					style="color: green; font-size: 15pt; font-weight: bold">&#10003;</span>
					<%}else{ %> <span
					style="color: red; font-size: 15pt; font-weight: bold">&#8943;</span>
					<%} %>
				</td>

				<td align="center" style="vertical-align: middle;">
					<%
				if (rs.getInt(3) == 1) {
				%> <a target="_blank" title="View Lab Report"
					href="https://nawalokaepay.lk/labreport/labreport1.jsp?invoice=<%=ref%>&labno=<%=rs.getString(2)%>&lh=yes&ac=view"><i
						class="fa fa-file fa-lg"></i></a> <%
 } else {
 //out.println("Pending");
 }
 %>
				</td>

				<td align="center" style="vertical-align: middle;">
					<%
				if (rs.getInt(3) == 1) {
				%><a target="_blank" title="View Lab Report"
					href="https://nawalokaepay.lk/labreport/labreport1.jsp?invoice=<%=ref%>&labno=<%=rs.getString(2)%>&lh=yes&ac=print"><i
						class="fa fa-print fa-lg"></i></a> <%
 } else {
 //out.println("Pending");
 }
 %>
				</td>

			</tr>
			<%
		}
		%>

			<%
		if (count1 == 0) {
		%>
			<tr>
				<td colspan="4"><h2></h2></td>
			</tr>
			<tr>
				<td colspan="4" align="center"><h2 style="color: red">
						Error occurred...!<br />
					</h2></td>
			</tr>
			<tr>
				<td colspan="4"><h2></h2></td>
			</tr>
			<%
		} else if (count == 0) {
		%>
			<tr>
				<td colspan="4"><h2></h2></td>
			</tr>
			<tr>
				<td colspan="4" align="center"><h2 style="color: red">
						Processing...!<br />
					</h2></td>
			</tr>
			<tr>
				<td colspan="4"><h2></h2></td>
			</tr>
			<%
		}
		%>
		</table>
		<%if (count > 0) { %>
		<table align="right" style="margin-top: 20pt" width="100%">
			<tr>
				<td valign="bottom" align="right" style="font-size: 9pt;">Status
					Description: &nbsp;&nbsp;<span
					style="color: green; font-size: 9pt; font-weight: bold">&#10003;</span>
					Ready &nbsp;&nbsp;&nbsp;&nbsp;<span
					style="color: red; font-size: 9pt; font-weight: bold">&#8943;</span>
					Pending&nbsp;
				</td>
			</tr>
		</table>
		<%} %>
		<%
	} catch (Exception e) {
	System.out.println(e);
	} finally {
	conn.CloseDataBaseConnection();
	}
	%>
		<div
			style="background-color: #cceaef; border-radius: 1rem !important; padding-top: 10pt; padding-bottom: 10pt; margin: 100pt 3pt 0pt 3pt"><%@ include
				file="footer.jsp"%></div>
		<%@ include file="footerout.jsp"%>
	</div>
</body>
</html>