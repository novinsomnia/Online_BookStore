<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="fudandb.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Book Statistics</title>
<link rel="stylesheet" type="text/css" href="css/style.css" />
</head>

<body>
	<div id="page">
		<div id="header">
			<a href="management.jsp?managerPassword=managerpassword"><title>Book Management System</title></a>
		</div>
	
		<div id="body">
			<title>[ Book Statistics ]</title>
			
		<%
			String pbook = request.getParameter("popularBook");
			if (pbook == null) {
		%>
			<form name="pbook" method=get action="bookstatistics.jsp">
				<input name="popularBook" value="popularbook" type=hidden>
				<span style="margin-left: 250px;">The </span>
				<select name="num">
      				<option value="5" selected="selected">5</option>
      				<option value="10">10</option>
      				<option value="15">15</option>
      				<option value="20">20</option>
      				<option value="25">25</option>
      				<option value="30">30</option>  			
      			</select>
      			<span>most popular</span>
				<select name="type">
      				<option value="1" selected="selected">Book</option>
      				<option value="2">Author</option>
      				<option value="3">Publisher</option>
      			</select>
				<input id="button" type=submit value="submit">
			</form>
			<a id="button" href="management.jsp?managerPassword=managerpassword">Back</a>
		<%
			}
			else {
				fudandb.Connector connector = new Connector();
				fudandb.Book book = new Book();
				
				String type_s = request.getParameter("type");
				String num_s = request.getParameter("num");
				int type = Integer.parseInt(type_s);
				int num = Integer.parseInt(num_s);
				
				List list;
				if (type == 1) {
					list = book.popularbook(num, connector.stmt);
					int n = 1;
					for(Iterator i = list.iterator();i.hasNext(); n++) {
						String[] str = new String[3];
						str = (String[]) i.next();
		%>
				<num style="margin-left: 100px;"><%=n%></num>
				<span>ISBN: <%=str[0] %> &nbsp&nbsp Title: <%=str[1] %>  &nbsp&nbsp SaleNumber: <%=str[2]%></span>
				<line>------------------------------------------------------------------------------------------------------------------------------------------------------------</line>
				<BR><BR>
		<%
					}
				}
				else if (type == 2) {
					list = book.popularauthor(num, connector.stmt);
					int n = 1;
					for(Iterator i = list.iterator();i.hasNext(); n++) {
						String[] str = new String[2];
						str = (String[]) i.next();
		%>
				<num><%=n%></num>
				<span>Author: <%=str[0] %> &nbsp&nbsp SaleNumber: <%=str[1] %></span>
				<line>------------------------------------------------------------------------------------------------------------------------------------------------------------</line>
				<BR><BR>
		
		<%
					}
				}
				else if (type == 3) {
					list = book.popularpublisher(num, connector.stmt);
					int n = 1;
					for(Iterator i = list.iterator();i.hasNext(); n++) {
						String[] str = new String[2];
						str = (String[]) i.next();
		%>
				<num><%=n%></num>
				<span>Publisher: <%=str[0] %> &nbsp&nbsp SaleNumber: <%=str[1] %></span>
				<line>------------------------------------------------------------------------------------------------------------------------------------------------------------</line>
				<BR><BR>
		<%
					}
				}
		%>	
			<a id="button" href="bookstatistics.jsp">Back</a>
			
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