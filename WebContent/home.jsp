<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="fudandb.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="css/style.css" />
<title>Book Browsing</title>
<script LANGUAGE="javascript">
function check_all_fields(form_obj){
        if(form_obj.order.value == "2" && form_obj.username.value == ""){
                alert("Please sign in first");
                return false;
        }
        return true;
}
</script>
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
			String browse = request.getParameter("browseBook");
			if (browse == null) {
		%>
			<form name="browse" method=get action="home.jsp" onsubmit="return check_all_fields(this);">
				<input name="browseBook" value="browseBook" type=hidden>
				<input name="username" value="<%=username %>" type=hidden>
				<span style="margin-left: 130px;">Title like </span>
				<input id="input" name="title" type=text>
				<select name="type1" style="margin-left: 10px; width: 70px;">
      				<option value="and" selected="selected">and</option>
      				<option value="or">or</option>		
      			</select>
      			
      			<span style="margin-left: 20px;">Author like </span>
				<input id="input" name="author" type=text>
				<select name="type2" style="margin-left: 10px; width: 70px;">
      				<option value="and" selected="selected">and</option>
      				<option value="or">or</option>		
      			</select>
      			
      			<br>
      			<span style="margin-left: 130px;">Publisher like </span>
				<input id="input" name="publisher" type=text>
				<select name="type3" style="margin-left: 10px; width: 70px;">
      				<option value="and" selected="selected">and</option>
      				<option value="or">or</option>		
      			</select>
      			
      			<span style="margin-left: 20px;">Subject like </span>
				<input id="input" name="subject" type=text>
      			
      			<span style="margin-left: 130px;">Order by </span>
				<select name="order" style="margin-left: 10px; width: 250px;">
      				<option value="0">year</option>
      				<option value="1" selected="selected">average feedback scores</option>		
      				<option value="2">average feedback scores by trusted users</option>
      			</select>
      				
				<input id="button" type=submit value="search">
			</form>
			<line>------------------------------------------------------------------------------------
      			-------------------------------------------------------------------</line>
			<a id="button" style="width: 180px;" href="home.jsp?browseBook=browseBook&username=sean&title=&type1=and&author=&type2=and&publisher=&type3=and&subject=&order=1">Show All Books</a>
			<line>------------------------------------------------------------------------------------
      			-------------------------------------------------------------------</line>
		
		<%
			}
			else {
				String title = request.getParameter("title");
				String author = request.getParameter("author");
				String publisher = request.getParameter("publisher");
				String subject = request.getParameter("subject");
				String t1 = request.getParameter("type1");
				String t2 = request.getParameter("type2");
				String t3 = request.getParameter("type3");
				String order_s = request.getParameter("order");
				int order = Integer.parseInt(order_s);
				
				fudandb.Connector connector = new Connector();
				fudandb.Book book = new Book();
				List list = book.browse(username, title, t1, author, t2, publisher, t3, subject, order, connector.stmt);
				int n = 1;
				if (order == 2) {
					for(Iterator i = list.iterator();i.hasNext(); n++) {
						String[] str = new String[8];
						str = (String[]) i.next();
		%>
			<num style="margin-left: 100px;"><%=n%></num>
				<a class="book" href="bookdetail.jsp?ISBN=<%=str[0] %>">
					<span>[ISBN] <%=str[0] %> &nbsp&nbsp [Title]<%=str[1] %>  &nbsp&nbsp </span><br>
					<span style="margin-left: 142px; margin-top: 5px;">[Publisher] <%=str[2]%> &nbsp&nbsp [Publish Year] <%=str[3] %> </span>
					<br>
					<span style="margin-left: 142px; margin-top: 0px;">[Price] <%=str[4] %>  &nbsp&nbsp [Subject] <%=str[5]%> &nbsp&nbsp [Avg feedback score] <%=str[6]%> &nbsp&nbsp [Avg feedback score by trusted users:] <%=str[7]%></span>
				</a>
				<line>----------------------------------------------------------------------------------------------------</line>
				<BR><BR>				
		<%					
					}
				}
				else {
					for(Iterator i = list.iterator();i.hasNext(); n++) {
						String[] str = new String[7];
						str = (String[]) i.next();
		%>
				<num style="margin-left: 100px;"><%=n%></num>
				<a class="book" href="bookdetail.jsp?ISBN=<%=str[0] %>">
				<span>[ISBN] <%=str[0] %> &nbsp&nbsp [Title] <%=str[1] %> </span><br>
				<span style="margin-left: 142px; margin-top: 5px;">[Publisher] <%=str[2]%> &nbsp&nbsp [Publish Year] <%=str[3] %> </span>
				<br>
				<span style="margin-left: 142px; margin-top: 5px;">[Price] <%=str[4] %>  &nbsp&nbsp [Subject] <%=str[5]%> &nbsp&nbsp [Avg feedback score] <%=str[6]%></span>
				</a>
				<line>----------------------------------------------------------------------------------------------------</line>		
		<%				
					}
				}
		%>
				<a id="button" href="home.jsp">Back</a>
		<%
			connector.closeStatement();
			connector.closeConnection();
			}
			if (browse == null) {
		%>
			<a id="button" href="customerentry.jsp">Back</a>
			
		<%
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