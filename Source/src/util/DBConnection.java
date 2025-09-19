package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
	public static Connection getConnection() throws Exception {
		// 설정 파일에서 데이터베이스 정보 읽기
		String host = ConfigUtil.getDbHost();
		String port = ConfigUtil.getDbPort();
		String dbName = ConfigUtil.getDbName();
		String username = ConfigUtil.getDbUsername();
		String password = ConfigUtil.getDbPassword();
		
		String url = "jdbc:mysql://" + host + ":" + port + "/" + dbName;

        Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL 드라이버
        return DriverManager.getConnection(url, username, password);
	}

}
