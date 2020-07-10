package editora.database;

import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.Properties;

public class GetPropertyValues {

    //acede ao ficheiro de propriedade e retorna propriedade pedida
    public String getProperties(String name) {
        String value = null;
        InputStream inputStream;

        try {
            Properties prop = new Properties();
            String propFileName = "config.properties";
            inputStream = getClass().getResourceAsStream(propFileName);

            if (inputStream != null) {
                prop.load(inputStream);
            } else {
                throw new FileNotFoundException("file '" + propFileName + "' not found");
            }

            value = prop.getProperty(name);

        } catch (Exception e) {
            System.out.println("Exception: " + e);
        }
        return value;
    }
}
