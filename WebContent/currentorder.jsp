<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="fudandb.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Current Order</title>
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
			<status><a href="signup.jsp">sign up</a> | <a href="signin.jsp">sign in</a> | sign out | <a href="currentorder.jsp">current order</a></status>
		<%
			}
			
			if (oid >= 0) {
		%>
			<title>Current Orderid = <%=orderid %></title>
		<%
				fudandb.Connector connector = new Connector();
				fudandb.Order order = new Order();
				List list = order.showcurrentorder(oid, connector.stmt);
				int sum = 0;
				for (Iterator i = list.iterator();i.hasNext(); ) {
					String[] str = new String[4];
					str = (String[]) i.next();
					sum += Float.parseFloat(str[3]);
		%>
				<span style="margin-left: 150px;">[ISBN] <%=str[0] %> &nbsp&nbsp [Title] <%=str[1] %> &nbsp&nbsp [Num] <%=str[2]%> &nbsp&nbsp [Price] <%=str[3]%></span>
				<line>----------------------------------------------------------------------------------------------------</line>		
		<%
				}
				if (list.size() > 0) {
		%>
				<span style="margin-left: 150px; font-weight:bold;">[Total Price] <%=sum %></span>
				<br>
				<div style="text-align:center">
				<a id="button" href="finishorder.jsp" style="display:inline-block; width: 160px;">Finish Order</a>
				<a id="button" href="clearorder.jsp" style="display:inline-block; width: 160px;">Clear Order</a>
				<a id="button" href="home.jsp">Back</a>
				</div>
		<%
				}
				else {
		%>
				<span style="margin-left: 150px; font-weight:bold;">[Empty Order]</span>
				<a id="button" href="home.jsp">Back</a>
		<%
				}
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

</body>
</html>