<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="fudandb.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Clear Order</title>
</head>
<body>
	<%
		fudandb.Connector connector = new Connector();
		fudandb.Order order = new Order();
		
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
		if (orderid.length() != 0)
			oid = Integer.parseInt(orderid);
		
		order.clear(oid, connector.stmt);
		connector.closeStatement();
		connector.closeConnection();
	%>
	
	<jsp:forward page="currentorder.jsp" />
	
</body>
</html>