<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="fudandb.*"%>
<html>

<head>
	<link rel="stylesheet" type="text/css" href="css/style.css" />

<script LANGUAGE="javascript">
function check_all_fields(form_obj){
        if( form_obj.username.value == ""){
                alert("Username should be nonempty");
                return false;
        }
        else if (form_obj.username.length > 20) {
        	alert("Username should be no longer than 20.");
        	form_obj.username.value="";
            return false;
        }
        else if( form_obj.password.value == ""){
            alert("Password should be nonempty");
            return false;
    	}
        else if (form_obj.password.value != form_obj.password2.value) {
        	alert("You entered two different password.");
        	form_obj.password.value = "";
        	form_obj.password2.value = "";
        	form_obj.password.focus();
        	return false;
        }
        else if (form_obj.phone.value != "" && isNaN(form_obj.phone.value)) {
        	alert("Phone number has to be digits.");
        	form_obj.phone.value = "";
        	form_obj.phone.focus();
        	return false;
        }
        return true;
}
</script>

<title>Sign Up</title>
</head>

<body>

	<div id="page"> 
		<div id="header">
			<a href="index.html"><title>Online Book Store</title></a>
		</div>
		
		<div id="body">
						<title>[ Sign Up ]</title>
		
		<%
			String signup = request.getParameter("signUp");
			if (signup == null) {
		%>
			<form name="signup" method=get action="signup.jsp" onsubmit="return check_all_fields(this);">
				<input type=hidden name="signUp" value="signUp">
				<ul style="text-align: left; margin-left: 200px;">
					<li><span>Username:</span><input id="input" name="username" type=text>*&nbsp Username should be no longer than 20.</li><BR>
					<li><span>Password:</span><input id="input" name="password" type=password>*&nbsp</li><BR>
					<li><span>Confirm Password:</span><input id="input" name="password2" type=password>*&nbsp Please enter the password again.</li><BR>
					<li><span>Fullname:</span><input id="input" name="fullname" type=text></li><BR>
					<li><span>Address:</span><input id="input" name="address" type=text></li><BR>
					<li><span>Phone number:</span><input id="input" name="phone" type=text></li><BR>
				</ul>				
				<input id="button" type=submit value="submit">
			</form>
			
		<%
			}
			
			else {
				fudandb.Connector connector = new Connector();
				fudandb.User user = new User();
				
				String username = request.getParameter("username");
				String password = request.getParameter("password");
				String fullname = request.getParameter("fullname");
				String address = request.getParameter("address");
				String phone = request.getParameter("phone");
				String rst = user.createuser(username, password, fullname, address, phone, connector.stmt);
		%>
			<title><%=rst %></title>
			<a id="button" href="customerentry.jsp">Back</a>
		<%
				if (rst.indexOf("Welcome") != -1) {
					Cookie cookie = new Cookie("username", username);
					cookie.setPath("/");
					cookie.setMaxAge(-1);
					response.addCookie(cookie);
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
	</div>

</body>
</html>