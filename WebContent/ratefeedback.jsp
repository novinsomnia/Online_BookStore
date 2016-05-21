<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="fudandb.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="css/style.css" />
</head>
<body>
		<div id="page"> 
		<div id="header">
			<a href="home.jsp"><title>Online Book Store</title></a>
		</div>
		
		<div id="body">
		
		<%
			String username="";
			Cookie[] cookies=request.getCookies();
			for(int n = 0; n < cookies.length; n++) {
					Cookie newCookie = cookies[n];
					if(newCookie.getName().equals("username")) {
						username = newCookie.getValue();
					}
			}
			
			if (username.length() != 0) {
		%>
			<status>Welcome back, <%=username %> | <a href="signout.jsp">sign out</a> | <a href="currentorder.jsp">current order</a></status>
		
		<%
			}
			else {
		%>
			<status><a href="signup.jsp">sign up</a> | <a href="signin.jsp">sign in</a> | sign out | current order</status>
		<%
			}
			
			String user = request.getParameter("user");
			String ISBN = request.getParameter("ISBN");
			String rating_s = request.getParameter("rating");
			int rating = Integer.parseInt(rating_s);
			String num_s = request.getParameter("num");
			int num = Integer.parseInt(num_s);
			
			fudandb.Connector connector = new Connector();
			fudandb.Feedback feedback = new Feedback();
			String rst = feedback.ratefeedback(username, user, ISBN, rating, connector.stmt);
			connector.closeStatement();
			connector.closeConnection();
		%>
			<title><%=rst %></title>
			<a id="button" href="showfeedback.jsp?ISBN=<%=ISBN %>&num=<%=num %>">Back</a>
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