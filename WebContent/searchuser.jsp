<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="fudandb.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Search User</title>
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
		%>	
			<title>[User Search]</title>
			
		<%	
			String usersearch = request.getParameter("userSearch");
			if (usersearch == null) {
		%>
			<form name="usersearch" method=get action="searchuser.jsp">
				<input name="userSearch" value="userSearch" type=hidden>
				<input id="input" name="user" type=text style="display:block; margin: 10px auto;">
				<span style="display:block; text-align:center; font-size: 14px;">*Please enter the username.</span>
				<input id="button" type=submit value="search">
      		</form>
      		<a id="button" style="width: 180px;" href="searchuser.jsp?userSearch=userSearch&user=">Show All Users</a>
			<a id="button" href="customerentry.jsp">Back</a>
		<%
			}
			else {
				fudandb.Connector connector = new Connector();
				fudandb.User u = new User();
				String user = request.getParameter("user");
				List list = u.searchuser(user, connector.stmt);
				if (list.size() == 0) {
		%>
				<span style="display:block; text-align: center;">There's no user named like <%=user %>.</span>
		<%
				}
				else {		
					for (Iterator i = list.iterator();i.hasNext(); ) {
						String[] str = new String[4];
						str = (String[]) i.next();
		%>				
				<span style="margin-left: 150px;">[Username] <%=str[0] %> &nbsp&nbsp [Fullname] <%=str[1] %> &nbsp&nbsp [Address] <%=str[2]%>&nbsp&nbsp [Phone] <%=str[3]%></span>
		<%
						if (username.length() == 0) {
		%>
				<span style="margin-left: 150px;">You have to sign in to trust/not trust other users.</span>
		
		<%			
						}
						else {
							String exist = u.existtrust(username, str[0], connector.stmt);
							if (exist.length() != 0 && username.equals(str[0]) == false) {
		%>
							<span style="margin-left: 150px;">[You <%=exist %> this user.]</span>
		<%								
							}
							else if (username.equals(str[0]) == false){
		%>
				<form name="trust" method=get action="trustuser.jsp">
					<span style="margin-left: 150px;">I want to</span>
					<input name="user" value="<%=str[0] %>" type=hidden>
					<select name="trust" style="margin-left: 10px; width: 120px;">
	      				<option value="1" selected="selected">trust</option>
	      				<option value="-1">not trust</option>
      				</select>
      				<span>this user.</span>
					<input id="button" type=submit value="confirm" style="display: inline-block; font-size: 18px; height: 25px;">
      			</form>
		<%					
							}
						}
		%>
				
				<line>----------------------------------------------------------------------------------------------------</line>
		<%
					}
				}
		%>
				<a id="button" href="searchuser.jsp">Back</a>
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

</body>
</html>