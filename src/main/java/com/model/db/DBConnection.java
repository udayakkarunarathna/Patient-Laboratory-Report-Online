package com.model.db;

import java.sql.*;

public class DBConnection {

	// JDBC driver name and database URL
	static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
	static final String DB_URL = "jdbc:mysql://192.168.3.71/nawaloka_cc?autoReconnect=true&allowPublicKeyRetrieval=true&useSSL=false";

	// Database credentials
	static final String USER = "root";
	static final String PASS = "Udaya@123";

	Connection conn = null;
	Statement stmt = null;
	ResultSet rs;

	public void ConnectToDataBase() {
		try {
			// Register JDBC driver
			Class.forName("com.mysql.jdbc.Driver");

			// Open a connection
			// System.out.println("Connecting to database...");
			conn = DriverManager.getConnection(DB_URL, USER, PASS);

			// Execute a query
			// System.out.println("Creating statement...");
			stmt = conn.createStatement();

		} catch (Exception x) {
			x.printStackTrace();
		}
	}

	public ResultSet getResultSet(String query) throws SQLException {
		rs = stmt.executeQuery(query);
		// System.out.println("Returning resulset...");
		return rs;
	}

	//when auto commit is false
	public boolean InsertToDatabaseWithoutCommit(String query) {
		boolean result = false;
		try {
			stmt.executeUpdate(query);
			result = true;
		} catch (SQLException e) {
			result = false;
			System.out.println(e);
			System.out.println("Error Inserting Data To Table");
		}
		return result;
	}

	public void SaveToDataBase(boolean bCommit) {
		try {
			if (bCommit) {
				conn.commit();
			} else {
				conn.rollback();
			}
		} catch (SQLException sqlexception) {
			System.out.println(sqlexception);
		}
	}

	public void CloseDataBaseConnection() {
		// System.out.println("Closing the database connection...");
		try {
			if (rs != null) {
				rs.close();
			}
			if (stmt != null) {
				stmt.close();
			}
			if (conn != null) {
				conn.close();
			}
		} catch (SQLException sqlexception) {
			System.out.println(sqlexception);
		}
	}

}
