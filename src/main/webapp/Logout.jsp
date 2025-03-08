<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Logout</title>
</head>
<body>
	<%
	String unit_code_L = "";
	if (request.getParameter("unit_code") != null) {
		unit_code_L = request.getParameter("unit_code");
	}

		session.invalidate();
		response.sendRedirect("labreportsmcccloging.jsp?unit_code=" + unit_code_L);
	%>
</body>
</html>