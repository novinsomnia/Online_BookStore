package fudandb;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

public class Book {
	
	public Book() {
		
	}
	
	public String recordnewbook(String ISBN, String title, String author1, String author2, String author3, String publisher, 
			String pub_year, String copy_num, String format, String price, String keyword, String subject, Statement stmt) {
		String rst="Success to add this book <" +title+ ">.";
		
		String sql="insert into Book(ISBN, title";
		if (publisher.length() != 0) {
			sql += ", publisher";
		}
		if (pub_year.length() != 0) {
			sql += ", pub_year";
		}
		if (copy_num.length() != 0) {
			sql += ", copy_num";			
		}
		if (format.length() != 0) {
			sql += ", format";			
		}
		sql += ", price";
		if (keyword.length() != 0) {
			sql += ", keyword";			
		}
		if (subject.length() != 0) {
			sql += ", subject";			
		}
		sql += ") value ('" +ISBN+ "', '" +title+ "'";
		
		if (publisher.length() != 0) {
			sql += ", '" +publisher+ "'";
		}
		if (pub_year.length() != 0) {
			sql += ", " +pub_year;
		}
		if (copy_num.length() != 0) {
			sql += ", " +copy_num;			
		}
		if (format.length() != 0) {
			sql += ", "+format;			
		}
		sql += ", " +price;
		if (keyword.length() != 0) {
			sql += ", '" +keyword+ "'";			
		}
		if (subject.length() != 0) {
			sql += ", '" +subject+ "'";			
		}
		sql += ");";
		
		try{
			stmt.execute(sql);
		}
		catch(Exception e) { 
			System.out.println(e);
			return "Fail to add this book. "+e;
		}
		
		String sql2 = "insert into Author value('" +ISBN+ "', '" +author1+ "');";
		try{
			stmt.execute(sql2);
		}
		catch(Exception e) { 
			System.out.println(e);
			return "" +e;
		}
		
		if (author2.length() != 0) {
			sql2 = "insert into Author value('" +ISBN+ "', '" +author2+ "');";
			try{
				stmt.execute(sql2);
			}
			catch(Exception e) { 
				System.out.println(e);
				return "" +e;
			}
		}
		
		if (author3.length() != 0) {
			sql2 = "insert into Author value('" +ISBN+ "', '" +author3+ "');";
			try{
				stmt.execute(sql2);
			}
			catch(Exception e) { 
				System.out.println(e);
				return "" +e;
			}
		}	
		return rst;
	}
	
	public String newcopies(String ISBN, int cn, Statement stmt) throws IOException {
		String sql;
		String title = "";
		ResultSet rs = null;
		
		sql = "select title from Book where ISBN='" +ISBN+ "';";
    	try {
    		rs=stmt.executeQuery(sql);
    		while (rs.next()) {
    			title = rs.getString("title");
    		}
    	}
    	catch(Exception e) {
    		return "" + e;
    	}
		
    	if (title.length() == 0)
    		return "Not exist a book's ISBN = '" +ISBN+ "'.";
    	
    	
		sql="update Book set copy_num=copy_num+" +cn+ " where ISBN='" +ISBN+ "';";
    	System.out.println("executing: " +sql);
		try{
			stmt.execute(sql);
		}
		catch(Exception e) { 
			System.out.println(e);
		}
    	return "Success to add " +cn+ " copies to book <" +title+ ">.";
	}

	public List browse(String username, String title, String t1, String author, String t2, String publisher, String t3, String subject, int order, Statement stmt) {
		List list = new ArrayList();
		String sql;
		ResultSet rs=null;
		
		if (order == 2) {
			sql="select b.ISBN, title, publisher, pub_year, price, subject, avg(f1.score), avg(f2.score)"
					+" from Book b left join Feedback f1 on b.ISBN=f1.ISBN"
					+ " left join Feedback f2 on b.ISBN=f2.ISBN and f2.username in (select user2 from Trust where user1='" +username+ "')"
					+ " where title like '%" +title+ "%'";
			
			if (author.length() != 0) {
				sql += " " +t1+ " b.ISBN in (select a.ISBN from Author a where a.author like '%" +author+ "%'";
			}
			if (publisher.length() != 0) {
				sql += " " +t2+ " publisher like '%" +publisher+ "%'";
			}
			if (subject.length() != 0) {
				sql += " " +t3+ " subject like '%" +subject+ "%'";
			}
			sql += " group by b.ISBN";
			sql += " order by avg(f2.score) desc;";		
			
			try{
				rs=stmt.executeQuery(sql);
				while (rs.next()) {
					String[] rst = new String[8];
					for (int i = 0; i < 8; i++) {
						rst[i] = rs.getString(i+1);
					}
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
		}
		else {
			sql="select b.ISBN, title, publisher, pub_year, price, subject, avg(f1.score)"
					+" from Book b left join Feedback f1 on b.ISBN=f1.ISBN"
					+ " where title like '%" +title+ "%'";
			if (author.length() != 0) {
				sql += " " +t1+ " b.ISBN in (select a.ISBN from Author a where a.author like '%" +author+ "%'";
			}
			if (publisher.length() != 0) {
				sql += " " +t2+ " publisher like '%" +publisher+ "%'";
			}
			if (subject.length() != 0) {
				sql += " " +t3+ " subject like '%" +subject+ "%'";
			}
			sql += " group by b.ISBN";
			
			if (order == 0) {
				sql += " order by pub_year desc;";
			}
			else {
				sql += " order by avg(f1.score) desc;";
			}
			
			try{
				rs=stmt.executeQuery(sql);
				while (rs.next()) {
					String[] rst = new String[7];
					for (int i = 0; i < 7; i++) {
						rst[i] = rs.getString(i+1);
					}
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
		}
		return list;
	}
	
    public List popularbook(int m, Statement stmt) {
    	Date dt = new Date();  
    	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM");  
        Calendar cal = Calendar.getInstance();
        cal.setTime(dt);
        cal.add(Calendar.MONTH,-6);
        dt = cal.getTime();
    	String dateString = formatter.format(dt); 
    	System.out.println("From: " +dateString);
    	
    	String sql;
    	ResultSet rs=null;
    	int oid=0;
    	sql="select min(orderid) from UserOrder where odate like '" +dateString+ "%';";
		try{
			rs=stmt.executeQuery(sql);
			rs.next();
			oid=rs.getInt(1);
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
		
		List list = new ArrayList();
		
		sql="select b1.ISBN, b2.title, sum(num) from BookOrder b1, Book b2 where orderid>" +oid+ " and b1.ISBN=b2.ISBN group by b1.ISBN order by 3 desc;";
		int i=0;
		rs=null;
		System.out.println("executing: " +sql);
		try{
			rs=stmt.executeQuery(sql);
			while (i < m && rs.next()) {
				String[] rst = new String[3];
				rst[0] = rs.getString(1);
				rst[1] = rs.getString(2);
				rst[2] = rs.getString(3);
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
    
    public List popularauthor(int m, Statement stmt) {
    	Date dt = new Date();  
    	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM");  
        Calendar cal = Calendar.getInstance();
        cal.setTime(dt);
        cal.add(Calendar.MONTH,-6);
        dt = cal.getTime();
    	String dateString = formatter.format(dt); 
    	System.out.println("From: " +dateString);
    	
    	String sql;
    	ResultSet rs=null;
    	int oid=0;
    	sql="select min(orderid) from UserOrder where odate like '" +dateString+ "%';";
		try{
			rs=stmt.executeQuery(sql);
			rs.next();
			oid=rs.getInt(1);
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
    	
		List list = new ArrayList();
		
		sql="select a.author, sum(num) from BookOrder b, Author a where b.ISBN=a.ISBN group by a.author order by 2 desc;";
		int i=0;
		rs=null;
		String output="";
		System.out.println("executing: " +sql);
		try{
			rs=stmt.executeQuery(sql);
			while (i < m && rs.next()) {
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
		return list;
    }

    public List popularpublisher(int m, Statement stmt) {
    	Date dt = new Date();  
    	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM");  
        Calendar cal = Calendar.getInstance();
        cal.setTime(dt);
        cal.add(Calendar.MONTH,-6);
        dt = cal.getTime();
    	String dateString = formatter.format(dt); 
    	System.out.println("From: " +dateString);
    	
    	String sql;
    	ResultSet rs=null;
    	int oid=0;
    	sql="select min(orderid) from UserOrder where odate like '" +dateString+ "%';";
		try{
			rs=stmt.executeQuery(sql);
			rs.next();
			oid=rs.getInt(1);
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
    	
		List list = new ArrayList();
		sql="select b2.publisher, sum(num) from BookOrder b1, Book b2 where b1.ISBN=b2.ISBN group by b2.publisher order by 2 desc;";
		int i=0;
		rs=null;
		System.out.println("executing: " +sql);
		try{
			rs=stmt.executeQuery(sql);
			while (i < m && rs.next()) {
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

    public List bookdetail(String ISBN, Statement stmt) {
    	List list = new ArrayList();
    	ResultSet rs = null;
    	String sql = "select ISBN, title from Book where ISBN='" +ISBN+ "';";
    	
		try{
			rs=stmt.executeQuery(sql);
			if (rs.next()) {
				list.add(rs.getString(1));
				list.add(rs.getString(2));
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
		rs = null;
		
		sql = "select author from Author where ISBN='" +ISBN+ "';";		
		String author="";
		try{
			rs=stmt.executeQuery(sql);
			if (rs.next()) {
				author += rs.getString(1);
			}
			while (rs.next()) {
				author += ", " +rs.getString(1);
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
		list.add(author);
		rs = null;
		
    	sql = "select publisher, pub_year, copy_num, format, price, keyword, subject from Book where ISBN = '" +ISBN+ "';";
		try{
			rs=stmt.executeQuery(sql);
			if (rs.next()) {
				for (int i = 1; i <= 3; i++) 
					list.add(rs.getString(i));
				String format = rs.getString(4);
				if (format == null || format.length() == 0) {
					list.add("don't know");
				}
				else if (format.equals("0")) {
					list.add("hard");
				}
				else {
					list.add("soft");
				}
				for (int i = 5; i <= 7; i++)
					list.add(rs.getString(i));
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
    	
    	return list;
    }
}
