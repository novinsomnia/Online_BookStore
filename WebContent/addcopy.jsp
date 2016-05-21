<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="fudandb.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Add copies</title>
<link rel="stylesheet" type="text/css" href="css/style.css" />

	<script LANGUAGE="javascript">
	function check_all_fields(form_obj){
        if( form_obj.ISBN.value == ""){
                alert("ISBN should be nonempty.");
                form_obj.ISBN.focus();
                return false;
        }
        else if (form_obj.ISBN.value.length != 10) {
        	alert("ISBN's length should be 10.");
            form_obj.ISBN.focus();
            return false;
        }
        else if (form_obj.copies.value == "") {
        	alert("Add copies number should be nonempty.");
            form_obj.copies.focus();
            return false;
        }
        else if (isNaN(form_obj.copies.value)) {
        	alert("Copies should be a number.");
        	form_obj.copies.value = "";
        	form_obj.copies.focus();
        	return false;
        }
        return true;
	}
	</script>

</head>

<body>
	<div id="page">
		<div id="header">
			<a href="management.jsp?managerPassword=managerpassword"><title>Book Management System</title></a>
		</div>
	
		<div id="body">
			<title>[ Add copies ]</title>
			
		<%
			String newcopy = request.getParameter("newCopy");
			if (newcopy == null) {
		%>
			<form name="newcopy" method=get action="addcopy.jsp" onsubmit="return check_all_fields(this);">
				<input type=hidden name="newCopy" value="newCopy">
				<ul style="text-align: left; margin-left: 300px;">
					<li><span>ISBN:</span><input id="input" name="ISBN" type=text>&nbspThe ISBN length should be 10.</li><BR>
					<li><span>Add Copies:</span><input id="input" name="copies" type=text></li><BR>
				</ul>				
				<input id="button" type=submit value="submit">
			</form>
			<a id="button" href="management.jsp?managerPassword=managerpassword">Back</a>
		<%
			}
			else {
				fudandb.Connector connector = new Connector();
				fudandb.Book book = new Book();
				
				String ISBN = request.getParameter("ISBN");
				String copies = request.getParameter("copies");
		%>
		
			<title><%=book.newcopies(ISBN, Integer.parseInt(copies), connector.stmt)%></title>
			<a id="button" href="management.jsp?managerPassword=managerpassword">Back</a>
			
		<%
			connector.closeStatement();
			connector.closeConnection();
			}
		%>			
		</div>
		
		<div id="footer">
			<div>
				<p class="connect">Get in Touch: 13307130414@fudan.edu.cn</p>
				<p class="footnote">Made by Yijing Xia. 2015</p>
			</div>
		</div>
	</div>


</body>
</html>