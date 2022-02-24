package com.quantumdataengines.app.compass.model.riskAssessmentNew;

import org.json.JSONException;
import org.json.JSONObject;

public class GeneralAndStatusDetails {
	public String ASSESSMENTPERIOD;
	public String BUSINESS1;
	public String BUSINESS2;
	public String CMMANAGERCODE;
	public String CMMANAGERCOMMENTS;
	public String CMMANAGERTIMESTAMP;
	public String CMOFFICERCODE;
	public String CMOFFICERCOMMENTS;
	public String CMOFFICERTIMESTAMP;
	public String COMPLIANCE1;
	public String COMPLIANCE2;
	public String FORMSTATUS;
	public String KEYBUSINESSNAME1;
	public String KEYBUSINESSNAME2;
	public String KEYBUSINESSNAME3;
	public String KEYBUSINESSROLE1;
	public String KEYBUSINESSROLE2;
	public String KEYBUSINESSROLE3;
	public String OTHER1;
	public String OTHER2;
	public String POCEMAIL;
	public String POCNAME;
	
	public GeneralAndStatusDetails(JSONObject generalAndStatusDetailsObj) throws JSONException {
		try {
			this.ASSESSMENTPERIOD = generalAndStatusDetailsObj.getString("ASSESSMENTPERIOD");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.ASSESSMENTPERIOD = "";
		}
		try {
			this.BUSINESS1 = generalAndStatusDetailsObj.getString("BUSINESS1");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.BUSINESS1 = "";
		}
		try {
			this.BUSINESS2 = generalAndStatusDetailsObj.getString("BUSINESS2");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.BUSINESS2 = "";
		}
		try {
			this.CMMANAGERCODE = generalAndStatusDetailsObj.getString("CMMANAGERCODE");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.CMMANAGERCODE = "";
		}
		try {
			this.CMMANAGERCOMMENTS = generalAndStatusDetailsObj.getString("CMMANAGERCOMMENTS");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.CMMANAGERCOMMENTS = "";
		}
		try {
			this.CMMANAGERTIMESTAMP = generalAndStatusDetailsObj.getString("CMMANAGERTIMESTAMP");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.CMMANAGERTIMESTAMP = "";
		}
		try {
			this.CMOFFICERCODE = generalAndStatusDetailsObj.getString("CMOFFICERCODE");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.CMOFFICERCODE = "";
		}
		try {
			this.CMOFFICERCOMMENTS = generalAndStatusDetailsObj.getString("CMOFFICERCOMMENTS");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.CMOFFICERCOMMENTS = "";
		}
		try {
			this.CMOFFICERTIMESTAMP = generalAndStatusDetailsObj.getString("CMOFFICERTIMESTAMP");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.CMOFFICERTIMESTAMP = "";
		}
		try {
			this.COMPLIANCE1 = generalAndStatusDetailsObj.getString("COMPLIANCE1");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.COMPLIANCE1 = "";
		}
		try {
			this.COMPLIANCE2 = generalAndStatusDetailsObj.getString("COMPLIANCE2");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.COMPLIANCE2 = "";
		}
		try {
			this.FORMSTATUS = generalAndStatusDetailsObj.getString("FORMSTATUS");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.FORMSTATUS = "";
		}
		try {
			this.KEYBUSINESSNAME1 = generalAndStatusDetailsObj.getString("KEYBUSINESSNAME1");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.KEYBUSINESSNAME1 = "";
		}
		try {
			this.KEYBUSINESSNAME2 = generalAndStatusDetailsObj.getString("KEYBUSINESSNAME2");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.KEYBUSINESSNAME2 = "";
		}
		try {
			this.KEYBUSINESSNAME3 = generalAndStatusDetailsObj.getString("KEYBUSINESSNAME3");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.KEYBUSINESSNAME3 = "";
		}
		try {
			this.KEYBUSINESSROLE1 = generalAndStatusDetailsObj.getString("KEYBUSINESSROLE1");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.KEYBUSINESSROLE1 = "";
		}
		try {
			this.KEYBUSINESSROLE2 = generalAndStatusDetailsObj.getString("KEYBUSINESSROLE2");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.KEYBUSINESSROLE2 = "";
		}
		try {
			this.KEYBUSINESSROLE3 = generalAndStatusDetailsObj.getString("KEYBUSINESSROLE3");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.KEYBUSINESSROLE3 = "";
		}
		try {
			this.OTHER1 = generalAndStatusDetailsObj.getString("OTHER1");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.OTHER1 = "";
		}
		try {
			this.OTHER2 = generalAndStatusDetailsObj.getString("OTHER2");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.OTHER2 = "";
		}
		try {
			this.POCEMAIL = generalAndStatusDetailsObj.getString("POCEMAIL");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.POCEMAIL = "";
		}
		try {
			this.POCNAME = generalAndStatusDetailsObj.getString("POCNAME");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			this.POCNAME = "";
		}
	}
}
