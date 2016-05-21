package fudandb;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class User {

	public User() {
	}
	
	public boolean existuser(String username, Statement stmt) {
		String sql="select count(*) from User where username='"+username+"';";
		int num=0;
		ResultSet rs = null;
		
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
		
		if (num > 0) return true;
		else return false;
	}
	
	public String createuser (String username, String password, String fullname, String address, String phone, Statement stmt) throws IOException {

		String sql;
		ResultSet rs=null;
		String rst="";
	
		sql="select count(*) from User where username='"+username+"';";
		int num=0;
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
		if (num > 0) {
			rst = "This username has been used. Please try another one.";
			return rst;
		}
		
		sql="insert into User(username, password";
		if (fullname.length() != 0) {
			sql += ", fullname";
		}
		if (address.length() != 0) {
			sql += ", address";
		}
		if (phone.length() != 0) {
			sql += ", phone";	
		}
		sql += ") value('" +username+ "', '" +password+ "'";
		if (fullname.length() != 0) {
			sql += ", '" +fullname+ "'";
		}
		if (address.length() != 0) {
			sql += ", '" +address+ "'";
		}
		if (phone.length() != 0) {
			sql += ", " +phone;	
		}
		sql += ");";
		
		try{
			stmt.execute(sql);
			rst ="Welcome to join us, " +username+ "!\n";
		}
		catch(Exception e) { 
			System.out.println(e);
		}
		
		return rst;
	}

	public boolean login(String username, String password, Statement stmt) {
		String output="";
		String sql;
		ResultSet rs=null;
		
		sql="select username from User where username='" +username+ "' and password='" +password+ "';";
		System.out.println("executing: " +sql);
		
		try{
	   		rs=stmt.executeQuery(sql);
	   		while (rs.next()) {
				output+=rs.getString("username"); 
			}     
			rs.close();
   		 }
   		 catch(Exception e) {
   		 	System.out.println("cannot execute the query");
   		 }
   		 finally {
   		 	try{
	   		 	if (rs!=null && !rs.isClosed()) rs.close();
   		 	}
   		 	catch(Exception e) {
   		 		System.out.println("cannot close resultset");
   		 	}
   		 }
		
		if (output.length() == 0) {
			return false;
		}
		else {
			return true;
		}
	}

	public String existtrust(String username, String user, Statement stmt) {
		String rst = "";
		ResultSet rs = null;
		int r = 0;
		
		String sql = "select trust from Trust where user1 = '" +username+ "' and user2 = '" +user+ "';";
		try{
			rs=stmt.executeQuery(sql);
			if (rs.next())
				r = rs.getInt(1);
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
		
		if (r == 1) 
			rst = "trust";
		else if (r == -1)
			rst = "don't trust";
		
		return rst;
	}
	
	public String trust(String username, String user, String trust, Statement stmt) throws IOException {
		String rst = "Fail to trust/not trust " +user+ ".";
		String sql="insert into Trust value('" +username+ "', '" +user+ "', " +trust+ ");";
		try{
			stmt.execute(sql);
			rst = "Success to trust/not trust " +user+ ".";
		}
		catch(Exception e) { 
			System.out.println(e);
		}
		return rst;
	}

	public List mosttrusted(int m, Statement stmt) {
		List list = new ArrayList();
		
		String sql="select user2, sum(trust) from Trust group by user2 order by 2 desc;";
		String output="";
		ResultSet rs=null;
		int i=0;
		System.out.println("executing: " +sql);
		System.out.println();
		try{
			rs=stmt.executeQuery(sql);
			while (rs.next() && i<m) {
				String[] rst = new String[2];
				rst[0] = rs.getString(1);
				rst[1] = rs.getString(2);
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
		/*
		System.out.print("Here are the top " +i+ " most trusted users:");
		if (i < m) {
			System.out.println("(Other users haven't been trusted/not-trusted by other users)");
		}
		System.out.println("username\ttrusting score");
		System.out.print(output);
		*/
	}
	
	public List mostuseful(int m, Statement stmt) {
		List list = new ArrayList();
		String sql="select user, avg(rating) from Rating group by user order by 2 desc;";
		String output="";
		ResultSet rs=null;
		int i=0;
		System.out.println("executing: " +sql);
		System.out.println();
		try{
			rs=stmt.executeQuery(sql);
			while (rs.next() && i<m) {
				String[] rst = new String[2];
				rst[0] = rs.getString(1);
				rst[1] = rs.getString(2);
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
	
	public List searchuser(String username, Statement stmt) {
		List list = new ArrayList();
		ResultSet rs = null;
		
		String sql = "select username, fullname, address, phone from User where username like '%" +username+ "%';";
		try{
			rs=stmt.executeQuery(sql);
			while (rs.next()) {
				String[] rst = new String[4];
				rst[0] = rs.getString(1);
				rst[1] = rs.getString(2);
				rst[2] = rs.getString(3);
				rst[3] = rs.getString(4);
				list.add(rst);
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
