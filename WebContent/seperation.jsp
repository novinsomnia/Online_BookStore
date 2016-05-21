<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="fudandb.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Two Degree of Seperation</title>
<link rel="stylesheet" type="text/css" href="css/style.css" />

<script LANGUAGE="javascript">
function check_all_fields(form_obj){
        if(form_obj.author1.value == "" || form_obj.author2.value == ""){
                alert("Author names should be nonempty.");
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
		%>	
			<title>[Two degrees of separation]</title>
		<%	
			String sep = request.getParameter("seperation");
			if (sep == null) {
		%>
			<form name="browse" method=get action="seperation.jsp" onsubmit="return check_all_fields(this);">
				<input name="seperation" value="seperation" type=hidden>
				<span style="margin-left: 350px;">First author: </span>
				<input id="input" name="author1" type=text>
				<br>
				
				<span style="margin-left: 350px;">Second author: </span>
				<input id="input" name="author2" type=text>
				<span style="display:block; text-align:center; font-size: 14px;">*Please enter the exact name of two authors.</span>
				<input id="button" type=submit value="check">
			</form>

			<br><br>
			<a id="button" href="customerentry.jsp">Back</a>
		<%
			}
			else {
				fudandb.Connector connector = new Connector();
				fudandb.Author author = new Author();
				String au1 = request.getParameter("author1");
				String au2 = request.getParameter("author2");
				String rst = author.sepdegree(au1, au2, connector.stmt);
		%>		
				<span style="display:block; text-align:center;"><%=rst %></span>
				<a id="button" href="seperation.jsp">Back</a>
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