<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.quantumdataengines.app.compass.model.CDDDisabledFieldsMap"%>
<%@ include file="../../tags/tags.jsp"%>

<%
String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
String prefix = CURRENTROLE+"_CN_";
%>

						<div role="tabpanel" class="tab-pane" id="screening">
							<form action="javascript:void(0)" method="POST" id="searchMasterForm2${UNQID}">
							<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
								<tbody>
									<tr>
										<td colspan="1" width="15%">Customer Full Name</td>
										<td colspan="3" width="50%">
											<input type="text" class="form-control input-sm" name="CUSTOMERNAMETOSCREEN" id="CUSTOMERNAMETOSCREEN${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CUSTOMERNAMETOSCREEN")){ %> disabled <% } %> value="${FORMDATA['CUSTOMERNAME']}">
										</td>
										<td colspan="1" style="text-align: center; vertical-align: middle;" width="35%" rowspan="3">
											<!-- <button type="button" class="btn btn-primary btn-sm" id="screenCustomerNames${UNQID}">Screen</button> -->
											<c:choose>
												<c:when test="${(CURRENTROLE eq 'ROLE_BPAMAKER')}">
													<button type="button" class="btn btn-primary btn-xs" onclick="screen(this,'CUSTOMERNAME','${FORMDATA['LINENO']}')">Screen</button>&nbsp;&nbsp;&nbsp;&nbsp;
													<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'CUSTOMERNAME','${FORMDATA['SCREENINGREFERENCENO']}')">View Screened Matches</button>
												</c:when>
												<c:otherwise>
													<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'CUSTOMERNAME','${FORMDATA['SCREENINGREFERENCENO']}')">View Screened Matches</button>
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									<tr>
										<td colspan="1" width="15%">Former Name</td>
										<td colspan="3" width="50%">
											<input type="text" class="form-control input-sm" name="CUSTOMERFORMARNAMETOSCREEN" id="CUSTOMERFORMARNAMETOSCREEN${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CUSTOMERFORMARNAMETOSCREEN")){ %> disabled <% } %> value="${FORMDATA['CUSTOMERPREVNAME']}">
										</td>
									</tr>
									<tr>
										<td colspan="1" width="15%">Customer Alias Name</td>
										<td colspan="3" width="50%">
											<input type="text" class="form-control input-sm" name="CUSTOMERALIASNAMETOSCREEN" id="CUSTOMERALIASNAMETOSCREEN${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CUSTOMERALIASNAMETOSCREEN")){ %> disabled <% } %> value="${FORMDATA['CUSTOMERALIASNAME']}">
										</td>
									</tr>
									<tr>
										<th colspan="2" width="40%">List Name</th>
										<th colspan="2" width="40%">Description</th>
										<th colspan="1" width="20%">Action</th>
									</tr>
									<tr>
										<td colspan="2" >CLAF (or equivalent)</td>
										<td colspan="2" >Sanctions<font size = "4" color = "red"><b> * </b></font></td>
										<td colspan="1">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="CLAFMATCH_Y${UNQID}">
												<input type="radio" id="CLAFMATCH_Y${UNQID}"  name="CLAFMATCH" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CLAFMATCH")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['CLAFMATCH'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="CLAFMATCH_N${UNQID}">
												<input type="radio" id="CLAFMATCH_N${UNQID}"  name="CLAFMATCH" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CLAFMATCH")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['CLAFMATCH'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="2" >Sanctions List Search</td>
										<td colspan="2" >Sanctions, Local & HO Bad Guy List<font size = "4" color = "red"><b> * </b></font></td>
										<td colspan="1">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="SLSMATCH_Y${UNQID}">
												<input type="radio" id="SLSMATCH_Y${UNQID}"  name="SLSMATCH" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"SLSMATCH")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['SLSMATCH'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="SLSMATCH_N${UNQID}">
												<input type="radio" id="SLSMATCH_N${UNQID}"  name="SLSMATCH" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"SLSMATCH")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['SLSMATCH'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="2" rowspan="2" style="vertical-align: middle;">Dow Jones (or equivalent)<font size = "4" color = "red"><b> * </b></font></td>
										<td colspan="2" >PEP (If Yes is selected, please fill in the PEP Details in the below table)<font size = "4" color = "red"><b> * </b></font></td>
										<td colspan="1">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="PEPMATCH_Y${UNQID}">
												<input type="radio" id="PEPMATCH_Y${UNQID}"  name="PEPMATCH" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PEPMATCH")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['PEPMATCH'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="PEPMATCH_N${UNQID}">
												<input type="radio" id="PEPMATCH_N${UNQID}"  name="PEPMATCH" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PEPMATCH")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['PEPMATCH'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="2" >Adverse Information is relation to ML/TF, Sanctions<font size = "4" color = "red"><b> * </b></font></td>
										<td colspan="1">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="ADVINFO_Y${UNQID}">
												<input type="radio" id="ADVINFO_Y${UNQID}"  name="ADVINFO" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"ADVINFO")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['ADVINFO'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="ADVINFO_N${UNQID}">
												<input type="radio" id="ADVINFO_N${UNQID}"  name="ADVINFO" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"ADVINFO")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['ADVINFO'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="2" >Credit Inquiry</td>
										<td colspan="2" >Anti-Social Elements(ASE)<font size = "4" color = "red"><b> * </b></font></td>
										<td colspan="1">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="ASEMATCH_Y${UNQID}">
												<input type="radio" id="ASEMATCH_Y${UNQID}"  name="ASEMATCH" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"ASEMATCH")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['ASEMATCH'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="ASEMATCH_N${UNQID}">
												<input type="radio" id="ASEMATCH_N${UNQID}"  name="ASEMATCH" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"ASEMATCH")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['ASEMATCH'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="4" >In addition to the above, are you aware of any AML / CTF and Sanction risk posed by the Customer?</td>
										<td colspan="1">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="OTHERMATCH_Y${UNQID}">
												<input type="radio" id="OTHERMATCH_Y${UNQID}"  name="OTHERMATCH" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"OTHERMATCH")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['OTHERMATCH'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="OTHERMATCH_N${UNQID}">
												<input type="radio" id="OTHERMATCH_N${UNQID}"  name="OTHERMATCH" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"OTHERMATCH")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['OTHERMATCH'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="2">If Yes is selected for any of the above questions, please provide details</td>
										<td colspan="3">
											<textarea rows="2" cols="2" class="form-control" name="SCREENINGMATCHDETAILS" id="SCREENINGMATCHDETAILS${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"SCREENINGMATCHDETAILS")){ %> disabled <% } %>>${FORMDATA['SCREENINGMATCHDETAILS']}</textarea>
										</td>
									</tr>
									<tr>
										<td colspan="4"><strong>PEP Details</strong> </td>
										<td colspan="1" style="text-align: center;">
											<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
												<% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"ADDPEPDETAILS")){ %> 
												<button type="button" class="btn btn-primary btn-xs" id="addPEPDetails${UNQID}" disabled>Add PEP</button>
												<% } else { %>
												<button type="button" class="btn btn-primary btn-xs cddModifyButton" id="addPEPDetails${UNQID}">Add PEP</button>
												<% } %>
											</c:if>
										</td>
									</tr>
									<tr>
										<td colspan="5" id="pepDetails${UNQID}">
											<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
												<thead>
													<th>Name</th>
													<th>Position Held in Government</th>
													<th>Nationality</th>
													<th>Position Held in Company</th>
													<th>Match?</th>
													<th>List Name</th>
													<th>Action</th>
												</thead>
												<tbody>
													<c:choose>
														<c:when test="${f:length(PEPDETAILS) > 0}">
															<c:forEach var="PEPDETAILS" items="${PEPDETAILS}">
																<tr>
																	<td width="15%" style="cursor: pointer; text-decoration: underline; color: blue;" onclick="viewDetails('PEP','${PEPDETAILS['COMPASSREFNO']}','${PEPDETAILS['LINENO']}')" >${PEPDETAILS['PEPNAME']}</td>
																	<td width="15%">${PEPDETAILS['PEPPOSITIONINGOVT']}</td>
																	<td width="15%">${PEPDETAILS['PEPNATIONALITY']}</td>
																	<td width="15%">${PEPDETAILS['PEPPOSITIONINCOMPANY']}</td>
																	<td width="10%" class="match">
																		<select class="form-control input-sm selectpicker">
																			<option value="N" <c:if test="${PEPDETAILS['SANCTIONLISTMATCH'] eq 'N'}">selected</c:if> >No</option>
																			<option value="Y" <c:if test="${PEPDETAILS['SANCTIONLISTMATCH'] eq 'Y'}">selected</c:if>>Yes</option>
																		</select>
																	</td>
																	<td width="15%" class="listname">
																		<select class="form-control input-sm selectpicker" multiple>
																			<option value="">None</option>
																			<option value="DJ" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'DJ')}">selected</c:if>>Dowjones</option>
																			<option value="RBI" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'RBI')}">selected</c:if>>RBI Defaulter</option>
																			<option value="EXP" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'EXP')}">selected</c:if>>Exporter List</option>
																			<option value="FIU" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'FIU')}">selected</c:if>>Local FIU Exception</option>
																			<option value="OFC" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'OFC')}">selected</c:if>>OFAC SDN</option>
																			<option value="UNC" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'UNC')}">selected</c:if>>UN Consolidated</option>
																			<option value="CLF" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'CLF')}">selected</c:if>>CLAF List</option>
																			<option value="CUL" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'CUL')}">selected</c:if>>Caution List</option>
																			<option value="CNS" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'CNS')}">selected</c:if>>Cibil Non Suit Filed</option>
																			<option value="CSF" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'CSF')}">selected</c:if>>Cibil Suit Filed</option>
																			<option value="CLS" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'CLS')}">selected</c:if>>High Risk Countries List</option>
																			<option value="HBL" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'HBL')}">selected</c:if>>HO Bad Guy List</option>
																			<option value="UAL" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'UAL')}">selected</c:if>>UN Alquaida List</option>
																			<option value="UTL" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'UTL')}">selected</c:if>>UN Taliban List</option>
																		</select>
																	</td>
																	<td width="15%">
																		<!-- <button type="button" class="btn btn-primary btn-xs" onclick="screen(this)">Screen</button>-->
																		<c:choose>
																			<c:when test="${(CURRENTROLE eq 'ROLE_BPAMAKER')}">
																				<button type="button" class="btn btn-primary btn-xs" onclick="screen(this, 'PEP','${PEPDETAILS['LINENO']}')">Screen</button>
																				<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'PEP','${PEPDETAILS['SCREENINGREFERENCENO']}')">View Screened Matches</button>
																			</c:when>
																			<c:otherwise>
																				<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'PEP','${PEPDETAILS['SCREENINGREFERENCENO']}')">View Screened Matches</button>
																			</c:otherwise>
																		</c:choose>
																		<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
																			<button type="button" class="btn btn-success btn-xs cddModifyButton" onclick="updateScreeningMatch(this, 'PEP','${PEPDETAILS['COMPASSREFNO']}','${PEPDETAILS['LINENO']}')">Update</button>
																			<button type="button" class="btn btn-danger btn-xs cddModifyButton"  onclick="removeEntity('PEP','${PEPDETAILS['COMPASSREFNO']}','${PEPDETAILS['LINENO']}')">Remove</button>
																		</c:if>
																	</td>
																</tr>
															</c:forEach>
														</c:when>
														<c:otherwise>
															<tr>
																<td colspan="7"><center>No PEP Added</center></td>
															</tr>
														</c:otherwise>
													</c:choose>
												</tbody>
											</table>
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong>Sanctions</strong> </td>
									</tr>
									<tr>
										<td colspan="2" >Does the Customer have any direct dealings with sanctioned countries or parties?</td>
										<td colspan="3">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="DIRECTDEALINGWITHSANCTION_Y${UNQID}">
												<input type="radio" id="DIRECTDEALINGWITHSANCTION_Y${UNQID}"  name="DIRECTDEALINGWITHSANCTION" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"DIRECTDEALINGWITHSANCTION")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['DIRECTDEALINGWITHSANCTION'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="DIRECTDEALINGWITHSANCTION_N${UNQID}">
												<input type="radio" id="DIRECTDEALINGWITHSANCTION_N${UNQID}"  name="DIRECTDEALINGWITHSANCTION" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"DIRECTDEALINGWITHSANCTION")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['DIRECTDEALINGWITHSANCTION'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="5">
											If No, proceed to Risk Rating Form<br/>
											If Yes, please do the following<br/>
											Proceed to answer questions below and proceed to Risk Rating Form
										</td>
									</tr>
									<tr>
										<td colspan="2" >
											Please provide the name of sanctioned countries and parties
										</td>
										<td colspan="3">
											<textarea rows="2" cols="2" class="form-control" name="SANCTIONCOUNTRIES" id="SANCTIONCOUNTRIES${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"SANCTIONCOUNTRIES")){ %> disabled <% } %>
											<c:if test="${FORMDATA['DIRECTDEALINGWITHSANCTION'] ne 'YES'}">disabled</c:if>>${FORMDATA['SANCTIONCOUNTRIES']}</textarea>
										</td>
									</tr>
									<tr>
										<td colspan="2" >have you conducted screening on the sanctioned parties & addressed any hits?</td>
										<td colspan="3">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="SANCTIONSCREENHITS_Y${UNQID}">
												<input type="radio" id="SANCTIONSCREENHITS_Y${UNQID}"  name="SANCTIONSCREENHITS" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"SANCTIONSCREENHITS")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['SANCTIONSCREENHITS'] eq 'YES'}">checked="checked"</c:if>
												<c:if test="${FORMDATA['DIRECTDEALINGWITHSANCTION'] ne 'YES'}">disabled</c:if>
												/>
												Yes
											</label>
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="SANCTIONSCREENHITS_N${UNQID}">
												<input type="radio" id="SANCTIONSCREENHITS_N${UNQID}"  name="SANCTIONSCREENHITS" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"SANCTIONSCREENHITS")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['SANCTIONSCREENHITS'] eq 'NO'}">checked="checked"</c:if>
												<c:if test="${FORMDATA['DIRECTDEALINGWITHSANCTION'] ne 'YES'}">disabled</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="2" >
											Please provide indicate the goods/servies involved
										</td>
										<td colspan="3">
											<textarea rows="2" cols="2" class="form-control" name="SANCTIONGOODSSERVICE" id="SANCTIONGOODSSERVICE${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"SANCTIONGOODSSERVICE")){ %> disabled <% } %>
											<c:if test="${FORMDATA['DIRECTDEALINGWITHSANCTION'] ne 'YES'}">disabled</c:if>>${FORMDATA['SANCTIONGOODSSERVICE']}</textarea>
										</td>
									</tr>
									<tr>
										<td colspan="2" >
											Please explain the nature of business involved with the sanctions parties
										</td>
										<td colspan="3">
											<textarea rows="2" cols="2" class="form-control" name="SANCTIONINVOLVEMENT" id="SANCTIONINVOLVEMENT${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"SANCTIONINVOLVEMENT")){ %> disabled <% } %>
											<c:if test="${FORMDATA['DIRECTDEALINGWITHSANCTION'] ne 'YES'}">disabled</c:if>>${FORMDATA['SANCTIONINVOLVEMENT']}</textarea>
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong>Additional Customer Information (For Customer subjected to EDD only)</strong> </td>
									</tr>
									<tr>
										<td colspan="2" rowspan="2" style="vertical-align: middle;">
											Source of Wealth (If others, please specify others)
										</td>
										<td colspan="3">
											<select class="form-control input-sm selectpicker" name="SOURCEOFWEALTH" id="SOURCEOFWEALTH${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"SOURCEOFWEALTH")){ %> disabled <% } %>>
												<option value="">Select One</option>
												<c:forEach var="SOURCEOFFUND" items="${SOURCEOFFUND}">
													<option value="${SOURCEOFFUND['OPTIONVALUE']}" 
													<c:if test="${FORMDATA['SOURCEOFWEALTH'] eq SOURCEOFFUND['OPTIONVALUE']}">selected="selected"</c:if>>${SOURCEOFFUND['OPTIONNAME']}</option>
												</c:forEach>
											</select>
										</td>
									</tr>
									<tr>
										<td colspan="5">
											<textarea rows="2" cols="2" class="form-control" name="OTHERSOURCEOFWEALTH" id="OTHERSOURCEOFWEALTH${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"OTHERSOURCEOFWEALTH")){ %> disabled <% } %>
											<c:if test="${FORMDATA['DIRECTDEALINGWITHSANCTION'] ne 'YES'}">disabled</c:if>>${FORMDATA['OTHERSOURCEOFWEALTH']}</textarea>
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong>Additional Information</strong> </td>
									</tr>
									<tr>
										<td colspan="5">
											<textarea rows="2" cols="2" class="form-control" name="ADDITIONALINFORMATION" id="ADDITIONALINFORMATION${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"ADDITIONALINFORMATION")){ %> disabled <% } %>
											<c:if test="${FORMDATA['DIRECTDEALINGWITHSANCTION'] ne 'YES'}">disabled</c:if>>${FORMDATA['ADDITIONALINFORMATION']}</textarea>
										</td>
									</tr>
									<tr>
										<td colspan="5" style="text-align: right;">
											<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
												<button type="button" class="btn btn-success btn-sm saveDraftCDDForm" id="saveDraftCDDForm4${UNQID}">Save Draft</button>
												<button type="button" class="btn btn-success btn-sm saveCDDForm" id="saveCDDForm4${UNQID}">Save</button>
											</c:if>
											<button type="button" class="btn btn-warning btn-sm" id="moveToRiskRating${UNQID}">Risk Rating >></button>
										</td>
									</tr>
								</tbody>
							</table>
							</form>
						</div>
						<div role="tabpanel" class="tab-pane" id="riskRating">
							<form action="javascript:void(0)" method="POST" id="searchMasterForm3${UNQID}">
							<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
								<tbody>
									<tr>   
										<td width="15%">
											Full Name of Customer
										</td>
										<td width="85%" colspan="4">
											<input type="text" class="form-control input-sm" name="RISKRATINGCUSTOMERNAME" id="RISKRATINGCUSTOMERNAME${UNQID}" value="${FORMDATA['CUSTOMERNAME']}">
										</td>
									</tr>
									<tr>
										<td width="15%">Relationship Manager</td>
										<td width="33%">
											<input type="text" class="form-control input-sm" name="RISKRATINGRELATIONSHIPMANAGER" id="RISKRATINGRELATIONSHIPMANAGER${UNQID}" value="${FORMDATA['RELATIONSHIPMANAGER']}">
										</td>
										<td width="4%">&nbsp;</td>
										<td width="15%">Department-In-Charge</td>
										<td width="33%">
											<input type="text" class="form-control input-sm" name="RISKRATINGDEPTINCHARGE" id="RISKRATINGDEPTINCHARGE${UNQID}" value="${FORMDATA['DEPTINCHARGE']}">
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong style="font-size: 20px;">Part 1 - Risk Factors</strong></td>
									</tr>
									<tr>
										<td colspan="5"><strong>1. Customer Risk - Attribute Type</strong></td>
									</tr>
									<tr>
										<td colspan="2" rowspan="2" style="vertical-align: middle;">
											Please select the option that best describes the Customer's Attribute. Refer to Branch Complianced Team,
											if unable to determine Attribute Type. For list of approved / recognized exchanges, see list provided by Branch Complianced Team.
											For "Others" Attribute Type, please specify.
										</td>
										<td colspan="2">
											Attribute Type
										</td>
										<td colspan="1" id="">
											<input type="text" class="form-control input-sm" readonly="readonly" name="ATTRIBUTETYPERISKRATING_DESC" id="ATTRIBUTETYPERISKRATING_DESC${UNQID}" value="${FORMDATA['ATTRIBUTETYPERISKRATING_DESC']}"/>
										</td>
									</tr>
									<tr>
										<td colspan="2">
											Risk Rating
										</td>
										<td colspan="1">
											<input type="text" class="form-control input-sm"  readonly="readonly" name="ATTRIBUTETYPERISKRATING_VALUE" id="ATTRIBUTETYPERISKRATING_VALUE${UNQID}" value="${FORMDATA['ATTRIBUTETYPERISKRATING_VALUE']}"/>
											<input type="hidden" name="ATTRIBUTETYPERISKRATING" id="ATTRIBUTETYPERISKRATING${UNQID}" value="${FORMDATA['ATTRIBUTETYPERISKRATING']}">
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong>2. Customer Risk - Industry / Occupation Type</strong></td>
									</tr>
									<tr>
										<td colspan="2" rowspan="2" style="vertical-align: middle;">
											Please select the option that best describes the Customer's Occupation. Refer to Branch Complianced Team,
											if unable to determine Occupation Type. For Others Occupation Type, please specify
										</td>
										<td colspan="2">
											Occupation Type 
										</td>
										<td colspan="1">
											<input type="text" class="form-control input-sm" readonly="readonly" name="INDUSTRYTYPERISKRATING_DESC" id="INDUSTRYTYPERISKRATING_DESC${UNQID}" value="${FORMDATA['INDUSTRYTYPERISKRATING_DESC']}"/>
										</td>
									</tr>
									<tr>
										<td colspan="2">
											Risk Rating
										</td>
										<td colspan="1">
											<input type="text" class="form-control input-sm"  readonly="readonly" name="INDUSTRYTYPERISKRATING_VALUE" id="INDUSTRYTYPERISKRATING_VALUE${UNQID}" value="${FORMDATA['INDUSTRYTYPERISKRATING_VALUE']}"/>
											<input type="hidden" name="INDUSTRYTYPERISKRATING" id="INDUSTRYTYPERISKRATING${UNQID}" value="${FORMDATA['INDUSTRYTYPERISKRATING']}">
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong>3. Geographic Risk</strong></td>
									</tr>
									<tr>
										<td colspan="2" rowspan="2" style="vertical-align: middle;">
											Country of Incorporation
										</td>
										<td colspan="2">
											Country
										</td>
										<td colspan="1">
											<input type="text" class="form-control input-sm" readonly="readonly" name="INCROPCOUNTRYRISKRATING_DESC" id="INCROPCOUNTRYRISKRATING_DESC${UNQID}" value="${FORMDATA['INCROPCOUNTRYRISKRATING_DESC']}"/>
										</td>
									</tr>
									<tr>
										<td colspan="2">
											Risk Rating
										</td>
										<td colspan="1">
											<input type="text" class="form-control input-sm"  readonly="readonly" name="INCROPCOUNTRYRISKRATING_VALUE" id="INCROPCOUNTRYRISKRATING_VALUE${UNQID}" value="${FORMDATA['INCROPCOUNTRYRISKRATING_VALUE']}"/>
											<input type="hidden" name="INCROPCOUNTRYRISKRATING" id="INCROPCOUNTRYRISKRATING${UNQID}" value="${FORMDATA['INCROPCOUNTRYRISKRATING']}">
										</td>
									</tr>
									<tr>
										<td colspan="2" rowspan="2" style="vertical-align: middle;">
											Principal Country of Business
										</td>
										<td colspan="2">
											Country
										</td>
										<td colspan="1" id="">
											<input type="text" class="form-control input-sm" readonly="readonly" name="PRINCICOUNTRYRISKRATING_DESC" id="PRINCICOUNTRYRISKRATING_DESC${UNQID}" value="${FORMDATA['PRINCICOUNTRYRISKRATING_DESC']}"/>
										</td>
									</tr>
									<tr>
										<td colspan="2">
											Risk Rating
										</td>
										<td colspan="1">
											<input type="text" class="form-control input-sm"  readonly="readonly" name="PRINCICOUNTRYRISKRATING_VALUE" id="PRINCICOUNTRYRISKRATING_VALUE${UNQID}" value="${FORMDATA['PRINCICOUNTRYRISKRATING_VALUE']}"/>
											<input type="hidden" name="PRINCICOUNTRYRISKRATING" id="PRINCICOUNTRYRISKRATING${UNQID}" value="${FORMDATA['PRINCICOUNTRYRISKRATING']}">
										</td>
									</tr>
									<tr>
										<td colspan="4" >
											Overall Geographic Risk
										</td>
										<td colspan="1">
											<input type="text" class="form-control input-sm"  readonly="readonly" name="GEOGRAPHICRISKRATING_VALUE" id="GEOGRAPHICRISKRATING_VALUE${UNQID}" value="${FORMDATA['GEOGRAPHICRISKRATING_VALUE']}"/>
											<input type="hidden" name="GEOGRAPHICRISKRATING" id="GEOGRAPHICRISKRATING${UNQID}" value="${FORMDATA['GEOGRAPHICRISKRATING']}">
										</td>
									</tr>
									<tr>
										<td colspan="2" rowspan="2" style="vertical-align: middle;">
											Economic Sanctions Questionnaire
										</td>
										<td colspan="2">
											Is the Customer's a Citizen or Resides in a Country that is subjected to economic sanctions?<br/>
											If Yes, refer immediately to Branch Compliance Team.<br/>
											<br/>
											Countries subjected to economic sanctions include : Democratic People's Republic of Korea,
											Sudan, Iran (Islamic Republic of), Cuba, Syrian Arab Republic and Venezuela
										</td>
										<td colspan="1" style="vertical-align: middle;">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="ECONOMICSANCTIONS_Y${UNQID}">
												<input type="radio" id="ECONOMICSANCTIONS_Y${UNQID}"  name="ECONOMICSANCTIONS" value="YES"
												<c:if test="${FORMDATA['ECONOMICSANCTIONS'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="ECONOMICSANCTIONS_N${UNQID}">
												<input type="radio" id="ECONOMICSANCTIONS_N${UNQID}"  name="ECONOMICSANCTIONS" value="NO"
												<c:if test="${FORMDATA['ECONOMICSANCTIONS'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="2" >
											Name of Jurisdiction
										</td>
										<td colspan="1">
											<input type="text" class="form-control input-sm" name="SANCTIONJURISDICTION" id="SANCTIONJURISDICTION${UNQID}" value="${FORMDATA['SANCTIONJURISDICTION']}">
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong>4. Product and Service Risk</strong></td>
									</tr>
									<tr>
										<td colspan="2">Selected Products and Services highest risk</td>
										<td colspan="3">
											<input type="text" class="form-control input-sm" readonly="readonly" name="PRODUCTRISKRATING_DESC" id="PRODUCTRISKRATING_DESC${UNQID}" value="${FORMDATA['PRODUCTRISKRATING_DESC']}">
										</td>
									</tr>
									<tr>
										<td colspan="2">Overall Product Risk</td>
										<td colspan="3">
											<input type="text" class="form-control input-sm"  readonly="readonly" name="PRODUCTRISKRATING_VALUE" id="PRODUCTRISKRATING_VALUE${UNQID}" value="${FORMDATA['PRODUCTRISKRATING_VALUE']}"/>
											<input type="hidden" name="PRODUCTRISKRATING" id="PRODUCTRISKRATING${UNQID}" value="${FORMDATA['PRODUCTRISKRATING']}">
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong>5. Channel Risk</strong></td>
									</tr>
									<tr>
										<td colspan="2">Select All Channels to be provided</td>
										<td colspan="3">
											<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RISKRATINGCHANNEL_1${UNQID}">
												<input type="checkbox" id="RISKRATINGCHANNEL_1${UNQID}"  name="RISKRATINGCHANNEL_1" value="YES" riskRating="Low"
												<c:if test="${FORMDATA['RISKRATINGCHANNEL_1'] eq 'YES'}">checked="checked"</c:if>
												/>
												Face-to-face interaction with customer
											</label>
											<br/>
											<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RISKRATINGCHANNEL_2${UNQID}">
												<input type="checkbox" id="RISKRATINGCHANNEL_2${UNQID}"  name="RISKRATINGCHANNEL_2" value="YES" riskRating="High"
												<c:if test="${FORMDATA['RISKRATINGCHANNEL_2'] eq 'YES'}">checked="checked"</c:if>
												/>
												No face-to-face interaction with customer
											</label>
											<br/>
											<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RISKRATINGCHANNEL_3${UNQID}">
												<input type="checkbox" id="RISKRATINGCHANNEL_3${UNQID}"  name="RISKRATINGCHANNEL_3" value="YES" riskRating="High"
												<c:if test="${FORMDATA['RISKRATINGCHANNEL_3'] eq 'YES'}">checked="checked"</c:if>
												/>
												<!--Third party (e.g. Power of Attorney, agent, broker or intermediary)-->
												Not applicable
											</label>
											<br/>
											<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RISKRATINGCHANNEL_4${UNQID}">
												<input type="checkbox" id="RISKRATINGCHANNEL_4${UNQID}"  name="RISKRATINGCHANNEL_4" value="YES" riskRating="High"
												<c:if test="${FORMDATA['RISKRATINGCHANNEL_4'] eq 'YES'}">checked="checked"</c:if>
												/>
												Internet Banking (e.g. MGeB)
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="2">Overall Channel Risk</td>
										<td colspan="3">
											<input type="text" class="form-control input-sm"  readonly="readonly" name="CHANNELRISKRATING_VALUE" id="CHANNELRISKRATING_VALUE${UNQID}" value="${FORMDATA['CHANNELRISKRATING_VALUE']}"/>
											<input type="hidden" name="CHANNELRISKRATING" id="CHANNELRISKRATING${UNQID}" value="${FORMDATA['CHANNELRISKRATING']}">
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong>6. System Generated Risk Rating</strong></td>
									</tr>
									<tr>
										<td colspan="2">System Generated Risk Rating</td>
										<td>
											<button type="button" class="btn btn-primary btn-sm" id="calculateCDDRisk${UNQID}">Calculate</button>
										</td>
										<td colspan="2">
											<input type="text" class="form-control input-sm"  readonly="readonly" 
											name="SYSTEMRISKRATING" id="SYSTEMRISKRATING${UNQID}" value="${FORMDATA['SYSTEMRISKRATING']}"/>
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong style="font-size: 20px;">Part 2 - Other Risk Factors</strong></td>
									</tr>
									<tr>
										<td colspan="5"><strong>1. Characteristics</strong></td>
									</tr>
									<tr>
										<td colspan="5" style="padding-left: 5px;">
											<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RR_CHARACTERISTICS_1${UNQID}">
												<input type="checkbox" id="RR_CHARACTERISTICS_1${UNQID}"  name="RR_CHARACTERISTICS_1" value="YES"
												<c:if test="${FORMDATA['RR_CHARACTERISTICS_1'] eq 'YES'}">checked="checked"</c:if>
												/>
												Customers who are PEPs or where Related Parties are PEPs
											</label>
											<br/>
											<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RR_CHARACTERISTICS_2${UNQID}">
												<input type="checkbox" id="RR_CHARACTERISTICS_2${UNQID}"  name="RR_CHARACTERISTICS_2" value="YES"
												<c:if test="${FORMDATA['RR_CHARACTERISTICS_2'] eq 'YES'}">checked="checked"</c:if>
												/>
												Adverse News relating to customer and/or connected parties
											</label>
											<br/>
											<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RR_CHARACTERISTICS_3${UNQID}">
												<input type="checkbox" id="RR_CHARACTERISTICS_3${UNQID}"  name="RR_CHARACTERISTICS_3" value="YES"
												<c:if test="${FORMDATA['RR_CHARACTERISTICS_3'] eq 'YES'}">checked="checked"</c:if>
												/>
												Customers who are categorized as Anti-Social Element or problem Customers
											</label>
											<br/>
											<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RR_CHARACTERISTICS_4${UNQID}">
												<input type="checkbox" id="RR_CHARACTERISTICS_4${UNQID}"  name="RR_CHARACTERISTICS_4" value="YES"
												<c:if test="${FORMDATA['RR_CHARACTERISTICS_4'] eq 'YES'}">checked="checked"</c:if>
												/>
												Customers who are known to have been involved in illicit use of account
											</label>
											<br/>
											<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RR_CHARACTERISTICS_5${UNQID}">
												<input type="checkbox" id="RR_CHARACTERISTICS_5${UNQID}"  name="RR_CHARACTERISTICS_5" value="YES"
												<c:if test="${FORMDATA['RR_CHARACTERISTICS_5'] eq 'YES'}">checked="checked"</c:if>
												/>
												Parties subject to economic sanctions such as freezing of assets ("Sanctions Targets")
											</label>
											<br/>
											<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RR_CHARACTERISTICS_6${UNQID}">
												<input type="checkbox" id="RR_CHARACTERISTICS_6${UNQID}"  name="RR_CHARACTERISTICS_6" value="YES"
												<c:if test="${FORMDATA['RR_CHARACTERISTICS_6'] eq 'YES'}">checked="checked"</c:if>
												/>
												Customers who has direct dealings with sanctioned countries or parties
											</label>
											<br/>
											<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RR_CHARACTERISTICS_7${UNQID}">
												<input type="checkbox" id="RR_CHARACTERISTICS_7${UNQID}"  name="RR_CHARACTERISTICS_7" value="YES"
												<c:if test="${FORMDATA['RR_CHARACTERISTICS_7'] eq 'YES'}">checked="checked"</c:if>
												/>
												None of the above
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong style="font-size: 20px;">Part 3 - Final Risk Rating</strong></td>
									</tr>
									<tr>
										<td width="15%">
											Provisional Risk Rating
										</td>
										<td width="33%">
											<input type="text" readonly="readonly" class="form-control input-sm" name="PROVISIONALRISKRATING" id="PROVISIONALRISKRATING${UNQID}" value="${FORMDATA['PROVISIONALRISKRATING']}">
										</td>
										<td>&nbsp;</td>
										<td width="15%">
											Final Risk Rating
										</td>
										<td width="33%">
											<select class="form-control input-sm selectpicker" name="FINALRISKRATING" id="FINALRISKRATING${UNQID}">
												<option value="1 - Low (Simplified)" <c:if test="${FORMDATA['FINALRISKRATING'] eq '1 - Low (Simplified)'}">selected="selected"</c:if> >1 - Low (Simplified)</option>
												<option value="2 - Low (Simplified)" <c:if test="${FORMDATA['FINALRISKRATING'] eq '2 - Low (Simplified)'}">selected="selected"</c:if>>2 - Low (Simplified)</option>
												<option value="3 - Medium (Standard)" <c:if test="${FORMDATA['FINALRISKRATING'] eq '3 - Medium (Standard)'}">selected="selected"</c:if>>3 - Medium (Standard)</option>
												<option value="4 - High (Enhanced)" <c:if test="${FORMDATA['FINALRISKRATING'] eq '4 - High (Enhanced)'}">selected="selected"</c:if>>4 - High (Enhanced)</option>
												<option value="5 - High (Enhanced)" <c:if test="${FORMDATA['FINALRISKRATING'] eq '5 - High (Enhanced)'}">selected="selected"</c:if>>5 - High (Enhanced)</option>
											</select>
										</td>
									</tr>
									<tr>
										<td>
											Reason(s) for Deviations between Provisional and Final Risk Rating
										</td>
										<td colspan="4">
											<textarea rows="2" cols="2" class="form-control" name="RISKRATINGREASON" id="RISKRATINGREASON${UNQID}">${FORMDATA['RISKRATINGREASON']}</textarea>
										</td>
									</tr>
									<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
									<tr>
										<td colspan="5" style="text-align: right;">
											<button type="button" class="btn btn-success btn-sm saveDraftCDDForm" id="saveDraftCDDForm5${UNQID}">Save Draft</button>
											<button type="button" class="btn btn-success btn-sm saveCDDForm" id="saveCDDForm5${UNQID}">Save</button>
										</td>
									</tr>
									</c:if>
								</tbody>
							</table>
							</form>
						</div>
						<div role="tabpanel" class="tab-pane" id="checkList">
							<form action="javascript:void(0)" method="POST" id="checkListForm${UNQID}">
							<input type="hidden" name="COMPASSREFERENCENO" id="COMPASSREFERENCENO1${UNQID}" value="${COMPASSREFERENCENO}"/>
							<input type="hidden" name="LINENO" id="LINENO1${UNQID}" value="${LINENO}"/>
							<table class="table table-bordered table-striped checkListTable" id="checkListTable${UNQID}" style="margin-bottom: 0px;">
								<tr>
									<th width="5%">SR NO.</th>
									<th width="50%">Documents</th>
									<th width="15%" class="chkListCheck">Check</th>
									<th width="15%" class="chkListApprove">Approve</th>
									<th width="15%">Mandatory / Provisional</th>
								</tr>
								<tr>
									<td>1</td>
									<td>
										<strong>Copy of Certificate of Incorporation (COI)  and Certificate of Commencement of Business </strong>
										(only in case of Public  Limited Co)
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_COI_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_COI_CHECK${UNQID}"  name="CHKLIST_COI_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_COI_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_COI_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_COI_APPROVE${UNQID}"  name="CHKLIST_COI_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_COI_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>2</td>
									<td>
										<strong>Copy of Memorandum & Article of Association</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_MRMART_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_MRMART_CHECK${UNQID}"  name="CHKLIST_MRMART_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_MRMART_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_MRMART_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_MRMART_APPROVE${UNQID}"  name="CHKLIST_MRMART_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_MRMART_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>3</td>
									<td>
										<strong>Copy of Board Resolution for Opening of Account & appointing authorized signatories</strong> 
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BRDRESOL_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_BRDRESOL_CHECK${UNQID}"  name="CHKLIST_BRDRESOL_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BRDRESOL_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BRDRESOL_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_BRDRESOL_APPROVE${UNQID}"  name="CHKLIST_BRDRESOL_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BRDRESOL_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td colspan="5" style="background-color: #BBB;">If the correspondence address of the company listed in point 1 and 4 is different from Registered 
									Office Address, then obtain any one document from the below:</td>
								</tr>
								<tr>
									<td rowspan="8" style="vertical-align: middle;">
										4
									</td>
									<td>
										<strong>a) Lease Deed/ License agreement </strong>(duly registered) 
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CKHLIST_LSLICN_CHECK${UNQID}">
											<input type="checkbox" id="CKHLIST_LSLICN_CHECK${UNQID}"  name="CKHLIST_LSLICN_CHECK" value="Y"
												<c:if test="${CHECKLIST['CKHLIST_LSLICN_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CKHLIST_LSLICN_APPROVE${UNQID}">
											<input type="checkbox" id="CKHLIST_LSLICN_APPROVE${UNQID}"  name="CKHLIST_LSLICN_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CKHLIST_LSLICN_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td rowspan="8" style="vertical-align: middle;">
										Mandatory
									</td>
								</tr>
								<tr>
									<td>
										<strong>b) Property Tax Bill</strong> (Not more than 6 months old)
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PROPTAX_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_PROPTAX_CHECK${UNQID}"  name="CHKLIST_PROPTAX_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PROPTAX_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PROPTAX_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_PROPTAX_APPROVE${UNQID}"  name="CHKLIST_PROPTAX_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PROPTAX_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>c) Telephone Bill </strong>(Not More than 6 months old)
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_TEL_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_TEL_CHECK${UNQID}"  name="CHKLIST_ADR_TEL_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_TEL_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_TEL_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_TEL_APPROVE${UNQID}"  name="CHKLIST_ADR_TEL_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_TEL_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>d) Water Tax Bill </strong>(Not More than 6 months old)
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_WATERBILL_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_WATERBILL_CHECK${UNQID}"  name="CHKLIST_WATERBILL_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_WATERBILL_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_WATERBILL_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_WATERBILL_APPROVE${UNQID}"  name="CHKLIST_WATERBILL_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_WATERBILL_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>e) Electricity Bill </strong>(Not more than 6 months old) 
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_EB_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_EB_CHECK${UNQID}"  name="CHKLIST_ADR_EB_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_EB_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_EB_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_EB_APPROVE${UNQID}"  name="CHKLIST_ADR_EB_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_EB_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>f)</strong> For low risk customers (under simplified measures) RBI circular dt.11.6.2015 permits, 
										bill of post-paid mobile phone or piped gas (not more than two months old) OR Bank A/C Statement
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_OTHERBILL_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_OTHERBILL_CHECK${UNQID}"  name="CHKLIST_ADR_OTHERBILL_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_OTHERBILL_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_OTHERBILL_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_OTHERBILL_APPROVE${UNQID}"  name="CHKLIST_ADR_OTHERBILL_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_OTHERBILL_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>g) Any other document</strong> (Must be approved by Compliance Department)
									</td>
									<td>
										<textarea rows="2" cols="2" class="form-control" name="CHKLIST_ID_OTHER_DETAILS" id="CHKLIST_ID_OTHER_DETAILS${UNQID}"
											<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
										>${CHECKLIST['CHKLIST_ID_OTHER_DETAILS']}</textarea>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_OTHER_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_OTHER_APPROVE${UNQID}"  name="CHKLIST_ID_OTHER_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_OTHER_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>h)</strong> [Where certificate of incorporation is accepted as address proof and no other document is provided 
										(the address on Bank's record is different to registered address), 
										then the CDD will be completed but a provisional will have to be made]
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PROVISON_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_PROVISON_CHECK${UNQID}"  name="CHKLIST_PROVISON_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PROVISON_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PROVISON_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_PROVISON_APPROVE${UNQID}"  name="CHKLIST_PROVISON_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PROVISON_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>5</td>
									<td>
										<strong>PAN card in the name of the Company</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PANCARD_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_PANCARD_CHECK${UNQID}"  name="CHKLIST_PANCARD_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PANCARD_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PANCARD_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_PANCARD_APPROVE${UNQID}"  name="CHKLIST_PANCARD_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PANCARD_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td colspan="5" style="background-color: #BBB">Directors Identification Number and address proof of Directors<strong></strong></td>
								</tr>
								<tr>
									<td>6</td>
									<td>
										<strong>Full Name and addresses of all the directors of the company </strong>(with the DIN numbers of Directors) 
										on letter head of company signed by the Company Secretary/ any two directors/ authorised signatory. 
										The details on letter head of unlisted companies (related to all Wholetime Directors) to be verified from MCA/IT websites and 
										chopped by BPA/Comp Department.
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_NAMEADDROFDIR_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_NAMEADDROFDIR_CHECK${UNQID}"  name="CHKLIST_NAMEADDROFDIR_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_NAMEADDROFDIR_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_NAMEADDROFDIR_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_NAMEADDROFDIR_APPROVE${UNQID}"  name="CHKLIST_NAMEADDROFDIR_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_NAMEADDROFDIR_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td colspan="5" style="background-color: #BBB">Photo ID Proof for all Authorised Signatories (Indian Nationals only)<strong></strong></td>
								</tr>
								<tr>
									<td rowspan="7" style="vertical-align: middle;">
										7
									</td>
									<td>	
										<strong>Copy of PAN card</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_PANCARD_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_PANCARD_CHECK${UNQID}"  name="CHKLIST_ID_PANCARD_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_PANCARD_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_PANCARD_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_PANCARD_APPROVE${UNQID}"  name="CHKLIST_ID_PANCARD_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_PANCARD_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td rowspan="7" style="vertical-align: middle;">
										Mandatory
									</td>
								</tr>
								<tr>
									<td colspan="4" style="background-color: #BBB">Photo ID Proof for all Authorised Signatories (Other than Indian Nationals) (Any One document)</td>
								</tr>
								<tr>
									<td>
										<strong>a) Copy of  Passport </strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_PASSPORT_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_PASSPORT_CHECK${UNQID}"  name="CHKLIST_ID_PASSPORT_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_PASSPORT_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_PASSPORT_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_PASSPORT_APPROVE${UNQID}"  name="CHKLIST_ID_PASSPORT_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_PASSPORT_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>b) Driving License</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CKHLIST_ID_DL_CHECK${UNQID}">
											<input type="checkbox" id="CKHLIST_ID_DL_CHECK${UNQID}"  name="CKHLIST_ID_DL_CHECK" value="Y"
												<c:if test="${CHECKLIST['CKHLIST_ID_DL_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CKHLIST_ID_DL_APPROVE${UNQID}">
											<input type="checkbox" id="CKHLIST_ID_DL_APPROVE${UNQID}"  name="CKHLIST_ID_DL_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CKHLIST_ID_DL_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>c) Voter ID</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_VIC_CHECKER${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_VIC_CHECKER${UNQID}"  name="CHKLIST_ID_VIC_CHECKER" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_VIC_CHECKER'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_VIC_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_VIC_APPROVE${UNQID}"  name="CHKLIST_ID_VIC_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_VIC_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>d) Letter issued by UIDAI containing the details of name, address and Aadhaar number</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_UAIDI_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_UAIDI_CHECK${UNQID}"  name="CHKLIST_ID_UAIDI_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_UAIDI_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_UAIDI_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_UAIDI_APPROVE${UNQID}"  name="CHKLIST_ID_UAIDI_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_UAIDI_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>e) Any other document</strong> (Must be approved by Compliance Department). In case of any doubt about
										 the authorised signatory, further documents can be called for from the customer.
									</td>
									<td>
										<textarea rows="2" cols="2" class="form-control" name="CHKLIST_ADR_OTHERPROOF_DETAILS" id="CHKLIST_ADR_OTHERPROOF_DETAILS${UNQID}"
											<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
										>${CHECKLIST['CHKLIST_ADR_OTHERPROOF_DETAILS']}</textarea>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_OTHERPROOF_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_OTHERPROOF_APPROVE${UNQID}"  name="CHKLIST_ADR_OTHERPROOF_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_OTHERPROOF_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>8</td>
									<td>
										<strong>h) No Objection Certificate (NOC)</strong> from existing bankers or provide evidence of 
										letter sent to banks for seeking NOC (where loan or any credit facility is granted or proposed 
										to be granted to the corporate by other banks)
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_NOC_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_NOC_CHECK${UNQID}"  name="CHKLIST_OR_NOC_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_NOC_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_NOC_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_NOC_APPROVE${UNQID}"  name="CHKLIST_OR_NOC_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_NOC_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>9</td>
									<td>
										<strong>Details of Beneficial Ownership </strong>(If required, further documents can be called for from the customer)
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BENEFOWNR_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_BENEFOWNR_CHECK${UNQID}"  name="CHKLIST_BENEFOWNR_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BENEFOWNR_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BENEFOWNR_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_BENEFOWNR_APPROVE${UNQID}"  name="CHKLIST_BENEFOWNR_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BENEFOWNR_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>Mandatory</td>
								</tr>
								<tr>
									<td>10</td>
									<td>
										<strong>Latest photograph of Authorized signatories with signatures obtained</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_PHOTO_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_PHOTO_CHECK${UNQID}"  name="CHKLIST_OR_PHOTO_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_PHOTO_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_PHOTO_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_PHOTO_APPROVE${UNQID}"  name="CHKLIST_OR_PHOTO_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_PHOTO_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>11</td>
									<td>
										<strong>Account Opening Form (signed) </strong>along  with the Terms and Conditions
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_RBIAOF_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_RBIAOF_CHECK${UNQID}"  name="CHKLIST_OR_RBIAOF_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_RBIAOF_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_RBIAOF_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_RBIAOF_APPROVE${UNQID}"  name="CHKLIST_OR_RBIAOF_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_RBIAOF_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>12</td>
									<td>
										<strong>Specimen Signature card</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_SSC_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_SSC_CHECK${UNQID}"  name="CHKLIST_OR_SSC_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_SSC_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_SSC_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_SSC_APPROVE${UNQID}"  name="CHKLIST_OR_SSC_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_SSC_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>13</td>
									<td>
										<strong>Cheque Book Requisition form</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_CHQBK_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_CHQBK_CHECK${UNQID}"  name="CHKLIST_OR_CHQBK_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_CHQBK_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_CHQBK_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_CHQBK_APPROVE${UNQID}"  name="CHKLIST_OR_CHQBK_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_CHQBK_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Optional
									</td>
								</tr>
								<tr>
									<td>14</td>
									<td>
										<strong>Consent Letter</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_CONSENT_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_CONSENT_CHECK${UNQID}"  name="CHKLIST_CONSENT_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_CONSENT_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_CONSENT_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_CONSENT_APPROVE${UNQID}"  name="CHKLIST_CONSENT_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_CONSENT_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>15</td>
									<td>
										<strong>FATCA and CRS declaration form & FAQ</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_FATCACRS_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_FATCACRS_CHECK${UNQID}"  name="CHKLIST_OR_FATCACRS_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_FATCACRS_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_FATCACRS_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_FATCACRS_APPROVE${UNQID}"  name="CHKLIST_OR_FATCACRS_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_FATCACRS_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td colspan="5" style="background-color: #BBB">Documents for Banks Use (Please do not send this list to the customer)</td>
								</tr>
								<tr>
									<td rowspan="10" style="vertical-align: middle;">16</td>
									<td>
										<strong>a) Provisional and Remittance Indemnity</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_PRI_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_PRI_CHECK${UNQID}"  name="CHKLIST_BNKUS_PRI_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_PRI_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_PRI_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_PRI_APPROVE${UNQID}"  name="CHKLIST_BNKUS_PRI_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_PRI_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Optional
									</td>
								</tr>
								<tr>
									<td>
										<strong>b) Internal Kyogi and Form I - 159 (Head Office Format)</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_IKF_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_IKF_CHECK${UNQID}"  name="CHKLIST_BNKUS_IKF_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_IKF_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_IKF_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_IKF_APPROVE${UNQID}"  name="CHKLIST_BNKUS_IKF_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_IKF_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td rowspan="4" style="vertical-align: middle;">
										Mandatory
									</td>
								</tr>
								<tr>
									<td>
										<strong>c) Risk Rating Sheet</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_RRS_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_RRS_CHECK${UNQID}"  name="CHKLIST_BNKUS_RRS_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_RRS_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_RRS_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_RRS_APPROVE${UNQID}"  name="CHKLIST_BNKUS_RRS_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_RRS_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>d) PEP check with documentary proof</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_PEPCHK_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_PEPCHK_CHECK${UNQID}"  name="CHKLIST_BNKUS_PEPCHK_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_PEPCHK_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_PEPCHK_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_PEPCHK_APPROVE${UNQID}"  name="CHKLIST_BNKUS_PEPCHK_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_PEPCHK_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>e) CAP Checklist</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_CAPCHK_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_CAPCHK_CHECK${UNQID}"  name="CHKLIST_BNKUS_CAPCHK_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_CAPCHK_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_CAPCHK_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_CAPCHK_APPROVE${UNQID}"  name="CHKLIST_BNKUS_CAPCHK_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_CAPCHK_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>f) FIEL Checklist</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_FIELCHK_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_FIELCHK_CHECK${UNQID}"  name="CHKLIST_BNKUS_FIELCHK_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_FIELCHK_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_FIELCHK_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_FIELCHK_APPROVE${UNQID}"  name="CHKLIST_BNKUS_FIELCHK_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_FIELCHK_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										<label class="btn btn-outline btn-primary btn-sm radio-inline" for="CHKLIST_BNKUS_FIELCHK_Y${UNQID}">
											<input type="radio" id="CHKLIST_BNKUS_FIELCHK_Y${UNQID}"  name="CHKLIST_BNKUS_FIELCHK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_FIELCHK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Applicable
										</label>
										<label class="btn btn-outline btn-primary btn-sm radio-inline" for="CHKLIST_BNKUS_FIELCHK_N${UNQID}">
											<input type="radio" id="CHKLIST_BNKUS_FIELCHK_N${UNQID}"  name="CHKLIST_BNKUS_FIELCHK" value="N"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_FIELCHK'] eq 'N'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Not Applicable
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>g) Anti-Social Element Check </strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_ASECHK_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_ASECHK_CHECK${UNQID}"  name="CHKLIST_BNKUS_ASECHK_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_ASECHK_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_ASECHK_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_ASECHK_APPROVE${UNQID}"  name="CHKLIST_BNKUS_ASECHK_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_ASECHK_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										<label class="btn btn-outline btn-primary btn-sm radio-inline" for="CHKLIST_BNKUS_ASECHK_Y${UNQID}">
											<input type="radio" id="CHKLIST_BNKUS_ASECHK_Y${UNQID}"  name="CHKLIST_BNKUS_ASECHK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_ASECHK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Conducted
										</label>
										<label class="btn btn-outline btn-primary btn-sm radio-inline" for="CHKLIST_BNKUS_ASECHK_N${UNQID}">
											<input type="radio" id="CHKLIST_BNKUS_ASECHK_N${UNQID}"  name="CHKLIST_BNKUS_ASECHK" value="N"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_ASECHK'] eq 'N'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Not Applicable
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>h) PAN Verification (when available on record)</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_PANCHK_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_PANCHK_CHECK${UNQID}"  name="CHKLIST_BNKUS_PANCHK_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_PANCHK_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_PANCHK_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_PANCHK_APPROVE${UNQID}"  name="CHKLIST_BNKUS_PANCHK_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_PANCHK_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>
										<strong>i) Name check against SLS system</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_SLSCHK_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_SLSCHK_CHECK${UNQID}"  name="CHKLIST_BNKUS_SLSCHK_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_SLSCHK_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_SLSCHK_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_SLSCHK_APPROVE${UNQID}"  name="CHKLIST_BNKUS_SLSCHK_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_SLSCHK_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>
										<strong>i) Check RBI's CRILC database</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_RBICRILC_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_RBICRILC_CHECK${UNQID}"  name="CHKLIST_BNKUS_RBICRILC_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_RBICRILC_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_RBICRILC_APRVE${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_RBICRILC_APRVE${UNQID}"  name="CHKLIST_BNKUS_RBICRILC_APRVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_RBICRILC_APRVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td colspan="5" style="background-color: #BBB">FOR PARTNERSHIP & SOLE PROPRIETORSHIP</td>
								</tr>
								<tr>
									<td>1</td>
									<td>
										<strong>Copy of registered Partnership Deed </strong>(and its amendments, if any)
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_REGPERTNER_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_REGPERTNER_CHECK${UNQID}"  name="CHKLIST_PSP_REGPERTNER_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_REGPERTNER_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_REGPERTNER_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_REGPERTNER_APPROVE${UNQID}"  name="CHKLIST_PSP_REGPERTNER_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_REGPERTNER_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>2</td>
									<td>
										<strong>Copy of the PAN card of the firm / Proprietor / Proprietorship concern. If not available, obtain Form 49A.</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_PAN49_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_PAN49_CHECK${UNQID}"  name="CHKLIST_PSP_PAN49_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_PAN49_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_PAN49_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_PAN49_APPROVE${UNQID}"  name="CHKLIST_PSP_PAN49_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_PAN49_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td style="vertical-align: middle;" rowspan="10">3</td>
									<td colspan="4" style="background-color: #BBB">
										To verify the name and the address of the firm (any one of the following)
									</td>
								</tr>
								<tr>
									<td><strong>a) Latest available Income Tax return or Sales Tax return/ Sales Tax registration Certificate</strong></td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_TAXRET_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_TAXRET_CHECK${UNQID}"  name="CHKLIST_PSP_TAXRET_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_TAXRET_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_TAXRET_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_TAXRET_APPROVE${UNQID}"  name="CHKLIST_PSP_TAXRET_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_TAXRET_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td><strong>b) Shop & Establishment Certificate</strong></td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_SHOP_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_SHOP_CHECK${UNQID}"  name="CHKLIST_PSP_SHOP_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_SHOP_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_SHOP_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_SHOP_APPROVE${UNQID}"  name="CHKLIST_PSP_SHOP_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_SHOP_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td><strong>c) Factory Registration Certificate</strong></td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_FACTORY_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_FACTORY_CHECK${UNQID}"  name="CHKLIST_PSP_FACTORY_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_FACTORY_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_FACTORY_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_FACTORY_APPROVE${UNQID}"  name="CHKLIST_PSP_FACTORY_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_FACTORY_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td><strong>d) SEBI Registration Certificate </strong>(In case of Broker accounts)</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_SEBI_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_SEBI_CHECK${UNQID}"  name="CHKLIST_PSP_SEBI_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_SEBI_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_SEBI_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_SEBI_APPROVE${UNQID}"  name="CHKLIST_PSP_SEBI_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_SEBI_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td><strong>e) Importer Exporter code in case of Importers or Exporters</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_IMPEXP_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_IMPEXP_CHECK${UNQID}"  name="CHKLIST_PSP_IMPEXP_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_IMPEXP_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_IMPEXP_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_IMPEXP_APPROVE${UNQID}"  name="CHKLIST_PSP_IMPEXP_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_IMPEXP_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td><strong>f) Any other certificate issued for registration/ operations/ business by Local/ State/ Central Government/ Government Agency</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_OTHER1_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_OTHER1_CHECK${UNQID}"  name="CHKLIST_PSP_OTHER1_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_OTHER1_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_OTHER1_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_OTHER1_APPROVE${UNQID}"  name="CHKLIST_PSP_OTHER1_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_OTHER1_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td><strong>g) Any other certificate of registration issued by professional bodies such as ICAI/ ICSI/ ICWAI/ Medical Council in the name of the firm</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_OTHER2_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_OTHER2_CHECK${UNQID}"  name="CHKLIST_PSP_OTHER2_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_OTHER2_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_OTHER2_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_OTHER2_APPROVE${UNQID}"  name="CHKLIST_PSP_OTHER2_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_OTHER2_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td><strong>h) Business License</strong></td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_BUSLIC_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_BUSLIC_CHECK${UNQID}"  name="CHKLIST_PSP_BUSLIC_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_BUSLIC_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_BUSLIC_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_BUSLIC_APPROVE${UNQID}"  name="CHKLIST_PSP_BUSLIC_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_BUSLIC_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td><strong>i) Utility Bills in the name of the Proprietorship concern </strong>(not more than 6 months old) [only for address proof]</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_UTLYBILL_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_UTLYBILL_CHECK${UNQID}"  name="CHKLIST_PSP_UTLYBILL_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_UTLYBILL_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PSP_UTLYBILL_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_PSP_UTLYBILL_APPROVE${UNQID}"  name="CHKLIST_PSP_UTLYBILL_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PSP_UTLYBILL_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td colspan="5" style="background-color: #BBB">FOR LIAISON / BRANCH / PROJECT OFFICE</td>
								</tr>
								<tr>
									<td>1</td>
									<td><strong>
									For Liaison Office and Branch office <br/>
									- Approval from RBI to open Liaison Office and Branch office For Liaison Office of Insurance Companies<br/>
									- Approval from IRDA and RBI For Project Office <br/>
										&nbsp;&nbsp;&nbsp;- a) Certified True Copy of Full / Complete Work Order from Indian company to execute a project in India<br/>
										&nbsp;&nbsp;&nbsp;-  b) RBI approval on exceptional cases, please refer extant RBI guidelines.
									</strong></td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_LIBO_OFFC_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_LIBO_OFFC_CHECK${UNQID}"  name="CHKLIST_LIBO_OFFC_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_LIBO_OFFC_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_LIBO_OFFC_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_LIBO_OFFC_APPROVE${UNQID}"  name="CHKLIST_LIBO_OFFC_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_LIBO_OFFC_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>2</td>
									<td><strong>Article of Association of the Parent Company Certified as True Copy by any Authorised Signatory.</strong></td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_LIBO_ASOPC_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_LIBO_ASOPC_CHECK${UNQID}"  name="CHKLIST_LIBO_ASOPC_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_LIBO_ASOPC_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_LIBO_ASOPC_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_LIBO_ASOPC_APPROVE${UNQID}"  name="CHKLIST_LIBO_ASOPC_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_LIBO_ASOPC_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>3</td>
									<td><strong>Power of Attorney for Appointing Signatories duly notarised</strong></td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_LIBO_POA_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_LIBO_POA_CHECK${UNQID}"  name="CHKLIST_LIBO_POA_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_LIBO_POA_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_LIBO_POA_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_LIBO_POA_APPROVE${UNQID}"  name="CHKLIST_LIBO_POA_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_LIBO_POA_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>4</td>
									<td><strong>PAN card in the name of the Liaison Office/ Branch/ Project office</strong></td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_LIBO_PAN_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_LIBO_PAN_CHECK${UNQID}"  name="CHKLIST_LIBO_PAN_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_LIBO_PAN_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_LIBO_PAN_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_LIBO_PAN_APPROVE${UNQID}"  name="CHKLIST_LIBO_PAN_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_LIBO_PAN_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td colspan="5" style="background-color: #BBB">FOR A TRUST (CHARITABLE & PRIVATE)</td>
								</tr>
								<tr>
									<td>1</td>
									<td><strong>Copy of Trust Deed (and amendments if any)</strong></td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_TRST_DEED_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_TRST_DEED_CHECK${UNQID}"  name="CHKLIST_TRST_DEED_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_TRST_DEED_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_TRST_DEED_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_TRST_DEED_APPROVE${UNQID}"  name="CHKLIST_TRST_DEED_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_TRST_DEED_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>2</td>
									<td><strong>Resolution of Trustees to open and operate the account</strong></td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_TRST_ROSL_CHECK${UNQID}">
											<input type="checkbox" id="CCHKLIST_TRST_ROSL_CHECK${UNQID}"  name="CHKLIST_TRST_ROSL_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_TRST_ROSL_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_TRST_ROSL_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_TRST_ROSL_APPROVE${UNQID}"  name="CHKLIST_TRST_ROSL_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_TRST_ROSL_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>3</td>
									<td><strong>List of current trustees on the letter head of the Trust</strong></td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_TRST_CRNT_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_TRST_CRNT_CHECK${UNQID}"  name="CHKLIST_TRST_CRNT_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_TRST_CRNT_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_TRST_CRNT_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_TRST_CRNT_APPROVE${UNQID}"  name="CHKLIST_TRST_CRNT_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_TRST_CRNT_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>4</td>
									<td><strong>Charity Commisioner's Certificate registering the Trust</strong></td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_TRST_COMSNR_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_TRST_COMSNR_CHECK${UNQID}"  name="CHKLIST_TRST_COMSNR_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_TRST_COMSNR_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_TRST_COMSNR_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_TRST_COMSNR_APPROVE${UNQID}"  name="CHKLIST_TRST_COMSNR_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_TRST_COMSNR_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>5</td>
									<td><strong>Copy of Income Tax Officers Certificate under whom the Trust is assessed / or Copy of PAN card in the name of the Trust</strong></td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_TRST_TAX_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_TRST_TAX_CHECK${UNQID}"  name="CHKLIST_TRST_TAX_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_TRST_TAX_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_TRST_TAX_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_TRST_TAX_APPROVE${UNQID}"  name="CHKLIST_TRST_TAX_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_TRST_TAX_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>6</td>
									<td><strong>Conduct a check against list of NGO misutilising Foreign Funds provided by RBI</strong></td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_TRST_NGORBI_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_TRST_NGORBI_CHECK${UNQID}"  name="CHKLIST_TRST_NGORBI_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_TRST_NGORBI_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_TRST_NGORBI_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_TRST_NGORBI_APPROVE${UNQID}"  name="CHKLIST_TRST_NGORBI_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_TRST_NGORBI_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td colspan="5" style="background-color: #BBB">FOR AN ASSOCIATION / SOCIETY / CLUB</td>
								</tr>
								<tr>
									<td>1</td>
									<td><strong>Copy of the Registration Certificate only in case of an Association or Society and not for Club</strong></td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ASC_REGCERT_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ASC_REGCERT_CHECK${UNQID}"  name="CHKLIST_ASC_REGCERT_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ASC_REGCERT_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ASC_REGCERT_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ASC_REGCERT_APPROVE${UNQID}"  name="CHKLIST_ASC_REGCERT_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ASC_REGCERT_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>2</td>
									<td><strong>Copy of the Bye Laws of the Association/ Society/ Club</strong></td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ASC_BYELAWS_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ASC_BYELAWS_CHECK${UNQID}"  name="CHKLIST_ASC_BYELAWS_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ASC_BYELAWS_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ASC_BYELAWS_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ASC_BYELAWS_APPROVE${UNQID}"  name="CHKLIST_ASC_BYELAWS_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ASC_BYELAWS_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>3</td>
									<td><strong>Resolution authorizing members to open and operate the account of Association / Society / Club</strong></td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ASC_AUTHMEM_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ASC_AUTHMEM_CHECK${UNQID}"  name="CHKLIST_ASC_AUTHMEM_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ASC_AUTHMEM_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ASC_AUTHMEM_APPROVE${UNQID}">
											<input type="checkbox" id="CCHKLIST_ASC_AUTHMEM_APPROVE${UNQID}"  name="CHKLIST_ASC_AUTHMEM_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ASC_AUTHMEM_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>4</td>
									<td><strong>List of current members of the Association/Society/Club</strong></td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ASC_CURRMEM_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ASC_CURRMEM_CHECK${UNQID}"  name="CHKLIST_ASC_CURRMEM_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ASC_CURRMEM_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ASC_CURRMEM_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ASC_CURRMEM_APPROVE${UNQID}"  name="CHKLIST_ASC_CURRMEM_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ASC_CURRMEM_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>5</td>
									<td><strong>Certificate of Income Tax Officer under whom the Association/Society/Club is assessed/ OR Copy of PAN card in the name of the Association/Society/Club</strong></td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ASC_TAX_CHECK${UNQID}">
											<input type="checkbox" id="CCHKLIST_ASC_TAX_CHECK${UNQID}"  name="CHKLIST_ASC_TAX_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ASC_TAX_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ASC_TAX_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ASC_TAX_APPROVE${UNQID}"  name="CHKLIST_ASC_TAX_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ASC_TAX_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
									<tr>
										<td colspan="5" style="text-align: right;">
											<button type="button" class="btn btn-success btn-sm saveCDDFormBPAMaker" id="saveCDDForm6${UNQID}">Save</button>
										</td>
									</tr>
								</c:if>
								<c:if test="${FORMDATA['STATUS'] eq 'BPA-A' && CURRENTROLE eq 'ROLE_BPACHECKER'}">
									<tr>
										<td colspan="5" style="text-align: right;">
											<button type="button" class="btn btn-success btn-sm saveCDDFormBPAChecker" id="saveCDDForm7${UNQID}">Save</button>
										</td>
									</tr>
								</c:if>
							</table>
							</form>
						</div>
						<div role="tabpanel" class="tab-pane" id="identificationForm"></div>
						<div role="tabpanel" class="tab-pane" id="statusApprovals"></div>
						</div>
					</div>
				</div>
		</div>
	</div>
</div>