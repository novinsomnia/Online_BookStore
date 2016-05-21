<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"  import="fudandb.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Book Detail</title>
<link rel="stylesheet" type="text/css" href="css/style.css" />

<script LANGUAGE="javascript">
function check_all_fields(form_obj){
        if(form_obj.fbscore.value == ""){
            alert("Please choose a score");
            form_obj.fbscore.focus();
            return false;
        }
        else if (form_obj.text.value.length > 200) {
        	alert("Text should be no longer than 50 chars.");
        	form_obj.text.focus();
            return false;
        }
        return true;
}

function checkorder(form_obj) {
	var num = parseInt(form_obj.num.value);
	var stock = parseInt(form_obj.stock.value);
	if (form_obj.username.value == "") {
		alert("Please sign in first.");
		return false;
	}
	else if (isNaN(form_obj.num.value)) {
		alert("Please enter the number of books you want to order.");
		form_obj.num.value="1";
        form_obj.num.focus();
        return false;
	}
	else if (num < 0) {
		alert("Please enter the number of books you want to order.");
		form_obj.num.value="1";
        form_obj.num.focus();
        return false;
	}
	else if (num > stock) {
		alert("Not enough books.");
		form_obj.num.value="1";
        form_obj.num.focus();
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
			fudandb.Book book = new Book();
			String ISBN = request.getParameter("ISBN");
			List list = book.bookdetail(ISBN, connector.stmt);
			String[] str = new String[10];
			for (int i = 0; i < list.size(); i++) {
				str[i] = (String) list.get(i);
			}
			int stock = Integer.parseInt(str[5]);
			
		%>
			<title>[ Book Detail ]</title>
			<div style="margin-left: 150px;">
				<span>[ISBN]:</span><%=str[0]%><br>
				<span>[Title]:</span><%=str[1] %><br>
				<span>[Author]:</span><%=str[2] %><br>
				<span>[Publisher]:</span><%=str[3] %><br>
				<span>[Publish Year]:</span><%=str[4] %><br>
				<span>[Stock]:</span><%=str[5] %><br>
				<span>[Format]:</span><%=str[6] %><br>
				<span>[Price]:</span><%=str[7] %><br>
				<span>[Keyword]:</span><%=str[8] %><br>
				<span>[Subject]:</span><%=str[9] %><br><br>		
			</div>
			
			<line>-------------------------------------------------------------------------------------------------------------------</line>
			
			<title>[ Order it ]</title>
			<form name="order" method=get action="orderbook.jsp" onsubmit="return checkorder(this)">
				<input name="ISBN" value="<%=ISBN %>" type=hidden>
				<input name="username" value="<%=username %>" type=hidden>
				<input name="stock" value="<%=stock %>" type=hidden>
				<span style="margin-left: 170px;">Add </span>
				<input name="num" type=text value="1" style="width:50px;">
				<span>of it to current order.</span>
				<input id="button" type=submit value="order">
			</form>
			
			<line>-------------------------------------------------------------------------------------------------------------------</line>
			
			<title>[ Feedback ]</title>
			
		<%
			if (username.length() == 0) {
		%>
			<span style="display:block; text-align:center;">You have to sign in to give a feedback.</span>
		<%		
			}
			else {
				fudandb.Feedback feedback = new Feedback();
				String[] exist = new String[3]; 
				exist = feedback.existfeedback(username, ISBN, connector.stmt);
				if (exist[0].length() != 0) {
		%>
			<span style="display:block; text-align:center;">You have already given a feedback on this book.</span>
			<div style="margin-left: 150px;">
				<span>[Time]:</span><%=exist[0]%><br>
				<span>[Score]:</span><%=exist[1] %><br>
				<span>[Text]:</span><%=exist[2] %><br>		
			</div>
		<%		
				}
				else {
		%>
			<div style="margin-left: 150px;">
			<form name="givefeedback" method=get action="newfeedback.jsp" onsubmit="return check_all_fields(this);">
				<span>[Score]:</span>
				<input name="username" value=<%=username %> type=hidden>
				<input name="ISBN" value=<%=ISBN %> type=hidden>
				<select name="fbscore" style="margin-left: 10px; width: 100px;">
      				<option value="" selected="selected">Choose</option>
      				<option value="1">1</option>
      				<option value="2">2</option>
      				<option value="3">3</option>
      				<option value="4">4</option>
      				<option value="5">5</option>
      				<option value="6">6</option>
      				<option value="7">7</option>
      				<option value="8">8</option>
      				<option value="9">9</option>
      				<option value="10">10</option>
      			</select>
      			<br>
      			<span>[Short Text]:</span>&nbsp no longer than 200 chars.
      			<br>
      			<input id="input" name="text" type=text style="margin-left: 15px; margin-top: 10px; width: 650px; height: 30px;"><BR>   			
      			<br>
      			<input id="button" type=submit value="feedback" style="margin-right: 150px;">
      		</form>	
			</div>
		<%
					
				}
			}
		connector.closeStatement();
		connector.closeConnection();
		%>
		
			<line>-------------------------------------------------------------------------------------------------------------------</line>
			<title>[ Show Useful Feedbacks]</title>
			<form name="feedback" method=get action="showfeedback.jsp">
				<input name="ISBN" value=<%=ISBN %> type=hidden>
				<span style="margin-left: 170px;">Show the </span>
				<select name="num" style="margin-left: 10px; width: 100px;">
      				<option value="5" selected="selected">5</option>
      				<option value="10">10</option>
      				<option value="15">15</option>
      				<option value="20">20</option>
      				<option value="25">25</option>
      				<option value="30">30</option>
      			</select>
				<span>most useful feedbacks.</span>
				<br>
				<input id="button" type=submit value="check" style="margin-top:0px; margin-right: 150px;">
			</form>
			
			<line>-------------------------------------------------------------------------------------------------------------------</line>
			<a id="button" href="home.jsp">Back</a>
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