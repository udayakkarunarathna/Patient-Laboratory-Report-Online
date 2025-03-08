<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="com.model.db.DatabaseConnection"%>
<%@page import="java.sql.ResultSet"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Footer</title>
</head>
<body>
	<%
	String cen_name1 = "", cen_name2 = "", cen_address = "", cen_tp1 = "", cen_tp2 = "", fax = "", email_footer = "";
	if (session.getAttribute("cen_name1") == null) {
		DatabaseConnection connF = new DatabaseConnection();
		try {
			connF.ConnectToDataBase();
			String queryF = "SELECT C.HOSPITAL_NAME, C.HOSPITAL_NAME, C.ADDRESS, C.TELE, ' ', C.FAX, ' ' FROM CASHIER_COLLECTION_ACCOUNTS@COLOMBO_LIVE C WHERE C.ACC_ID = 'A001'";
			ResultSet rsF = connF.query(queryF);
			while (rsF.next()) {
		cen_name1 = rsF.getString(1);
		cen_name2 = rsF.getString(2);
		cen_address = rsF.getString(3);
		cen_tp1 = rsF.getString(4);
		cen_tp2 = rsF.getString(5);
		fax = rsF.getString(6);
		email_footer = rsF.getString(7);
			}
			session.setAttribute("cen_name1", cen_name1);
			session.setAttribute("cen_name2", cen_name2);
			session.setAttribute("cen_address", cen_address);
			session.setAttribute("cen_tp1", cen_tp1);
			session.setAttribute("cen_tp2", cen_tp2);
			session.setAttribute("fax", fax);
			session.setAttribute("email", email_footer);
		} catch (Exception e) {
			System.out.println(e);
		} finally {
			connF.CloseDataBaseConnection();
		}
	} else {
		cen_name2 = (String) session.getAttribute("cen_name2");
		cen_address = (String) session.getAttribute("cen_address");
		cen_tp1 = (String) session.getAttribute("cen_tp1");
		cen_tp2 = (String) session.getAttribute("cen_tp2");
		fax = (String) session.getAttribute("fax");
		email_footer = (String) session.getAttribute("email");
	}
	%>
	<center>
		<div class="text-center">
			<font size="1pt"><%=cen_address%></font>
		</div>
		<div class="text-center">
			<font size="1pt"><%=cen_tp1%></font>
		</div>
		<div class="text-center">
			<font size="1pt"><%=fax%></font>
		</div>
	</center>
</body>
</html>