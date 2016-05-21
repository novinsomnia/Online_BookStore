package fudandb;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.ResultSet;
import java.sql.Statement;

public class Author {
	public Author() {
		
	}
	
	public String sepdegree (String au1, String au2, Statement stmt) throws IOException {
    	BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
    	int rst = 3;
    	
    	ResultSet rs = null;
    	boolean first = false;
    	boolean second = false;
    	
	    	String sql="select distinct author from Author where author = '" +au1+ "';";
	    	System.out.println("executing: " +sql);
			try{
				rs=stmt.executeQuery(sql);
				first = rs.next();
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
			if (first == false)
				return "Not exist an author named " +au1+ ".";
		
			
			rs = null;
			sql="select distinct author from Author where author like '%" +au2+ "%';";
			try{
				rs=stmt.executeQuery(sql);
				second = rs.next();
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
			if (second == false)
				return "Not exist an author named " +au2+ ".";
		
		//1-degree
		rs=null;
		int num=0;
		sql="select count(*) from Author as a, Author as b where a.author='" +au1+ 
    			"' and b.author='" +au2+ "' and a.ISBN=b.ISBN;";
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
			return au1+ " and " +au2+ " are 1-degree of seperation.";
		}
    	
		//2-degree
		rs=null;
		num=0;
		sql="select count(*) from Author a "
				+ "where a.author in (select b1.author from Author b1, Author b2 where b1.ISBN=b2.ISBN and b2.author='" +au1+ "') "
						+ "and a.author in (select c1.author from Author c1, Author c2 where c1.ISBN=c2.ISBN and c2.author='" +au2+ "');";
		System.out.println("executing: " +sql);
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
			return au1+ " and " +au2+ " are 2-degree of seperation.";
		}
		
		return au1+ " and " +au2+ " are neither 1-degree nor 2-degree of seperation.";
	}
}
