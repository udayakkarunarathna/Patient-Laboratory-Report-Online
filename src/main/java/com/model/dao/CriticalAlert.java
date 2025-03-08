package com.model.dao;

import java.sql.ResultSet;

import com.model.db.DatabaseConnection;

public class CriticalAlert {
	public boolean isHavingAlert(final String testCode, final String value) {
		boolean result = false;
		final DatabaseConnection conn = new DatabaseConnection();
		ResultSet rs = null;
		double lowValue = 0.0;
		double highValue = 0.0;
		String otherValue = "";
		boolean isLowValueExist = false;
		boolean isHighValueExist = false;
		boolean isOtherValueExist = false;
		try {
			conn.ConnectToDataBase();
			final String sql = " select nvl(l.LOW_VALUE_ALERT,-1),nvl(l.HIGH_VALUE_ALERT,-1),nvl(l.OTHER_VALUE_ALERT,'NODATA')  from lab_tests@COLOMBO_LIVE l where l.TEST_CODE='"
					+ testCode + "'";
			//System.out.println(sql);
			rs = conn.query(sql);
			while (rs.next()) {
				lowValue = rs.getDouble(1);
				highValue = rs.getDouble(2);
				otherValue = rs.getString(3);
			}
			if (lowValue != -1.0) {
				isLowValueExist = true;
			}
			if (highValue != -1.0) {
				isHighValueExist = true;
			}
			if (!"NODATA".equals(otherValue)) {
				isOtherValueExist = true;
			}
			if (isLowValueExist && isHighValueExist) {
				result = (lowValue >= Double.parseDouble(value) || highValue <= Double.parseDouble(value));
			} else {
				if (isLowValueExist) {
					result = (Double.parseDouble(value) <= lowValue);
				}
				if (isHighValueExist) {
					result = (Double.parseDouble(value) >= highValue);
				}
			}
			if (isOtherValueExist) {
				result = value.equals(otherValue);
			}
		} catch (Exception e) {
			result = false;
			e.printStackTrace();
		} finally {
			conn.CloseDataBaseConnection();
		}
		return result;
	}
}