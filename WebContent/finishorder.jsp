<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="fudandb.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Finish Order</title>
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
			String orderid="";
			Cookie[] cookies=request.getCookies();
			for(int n = 0; n < cookies.length; n++) {
					Cookie newCookie = cookies[n];
					if(newCookie.getName().equals("username")) {
						username = newCookie.getValue();
					}
					if (newCookie.getName().equals("orderid")) {
						if (orderid.length() == 0 || Integer.parseInt(newCookie.getValue()) > Integer.parseInt(orderid))
							orderid = newCookie.getValue();
					}
			}
			int oid = -1;
			if (orderid.length() != 0)
				oid = Integer.parseInt(orderid);
			
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
			
			fudandb.Connector connector = new Connector();
			fudandb.Order order = new Order();
			String rst = order.finishorder(oid, connector.stmt);
			oid++;
			orderid = Integer.toString(oid);
			
			Cookie cookie = new Cookie("orderid", orderid);
			//cookie.setPath("/");
			cookie.setMaxAge(0);
			response.addCookie(cookie);
			
			cookie = new Cookie("orderid", orderid);
			//cookie.setPath("/");
			cookie.setMaxAge(-1);
			response.addCookie(cookie);
			
			
			Cookie[] cookies2=request.getCookies();
			for(int n = 0; n < cookies.length-1; n++) {
					Cookie newCookie = cookies2[n];
			}
			
			connector.closeStatement();
			connector.closeConnection();
		%>
			<title><%=rst %></title>
			<a id="button" href="home.jsp">Back</a>
		</div>
		
		<div id="footer">
			<div>
				<p class="connect">Get in Touch: 13307130414@fudan.edu.cn</p>
				<p class="footnote">Made by Yijing Xia. 2015</p>
			</div>
		</div>

</body>
</html>