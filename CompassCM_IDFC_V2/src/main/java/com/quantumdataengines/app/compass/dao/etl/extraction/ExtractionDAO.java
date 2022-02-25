package com.quantumdataengines.app.compass.dao.etl.extraction;

import java.util.List;

import com.quantumdataengines.app.compass.model.ExtractionDBMessage;
import com.quantumdataengines.app.compass.model.ExtractionProcedure;
import com.quantumdataengines.app.compass.schema.Configuration;

public interface ExtractionDAO {
	public String getFromDateFromDB();
	public List<ExtractionProcedure> getAllProcedureList(Configuration configuration);
	public List<Integer> getAllGroup(Configuration configuration);
	public List<ExtractionProcedure> getAllProcedureInGroup(Configuration configuration, int a_intGroupId);
	public List<ExtractionDBMessage> getProcessMessage(Configuration configuration);
	public List<ExtractionProcedure> getCompletedProcedureList(Configuration configuration);
	public String ExecuteProcedure(Configuration configuration, ExtractionProcedure a_objProc, String a_strFromdate, String a_strToDate, String l_strUserCode) throws Exception;
	public void saveSkippedProcedureInProcessLog(Configuration configuration, ExtractionProcedure a_objProc);
}
