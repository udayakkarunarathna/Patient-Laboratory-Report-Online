<!DOCTYPE html>
<%@ page import="com.model.dao.*"%>
<%@ page import="com.model.db.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.URLConnection"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.text.*"%>
<%@ page import="java.math.RoundingMode"%>
<%@ page import="java.net.*"%>

<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Base64"%>
<%@page import="javax.crypto.Cipher"%>
<%@page import="javax.crypto.spec.SecretKeySpec"%>


<html>
<title>Nawaloka Lab Reports Online</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="css/normalize.min.css">
<link rel="stylesheet" href="css/paper.css">
<link rel="icon" href="images/logo.png" type="image/x-icon">
<style>
@page {
	size: A4
}
</style>
<%
//String invoice = request.getParameter("invoice");
//String lab_no = request.getParameter("labno");


String invoice = "-";
if (request.getParameter("invoice") != null && request.getParameter("invoice") != "null") {
	invoice = request.getParameter("invoice");
	System.out.println("invoice = |" + invoice + "|");
	invoice = decrypt(invoice,"ABC@12345");
	System.out.println("invoice = |" + invoice + "|");
}
String lab_no = "-";
if (request.getParameter("labno") != null && request.getParameter("labno") != "null") {
	lab_no = request.getParameter("labno");
	System.out.println("lab_no = |" + lab_no + "|");	
	lab_no = decrypt(lab_no,"ABC@1234567");
	System.out.println("lab_no = |" + lab_no + "|");
}


String lh = request.getParameter("lh");
String ac = request.getParameter("ac");

String header_include = "", uc = "";
String Spe = "";
String[] Spe_arr = null;

if (request.getParameter("uc") != null) {
	uc = request.getParameter("uc");
}

if(lh.equals("yes")){
	lh = "true";
}

String dash = " ";
%>
<body class="A4" <%if(ac.equals("print")){ %> onload="this.window.print()" <%} %>>
	<%
	
	
	DatabaseConnection connAG = new DatabaseConnection();
	ResultSet rsAG = (ResultSet) null;
	
	ReferenceRangeCls rr = new ReferenceRangeCls();
	int AGE_DAYS = 0, GENDER = 0;
	
	try {
		connAG.ConnectToDataBase();
		String queryAG = "SELECT NVL(LI.AGE_YY,0)*365 + DECODE(NVL(LI.AGE_MM,0), 0, 30, NVL(LI.AGE_MM,0)*30) AGE_DAYS, " 
				+"DECODE(LI.SEX, 'MALE', 1, 'FEMALE', 2) GENDER " 
				+"FROM LAB_TEST_INVOICES@COLOMBO_LIVE LI WHERE LI.INVOICE_NO = '" + invoice + "'";
		//System.out.println(queryAG);
		rsAG = connAG.query(queryAG);
        while (rsAG.next()) {
            AGE_DAYS = rsAG.getInt("AGE_DAYS");
            GENDER = rsAG.getInt("GENDER");
        }
	} catch (SQLException e) {
		connAG.CloseDataBaseConnection();
	} finally {
		connAG.CloseDataBaseConnection();
	}
	
	int responseCode = 0;
	int responseCode2 = 0;
	String a_user = "";
	StringTokenizer st1forjsf = null;
	String test_code = "";
	String tempforjsf = "", temp2forjsf = "", tok1forjsf = null, temp3forjsf = "";
	java.util.Map<String, String> reportheaderHashMap = null;
	session = request.getSession(false);
	CriticalAlert criticalAlert = new CriticalAlert();
	boolean isHavingAlert = false;
	String Staff_name = "";
	String pathologist = "";
	ResultSet rs = (ResultSet) null;
	ResultSet rs1 = (ResultSet) null;
	ResultSet rs2 = (ResultSet) null;
	ResultSet rs3 = (ResultSet) null;
	ResultSet rs4 = (ResultSet) null;
	ResultSet rs5 = (ResultSet) null;
	ResultSet rs6 = (ResultSet) null;
	ResultSet rs7 = (ResultSet) null;
	ResultSet rs10 = (ResultSet) null;
	ResultSet rs11 = (ResultSet) null;
	ResultSet rs12 = (ResultSet) null;
	ResultSet urs = (ResultSet) null;
	DatabaseConnection conn = new DatabaseConnection();
	DatabaseConnection conn1 = new DatabaseConnection();
	DatabaseConnection conn2 = new DatabaseConnection();
	int diss = 0;
	String query = " select lab_ref_no,invoice_no,test_profile_code,nvl(TO_CHAR (sample_collected_time,'DD/MM/YYYY'),"
	+"TO_CHAR(sysdate,'DD/MM/YYYY'))sample_collected_date,nvl(TO_CHAR(sample_collected_time,'HH:MI AM'),"
	+"to_char(sysdate,'HH:MI AM'))sample_collected_time,AUTHORIZED_USER "
	+"from lab_test_breakdown@COLOMBO_LIVE where lab_ref_no='"
			+ lab_no + "'";
	//System.out.println(query);
	try {
		String roomNo = "";
		conn.ConnectToDataBase();
		conn1.ConnectToDataBase();
		conn2.ConnectToDataBase();
		int i = 0;
		rs = conn.query(query);
		String code1 = "";
		test_code = "";
		String lab_no1 = "";
		String comment = "";
		String special_ref_range = "";
		String Authorised_status = "";
		String agentName = "", Receiptno = "";
		String mediPack = "", mediPackShort = "";
		String tcom = null;
		ResultSet rsnew = (ResultSet) null;
		ResultSet rsnew2 = (ResultSet) null;
		ResultSet rsnew3 = (ResultSet) null;
		ResultSet rs7new = (ResultSet) null;
		DatabaseConnection conn1NEW = new DatabaseConnection();
		DatabaseConnection conn2NEW = new DatabaseConnection();
		DatabaseConnection conn3NEW = new DatabaseConnection();
		int covd = 0;
		DatabaseConnection conn210 = new DatabaseConnection();
		ResultSet rs210 = null;
		String test10 = "SELECT COUNT(*) FROM LAB_TEST_BREAKDOWN@COLOMBO_LIVE B WHERE B.LAB_REF_NO = '" + lab_no
		+ "' AND B.TEST_PROFILE_CODE IN (SELECT L.TEST_CODE FROM LAB_TESTS@COLOMBO_LIVE L WHERE L.DESCRIPTION LIKE '%COVID%' UNION SELECT L.PROFILE_CODE FROM LAB_PROFILE@COLOMBO_LIVE L WHERE L.DESCRIPTION LIKE '%COVID%')";
		//System.out.println(test10);
		int gg10 = 0;
		try {
			conn210.ConnectToDataBase();
			rs210 = conn210.query(test10);
			while (rs210.next()) {
		covd = rs210.getInt(1);
			}
			conn210.CloseDataBaseConnection();
		} catch (Exception e) {
			conn210.CloseDataBaseConnection();
		}


		if(lh.equals("true")){
			header_include = "background: white url('images/header.jpg') no-repeat center; background-size: 100% 100%;";
		}
	%>

	<section class="sheet padding-5mm"  style="<%=header_include%>">
		<!-- Write HTML just like a web page -->
		<article>
			<header>
				<%
				// For PANADURA and BATTARAMULLA leter head issue
				if(uc.equals("LAB00278") || uc.equals("LAB00052")){ %>
				<br/><br/>
				<%} %>
				<%
				if (covd > 0 && lh.equals("true")) {
				%>
				<%@include file="newjsp_LHcovid.jspf"%>
				<%
				} else if (covd > 0) {
				%>
				<%@include file="newjspcovid.jspf"%>
				<%
				} else if (lh.equals("false")) {
				%>
				<%@include file="newjsp.jspf"%>
				<%
				} else {
				%>
				<%@include file="newjsp_LH.jspf"%>
				<%
				}
				%>
			</header>
			<div id="content">
					<table width="100%" style="font-size: 10pt" border="0">
						<tr>
							<td width="30%"></td>
							<td></td>
							<td width="22%"></td>
							<td width="6%"></td>
							<td width="2%"></td>
							<td width="18%"></td>
						</tr>
						<%
						String staff_id = "", Imageurl = "";
						String query0 = " SELECT 'AA','SS','DD',AUTHORIZED_USER FROM LAB_TEST_BREAKDOWN@COLOMBO_LIVE WHERE lab_ref_no='"
								+ lab_no + "'  ";
						//System.out.println(query0);
						urs = conn.query(query0);
						while (urs.next()) {
							Staff_name = "";
							staff_id = "";
							a_user = urs.getString(4);
						}
						String Normal = "";
						String Flag = "";
						String testcomment = "";
						String squery2 = "";
						String testCodeId = "";
						if (code1.equals("T")) {
							int com = 0;
							squery2 = "select  i.description,nvl(i.result_type_flag,'1')result_type_flag,nvl(i.units,'-')units,nvl(i.ref_level1,'-')ref_level1,nvl(i.ref_level2,' -')ref_level2,nvl(replace(ref_extra,'<br>',chr(13)||chr(10)),'-')ref_extra from lab_tests@COLOMBO_LIVE i where test_code='"
							+ test_code + "'";
							//System.out.println(squery2);
							rs2 = conn.query(squery2);
							String query10 = "select nvl(normal_results,' ')normal_results,nvl(replace(special_results,'<br>',chr(13)||chr(10)),' ')special_results ,nvl(result_flag,' ')result_flag,authorised_status,nvl(replace(remarks,'<br>',chr(10)||chr(13)),'-')special_ref_range,test_id as testId  from lab_test_results@COLOMBO_LIVE where lab_ref_no='"
							+ lab_no1 + "'";
							//System.out.println(query10);
							rs3 = conn1.query(query10);
							while (rs3.next()) {
								Spe = rs3.getString("special_results");
								Normal = rs3.getString("normal_results");
								Flag = rs3.getString("result_flag");
								testcomment = rs3.getString("special_ref_range");
								Authorised_status = rs3.getString("authorised_status");
								testCodeId = rs3.getString("testId");
							}
							//Spe = "Xp.t.oYp.t.oZ";
							if(Spe.contains("p.t.o ")){
								Spe_arr = Spe.split("p.t.o ");
							}
							
							while (rs2.next()) {
								try {
							String desc = rs2.getString("description");
							String result_type_flag = rs2.getString("result_type_flag");
							String units = rs2.getString("units");							
							
							String ref1 = rs2.getString("ref_level1");
							String ref2 = rs2.getString("ref_level2");							

							dash = " ";
                            if (!ref1.equals(" ") && !ref2.equals(" ")) {
                                dash = "-";
                            }
							
							
							//Udaya - New reference ranges
							String ref_range = ref1 + " " + dash + " " + ref2;
							String real_ref_range = rr.getRealRefRange(test_code, AGE_DAYS, GENDER);
							if(!real_ref_range.equals("---")){
								ref_range = real_ref_range;
							}
							String ref1_new = ref1;
							String real_ref1 = rr.getRealRefRangeOne(test_code, AGE_DAYS, GENDER, 1);
							if(!real_ref1.equals("---")){
								ref1_new = real_ref1;
							} 
							String ref2_new = ref2;							
							String real_ref2 = rr.getRealRefRangeOne(test_code, AGE_DAYS, GENDER, 2);
							if(!real_ref2.equals("---")){
								ref2_new = real_ref2;
							}
							
							
							String refextra = rs2.getString("ref_extra");
							if (result_type_flag.equals("1")) {
								// only nomal result alert activates
								if (true || (!isHavingAlert) && (Normal != null) && (!Normal.equals(""))) {
									try {
										if (Normal.matches("-?\\d+(\\.\\d+)?")) {
											isHavingAlert = criticalAlert.isHavingAlert(testCodeId, Normal);
										}
									} catch (Exception e) {
										e.printStackTrace();
									}
								}
						%>
						<tr>
							<td height="5px" colspan="6"></td>
						</tr>
						<tr>
							<td height="10px" >TEST NAME</td>
							<td >RESULT</td>
							<td >UNITS</td>
							<td >FLAG</td>
							<td ></td>
							<td align="center">REF.RANGE</td>
						</tr>
						<tr>
							<td height="5px" colspan="6"></td>
						</tr>
						<%
						dash = " ";
						if (!ref1_new.equals(" ") && !ref2_new.equals(" ")) {
							dash = "-";
						}
						%>
						<tr class="boldCls">
							<td height="10px" width="30%"><%=desc%></td>
							<td><%=Normal%></td>
							<td width="22%"><%=units%></td>
							<td width="6%"><%=Flag%></td>
							<td width="2%"></td>
							<td align="center" width="18%"><%=ref_range%></td>
						</tr>
						<tr>
							<td height="5px" colspan="6"></td>
						</tr>
						<%
						if ((test_code.equals("P000120")) || (test_code.equals("P000043"))) {
						%>
						<tr class="boldCls">
							<td height="10px" colspan="6">CULTURE REPORT</td>
						</tr>
						<%
						} else {
						if (testcomment.equals("-") || testcomment.equals("null")) {
						} else {
							diss = 1;
						%>
						<%if(test_code.equals("T000004")){ %>
						<tr>
							<td height="30pt" colspan="6"></td>
						</tr>
						<%}
						%>
						<tr class="boldCls">
							<td height="10px" colspan="6">Description :</td>
						</tr>
						<%
						}
						}
						StringTokenizer st11 = new StringTokenizer(testcomment, "\n");
						String tok11 = null;
						while (st11.hasMoreTokens()) {
						tok11 = st11.nextToken().trim();
						if (testcomment.equals("-") || testcomment.equals("null")) {
						} else {
						%>
						<tr>
							<td height="10px" colspan="6" style="white-space: pre-wrap;"><%=tok11%></td>
						</tr>
						<%if(test_code.equals("T000004")){ %>
						<tr>
							<td height="40pt" colspan="6"></td>
						</tr>
						<%} %>
						<%
						}
						}
						if (diss == 0) {
						if ((test_code.equals("P000120")) || (test_code.equals("P000043"))) {
						%>
						<tr class="boldCls">
							<td height="10px" colspan="6">CULTURE REPORT</td>
						</tr>
						<%
						} else {
						if (testcomment.equals("-") || testcomment.equals("null")) {
						} else {
							diss = 1;
						%>
						<tr class="boldCls">
							<td height="10px" colspan="6">Description :</td>
						</tr>
						<%
						}
						}
						StringTokenizer st110 = new StringTokenizer(testcomment, "\n");
						String tok110 = null;
						while (st110.hasMoreTokens()) {
						tok110 = st110.nextToken().trim();
						if (testcomment.equals("-") || testcomment.equals("null")) {
						} else {
						%>
						<tr>
							<td height="10px" colspan="6" style="white-space: pre-wrap;"><%=tok110%></td>
						</tr>
						<%
						}
						}
						}
						if (refextra.equals(" ") || refextra.equals("-")) {
						} else {
						%>
						<%
						StringTokenizer st = new StringTokenizer(refextra, "\n");
						String tok = null;
						String temp;
						while (st.hasMoreTokens()) {
							tok = st.nextToken().trim();
							temp = tok;
							if (covd > 0) {
						%>

						<%
						}
						%>
						<tr>
							<td height="10px" colspan="6" style="white-space: pre-wrap;"><%=temp%></td>
						</tr>
						<%
						}
						}
						}
						// Biopsy
						else if (result_type_flag.equals("2")) {
						String result12 = "";
						int line_count = 0;
						try {
						String special_query = "select replace(replace(special_results,'<br>',chr(13)||chr(10)), ' ','_') from lab_test_results@COLOMBO_LIVE where lab_ref_no='"
								+ lab_no1 + "'";
						//System.out.println(special_query);
						rs6 = conn2.query(special_query);
						while (rs6.next()) {
						result12 = rs6.getString(1);
						}
						} catch (Exception e) {
						}
						%>
						<tr>
							<td height="10px" colspan="6" style="white-space: pre-wrap;" align="left"><%if(test_code.equals("T001177")){%><b><u><%=desc%></u></b><%}else{%><%=desc%><%}%></td>
						</tr>
						<%
						StringTokenizer st1 = new StringTokenizer(result12, "\n");
						String tok1 = null;
						String temp = "";
						String temp2 = "";
						int temp3;
						while (st1.hasMoreTokens()) {
							line_count++;
							tok1 = st1.nextToken();
							temp = tok1;
							tok1 = tok1.trim();
							if (!(tok1.equals(""))) {
								temp2 = tok1.substring(0, 1);
								temp3 = temp.indexOf(temp2);
								temp = temp.substring(0, temp3);
							}
						%>
						<tr>
							<td height="10px" colspan="6" style="white-space: pre-wrap;"><%=tok1.replace("_","&nbsp;")%></td>
						</tr>
						<%
						}
						if (refextra.equals(" ") || refextra.equals("-")) {
						} else {
						StringTokenizer st = new StringTokenizer(refextra, "\n");
						String tok = null;
						String tempp;
						while (st.hasMoreTokens()) {
							tok = st.nextToken().trim();
							tempp = tok;
						%>
						<tr>
							<td height="10px" colspan="6" style="white-space: pre-wrap;"><%=tempp%></td>
						</tr>
						<%
						}
						}
						} else if (result_type_flag.equals("3")) {
						//ABST without Urine Culture
						StringTokenizer st2 = new StringTokenizer(Spe, "\n");
						String tok2 = null;
						while (st2.hasMoreTokens()) {
						tok2 = st2.nextToken().trim();
						%>
						<tr>
							<td height="10px" colspan="6" style="white-space: pre-wrap;"><%=tok2%></td>
						</tr>
						<%
						}
						}
						} catch (Exception e) {
						e.printStackTrace();
						}
						}
						}
						if (code1.equals("P")) {
						String profileDes = "";
						String prorefextra = "";
						String testcomment1 = "";
						String quer1 = "select nvl(EACHTEST_NEWPAGE,'f') EACHTEST_NEWPAGE ,description,nvl(replace(ref_extra,'<br>',chr(13)||chr(10)),'-')prorefextra from lab_profile@COLOMBO_LIVE where profile_code='"
								+ test_code + "'";
						//System.out.println(quer1);
						rs4 = conn1.query(quer1);
						if (test_code.equals("P000056") || test_code.equals("P000013")) {
						double wbc = 0.0;
						String sp_results = "";
						String spquery = "select t.test_code, t.description,nvl(t.result_type_flag,'1')result_type_flag,nvl(t.units,' ')units,nvl(t.ref_level1,' ')ref_level1,nvl(t.ref_level2,' ')ref_level2,nvl(t.ref_extra,' ')ref_extra ,t.test_code,b.status from lab_tests@COLOMBO_LIVE t, profile_description@COLOMBO_LIVE b where  t.test_code=b.test_code and b.profile_code='"
								+ test_code + "'  and b.status='1' order by b.show_order asc";
						//System.out.println(spquery);
						rs10 = conn2.query(spquery);
						%>
						<%
						if (test_code.equals("P000056")) {
						%>
						<tr>
							<td height="10px" colspan="6"></td>
						</tr>
						<tr class="boldCls">
							<td height="10px" colspan="6"><u><i>FULL BLOOD COUNT</i></u></td>
						</tr>
						<%
						} else {
						%>
						<tr class="boldCls">
							<td height="10px" colspan="6"><u><i>WBC/DC</i></u></td>
						</tr>
						<%
						}
						%>
						<tr>
							<td height="10px" >TEST NAME</td>
							<td >RESULT</td>
							<td >UNITS</td>
							<td >FLAG</td>
							<td >AB.COUNT</td>
							<td align="center">REF.RANGE</td>
						</tr>
						<tr>
							<td height="5px" colspan="6"></td>
						</tr>
						<%
						String testcom = null;
						while (rs10.next()) {
							String sptestcode = rs10.getString("test_code");
							String spsquery2 = "select i.test_code,nvl(i.description,'*')description,nvl(i.result_type_flag,'1')result_type_flag,nvl(i.units,' ')units,nvl(i.ref_level1,' ')ref_level1,nvl(i.ref_level2,' ')ref_level2,nvl(t.normal_results,' ')normal_results,nvl(replace(t.special_results,'<br>',chr(13)||chr(10)),' ')special_results,nvl(replace(remarks,'<br>',chr(13)||chr(10)),'-')special_ref_range,nvl(replace(ref_extra,'<br>',chr(13)||chr(10)),'-')ref_extra,nvl(result_flag,' ')result_flag ,t.authorised_status,t.remarks from lab_tests@COLOMBO_LIVE i ,lab_test_results@COLOMBO_LIVE  t where i.test_code ='"
							+ sptestcode + "' and t.test_id=i.test_code and t.profile_id= '" + test_code + "'  and t.lab_ref_no='"
							+ lab_no1 + "' order by result_type_flag asc";
							//System.out.println(spsquery2);
							rs11 = conn.query(spsquery2);
							while (rs11.next()) {
								String spdescription = rs11.getString("description");
								String spresults = rs11.getString("normal_results");
								String spunits = rs11.getString("units");
								String result_flag = "";
								result_flag = rs11.getString("result_flag");
								String spref1 = rs11.getString("ref_level1");
								String spref2 = rs11.getString("ref_level2");
								String sptestcode1 = rs11.getString("test_code");
								
								dash = " ";
                                if (!spref1.equals(" ") && !spref2.equals(" ")) {
                                    dash = "-";
                                }
								
								//Udaya - New reference ranges
				    			String ref_range_sp = spref1 + " " + dash + " " + spref2;
				    			String real_ref_range_sp = rr.getRealRefRange(sptestcode1, AGE_DAYS, GENDER);
				    			if(!real_ref_range_sp.equals("---")){
				    				ref_range_sp = real_ref_range_sp;
				    			}
				    			String ref1_new_sp = spref1;
				    			String real_ref1_sp = rr.getRealRefRangeOne(sptestcode1, AGE_DAYS, GENDER, 1);
				    			if(!real_ref1_sp.equals("---")){
				    				ref1_new_sp = real_ref1_sp;
				    			} 
				    			String ref2_new_sp = spref2;							
				    			String real_ref2_sp = rr.getRealRefRangeOne(sptestcode1, AGE_DAYS, GENDER, 2);
				    			if(!real_ref2_sp.equals("---")){
				    				ref2_new_sp = real_ref2_sp;
				    			}
								
								
								String spremarks = rs11.getString("special_ref_range");
								Authorised_status = rs11.getString("authorised_status");
								testcomment = "-";
								sp_results = rs11.getString("special_results");
								testcom = rs11.getString("remarks");
								if (sptestcode1.equals("T000049")) {
							testcom = rs11.getString("remarks");
							testcomment = sp_results;
							tcom = sp_results;
								}
								if (sptestcode1.equals("T000045") || sptestcode1.equals("T000046") || sptestcode1.equals("T000047")
								|| sptestcode1.equals("T000048") || sptestcode1.equals("T000049") || sptestcode1.equals("T000044")) {
						%>
						<%
						dash = " ";
						if (!ref1_new_sp.equals(" ") && !ref2_new_sp.equals(" ")) {
							dash = "-";
						}
						%>
						<%
						String normal_res = spresults;
						String tok1 = null;
						String tok2 = null;
						String tok3 = null;
						try {
							DecimalFormat df = new DecimalFormat("#.##");
							DecimalFormat df1 = new DecimalFormat("#");
							df1.setRoundingMode(RoundingMode.DOWN);
							double abs = 0.0;
							if ((!isHavingAlert) && (normal_res != null) && (!normal_res.equals(""))) {
								try {
							if (normal_res.matches("-?\\d+(\\.\\d+)?")) {
								isHavingAlert = criticalAlert.isHavingAlert(sptestcode1, normal_res);
							}
								} catch (Exception e) {
							e.printStackTrace();
								}
							}
							if (sptestcode1.equals("T000044")) { //WBC
								try {
							if ((normal_res != null) && (!normal_res.trim().equals(""))) {
								if (normal_res.matches("-?\\d+(\\.\\d+)?")) {
									wbc = Double.parseDouble(normal_res);
								}
							}
								} catch (Exception e) {
							e.printStackTrace();
								}
						%>
						<tr class="boldCls">
							<td height="10px" colspan="6"><i>WHITE BLOOD CELLS</i></td>
						</tr>
						<tr class="boldCls">
							<td height="10px"><%=spdescription%></td>
							<td><%=normal_res%></td>
							<td><%=spunits%></td>
							<td><%=result_flag%></td>
							<td></td>
							<td align="center"><%=ref_range_sp%></td>
						</tr>
						<%
						} else {
						try {
							if ((normal_res != null) && (!normal_res.trim().equals(""))) {
								if (normal_res.matches("-?\\d+(\\.\\d+)?")) {
							abs = Double.parseDouble(normal_res) * wbc / 100;
								}
							}
						} catch (Exception e) {
							e.printStackTrace();
						}
						%>
						<tr class="boldCls">
							<td height="10px"><%=spdescription%></td>
							<td><%=normal_res%></td>
							<td><%=spunits%></td>
							<td><%=result_flag%></td>
							<td><%=df1.format(abs)%></td>
							<td align="center"><%=ref_range_sp%></td>
						</tr>
						<%
						}
						} catch (Exception e) {
						}
						%>
						<%
						if (test_code.equals("P000056") && sptestcode1.equals("T000049")) {
						%>
						<tr class="boldCls">
							<td height="10px" colspan="6"></td>
						</tr>
						<tr class="boldCls">
							<td height="10px" colspan="6"><i>RED BLOOD CELLS</i></td>
						</tr>
						<%
						}
						} else if (sptestcode.equals("T000074")) {
						%>
						<%
						} else {
						if ((!isHavingAlert) && (spresults != null) && (!spresults.equals(""))) {
							try {
								if (spresults.matches("-?\\d+(\\.\\d+)?")) {
							isHavingAlert = criticalAlert.isHavingAlert(sptestcode1, spresults);
								}
							} catch (Exception e) {
								e.printStackTrace();
							}
						}
						DecimalFormat df3 = new DecimalFormat("0.0");
						if (sptestcode1.equals("T000061")) {
							df3 = new DecimalFormat("#.#");
						} else {
							df3 = new DecimalFormat("0.0");
						}
						%>
						<%
						dash = " ";
						if (!ref1_new_sp.equals(" ") && !ref2_new_sp.equals(" ")) {
							dash = "-";
						}
						if (spresults == null || " ".equals(spresults) || "".equals(spresults)) {
						%>
						<tr>
							<td height="10px"><%=spdescription%></td>
							<td><%=spresults%></td>
							<td><%=spunits%></td>
							<td><%=result_flag%></td>
							<td></td>
							<td align="center"><%=ref_range_sp%></td>
						</tr>
						<%
						} else {
						double tmpRes = 0;						
						try {
							tmpRes = Double.parseDouble(spresults);
				        } catch (NumberFormatException e) {
				        	tmpRes = 0;
				        }
						
						df3.setRoundingMode(RoundingMode.DOWN);
						%>
						<%if(spdescription.equals("Platelet count")){ %>
						<tr>
							<td height="5pt" colspan="6"></td>
						</tr>
						<%} %>
						<tr class="boldCls">
							<td height="10px"><%=spdescription%></td>
							<td><%if((df3.format(tmpRes)).equals("0.0")){out.println(spresults);}else{%><%=df3.format(tmpRes)%><%}%></td>
							<td><%=spunits%></td>
							<td><%=result_flag%></td>
							<td></td>
							<td align="center"><%=ref_range_sp%></td>
						</tr>

						<%
						}
						}
						%>
						<%
						}
						%>
						<%
						}
						%>
						<tr>
							<td height="10px" colspan="6"></td>
						</tr>
						<%
						if (test_code.equals("P000056")) {
						%>
						<%
						String query2 = "";
						String ty = "";
						query2 = "SELECT nvl(replace(ref_extra,'<br>',chr(13)||chr(10)),'-')ref_extra FROM LAB_PROFILE@COLOMBO_LIVE P WHERE P.PROFILE_CODE = 'P000056'";
						//System.out.println(query2);
						DatabaseConnection conn2a = new DatabaseConnection();
						conn2a.ConnectToDataBase();
						ResultSet rs2a = null;
						try {
							rs2a = conn2a.query(query2);
							while (rs2a.next()) {
								ty = rs2a.getString(1);
							}
							conn2a.CloseDataBaseConnection();
						} catch (Exception e) {
							conn2a.CloseDataBaseConnection();
						}
						StringTokenizer st5 = new StringTokenizer(ty, "\n");
						String tok5 = null;
						String temp5;
						while (st5.hasMoreTokens()) {
							tok5 = st5.nextToken().trim();
							temp5 = tok5;
						%>
						<tr>
							<td height="10px" colspan="6" style="white-space: pre-wrap;"><%=temp5%></td>
						</tr>
						<%
						}
						}
						tcom = tcom.trim();
						try {
						if (testcom.trim().equals("")) {
						} else {
						%>
						<tr class="boldCls">
							<td height="10px" colspan="6">Special Comment</td>
						</tr>
						<%
						StringTokenizer st1 = new StringTokenizer(testcom, "\n");
						String tok1 = null;
						while (st1.hasMoreTokens()) {
							tok1 = st1.nextToken().trim();
						%>
						<tr>
							<td height="10px" colspan="6" style="white-space: pre-wrap;"><%=tok1%></td>
						</tr>
						<%
						}
						}
						%>
						<%
						} catch (Exception ex) {
						}
						%>
						<%
						//full blood count
						} else {
						while (rs4.next()) {
							profileDes = rs4.getString("description");
							prorefextra = rs4.getString("prorefextra");
						}
						squery2 = "select i.ref_extra,i.test_code,nvl(i.description,'*')description,nvl(i.result_type_flag,'1')result_type_flag,nvl(result_flag,' ')result_flag,nvl(i.units,' ')units,nvl(i.ref_level1,' ')ref_level1,nvl(i.ref_level2,' ')ref_level2,nvl(t.normal_results,' ')normal_results,nvl(replace(t.special_results,'<br>',chr(13)||chr(10)),' ')special_results,nvl(replace(t.remarks,'<br>',chr(13)||chr(10)),'-')special_ref_range,t.authorised_status,n.show_order from lab_tests@COLOMBO_LIVE i ,lab_test_results@COLOMBO_LIVE t, profile_description@COLOMBO_LIVE n   where i.test_code  in (select m.test_code from profile_description@COLOMBO_LIVE m where profile_code='"
								+ test_code + "' and m.status='1' )  and t.test_id=i.test_code and t.profile_id= '" + test_code
								+ "' and t.test_id=n.test_code and  t.profile_id=n.profile_code and t.lab_ref_no='" + lab_no1
								+ "' order by n.show_order asc";
						//System.out.println(squery2);
						rs5 = conn1.query(squery2);
						%>
						<tr class="boldCls">
							<td height="10px" colspan="6"><u><i><%=profileDes%></i></u></td>
						</tr>
						<%
						//P000351- HLA - ABDR TYPING
						if(!test_code.equals("P000351")){ 						
						%>
						<tr>
							<td height="10px" >TEST NAME</td>
							<td >RESULT</td>
							<td >UNITS</td>
							<td >FLAG</td>
							<td></td> <%-- AB.COUNT --%>
							<td align="center">REF.RANGE</td>
						</tr>
						<%} %>
						<tr>
							<td height="5px" colspan="6"></td>
						</tr>
						<%
						//P000351 - HLA - ABDR TYPING
						if(test_code.equals("P000351")){ 						
					%>
					<tr>
						<td colspan="6">
							<table border="1" style="border-collapse: collapse;" width="100%">
								<tr style="font-weight: bold;">
									<td height="20px"></td>
									<td width="18%" align="center" style="padding: 0px 2px">HLA-A</td>
									<td width="18%" align="center" style="padding: 0px 2px">HLA-B</td>
									<td width="18%" align="center" style="padding: 0px 2px">HLA-DRB1</td>
									<td width="18%" align="center" style="padding: 0px 2px">HLA-DRB3/4/5</td>
								</tr>
								<%								
								DatabaseConnection conn_HLA = new DatabaseConnection();
								ResultSet rs_HLA = null;
								String[] arr_HLA = new String[8];
								try {
									conn_HLA.ConnectToDataBase();
									String query_HLA = "SELECT NVL(L.NORMAL_RESULTS,'-') FROM LAB_TEST_RESULTS@COLOMBO_LIVE L, PROFILE_DESCRIPTION@COLOMBO_LIVE D "
											 +" Where L.PROFILE_ID  = D.PROFILE_CODE AND L.TEST_ID = D.TEST_CODE AND L.LAB_REF_NO = '" + lab_no + "' ORDER BY D.SHOW_ORDER";
									rs_HLA = conn_HLA.query(query_HLA);
									int len_HLA = 0;
									while (rs_HLA.next()) {
										arr_HLA[len_HLA] = rs_HLA.getString(1);
										len_HLA++;
									}
									conn_HLA.CloseDataBaseConnection();
								} catch (Exception e) {
									conn_HLA.CloseDataBaseConnection();
								}
								%>
								<tr>
									<td height="35px" style="padding: 0px 2px">HLA Genotype</td>
									<td align="center" style="padding: 0px 2px"><%=arr_HLA[0]%></td>
									<td align="center" style="padding: 0px 2px"><%=arr_HLA[1]%></td>
									<td align="center" style="padding: 0px 2px"><%=arr_HLA[2]%></td>
									<td align="center" style="padding: 0px 2px"><%=arr_HLA[3]%></td>
								</tr>
								<tr>
									<td height="35px" style="padding: 0px 2px">Interpreted Serology<br/>Equivalent</td>
									<td align="center" style="padding: 0px 2px"><%=arr_HLA[4]%></td>
									<td align="center" style="padding: 0px 2px"><%=arr_HLA[5]%></td>
									<td align="center" style="padding: 0px 2px"><%=arr_HLA[6]%></td>
									<td align="center" style="padding: 0px 2px"><%=arr_HLA[7]%></td>
								</tr>
							</table>
						</td>
					</tr>
					<%} %>
						<%
						if ((test_code.equals("P00012011")) || (test_code.equals("P000043"))) {
						%>
						<tr class="boldCls">
							<td height="10px" colspan="6">MICROSCOPY FINDINGS</td>
						</tr>
						<%
						}
						%>
						<%
						//P000351- HLA - ABDR TYPING
						if(!test_code.equals("P000351")){ 
						while (rs5.next()) {
							String refextra = rs5.getString("ref_extra");
							String desc = rs5.getString("description");
							String result = rs5.getString("result_type_flag");
							String codee = rs5.getString("test_code");
							String pntest = rs5.getString("normal_results");
							if (codee.equals("T001020") && pntest.equals("-")) {
								prorefextra = "";
							} else if (codee.equals("T002048") && pntest.equalsIgnoreCase("POSITIVE")) {
								prorefextra = prorefextra;
							} else if (codee.equals("T002048") && pntest.equalsIgnoreCase("NIL")) {
								prorefextra = "";
							} else if (codee.equals("T002048") && pntest.equals(" ")) {
								prorefextra = "";
							} else if (codee.equals("T002048") && pntest.equals("-")) {
								prorefextra = "";
							} else {
							}
							if ((!isHavingAlert) && (pntest != null) && (!pntest.equals(""))) {
								try {
							if (pntest.matches("-?\\d+(\\.\\d+)?")) {
								isHavingAlert = criticalAlert.isHavingAlert(codee, pntest);
							}
								} catch (Exception e) {
							e.printStackTrace();
								}
							}
							String pstest = rs5.getString("special_results");
							String result_flag = rs5.getString("result_flag");
							Authorised_status = rs5.getString("authorised_status");
							testcomment = rs5.getString("special_ref_range");
							String units = rs5.getString("units");
							String ref1 = rs5.getString("ref_level1");
							String ref2 = rs5.getString("ref_level2");
							
							dash = " ";
                            if (!ref1.equals(" ") && !ref2.equals(" ")) {
                                dash = "-";
                            }
							
							//Udaya - New reference ranges
							String ref_range = ref1 + " " + dash + " " + ref2;
							String real_ref_range = rr.getRealRefRange(codee, AGE_DAYS, GENDER);
							if(!real_ref_range.equals("---")){
								ref_range = real_ref_range;
							}
							String ref1_new = ref1;
							String real_ref1 = rr.getRealRefRangeOne(codee, AGE_DAYS, GENDER, 1);
							if(!real_ref1.equals("---")){
								ref1_new = real_ref1;
							} 
							String ref2_new = ref2;							
							String real_ref2 = rr.getRealRefRangeOne(codee, AGE_DAYS, GENDER, 2);
							if(!real_ref2.equals("---")){
								ref2_new = real_ref2;
							}
							
							if (result.equals("1") || result.equals("4")) {
								if (result.equals("4")) {
						%>
						<tr>
							<td height="2px" colspan="6"></td>
						</tr>
						<tr>
							<td height="10px" colspan="6" style="white-space: pre-wrap;"><%=desc%></td>
						</tr>
						<tr>
							<td height="2px" colspan="6"></td>
						</tr>
						<%
						} else if (codee.equals("T000721")) {
						} else {
						dash = " ";
						if (!ref1_new.equals(" ") && !ref2_new.equals(" ")) {
							dash = "-";
						}
						%>
						<%
						if (desc.equals("2HRS INCUBATION AT 37 CENTRIGRADE")) {
						%>
						<tr>
							<td height="10px" colspan="6">2HRS INCUBATION AT 37
								CENTRIGRADE</td>
						</tr>
						<%
						} else {
						%>
						<tr class="boldCls">
							<td height="10px"><%=desc%></td>
							<td><%=pntest%></td>
							<td><%=units%></td>
							<td><%=result_flag%></td>
							<td></td>
							<td align="center"><%=ref_range%></td>
						</tr>
						<%
						}
						}
						if (profileDes.matches("(?i).*torch.*")) {
						%>
						<%@include file="ref_extrajsp.jspf"%>
						<%
						}
						} else if (result.equals("2")) {
						%>
						<!-- <tr>
						<td height="10px">TEST NAME4</td>
						<td>RESULT</td>
						<td>UNITS</td>
						<td>FLAG</td>
						<td>REF.RANGE</td>
					</tr>
					<tr>
						<td height="5px" colspan="6"></td>
					</tr> -->
						<tr>
							<td height="10px" colspan="6" style="white-space: pre-wrap;"
								class="boldCls"><i><%=desc%></i></td>
						</tr>
						<%
						StringTokenizer st1 = new StringTokenizer(pstest, "\n");
						String tok1 = null;
						String temp = "";
						String temp2 = "";
						int temp3;
						while (st1.hasMoreTokens()) {
							tok1 = st1.nextToken();
							temp = tok1;
							tok1 = tok1.trim();
							if (!(tok1.equals(""))) {
								temp2 = tok1.substring(0, 1);
								temp3 = temp.indexOf(temp2);
								temp = temp.substring(0, temp3);
							}
						%>
						<tr>
							<td height="10px" colspan="6" style="white-space: pre-wrap;"><%=tok1%></td>
						</tr>
						<%
						}
						if (profileDes.matches("(?i).*torch.*")) {
						%>
						<%@include file="ref_extrajsp.jspf"%>
						<%
						}
						} else if (result.equals("3")) {
						// ABST & Urine Culture
						String newstring = pstest.substring(0, 1);
						%>
						<tr>
							<td height="10px" >TEST NAME</td>
							<td >RESULT</td>
							<td >UNITS</td>
							<td >FLAG</td>
							<td align="center">REF.RANGE</td>
						</tr>
						<tr>
							<td height="5px" colspan="6"></td>
						</tr>
						<%
						StringTokenizer st = new StringTokenizer(pstest, "\n");
						String tok = null;
						String temp = null;
						try {
							while (st.hasMoreTokens()) {
								tok = st.nextToken().trim();
								temp = tok;
						%>
						<tr>
							<td height="10px" colspan="6" style="white-space: pre-wrap;"><%=temp%></td>
						</tr>
						<%
						}
						} catch (Exception e) {
						e.printStackTrace();
						}
						%>
						<tr class="boldCls">
							<td height="10px" colspan="6">R-RESISTANT S-SENSITIVE
								I-INTERMEDIATE</td>
						</tr>
						<%
						}
						i = i + 1;
						}
						}
						%>
						<tr>
							<td height="10px" colspan="6"></td>
						</tr>
						<%
						if (prorefextra.equals("null") || prorefextra.trim().equals("-") || prorefextra.trim().equals("")) {
						} else {
						%>
						<%
						StringTokenizer st1 = new StringTokenizer(prorefextra.trim(), "\n");
						String tok1 = null;
						while (st1.hasMoreTokens()) {
							tok1 = st1.nextToken().trim();
						%>
						<tr>
							<td colspan="6" style="white-space: pre-wrap;"><%=tok1%></td>
						</tr>
						<%
						}
						}
						}
						}
						if (testcomment.equals("-") || testcomment.equals("null") || testcomment.equals(" ")) {
						} else if (test_code.equals("P000056") || test_code.equals("P000013")) {
						} else if (!testcomment.trim().equals("-")) {
						%>
						<%
						if (diss == 0) {
							if ((test_code.equals("P000120")) || (test_code.equals("P000043"))) {
						%>

						<tr class="boldCls">
							<td height="10px" colspan="6">CULTURE REPORT</td>
						</tr>
						<%
						} else {
						%>
						<tr class="boldCls">
							<td height="10px" colspan="6">Description :</td>
						</tr>
						<%
							//P000351- HLA - ABDR TYPING
							if(test_code.equals("P000351")){%>
						<tr class="boldCls">
							<td height="10px" colspan="6"><%=getResults(lab_no)%><br/></td>
						</tr>
						<%} %>
						
						<%
						}
						StringTokenizer st1 = new StringTokenizer(testcomment, "\n");
						String tok1 = null;
						while (st1.hasMoreTokens()) {
						tok1 = st1.nextToken().trim();
						%>
						<tr>
							<td height="10px" colspan="6" style="white-space: pre-wrap;"><%=tok1%></td>
						</tr>
						<%
						}
						}
						%>
						<%
						}
						} catch (SQLException e) {
						} finally {
						conn.CloseDataBaseConnection();
						conn1.CloseDataBaseConnection();
						conn2.CloseDataBaseConnection();
						}
						%>
						<%
						String sign = "";
						int scope = 1;
						DatabaseConnection conn77 = new DatabaseConnection();
						ResultSet rs77 = null;
						String query77 = "";
						try {
							conn77.ConnectToDataBase();
							query77 = "SELECT DECODE(D.DEP_NAME,'MICROBIOLOGY','M','HAEMATOLOGY','H','CLINICAL PATHALOGY','C','MOLECULAR BIOLOGY','L','LABORATORY AUTOMATION','S','SPECIAL CHEMISTRY','S','VIROLOGY','V','BIO CHEMISTRY','B','-') FROM LAB_TESTS@COLOMBO_LIVE L,LAB_TEST_DEPARTMENT@COLOMBO_LIVE D "
							+ "WHERE L.DEPARTMENT_ID = D.DEP_ID AND L.STATUS = 1 AND L.TEST_CODE = '" + test_code + "'  " + "UNION  "
							+ "SELECT DECODE(D.DEP_NAME,'MICROBIOLOGY','M','HAEMATOLOGY','H','CLINICAL PATHALOGY','C','MOLECULAR BIOLOGY','L','LABORATORY AUTOMATION','S','SPECIAL CHEMISTRY','S','VIROLOGY','V','BIO CHEMISTRY','B','-') FROM LAB_PROFILE@COLOMBO_LIVE P,LAB_TEST_DEPARTMENT@COLOMBO_LIVE D  "
							+ "WHERE P.DEPARTMENT_ID = D.DEP_ID AND P.STATUS = 1 AND P.PROFILE_CODE = '" + test_code + "'";
							//System.out.println(query77);
							rs77 = conn77.query(query77);
							while (rs77.next()) {
								sign = rs77.getString(1);
							}
							conn77.CloseDataBaseConnection();
						} catch (Exception e) {
							conn77.CloseDataBaseConnection();
						}
						if (sign.equals("-")) {
							sign = "";
						}
						int covidsignI = 0;
						DatabaseConnection conn774I = new DatabaseConnection();
						ResultSet rs774I = null;
						String query774I = "";
						try {
							conn774I.ConnectToDataBase();
							query774I = "SELECT COUNT(*),B.TEST_PROFILE_CODE FROM LAB_TEST_INVOICES@COLOMBO_LIVE L,LAB_TEST_BREAKDOWN@COLOMBO_LIVE B,LAB_TEST_RESULTS@COLOMBO_LIVE R WHERE L.INVOICE_NO = B.INVOICE_NO "
							+ "AND R.LAB_REF_NO = B.LAB_REF_NO AND B.LAB_REF_NO = '" + lab_no + "' AND R.TEST_NAME LIKE '%COVID 19%' "
							+ "AND TRIM(R.NORMAL_RESULTS) IN ('DETECTED')  GROUP BY B.TEST_PROFILE_CODE";
							//System.out.println(query774I);
							rs774I = conn774I.query(query774I);
							while (rs774I.next()) {
								covidsignI = rs774I.getInt(1);
							}
							conn774I.CloseDataBaseConnection();
						} catch (Exception e) {
							conn774I.CloseDataBaseConnection();
						}
						if (covidsignI > 0) {
						%>
						<tr class="boldCls">
							<td height="10px" colspan="6">The results indicate that the
								SARS-CoV-2 virus was present in the given sample at the time of
								testing</td>
						</tr>
						<%
						} else {
						%>
						<!-- <tr>
							<td height="10px" colspan="6" align="center">- End Of Report
								-</td>
						</tr> -->
						<%
						}
						
						String sig_path = "https://nawalokaepay.lk/Signatures/" + a_user + sign + ".jpg";
						%>
						<tr>
							<td colspan="6" valign="top">
								<%
									String sign_height = "65px";
								
									String[] sign_arr = {"100034", "100270", "100568", "100587", "100591", "100626", "100659", "100684", "100696", "100709"}; 
									// Convert String Array to List
							        List<String> list = Arrays.asList(sign_arr);
									
								if(list.contains(a_user + sign)){
									sign_height = "auto";
								}
								%>
								<div class="parent">
									<img class="image1" alt="signature" src="<%=sig_path%>"
										style="height: <%=sign_height%>">
									<%
									int covidsign = 0;
									String testcodes = "";
									DatabaseConnection conn774 = new DatabaseConnection();
									ResultSet rs774 = null;
									String query774 = "";
									try {
										conn774.ConnectToDataBase();
										query774 = "SELECT COUNT(*),B.TEST_PROFILE_CODE FROM LAB_TEST_INVOICES@COLOMBO_LIVE L,LAB_TEST_BREAKDOWN@COLOMBO_LIVE B,LAB_TEST_RESULTS@COLOMBO_LIVE R WHERE L.INVOICE_NO = B.INVOICE_NO "
										+ "AND R.LAB_REF_NO = B.LAB_REF_NO AND B.LAB_REF_NO = '" + lab_no + "' AND R.TEST_NAME LIKE '%COVID%' "
										+ "AND TRIM(R.NORMAL_RESULTS) IN ('DETECTED','POSITIVE')  GROUP BY B.TEST_PROFILE_CODE";
										//System.out.println(query774);
										rs774 = conn774.query(query774);
										while (rs774.next()) {
											covidsign = rs774.getInt(1);
											testcodes = rs774.getString(2);
										}
										conn774.CloseDataBaseConnection();
									} catch (Exception e) {
										conn774.CloseDataBaseConnection();
									}
									String upin2 = "";
									DatabaseConnection conn774x = new DatabaseConnection();
									ResultSet rs774x = null;
									String query774x = "";
									try {
										conn774x.ConnectToDataBase();
										query774x = "SELECT (NVL(L.UPIN,L.INVOICE_NO)) FROM LAB_TEST_INVOICES@COLOMBO_LIVE L, LAB_TEST_BREAKDOWN@COLOMBO_LIVE B, LAB_TEST_RESULTS@COLOMBO_LIVE R WHERE L.INVOICE_NO = B.INVOICE_NO "
										+ "AND R.LAB_REF_NO = B.LAB_REF_NO AND B.LAB_REF_NO = '" + lab_no + "' AND (R.TEST_NAME LIKE '%COVID%' OR B.TEST_PROFILE_CODE = 'P000351') ";
										//System.out.println(query774x);
										rs774x = conn774x.query(query774x);
										while (rs774x.next()) {
											upin2 = rs774x.getString(1) + "L";
										}
										conn774x.CloseDataBaseConnection();
									} catch (Exception e) {
										conn774x.CloseDataBaseConnection();
									}							
									
									String scheme = request.getScheme();
									
									String serverIP2 = "http://124.43.206.205:8899";
									String imgName2 = serverIP2 + "/Covid_Images/" + upin2 + ".jpg";
									%>
									
									 <%
									try {
										final URL url2 = new URL(imgName2);
										HttpURLConnection huc2 = (HttpURLConnection) url2.openConnection();
										responseCode2 = huc2.getResponseCode();
									} catch (Exception e) {
									}
									if (responseCode2 == 200) {
									%>
									<img class="image2" alt="photo" style="height: 65pt"
										src="<%=imgName2%>">
									<%
									}%> 
									
									
									<%
									if (isHavingAlert || getOtherTest(lab_no, test_code)) {
									%>
									<img class="image2" alt=""
										src="images/attention.jpg">
									<%
									} else if (covidsign > 0) {
									if (testcodes.equals("P000313")) {
									} else {
									%>
									<img class="image2" alt=""
										src="images/attentionnew.jpg"
										height="400px"> <img class="image2" alt=""
										src="images/ins.jpg"
										height="400px">
									<%
									}
									}
									%>
								</div>
							</td>
						</tr>						
					</table>
			</div>
		</article>
	</section>
	<%if(Spe.contains("p.t.o")){
		//Spe_arr = Spe.split("p.t.o");
		for(int k = 1; k < Spe_arr.length; k++){
	%>
	<section class="sheet padding-5mm" style="<%=header_include%>">
		<article>
			<table width="100%" style="font-size: 10pt" border="0">
				<tr>
					<td height="10px" colspan="6" style="white-space: pre-wrap;">
						<%=Spe_arr[k].replace("--->","")%>
					</td>
				</tr>
			</table>
		</article>
	</section>
	<%
  		}
	}		
	%>
</body>

<%!
public boolean getOtherTest(String lab_no, String test_code){
	DatabaseConnection conn = new DatabaseConnection();
	ResultSet rs = null;
	String query = "";
	boolean ret = false;
	try {
		conn.ConnectToDataBase();
		query = "SELECT * FROM LAB_TEST_RESULTS@COLOMBO_LIVE R, LAB_TESTS@COLOMBO_LIVE T WHERE TRIM(UPPER(T.OTHER_VALUE_ALERT)) != 'N/A' AND T.OTHER_VALUE_ALERT IS NOT NULL AND R.LAB_REF_NO = '" + lab_no + "' AND R.TEST_ID = '" + test_code + "' AND R.TEST_ID = T.TEST_CODE AND trim(UPPER(R.NORMAL_RESULTS)) = trim(UPPER(T.OTHER_VALUE_ALERT))";
		rs = conn.query(query);
		if (rs.next()) {
			ret = true;
		}
		conn.CloseDataBaseConnection();
	} catch (Exception e) {
		conn.CloseDataBaseConnection();
	}
	return ret;
}
public String getResults(String lab_ref){
	DatabaseConnection conn = new DatabaseConnection();
	ResultSet rs = null;
	String query = "";
	String ret = "";
	try {
		conn.ConnectToDataBase();
		query = "SELECT nvl(replace(REMARKS,chr(13)||chr(10),'<br>'),'-') FROM LAB_TEST_RESULTS@COLOMBO_LIVE R WHERE LAB_REF_NO = '" + lab_ref + "'";
		rs = conn.query(query);
		if (rs.next()) {
			ret = rs.getString(1);
		}
		conn.CloseDataBaseConnection();
	} catch (Exception e) {
		conn.CloseDataBaseConnection();
	}
	return ret;
}
%>

<%!private static SecretKeySpec secretKey;
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
    }%>
</html>