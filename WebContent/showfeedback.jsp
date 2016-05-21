<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="fudandb.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Useful Feedbacks</title>
<link rel="stylesheet" type="text/css" href="css/style.css" />

<script LANGUAGE="javascript">
function check_all_fields(form_obj){
        if(form_obj.rating.value == ""){
            alert("Please choose a score.");
            form_obj.fbscore.focus();
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
			
			fudandb.Connector connector = new Connector();
			fudandb.Feedback feedback = new Feedback();
			String ISBN = request.getParameter("ISBN");
			String num_s = request.getParameter("num");
			int num = Integer.parseInt(num_s);
			List list = feedback.showfeedback(ISBN, num, connector.stmt);
			if (list.size() == 0) {
		%>
			<title>No feedback on this book.</title>
		<%		
			}	
			int n = 1;
			for (Iterator i = list.iterator();i.hasNext(); n++) {
				String[] str = new String[5];
				str = (String[]) i.next();	
		%>
				<num style="margin-left: 150px;"><%=n%></num>
				<span>[Username] <%=str[0] %> &nbsp&nbsp [Time] <%=str[1] %> &nbsp&nbsp [Useful Rating] <%=str[4]%></span>
				<br>
				<span style="margin-left: 192px; margin-top: 5px;">[Score] <%=str[2] %>  &nbsp&nbsp [Text] <%=str[3]%></span>
				<BR><BR>			
		<%		
				if (username.length() == 0) {
		%>			
					<span style="margin-left: 192px; margin-top: 5px;">[You have to sign in to rate this feedback.]</span>
					
		<%			
				}
				else if (username.equals(str[0]) == false) {
					String exist = feedback.existrating(username, str[0], ISBN, connector.stmt);
					if (exist.length() == 0) {
		%>			
				<form name="ratefeedback" method=get action="ratefeedback.jsp" onsubmit="return check_all_fields(this);">
						<span style="margin-left:192px;">[Rate it]:</span>
						<input name="username" value=<%=username %> type=hidden>
						<input name="ISBN" value=<%=ISBN %> type=hidden>
						<input name="user" value=<%=str[0] %> type=hidden>
						<input name="num" value=<%=num %> type=hidden>
					<select name="rating" style="margin-left: 10px; width: 100px;">
	      				<option value="" selected="selected">Choose</option>
	      				<option value="0">useless</option>
	      				<option value="1">useful</option>
	      				<option value="2">very useful</option>
	      			</select>
	      			<input id="button" type=submit value="rate" style="margin-left: 10px; display: inline-block;">
	      		</form>	
		<%			
					}
					else {
		%>
				<span style="margin-left: 192px; margin-top: 5px;">[You rated it as <%=exist %>.]</span>
		<%				
					}
				}
		%>							
				<line>----------------------------------------------------------------------------------------------------</line>
		<%
			}
			connector.closeStatement();
			connector.closeConnection();
		%>
		
		
			<a id="button" href="bookdetail.jsp?ISBN=<%=ISBN %>">Back</a>
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