package fudandb;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Feedback {
	public Feedback() {
		
	}
	
	public String newfeedback(String username, String ISBN, int score, String text, Statement stmt) {
    	String rst = "";
		ResultSet rs=null;
		int num = 0;
		String sql="select count(*) from Book where ISBN='" +ISBN+ "';";
		try{
			rs=stmt.executeQuery(sql);
			rs.next();
			num=rs.getInt(1);
		}
		catch(Exception e) { 
			System.out.println(e);
		}
		finally {
			try{
				if (rs!=null && !rs.isClosed())
				rs.close();
			}
			catch(Exception e) {
				System.out.println("cannot close resultset");
			}
		}	
		if (num==0) {
			rst = "Not exist a book's ISBN is " +ISBN+ ".";
			return rst;
		}
				
		rst = "";
		Date currentTime = new Date();  
    	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
    	String dateString = formatter.format(currentTime); 
    	
    	sql="insert into Feedback(username, ISBN, fbdate, score";
    	if (text.length() != 0) {
    		sql += ", text";
    	}
    	sql += ") value ('" +username+ "', '" +ISBN+ "','" +dateString+ "', " +score;
    	if (text.length() != 0) {
    		sql += ", '" +text+ "'";
    	}
    	sql += ");";
    	
		try{
			stmt.execute(sql);
			rst = "Success to give a feedback.";
		}
		catch(Exception e) { 
			System.out.println(e);
			rst = "Fail to give a feedback.";
		}
		return rst;
	}
	
	public String ratefeedback(String username, String user, String ISBN, int num, Statement stmt) throws IOException {
		String rst="";
		
		String sql="insert into Rating value('" +username+ "', '" +user+ "', '" +ISBN+ "', " +num+ ");";
		try{
			stmt.execute(sql);
			rst = "Success to rate the feedback.";
		}
		catch(Exception e) { 
			System.out.println(e);
			rst = "Fail to rate the feedback.";
		}
		
		return rst;
	}

	public String existrating(String username, String user, String ISBN, Statement stmt) {
		String rst = "";
		String sql = "select rating from Rating where username = '" +username+ "' and user = '" +user+ "' and ISBN='" +ISBN+ "';";
		ResultSet rs = null;
		try{
			rs=stmt.executeQuery(sql);
			if (rs.next()) {
				rst = rs.getString(1);				
			}
		}
		catch(Exception e) { 
			System.out.println(e);
		}
		finally {
			try{
				if (rs!=null && !rs.isClosed())
				rs.close();
			}
			catch(Exception e) {
				System.out.println("cannot close resultset");
			}
		}
		if (rst.equals("0"))
			return "useless";
		else if (rst.equals("1"))
			return "useful";
		else if (rst.equals("2"))
			return "very useful";
		else
			return "";
	}
	
	public String[] existfeedback(String username, String ISBN, Statement stmt) {
		String sql = "select fbdate, score, text from Feedback where username='" +username+ "' and ISBN = '" +ISBN+ "';";
		ResultSet rs = null;
		String[] rst = new String[3];
		try{
			rs=stmt.executeQuery(sql);
			if (rs.next()) {
				rst[0] = rs.getString(1);
				rst[1] = rs.getString(2);
				rst[2] = rs.getString(3);				
			}
			else {
				rst[0] = rst[1] = rst[2] = "";
			}
		}
		catch(Exception e) { 
			System.out.println(e);
		}
		finally {
			try{
				if (rs!=null && !rs.isClosed())
				rs.close();
			}
			catch(Exception e) {
				System.out.println("cannot close resultset");
			}
		}
		return rst;
	}

	public List showfeedback(String ISBN, int m, Statement stmt) {
		List list = new ArrayList();
		ResultSet rs = null;
		int i = 0;
		String sql="select f.username, f.fbdate, f.score, f.text, avg(rating) from Feedback f left join Rating r "
				+ "on f.ISBN=r.ISBN and f.username=r.user where f.ISBN='" +ISBN+ "' "
				+ "group by f.username order by 5 desc;";
		try{
			rs=stmt.executeQuery(sql);
			while (rs.next() && i<m) {
				String[] rst = new String[5];
				for (int n = 0; n < 5; n++) {
					rst[n] = rs.getString(n+1);
				}
				list.add(rst);
				i++;
			}
			rs.close();
		}
		catch(Exception e) {
			System.out.println(e);
		}
		finally {
			try{
				if (rs!=null && !rs.isClosed()) rs.close();
		 	}
		 	catch(Exception e) {
		 		System.out.println("cannot close resultset");
		 	}
		}
		return list;
	}
}
