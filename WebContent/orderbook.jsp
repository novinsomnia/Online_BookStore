<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="fudandb.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Order Book</title>
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
			int oid = Integer.parseInt(orderid);
			String ISBN = request.getParameter("ISBN");
			String num_s = request.getParameter("num");
			int num = Integer.parseInt(num_s);
			String stock_s = request.getParameter("stock");
			int stock = Integer.parseInt(stock_s);
			String rst = order.orderabook(oid, ISBN, username, num, stock, connector.stmt);
		%>
			<title><%=rst %></title>
			
			<line>----------------------------------------------------------------------------------------------------</line>		
		<%
		
			List list = order.recommend(oid, ISBN, connector.stmt);
			if (list.size() != 0) {
		%>			
			<title>People who bought this book also bought:</title>
		<%
			for (Iterator i = list.iterator();i.hasNext(); ) {
				String[] str = new String[3];
				str = (String[]) i.next();		
		%>
				<a class="book" href="bookdetail.jsp?ISBN=<%=str[0] %>">
				<span style="margin-left: 150px;" >[ISBN] <%=str[0] %> &nbsp&nbsp [Title] <%=str[1] %> &nbsp&nbsp [Price] <%=str[2]%></span>
				</a>
				<line>----------------------------------------------------------------------------------------------------</line>
		<%
			}
			}
			else {
		%>		
				<title>No recommend statistics.</title>
		<%	
			}
			connector.closeStatement();
			connector.closeConnection();
		%>
			
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