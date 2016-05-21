<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
	<meta charset="UTF-8">
	<title>Book Management System</title>
	<link rel="stylesheet" type="text/css" href="css/style.css" />

</head>

<body>
	<div id="page">
		<div id="header">
			<a href="index.html"><title>Book Management System</title></a>
		</div>		

		<div id="body">	
		<% 
			String pass = request.getParameter("managerPassword");	
			if (pass == null || pass.equals("managerpassword") == false) {				
		%>
			<title>Fail to log in as a manager. Wrong password.</title>
		<%
			}
			else {
		%>
		
			<title>Welcome back, Store Manager.</title>
			<ul>
				<li class="choice"><a href="newbook.jsp"><span>Record a new book</span></a></li>
				<li class="choice"><a href="addcopy.jsp"><span>Add copies</span></a>
				<li class="choice"><a href="bookstatistics.jsp"><span>Statistics(Book)</span></a></li>
				<li class="choice"><a href="userstatistics.jsp"><span>Statistics(User)</span></a></li>
			</ul>
		
		<%
			}
		%>	
			<a id="button" href="index.html">Back</a>
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