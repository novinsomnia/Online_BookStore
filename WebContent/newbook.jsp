<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="fudandb.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Record a new book</title>
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
        else if (form_obj.title.value == "") {
        		alert("Title should be nonempty.");
        		form_obj.title.focus();
            	return false;
        }
        else if (form_obj.author1.value == "") {
        	alert("At least one author has to be added.");
        	form_obj.author1.focus();
        	return false;
        }
        else if (form_obj.price.value == "") {
        	alert("Price should be nonempty.");
        	form_obj.price.focus();
        	return false;
        }
        else if (isNaN(form_obj.publish_year.value) || (form_obj.publish_year.value.length != 4 && form_obj.publish_year.value != "")) {
        	alert("Publish Year should be 4 digits.");
        	form_obj.publish_year.value = "";
        	form_obj.publish_year.focus();
        	return false;
        }
        else if (form_obj.copies.value != "" && isNaN(form_obj.copies.value)) {
        	alert("Copies should be a number.");
        	form_obj.copies.value = "";
        	form_obj.copies.focus();
        	return false;
        }
        else if (form_obj.format.value != "" && form_obj.format.value != "1" && form_obj.format.value != "0") {
        	alert("Format should be 1 or 0.");
        	form_obj.format.value = "";
        	form_obj.format.focus();
        	return false;
        }
        else if (isNaN(form_obj.price.value)) {
        	alert("Price should be a number.");
        	form_obj.price.value = "";
        	form_obj.price.focus();
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
			<title>[ Record a new book ]</title>
		
		<%
			String newBook = request.getParameter("newBook");
			if (newBook == null) {
		%>
			<form name="newbook" method=get action="newbook.jsp" onsubmit="return check_all_fields(this);">
				<input type=hidden name="newBook" value="newBook">
				<ul style="text-align: left; margin-left: 200px;">
					<li><span>ISBN:</span><input id="input" name="ISBN" type=text>*&nbspThe ISBN length should be 10.</li><BR>
					<li><span>Title:</span><input id="input" name="title" type=text>*&nbsp</li><BR>
					<li><span>Author:</span><input id="input" name="author1" type=text>*&nbsp<input id="input" name="author2" type=text>&nbsp<input id="input" name="author3" type=text></li><BR>
					<li><span>Publisher:</span><input id="input" name="publisher" type=text></li><BR>
					<li><span>Publish Year:</span><input id="input" name="publish_year" type=text></li><BR>
					<li><span>Copies:</span><input id="input" name="copies" type=text>&nbsp By default is 0.</li><BR>
					<li><span>Format:</span><input id="input" name="format" type=text>&nbsp 1 represents soft cover, 0 represents hard cover.</li><BR>
					<li><span>Price:</span><input id="input" name="price" type=text>*</li><BR>
					<li><span>Keywords:</span><input id="input" name="keywords" type=text></li><BR>
					<li><span>Subject:</span><input id="input" name="subject" type=text></li><BR>
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
				String title = request.getParameter("title");
				String author1 = request.getParameter("author1");
				String author2 = request.getParameter("author2");
				String author3 = request.getParameter("author3");
				String publisher = request.getParameter("publisher");
				String publish_year = request.getParameter("publish_year");
				String copies = request.getParameter("copies");
				String format = request.getParameter("format");
				String price = request.getParameter("price");
				String keywords = request.getParameter("keywords");
				String subject = request.getParameter("subject");				
		%>
			<title><%= book.recordnewbook(ISBN, title, author1, author2, author3, publisher, publish_year, copies, format, price, keywords, subject, connector.stmt) %></title>
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