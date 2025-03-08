<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="com.model.db.DatabaseConnection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.*"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Base64"%>
<%@page import="javax.crypto.Cipher"%>
<%@page import="javax.crypto.spec.SecretKeySpec"%>


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
	String title = "History | Laboratory Portal";
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
	String upin = "-";
	int a = 0;
	if (request.getParameter("upin") != null && request.getParameter("upin") != "null") {
		upin = request.getParameter("upin");	
		upin = decrypt(upin,"ABC@123");
	} else {
		upin = "XXXXXXXXXXXXXX";
	}

	if(upin == "null" || upin.equals("null")){
		a = 0;
		upin = "-";
	}
%>
<body>
	<div style="max-width: 1000px; margin: auto;">
		<div class="text-center"
			style="background-color: #9edae2; border-radius: 0.5rem !important; padding-top: 8pt; padding-bottom: 5pt; margin: 2pt 3pt 0pt 3pt">
			<div align="center">
				<img src="images/logo.png" class="img-rounded"
					alt="Nawaloka Laboratory" height="40">&nbsp;&nbsp;NAWALOKA
				HOSPITALS PLC
				<div align="center" style="margin-top: 0pt; color: green">
					<b><%=title%></b>
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
			String query = "SELECT TO_CHAR(SYSDATE-150,'DD/MM/YYYY'), TO_CHAR(SYSDATE,'DD/MM/YYYY') FROM DUAL";
			ResultSet rs = conn3.query(query);
			while (rs.next()) {
				date_from = rs.getString(1);
				date_to = rs.getString(2);
			}
		} catch (Exception e) {
			System.out.println(e);
		} finally {
			conn3.CloseDataBaseConnection();
		}
		}
%>

		<div class="text-center">
			<table border="0" align="center">
				<tr>
					<td></td>
				</tr>
			</table>
		</div>

		<div align="center">
			<form method="post" action="">
				<input type="hidden" name="upin" value="<%=upin%>">
				<table border="0" align="center"
					style="margin: 10pt 0pt 10pt 0pt; font-size: 11pt;">
					<tr>
						<td rowspan="2" valign="middle" align="right">Date Range
							&nbsp;</td>
						<td>From</td>
						<td><input readonly="readonly" style="text-align: center;"
							type="text" class="input" id="date_from" tabindex="1"
							value="<%=date_from%>" size="10" name="date_from"> <i
							class="fa fa-calendar" aria-hidden="true"></i></td>
						<td rowspan="2" valign="middle">&nbsp;&nbsp;&nbsp;<input
							type="submit" class="btn btn-primary" value="Search"></td>
					</tr>


					<tr>
						<td>To</td>
						<td><input readonly="readonly" style="text-align: center;"
							type="text" class="input" id="date_to" tabindex="2"
							value="<%=date_to%>" size="10" name="date_to"> <i
							class="fa fa-calendar" aria-hidden="true"></i></td>
					</tr>
				</table>
			</form>
		</div>
		<%
		DatabaseConnection conn = new DatabaseConnection();
		try {
			conn.ConnectToDataBase();

			String query = "select to_char(li.TXN_DATE,'yyyy/mm/dd') TXN_DATE, li.INVOICE_NO, li.NAME_BHT NAME, LI.SEX, LI.AGE_YY || 'Y ' || LI.AGE_MM || 'M' AGE "
			+ "from lab_test_invoices@COLOMBO_LIVE li, lab_test_credit@COLOMBO_LIVE lc "
			+ "where lc.INVOICE_NO = li.INVOICE_NO and li.STATUS =1 " + "and li.upin = '" + upin + "' "
			+ "and li.TXN_DATE between to_date('" + date_from + "','dd/mm/yyyy') and to_date('" + date_to + "','dd/mm/yyyy')+1 "
			
			+ "UNION ALL "

			+ "select to_char(li.TXN_DATE,'yyyy/mm/dd') TXN_DATE, li.INVOICE_NO, li.NAME_BHT NAME, LI.SEX, LI.AGE_YY || 'Y ' || LI.AGE_MM || 'M' AGE "
			+ "from lab_test_invoices@COLOMBO_LIVE li, MEDI_PACK_credit@COLOMBO_LIVE lc " 
			+ "where LI.INVOICE_NO = LC.SERVICE_REF_NO and li.STATUS =1 and li.upin = '" + upin + "' and li.TXN_DATE between to_date('" + date_from + "','dd/mm/yyyy') " 
			+ "and to_date('" + date_to + "','dd/mm/yyyy')+1 "
			
			+ "UNION ALL "
			+ "select to_char(li.TXN_DATE,'yyyy/mm/dd') TXN_DATE, li.INVOICE_NO,li.NAME_BHT, LI.SEX, LI.AGE_YY || 'Y ' || LI.AGE_MM || 'M' "
			+ "from lab_test_invoices@COLOMBO_LIVE li, cashier_collection@COLOMBO_LIVE cc "
			+ "where li.INVOICE_NO = cc.SERVICE_REF_NO and li.STATUS =1 " + "and li.upin = '"+ upin +"' "
			+ "and li.TXN_DATE between to_date('" + date_from + "','dd/mm/yyyy') and to_date('" + date_to + "','dd/mm/yyyy')+1 "
			
			+ "UNION ALL "
			+ "SELECT TO_CHAR (la.txn_date, 'yyyy/mm/dd') AS txndate, la.invoice_no, lt.name_bht, LT.SEX, LT.AGE_YY || 'Y ' || LT.AGE_MM || 'M' AGE "
			+ "FROM lab_agent_invoices@COLOMBO_LIVE la, lab_test_invoices@COLOMBO_LIVE lt "
			+ "WHERE lt.upin = '"+ upin +"' AND la.invoice_no = lt.invoice_no  AND lt.status = 1 "
			+ "AND la.txn_date BETWEEN TO_DATE ('"+date_from+"', 'DD/MM/YYYY') AND TO_DATE ('"+date_to+"', 'DD/MM/YYYY')+1 "
			+ "AND (  la.net_amount  - NVL ((SELECT SUM (lb.amount) - (SUM (lb.amount) * (u.discount_mgn) / 100) "
			+ "AS amt  FROM lab_test_breakdown@COLOMBO_LIVE lb, metro_labs@COLOMBO_LIVE ml, units@COLOMBO_LIVE u "
			+ "WHERE lt.invoice_no = lb.invoice_no  AND la.invoice_no = lt.invoice_no "
			+ "AND lb.status = 0  AND la.invoice_no NOT IN ( "
			+ "SELECT lr.invoice_no FROM lab_test_refund@COLOMBO_LIVE lr WHERE lr.invoice_no = la.invoice_no "
			+ "AND lr.status = 1 GROUP BY lr.invoice_no)  AND lt.upin = '"+ upin +"' AND ml.clinic_id = la.clinic_id AND ml.lab_type = 3 "
			+ "AND u.unit_code = ml.unit_code  GROUP BY lt.invoice_no, u.discount_mgn),  0 ) ) != 0 " + "order by 1 desc, 2 desc";
			//out.println(query + "<br/><br/>");
			ResultSet rs = conn.query(query);
		%>
		<table class="table table-striped table-bordered table-sm"
			style="margin-top: 0pt; font-size: 10pt" cellspacing="0" width="100%">
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
					<th style="text-align: left;">Age</th>
					<th style="text-align: center;"></th>
				</tr>
			</thead>
			<%
			}
			%>
			<tr>
				<td><%=count%>.</td>
				<td style="text-align: center; font-weight: bold;"><%=rs.getString(1)%></td>
				<td style="text-align: center; font-weight: bold;"><%=rs.getString(2)%></td>
				<td style="text-align: left;"><%=rs.getString(5)%></td>
				<td style="text-align: center;"><input type="submit" style="font-size: 9pt"
					class="btn btn-dark" value="More"
					onclick="window.open('https://nawalokaepay.lk/labreport/reportview.jsp?p=<%=rs.getString(2)%>_<%=upin%>&mc_cc=no&lh=true')">
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
		<div
			style="background-color: #cceaef; border-radius: 0.5rem !important; padding-top: 10pt; padding-bottom: 10pt; margin: 100pt 3pt 0pt 3pt"><%@ include
				file="footer.jsp"%></div>
		<%@ include file="footerout.jsp"%>
	</div>
</body>
<%!
	private static SecretKeySpec secretKey;
	private static byte[] key;
	private static final String ALGORITHM = "AES";


    // Decrypt method for URL-safe Base64 encoding
    public String decrypt(String strToDecrypt, String secret) {
        try {
            prepareSecreteKey(secret);
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.DECRYPT_MODE, secretKey);

            // Decode using URL-safe Base64
            byte[] decodedBytes = Base64.getUrlDecoder().decode(strToDecrypt);
            return new String(cipher.doFinal(decodedBytes), StandardCharsets.UTF_8);
        } catch (Exception e) {
            System.out.println("Error while decrypting: " + e.toString());
        }
        return null;
    }

    public void prepareSecreteKey(String myKey) {
        MessageDigest sha = null;
        try {
            key = myKey.getBytes(StandardCharsets.UTF_8);
            sha = MessageDigest.getInstance("SHA-1");
            key = sha.digest(key);
            key = Arrays.copyOf(key, 16); // Ensure key is 16 bytes (128 bits)
            secretKey = new SecretKeySpec(key, ALGORITHM);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
    }
%>
</html>