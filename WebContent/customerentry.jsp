<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="fudandb.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
	<meta charset="UTF-8">
	<title>Customer Entry</title>
	<link rel="stylesheet" type="text/css" href="css/style.css" />

</head>

<body>
	<div id="page">
		<div id="header">
			<a href="customerentry.jsp"><title>Online Book Store</title></a>
		</div>		

		<div id="body">	
		<%		
			String oid = "";
			String username="";
			Cookie[] cookies=request.getCookies();
			for(int n = 0; cookies != null && n < cookies.length; n++) {
					Cookie newCookie = cookies[n];
					if(newCookie.getName().equals("username")) {
						username = newCookie.getValue();
					}
					if (newCookie.getName().equals("orderid")) {
						if (oid.length() == 0 || Integer.parseInt(newCookie.getValue()) > Integer.parseInt(oid))
							oid = newCookie.getValue();
					}
			}
			
			if (oid.length() == 0) {
				fudandb.Connector connector = new Connector();
				fudandb.Order order = new Order();
				int orderid = order.getorderid(connector.stmt);
				oid = Integer.toString(orderid);
				Cookie cookie = new Cookie("orderid", oid);
				cookie.setPath("/");
				cookie.setMaxAge(-1);
				response.addCookie(cookie);
				connector.closeStatement();
				connector.closeConnection();
			}
		
			if (username.length() != 0) {
		%>
			<status>Welcome back, <%=username %> | <a href="signout.jsp">sign out</a></status>
		
		<%
			}
			else {
		%>
			<status><a href="signup.jsp">sign up</a> | <a href="signin.jsp">sign in</a> | sign out</status>
		<%
			}
		%>
			<ul style="margin-top: 80px;">
				<li class="choice"><a href="home.jsp"><span>Browse & Order</span></a></li>
				<li class="choice"><a href="searchuser.jsp"><span>Search User</span></a>
				<li class="choice" style="width: 300px;"><a href="seperation.jsp"><span>Two degree of seperation</span></a></li>
			</ul>

			<span style="margin: 5px 0; margin-top: 20px; margin-left:110px; font-size: 18px; font-weight: bold;">[ Instructions ]</span><br>
			<span style="margin: 5px 0; margin-left:110px; font-size: 15px;">* When you want to trust/not trust a certain user, you should click 'Search User'.</span><br>
			<span style="margin: 5px 0; margin-left:110px; font-size: 15px;">* You have to know the exact name of two authors when you want to know the 'two degrees of seperation' result of them.</span><br>
			<span style="margin: 5px 0; margin-left:110px; font-size: 15px;">* You can find other functions in 'Browse & Order'.</span><br>
			<span style="margin: 5px 0; margin-left:110px; font-size: 18px; font-weight: bold;">Hope you have a good time here.</span><br>
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