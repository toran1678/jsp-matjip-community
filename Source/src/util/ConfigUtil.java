package util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class ConfigUtil {
    private static Properties properties;
    
    static {
        loadProperties();
    }
    
    private static void loadProperties() {
        properties = new Properties();
        try {
            // 클래스패스에서 config.properties 파일 로드
            InputStream inputStream = ConfigUtil.class.getClassLoader()
                .getResourceAsStream("config.properties");
            
            if (inputStream != null) {
                properties.load(inputStream);
                inputStream.close();
            } else {
                System.err.println("config.properties 파일을 찾을 수 없습니다.");
            }
        } catch (IOException e) {
            System.err.println("설정 파일 로드 중 오류 발생: " + e.getMessage());
        }
    }
    
    public static String getProperty(String key) {
        return properties.getProperty(key);
    }
    
    public static String getProperty(String key, String defaultValue) {
        return properties.getProperty(key, defaultValue);
    }
    
    // 데이터베이스 설정
    public static String getDbHost() {
        return getProperty("db.host", "localhost");
    }
    
    public static String getDbPort() {
        return getProperty("db.port", "3306");
    }
    
    public static String getDbName() {
        return getProperty("db.name", "MatJip");
    }
    
    public static String getDbUsername() {
        return getProperty("db.username", "root");
    }
    
    public static String getDbPassword() {
        return getProperty("db.password", "");
    }
    
    // 이메일 설정
    public static String getEmailAddress() {
        return getProperty("email.address", "");
    }
    
    public static String getEmailPassword() {
        return getProperty("email.password", "");
    }
    
    // 카카오 지도 API
    public static String getKakaoMapApiKey() {
        return getProperty("kakao.map.api.key", "");
    }
}
