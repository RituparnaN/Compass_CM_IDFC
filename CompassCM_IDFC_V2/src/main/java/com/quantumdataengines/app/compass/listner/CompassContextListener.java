package com.quantumdataengines.app.compass.listner;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.springframework.beans.factory.annotation.Value;

import com.quantumdataengines.app.compass.model.AOFDisabledFiledsMap;
import com.quantumdataengines.app.compass.model.scanning.NoiseWordsModel;
import com.quantumdataengines.app.compass.util.CompassEncryptorDecryptorNew;
import com.quantumdataengines.app.compass.util.CompassLanguageLoaderUtil;
import com.quantumdataengines.app.compass.util.CompassSystemInfo;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

public class CompassContextListener implements ServletContextListener{
	
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		CompassLanguageLoaderUtil loaderUtil = new CompassLanguageLoaderUtil();
		final CompassSystemInfo compassSystemInfo = new CompassSystemInfo();
		try {
			loaderUtil.loadLanguagesInstalled();
			
			new Thread(new Runnable() {				
				@Override
				public void run() {
					compassSystemInfo.refreshSystemInfo();
				}
			}).start();;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		try{
        	AOFDisabledFiledsMap.init();
        	InputStream in = this.getClass().getClassLoader().getResourceAsStream("AOFDisabledFileds.dat");
            BufferedReader br = new BufferedReader(new InputStreamReader(in));
            String currentLine = "";
            while ((currentLine = br.readLine()) != null ) {
            	AOFDisabledFiledsMap.setFiled(currentLine);
			}
            br.close();
        }catch(Exception e){
        	e.printStackTrace();
        }
        
        try{
        	/*CDDDisabledFieldsMap.init();
        	InputStream in = this.getClass().getClassLoader().getResourceAsStream("CDDDisabledFields.dat");
            BufferedReader br = new BufferedReader(new InputStreamReader(in));
            String currentLine = "";
            while ((currentLine = br.readLine()) != null ) {
            	CDDDisabledFieldsMap.setField(currentLine);
			}
            br.close();*/
			
        	Connection connection = null;				
			try{
				InputStream in = this.getClass().getClassLoader().getResourceAsStream("jdbcDetails.dat");
	            BufferedReader br = new BufferedReader(new InputStreamReader(in));
	            String driverDetails = br.readLine();
				String jdbcURL = br.readLine();
				String jdbcUser = br.readLine();
				String jdbcPassword = br.readLine();
				String schemaName = br.readLine();
				//System.out.println("driverDetails = "+driverDetails+", jdbcURL = "+jdbcURL+", jdbcUser = "+jdbcUser+", jdbcPassword = "+jdbcPassword);
				CompassEncryptorDecryptorNew decryptor = new CompassEncryptorDecryptorNew();

				ConnectionUtil _conUtil = new ConnectionUtil();
				connection = _conUtil.getDBConnectObject(driverDetails, jdbcURL, jdbcUser, decryptor.decrypt(jdbcPassword));
				//System.out.println("connection:  "+connection);
				PreparedStatement preparedStatement = null;
				ResultSet resultSet = null;
				List<String> noiseWord = new ArrayList<String>();
				String sql = "";
				try{
					//System.out.println(schemaName);
					//connection = connectionUtil.getConnection();
					sql = "SELECT UPPER(TRIM(NOISEWORD)) NOISEWORD FROM "+schemaName+"TB_NOISEWORDSCONFIGURATION WHERE ISENABLED = ? ";
					preparedStatement = connection.prepareStatement(sql);
					//System.out.println(sql);
					preparedStatement.setString(1, "Y");
					resultSet = preparedStatement.executeQuery();
					while(resultSet.next()){
						noiseWord.add(" "+resultSet.getString("NOISEWORD")+" ");
					}
					NoiseWordsModel noiseWordModelObject = NoiseWordsModel.getInstance();
					noiseWordModelObject.setNoiseWords(noiseWord);
					System.out.println("noiseWord in ContextListner: "+noiseWord);
				}catch(Exception e){
					System.out.println("Exception occur during initilizing loading of noise word = "+e.getMessage());
					e.printStackTrace();
				}finally{
					_conUtil.closeResources(connection, preparedStatement, null, null);
				}
			}catch(Exception e){
				e.printStackTrace();
			}
			
        }catch(Exception e){
        	e.printStackTrace();
        }
        
        
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		
	}

}
