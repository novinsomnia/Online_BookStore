package fudandb;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.*;
//import javax.servlet.http.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Order{
	public Order() {
		
	}
	
	public List showcurrentorder(int orderid, Statement stmt) {
		List list = new ArrayList();
		String sql;
		ResultSet rs=null;
		sql="select orderid, b.ISBN as ISBN, title, num, price from BookOrder as bo, Book as b where orderid=" +orderid+ " and bo.ISBN=b.ISBN;";
		
		try{
			rs=stmt.executeQuery(sql);
			while (rs.next()) {
				String[] rst = new String[4];
				rst[0] = rs.getString("ISBN");
				rst[1] = rs.getString("title");
				rst[2] = rs.getString("num");
				float price = rs.getInt("num") * rs.getFloat("price");
				rst[3] = Float.toString(price);
				list.add(rst);
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
		return list;
	}
	
	public String orderabook(int orderid, String ISBN, String username, int n, int stock, Statement stmt) throws IOException {
		int num=0;
		String sql;
		ResultSet rs=null;
		String rst = "Fail to order";
		
    	sql="select count(*) from UserOrder where orderid=" +orderid+ ";";
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
        	sql="insert into UserOrder(orderid, username) value(" +orderid+ ", '" +username+ "');";
        	System.out.println("executing: " +sql);
        	try{
        		stmt.execute(sql);
        	}
        	catch(Exception e) { 
        		System.out.println(e);
        	}
        }
        
		num=0;
    	sql="select num from BookOrder where ISBN='" +ISBN+ "' and orderid=" +orderid+ ";";
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
		
		if (num > 0 && (num+n) <= stock) {
			sql="update BookOrder set num=num+" +n+ " where orderid=" +orderid+ " and ISBN='" +ISBN+ "';";
		}
		else if (num <= 0){
			sql="insert into BookOrder value(" +orderid+ ", '" +ISBN+ "', " +n+ ");";
		}
		try{
			stmt.execute(sql);
			rst = "Success to order.";
		}
		catch(Exception e) { 
			System.out.println(e);
		}
		
		if ((num+n) > stock)
			rst = "Not enough books. Fail to order.";
		
		return rst;
	}
	
	public String finishorder(int orderid, Statement stmt) {
		Date currentTime = new Date();  
    	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
    	String dateString = formatter.format(currentTime); 
		String sql="update UserOrder set odate='" +dateString+ "' where orderid=" +orderid+ ";";
		try{
			stmt.execute(sql);
		}
		catch(Exception e) { 
			System.out.println(e);
			return "Fail to finish the order.";
		}
		
		
		ResultSet rs=null;
		String[] book = new String[20];
		String[] number = new String[20];
		int cnt=0;
		
		for (; cnt < 20; cnt++) {
			book[cnt]=null;
			number[cnt]=null;
		}
		
		cnt=0;
		sql="select ISBN, num from BookOrder where orderid=" +orderid+ ";";
		System.out.println("executing: " +sql);
		try{
			rs=stmt.executeQuery(sql);
			while (rs.next()) {
				book[cnt]=rs.getString("ISBN");
				number[cnt]=rs.getString("num");
				cnt++;
			}
		}
		catch(Exception e) {
			System.out.println(e);
			return "Fail to finish the order.";
		}
		finally {
			try{
				if (rs!=null && !rs.isClosed()) rs.close();
		 	}
		 	catch(Exception e) {
		 		System.out.println(e);
		 	}
		}
		
		String sql2;
		for (cnt=0; number[cnt] != null && cnt < 20; cnt++) {
			sql2="update Book set copy_num=copy_num-" +number[cnt]+ " where ISBN='" +book[cnt]+ "';";
			System.out.println("executing: " +sql2);
			try{
				stmt.execute(sql2);
			}
			catch(Exception e) { 
				System.out.println(e);
				return "Fail to finish the order.";
			}
		}
		
		return "Success to finish the order";
	}
	
	public List recommend(int orderid, String ISBN, Statement stmt) {
		List list = new ArrayList();
		String sql;
		ResultSet rs=null;
		
		sql="select b1.ISBN as ISBN, title, price, count(*) from BookOrder b1, Book b "
				+ "where b1.orderid in (select b2.orderid from BookOrder b2 where b2.ISBN='" +ISBN+ "') and "
						+ "b1.ISBN=b.ISBN and b.ISBN != '" +ISBN+ "' and b1.orderid != " +orderid+ " "
								+ "group by b1.ISBN order by 4 desc, 1;";
		int i=0;
		System.out.println("executing: " +sql);
		try{
			rs=stmt.executeQuery(sql);
			while (rs.next() && i<5) {
				String[] rst = new String[3];
				rst[0] = rs.getString(1);
				rst[1] = rs.getString(2);
				rst[2] = Float.toString(rs.getFloat(3));
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

	public int getorderid(Statement stmt) {
		int orderid = -1;
		ResultSet rs = null;
		String sql="select max(orderid) from UserOrder";
    	try{
			rs=stmt.executeQuery(sql);
			while(rs.next()) {
				orderid=rs.getInt(1);
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
    	orderid++;
    	return orderid;
	}

	public void clear(int orderid, Statement stmt) {
    	String sql="delete from UserOrder where orderid=" +orderid+ ";";
    	try{
    		stmt.execute(sql);
    	}
    	catch(Exception e) { 
    		System.out.println(e);
    	}
    	sql="delete from BookOrder where orderid=" +orderid+ ";";
    	try{
    		stmt.execute(sql);
    	}
    	catch(Exception e) { 
    		System.out.println(e);
    	}
	}
}
