package fudandb;

import java.sql.*;

public class Connector {
	public Connection con;
	public Statement stmt;
	public Connector() throws Exception {
		try{
		 	//String userName = "fudanu31";
	   		//String password = "8e51kikn";
	        //String url = "jdbc:mysql://10.141.208.26/fudandbd31";
	        String userName = "root";
	   		String password = "110120119";
	        String url = "jdbc:mysql://127.0.0.1:3306/BookManagement";
		    Class.forName ("com.mysql.jdbc.Driver").newInstance ();
		    con = DriverManager.getConnection (url, userName, password);
			stmt = con.createStatement();
        } catch(Exception e) {
			System.err.println("Unable to open mysql jdbc connection. The error is as follows,\n");
            		System.err.println(e.getMessage());
			throw(e);
		}
	}
	
	public void closeConnection() throws Exception{
		con.close();
	}
	
	public void closeStatement() throws SQLException {
		stmt.close();
	}
}
