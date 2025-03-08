package com.model.dao;

import java.sql.*;

import com.model.db.DatabaseConnection;

public class ReferenceRangeCls {

	public String[] getRealRefRangeAll(String test_code, int AGE_DAYS, int GENDER) {
		String[] arr = new String[3];
		DatabaseConnection conn = new DatabaseConnection();
		ResultSet rs = null;
		String query = "";
		try {
			conn.ConnectToDataBase();
			query = "SELECT NVL(R.NORMAL_LOW_VALUE, ' '), NVL(R.NORMAL_HIGH_VALUE, ' '), NVL(R.PRINT_REF_RANGE, ' ') "
					+ "FROM LAB_TEST_REF_RANGES@COLOMBO_LIVE R " + "WHERE R.TEST_CODE = '" + test_code + "' AND R.GENDER = " + GENDER
					+ " AND R.MIN_AGE_DAYS < " + AGE_DAYS + " AND " + AGE_DAYS + " <= R.MAX_AGE_DAYS AND R.STATUS = 1";
			rs = conn.query(query);
			if (rs.next()) {
				arr[0] = rs.getString(1);
				arr[1] = rs.getString(2);
				arr[2] = rs.getString(3);
			} else {
				arr[0] = "---";
				arr[1] = "---";
				arr[2] = "---";
			}
			conn.CloseDataBaseConnection();
			return arr;
		} catch (Exception e) {
			conn.CloseDataBaseConnection();
			return arr;
		}
	}

	public String getRealRefRange(String test_code, int AGE_DAYS, int GENDER) {
		String PRINT_REF_RANGE = "---";
		DatabaseConnection conn = new DatabaseConnection();
		ResultSet rs = null;
		String query = "";
		try {
			conn.ConnectToDataBase();
			query = "SELECT NVL(R.PRINT_REF_RANGE, ' ') " + "FROM LAB_TEST_REF_RANGES@COLOMBO_LIVE R " + "WHERE R.TEST_CODE = '"
					+ test_code + "' AND R.GENDER = " + GENDER + " AND R.MIN_AGE_DAYS < " + AGE_DAYS + " AND "
					+ AGE_DAYS + " <= R.MAX_AGE_DAYS AND R.STATUS = 1";
			rs = conn.query(query);
			while (rs.next()) {
				PRINT_REF_RANGE = rs.getString(1);
			}
			conn.CloseDataBaseConnection();
			return PRINT_REF_RANGE;
		} catch (Exception e) {
			conn.CloseDataBaseConnection();
			return PRINT_REF_RANGE;
		}
	}

	public String getRealRefRangeOne(String test_code, int AGE_DAYS, int GENDER, int low_high) {
		String ref = "---";
		DatabaseConnection conn = new DatabaseConnection();
		ResultSet rs = null;
		String query = "";
		String col = "";
		if (low_high == 1) {
			col = "NORMAL_LOW_VALUE ";
		} else if (low_high == 2) {
			col = "NORMAL_HIGH_VALUE ";
		}
		try {
			conn.ConnectToDataBase();
			query = "SELECT NVL(R." + col + ", ' ') FROM LAB_TEST_REF_RANGES@COLOMBO_LIVE R " + "WHERE R.TEST_CODE = '" + test_code
					+ "' AND R.GENDER = " + GENDER + " AND R.MIN_AGE_DAYS < " + AGE_DAYS + " AND " + AGE_DAYS
					+ " <= R.MAX_AGE_DAYS AND R.STATUS = 1";
			rs = conn.query(query);
			while (rs.next()) {
				ref = rs.getString(1);
			}
			conn.CloseDataBaseConnection();
			return ref;
		} catch (Exception e) {
			conn.CloseDataBaseConnection();
			return ref;
		}
	}
}
