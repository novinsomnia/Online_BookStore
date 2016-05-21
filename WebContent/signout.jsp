<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="fudandb.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="css/style.css" />
<title>Sign Out</title>
</head>

<body>
		<div id="page"> 
		<div id="header">
			<a href="home.jsp"><title>Online Book Store</title></a>
		</div>
		
		<div id="body">
			<title>[ Sign Out ]</title>
			<title>See you next time!</title>
		
		<%
			Cookie cookie = new Cookie("username", "");
			cookie.setPath("/");
			cookie.setMaxAge(0);
			response.addCookie(cookie);
			
			String orderid="";
			Cookie[] cookies=request.getCookies();
			for(int n = 0; n < cookies.length; n++) {
					Cookie newCookie = cookies[n];
					if (newCookie.getName().equals("orderid")) {
						if (orderid.length() == 0 || Integer.parseInt(newCookie.getValue()) > Integer.parseInt(orderid))
							orderid = newCookie.getValue();
					}
			}
			int oid = -1;
			if (orderid.length() != 0) {
				oid = Integer.parseInt(orderid);
				fudandb.Connector connector = new Connector();
				fudandb.Order order = new Order();
				order.clear(oid, connector.stmt);
				connector.closeStatement();
				connector.closeConnection();
			}
		%>
		
			<a id="button" href="customerentry.jsp">Back</a>
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