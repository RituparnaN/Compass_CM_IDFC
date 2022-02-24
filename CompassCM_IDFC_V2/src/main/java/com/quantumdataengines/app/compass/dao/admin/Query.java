package com.quantumdataengines.app.compass.dao.admin;

public interface Query {
	String SAVESYSTEMPARAMETERS = "UPDATE TB_SYSTEMPARAMETERS"+
								  "   SET PARAMETERVALUE = ?"+
								  " WHERE PARAMETERNAME = ?";
}
