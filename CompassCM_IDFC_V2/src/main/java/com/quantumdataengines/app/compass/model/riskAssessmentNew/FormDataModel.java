package com.quantumdataengines.app.compass.model.riskAssessmentNew;

import org.json.JSONException;
import org.json.JSONObject;

public class FormDataModel {
	public String userName;
	public String userRole;
	public String assessmentUnit;
	public String cmRefNo;
	public GeneralAndStatusDetails generalAndStatusDetails;
	public CategSubcategInherentRiskRatings categSubcategInherentRiskRatings;
	public CategoryRiskRatings categoryRiskRatings;
	public CrCategoryRiskRatings crCategoryRiskRatings;
	public QuestionResponses questionResponses;
	public String formData;
	
	public FormDataModel(String formData, String userName, String userRole) throws JSONException {
		this.formData = formData;
		this.userName = userName;
		this.userRole = userRole;
		JSONObject formDataObj = new JSONObject(formData);
		this.assessmentUnit = formDataObj.getString("assessmentUnit");
		this.cmRefNo = formDataObj.getString("cmRefNo");
		
		this.generalAndStatusDetails = new GeneralAndStatusDetails(formDataObj.getJSONObject("generalAndStatusDetails"));
		this.categSubcategInherentRiskRatings = new CategSubcategInherentRiskRatings(formDataObj.getJSONArray("categSubcategInherentRiskRatings"));
		this.categoryRiskRatings = new CategoryRiskRatings(formDataObj.getJSONArray("categoryRiskRatings"));
		this.crCategoryRiskRatings = new CrCategoryRiskRatings(formDataObj.getJSONArray("crCategoryRiskRatings"));
		this.questionResponses = new QuestionResponses(formDataObj.getJSONArray("questionResponses"));
	}

}
