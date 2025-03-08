package com.model.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.sql.DataSource;

public class DatabaseConnectionOut {

	public static int DbConnCount;
	Connection con;
	Statement stmt;
	ResultSet rs;
	DataSource ds;
	String main_unit;

	public DatabaseConnectionOut(String main_unit) {
		System.out.println("main_unit 1 = " + main_unit);
		this.main_unit = main_unit;
	}

	public void ConnectToDataBase() {

		String db_ip = "", uname = "", pwd = "";
		System.out.println("main_unit 2 = " + main_unit);

		if (main_unit.toUpperCase().equals("KANDY")) {
			db_ip = "47.241.62.112";
			uname = "LAB";
			pwd = "LAB";
		}

		System.out.println("db_ip = " + db_ip);
		System.out.println("uname = " + uname);
		System.out.println("pwd = " + pwd);

		// System.out.println("db_ip = " + db_ip);
		// System.out.println("Trying to connect DB...");
		try {
			// step1 load the driver class
			Class.forName("oracle.jdbc.driver.OracleDriver");
			// System.out.println("1");
		} catch (ClassNotFoundException e) {
			// System.out.println("ClassNotFoundException.....");
			e.printStackTrace();
		}
		try {
			// step2 create the connection object
			// System.out.println("2");
			System.out.println("db_ip = " + db_ip);
			System.out.println("uname = " + uname);
			System.out.println("pwd = " + pwd);
			con = DriverManager.getConnection("jdbc:oracle:thin:@" + db_ip + ":1521:HOSPITAL", uname, pwd);

			// step3 create the statement object
			stmt = con.createStatement();
			DbConnCount++;
		} catch (SQLException x) {
			// System.out.println("SQLException....");
			x.printStackTrace();
		}
	}

	public ResultSet query(String query) throws SQLException {
		rs = stmt.executeQuery(query);
		return rs;
	}

	public boolean InsertToDatabaseWithoutCommit(String query) {
		boolean result = false;
		try {
			stmt.executeUpdate(query);
			result = true;
		} catch (SQLException e) {
			result = false;
			// System.out.println("Error Inserting Data...");
		}
		return result;
	}

	public void SaveToDataBase(boolean bCommit) {
		try {
			if (bCommit) {
				con.commit();
			} else {
				con.rollback();
			}
		} catch (SQLException sqlexception) {
			// System.out.println("Error Commit Data...");
		}
	}

	public void CloseDataBaseConnection() {
		try {
			if (rs != null) {
				rs.close();
			}
			if (stmt != null) {
				stmt.close();
			}
			if (con != null) {
				con.close();
				DbConnCount--;
				// System.out.println("");
			}
		} catch (SQLException sqlexception) {
			// System.out.println("Error Closing DataBase Connection");
		}
	}

	public boolean DirectInsertToDataBase(String query) throws SQLException {
		stmt.executeUpdate(query);
		con.commit();
		return true;
	}
}