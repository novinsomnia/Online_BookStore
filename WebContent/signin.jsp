<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="fudandb.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Sign In</title>
<link rel="stylesheet" type="text/css" href="css/style.css" />
</head>
<body>

	<div id="page"> 
		<div id="header">
			<a href="home.jsp"><title>Online Book Store</title></a>
		</div>
		
		<div id="body">
			<title>[ Sign In ]</title>
		
		<%
			String signin = request.getParameter("signIn");
			if (signin == null) {
		%>
			<form name="signin" method=get action="signin.jsp">
				<input type=hidden name="signIn" value="signIn">
				<ul style="text-align: left; margin-left: 350px;">
					<li><span>Username:</span><input id="input" name="username" type=text></li><BR>
					<li><span>Password:</span><input id="input" name="password" type=password></li><BR>
				</ul>				
				<input id="button" type=submit value="submit">
			</form>
			
		<%
			}
			
			else {
				fudandb.Connector connector = new Connector();
				fudandb.User user = new User();
				
				String username = request.getParameter("username");
				String password = request.getParameter("password");
				
				boolean in = user.login(username, password, connector.stmt);
				if (in) {
					Cookie cookie = new Cookie("username", username);
					cookie.setPath("/");
					cookie.setMaxAge(-1);
					response.addCookie(cookie);
		%>
			<title>Welcome back, <%=username %>.</title>
			
		<%
				}
				else {
		%>
			<title>Sorry, fail to sign in as <%=username %>.</title>
		<%
				}
			connector.closeStatement();
			connector.closeConnection();
		%>	
			<a id="button" href="customerentry.jsp">Back</a>
		<%
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