<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="fudandb.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>User Statistics</title>
<link rel="stylesheet" type="text/css" href="css/style.css" />
</head>

<body>
	<div id="page">
		<div id="header">
			<a href="management.jsp?managerPassword=managerpassword"><title>Book Management System</title></a>
		</div>
	
		<div id="body">
			<title>[ User Statistics ]</title>
			
		<%
			String puser = request.getParameter("popularUser");
			if (puser == null) {
		%>
			<form name="puser" method=get action="userstatistics.jsp">
				<input name="popularUser" value="popularuser" type=hidden>
				<span style="margin-left: 250px;">The top </span>
				<select name="num">
      				<option value="5" selected="selected">5</option>
      				<option value="10">10</option>
      				<option value="15">15</option>
      				<option value="20">20</option>
      				<option value="25">25</option>
      				<option value="30">30</option>  			
      			</select>
      			<span>most</span>
				<select name="type">
      				<option value="1" selected="selected">trusted</option>
      				<option value="2">useful</option>
      			</select>
      			<span>user.</span>
				<input id="button" type=submit value="submit">
			</form>
			<a id="button" href="management.jsp?managerPassword=managerpassword">Back</a>
		<%
			}
			else {
				fudandb.Connector connector = new Connector();
				fudandb.User user = new User();
				
				String type_s = request.getParameter("type");
				String num_s = request.getParameter("num");
				int type = Integer.parseInt(type_s);
				int num = Integer.parseInt(num_s);
				
				List list;
				if (type == 1) {
					list = user.mosttrusted(num, connector.stmt);
					int n = 1;
					for(Iterator i = list.iterator();i.hasNext(); n++) {
						String[] str = new String[3];
						str = (String[]) i.next();
		%>
				<num><%=n%></num>
				<span>Username: <%=str[0] %> &nbsp&nbsp Trusted Score: <%=str[1]%></span>
				<line>----------------------------------------------------------------------------------------------------</line>
				<BR><BR>
		<%
					}
				}
				else if (type == 2) {
					list = user.mostuseful(num, connector.stmt);
					int n = 1;
					for(Iterator i = list.iterator();i.hasNext(); n++) {
						String[] str = new String[2];
						str = (String[]) i.next();
		%>
				<num><%=n%></num>
				<span>Username: <%=str[0] %> &nbsp&nbsp Useful Score: <%=str[1] %></span>
				<line>----------------------------------------------------------------------------------------------------</line>
				<BR><BR>
		<%
					}
				}
		%>	
			<a id="button" href="userstatistics.jsp">Back</a>
			
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