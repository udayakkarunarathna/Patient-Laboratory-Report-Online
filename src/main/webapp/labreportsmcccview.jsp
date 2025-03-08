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
<link rel="stylesheet"
	href="font-awesome-4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="font-awesome-4.7.0/css/font-awesome.css">
<link rel="stylesheet" href="jquery/jquery-ui.css">
<script src="jquery/jquery-1.10.2.js"></script>
<script src="jquery/jquery-ui.js"></script>
<script src="js/bootstrap.bundle.min.js"></script>
<link href="css/bootstrap.min.css" rel="stylesheet">
<%
	String title = "Laboratory Portal";
%>
<title><%=title%> | Nawaloka Hospital</title>
<script type="text/javascript">
	$(function() {
		$("#date_from").datepicker({
			dateFormat : 'dd/mm/yy',
			changeYear : true,
			changeMonth : true,
			numberOfMonths : 1,
			yearRange : '-20:+5',
			onClose : function(selectedDate) {
				$("#date_to").datepicker("option", "minDate", selectedDate);
			}
		});
		$("#date_to").datepicker({
			dateFormat : 'dd/mm/yy',
			changeYear : true,
			changeMonth : true,
			numberOfMonths : 1,
			yearRange : '-20:+5',
			onClose : function(selectedDate) {
				$("#date_from").datepicker("option", "maxDate", selectedDate);
			}
		});
	});
</script>
</head>
<%
String password = "";
if (request.getParameter("password") != null) {
	password = request.getParameter("password");
}
String branch_code_name = "", unit_code = "", unit_name = "", letter_head = "";
if (request.getParameter("branch_code_name") != null) {
	branch_code_name = request.getParameter("branch_code_name");
	unit_code = request.getParameter("branch_code_name").split("~")[0];
	unit_name = request.getParameter("branch_code_name").split("~")[1];
	letter_head = request.getParameter("branch_code_name").split("~")[2];
}
//out.println(unit_code);
%>
<body>
	<%if(password.equals(unit_code)){ %>
	<div style="margin: auto; width: 98%">
		<div class="text-center"
			style="background-color: #9edae2; border-radius: 0.5rem !important; padding-top: 8pt; padding-bottom: 5pt; margin: 2pt 3pt 0pt 3pt">
			<div align="center">
				<div align="right">
					<a href="Logout.jsp?unit_code=<%=unit_code%>" style="font-size: 17px"><b>Logout</b></a>&nbsp;&nbsp;<a
						href="Logout.jsp?unit_code=<%=unit_code%>"><i class="fa fa-sign-out fa-2x"
						aria-hidden="true"></i></a>
				</div>
				<div style="margin-top: -25pt;">
					<img src="images/logo.png" class="img-rounded"
						alt="Nawaloka Laboratory" height="40">&nbsp;&nbsp;NAWALOKA
					HOSPITALS PLC
					<div align="center" style="margin-top: -7pt; color: green">
						<b><%=title%></b>
					</div>
					<div align="center" style="color: #e31717; font-weight: bold;"><%=unit_name%>
						-
						<%=unit_code%></div>
				</div>
			</div>
		</div>
		<%
		
		String date_from = "";
		String date_to = "";

		if (request.getParameter("date_from") != null) {
			date_from = request.getParameter("date_from");
		}
		if (request.getParameter("date_to") != null) {
			date_to = request.getParameter("date_to");
		}
		
		if(date_from.equals("")){
		DatabaseConnection conn3 = new DatabaseConnection();
		try {
			conn3.ConnectToDataBase();
			String query = "SELECT TO_CHAR(SYSDATE,'DD/MM/YYYY') FROM DUAL";
			ResultSet rs = conn3.query(query);
			while (rs.next()) {
				date_from = rs.getString(1);
				date_to = rs.getString(1);
			}
		} catch (Exception e) {
			System.out.println(e);
		} finally {
			conn3.CloseDataBaseConnection();
		}
		}
%>

		<form method="post" action="">
			<input type="hidden" name="branch_code_name"
				value="<%=branch_code_name%>"> <input type="hidden"
				name="password" value="<%=password%>">
			<table border="0" align="center">
				<tr>
					<td valign="middle">Date Range</td>
					<td align="left" valign="middle" width="30px;">:</td>
					<td valign="middle">From &nbsp;<input readonly="readonly"
						style="text-align: center;" type="text" class="input"
						id="date_from" tabindex="1" value="<%=date_from%>" size="10"
						name="date_from"> <i class="fa fa-calendar"
						aria-hidden="true"></i>&nbsp;&nbsp;&nbsp; To &nbsp;<input
						readonly="readonly" style="text-align: center;" type="text"
						class="input" id="date_to" tabindex="2" value="<%=date_to%>"
						size="10" name="date_to"> <i class="fa fa-calendar"
						aria-hidden="true"></i></td>
					<td height="50pt;" width="25pt">&nbsp;</td>
					<td><input type="submit" class="btn btn-primary"
						value="Search"></td>
				</tr>
			</table>
		</form>
		<%
		DatabaseConnection conn = new DatabaseConnection();
		try {
			conn.ConnectToDataBase();
			String MOL_query = "";
			if(unit_code.equals("LAB04594")){
				MOL_query = " UNION ALL "
				+ " select to_char(li.TXN_DATE,'dd/mm/yyyy') TXN_DATE, li.INVOICE_NO, li.NAME_BHT NAME, LI.SEX, LI.AGE_YY || 'Y ' || LI.AGE_MM || 'M' AGE " 
				+ " from lab_test_invoices@COLOMBO_LIVE li, MEDICAL_PACKAGES@COLOMBO_LIVE MP "
				+ " where LI.PACKAGE_ID = MP.PACKAGE_ID AND MP.PACKAGE_NAME LIKE '%ONE WELLNESS%' AND LI.INVOICE_NO LIKE 'MOL%' AND LI.TXN_TYPE = 'LAB' and li.STATUS =1 "
				+ " and li.TXN_DATE between to_date('"+date_from+"','dd/mm/yyyy') and to_date('"+date_to+"','dd/mm/yyyy')+1 ";
			}

			String query = "select to_char(li.TXN_DATE,'dd/mm/yyyy') TXN_DATE, li.INVOICE_NO, li.NAME_BHT NAME, LI.SEX, LI.AGE_YY || 'Y ' || LI.AGE_MM || 'M' AGE "
			+ "from lab_test_invoices@COLOMBO_LIVE li, lab_test_credit@COLOMBO_LIVE lc "
			+ "where lc.INVOICE_NO = li.INVOICE_NO and li.STATUS =1 " + "and lc.CREDIT_AGENT_ID = '"+unit_code+"' "
			+ "and li.TXN_DATE between to_date('"+date_from+"','dd/mm/yyyy') and to_date('"+date_to+"','dd/mm/yyyy')+1 "
			+ "UNION ALL "
			+ "select to_char(li.TXN_DATE,'dd/mm/yyyy') TXN_DATE, li.INVOICE_NO,li.NAME_BHT, LI.SEX, LI.AGE_YY || 'Y ' || LI.AGE_MM || 'M' "
			+ "from lab_test_invoices@COLOMBO_LIVE li, cashier_collection@COLOMBO_LIVE cc "
			+ "where li.INVOICE_NO = cc.SERVICE_REF_NO and li.STATUS =1 " + "and li.COMPANY_ID = '"+unit_code+"' "
			+ "and li.TXN_DATE between to_date('"+date_from+"','dd/mm/yyyy') and to_date('"+date_to+"','dd/mm/yyyy')+1 "
			+ "UNION ALL "
			+ "SELECT TO_CHAR (la.txn_date, 'DD/MM/YYYY') AS txndate, la.invoice_no, lt.name_bht, LT.SEX, LT.AGE_YY || 'Y ' || LT.AGE_MM || 'M' AGE "
			+ "FROM lab_agent_invoices@COLOMBO_LIVE la, lab_test_invoices@COLOMBO_LIVE lt "
			+ "WHERE la.clinic_id = '"+unit_code+"' AND la.invoice_no = lt.invoice_no  AND lt.status = 1 "
			+ "AND la.txn_date BETWEEN TO_DATE ('"+date_from+"', 'DD/MM/YYYY') AND TO_DATE ('"+date_to+"', 'DD/MM/YYYY') "
			+ "AND (  la.net_amount  - NVL ((SELECT SUM (lb.amount) - (SUM (lb.amount) * (u.discount_mgn) / 100) "
			+ "AS amt  FROM lab_test_breakdown@COLOMBO_LIVE lb, metro_labs@COLOMBO_LIVE ml, units@COLOMBO_LIVE u "
			+ "WHERE lt.invoice_no = lb.invoice_no  AND la.invoice_no = lt.invoice_no "
			+ "AND lb.status = 0  AND la.invoice_no NOT IN ( "
			+ "SELECT lr.invoice_no FROM lab_test_refund@COLOMBO_LIVE lr WHERE lr.invoice_no = la.invoice_no "
			+ "AND lr.status = 1 GROUP BY lr.invoice_no)  AND la.clinic_id = '"+unit_code+"' AND ml.clinic_id = la.clinic_id AND ml.lab_type = 3 "
			+ "AND u.unit_code = ml.unit_code  GROUP BY lt.invoice_no, u.discount_mgn),  0 ) ) != 0 " 
			+ "UNION ALL "
			+ "SELECT "
			+ "to_char(MI.TXN_DATE,'dd/mm/yyyy') TXN_DATE, MI.SERVICE_REF_NO, MI.NAME, MI.GENDER, C.AGE_YY || 'Y ' || C.AGE_MM || 'M' AGE "
			+ "FROM MEDI_PACK_CREDIT@COLOMBO_LIVE MC, MEDI_PACK_INVOICES@COLOMBO_LIVE MI, OPD_CREDIT_PATIENTS@COLOMBO_LIVE C " 
			+ "WHERE C.REG_NO = MC.OPD_REG_NO AND MC.SERVICE_REF_NO = MI.SERVICE_REF_NO AND MC.CREDIT_AGENT_ID = '"+unit_code+"' AND MC.STATUS = 1 AND MI.STATUS = 1 "
			+ "AND MI.TXN_DATE between to_date('"+date_from+"','dd/mm/yyyy') and to_date('"+date_to+"','dd/mm/yyyy')+1 "
			+ MOL_query
			+ "order by 2, 3";
			//out.println(query + "<br/><br/>");
			ResultSet rs = conn.query(query);
		%>
		<table class="table table-striped table-bordered table-sm"
			style="margin-top: 0pt;" cellspacing="0" width="100%">
			<%
			int count = 0;
			while (rs.next()) {
				count++;
				if (count == 1) {
			%>
			<thead>
				<tr style="background-color: #b8a6f5; color: white">
					<th>#</th>
					<th style="text-align: center;">Date</th>
					<th style="text-align: center;">Ref. No</th>
					<th style="text-align: left;">Patient Name</th>
					<th style="text-align: left;">Gender</th>
					<th style="text-align: left;">Age</th>
					<th style="text-align: left; width: 80pt">Letter-Head</th>
					<th style="text-align: center;"></th>
				</tr>
			</thead>
			<%
			}
			%>
			<tr>
				<td><%=count%>.</td>
				<td style="text-align: center;"><%=rs.getString(1)%></td>
				<td style="text-align: center; font-weight: bold;"><%=rs.getString(2)%></td>
				<td style="text-align: left; font-weight: bold;"><%=rs.getString(3)%></td>
				<td style="text-align: left;"><%=rs.getString(4)%></td>
				<td style="text-align: left;"><%=rs.getString(5)%></td>
				<td style="text-align: center;" align="center"><div
						style="padding-left: auto;" class="form-check form-switch">
						<input class="form-check-input" type="checkbox" name="darkmode"
							id="darkmode<%=count%>" value="yes"
							<%if(letter_head.equals("1")){ %> checked <%} %>>
					</div></td>
				<td style="text-align: center;"><input type="submit"
					class="btn btn-success" value=" View "
					onclick="window.open('https://nawalokaepay.lk/labreport/reportview.jsp?uc=<%=unit_code%>&p=<%=rs.getString(2)%>_NH&mc_cc=yes&lh='+document.getElementById('darkmode<%=count%>').checked)">
				</td>
			</tr>
			<%
			}
			%>
			<%
			if (count == 0) {
			%>
			<tr style="margin-top: 50pt">
				<td align="center"><br /></td>
			</tr>
			<tr>
				<td align="center"><h2 style="color: red">
						No data...!<br />
					</h2></td>
			</tr>
			<tr>
				<td align="center"><br /></td>
			</tr>
			<%
			}
			%>
		</table>

		<%
		} catch (Exception e) {
		System.out.println(e);
		} finally {
		conn.CloseDataBaseConnection();
		}
		%>
		<%if(!unit_code.equals("LAB04596") && !unit_code.equals("LAB04594")){%>
		<div
			style="background-color: #cceaef; border-radius: 0.5rem !important; padding-top: 10pt; padding-bottom: 10pt; margin: 100pt 3pt 0pt 3pt"><%@ include
				file="footer.jsp"%></div>
		<%@ include file="footerout.jsp"%>
		<%}%>
	</div>
	<%}else{ %>
	<div
		style="margin: auto; width: 50%; margin-top: 100pt; color: red; border: 1px solid black; padding-top: 30pt; padding-bottom: 30pt"
		align="center">
		<h1>Incorrect Password...</h1>
		<br /> <input type="button" class="btn btn-danger" value="<< Back"
			onclick="history.go(-1)">
	</div>
	<%} %>
</body>
</html>