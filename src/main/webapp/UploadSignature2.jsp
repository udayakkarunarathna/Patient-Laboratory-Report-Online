<%@ page import="java.io.File"%>
<%@ page import="org.apache.commons.io.FilenameUtils"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.util.List"%>
<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page
	import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%
	String UPLOAD_DIRECTORY = "";
	
		StringBuffer url = request.getRequestURL();
		String baseURL = url.substring( 0, url.length() - request.getRequestURI().length() ) + "/";

	if (baseURL.contains("192.168.3.250:8888")) {
		UPLOAD_DIRECTORY = "/app/glassfish3/glassfish/domains/nawaloka/docroot/Signatures";
	} else if (baseURL.contains("192.168.3.61:8888")) {
		UPLOAD_DIRECTORY = "/app/glassfish3/glassfish/domains/coco/docroot/Signatures";
	} else if (baseURL.contains("47.241.62.112:8889")) {
		UPLOAD_DIRECTORY = "/app/glassfish3/glassfish/domains/nawaloka/docroot/Signatures";
	} else if (baseURL.contains("47.241.62.112:8891")) {
		UPLOAD_DIRECTORY = "/app/glassfish3/glassfish/domains/ragama3/docroot/Signatures";
	} else if (baseURL.contains("8.214.53.95:8889")) {
		UPLOAD_DIRECTORY = "/app/glassfish3/glassfish/domains/nawaloka/docroot/Signatures";
	} else if (baseURL.contains("8.214.53.95:8895")) {
		UPLOAD_DIRECTORY = "/app/glassfish3/glassfish/domains/batico/docroot/Signatures";
	} else if (baseURL.contains("8.214.53.95:8891")) {
		UPLOAD_DIRECTORY = "/app/glassfish3/glassfish/domains/lis/docroot/Signatures";
	} else if (baseURL.contains("8.214.53.95:8896")) {
		UPLOAD_DIRECTORY = "/app/glassfish3/glassfish/domains/kurunegala/docroot/Signatures";
	} else if (baseURL.contains("nawalokaepay.lk")) {
		UPLOAD_DIRECTORY = "/Signatures";
	}

    //process only if its multipart content
    if (ServletFileUpload.isMultipartContent(request)) {
        try {
            List<FileItem> multiparts = new ServletFileUpload(
                    new DiskFileItemFactory()).parseRequest(request);

            for (FileItem item : multiparts) {
                if (!item.isFormField()) {
                    //String name = new File(item.getName()).getName();
					
					String fileName = item.getName();
					
					if (fileName != null) {
							fileName = FilenameUtils.getName(fileName);
						}
					
		
                    item.write(new File(UPLOAD_DIRECTORY + File.separator + fileName));
                }
            }
            //File uploaded successfully
            request.setAttribute("message", "File Uploaded Successfully");
        } catch (Exception ex) {
            request.setAttribute("message", "File Upload Failed due to " + ex);
        }
    } else {
        request.setAttribute("message",
                "Sorry this Servlet only handles file upload request");
    }    
%>
<script language="javascript">
	alert("Signature Uploaded !");
	//window.close();
</script>