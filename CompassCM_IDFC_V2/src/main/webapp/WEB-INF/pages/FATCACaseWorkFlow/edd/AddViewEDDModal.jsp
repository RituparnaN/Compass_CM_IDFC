<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../../tags/tags.jsp"%>
    
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var caseNoForEDD = '${caseNoForEDD}';
	
	$("#addViewEDDForm"+id).submit(function(e){
		var formObj = $("#addViewEDDForm"+id);
		var formData = (formObj).serialize();
		$.ajax({
			url: "${pageContext.request.contextPath}/common/saveUpdateEDD",
			cache: false,
			type: "POST",
			data: formData,
			success: function(res){
				alert(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
		e.preventDefault();
	});
	
	$("#backToRecords"+id).click(function(){
		$.ajax({
			url: "${pageContext.request.contextPath}/common/viewEddRecords?caseNoForEDD="+caseNoForEDD,
			cache: false,
			type: "POST",
			success: function(res){
				$("#compassCaseWorkFlowGenericModal-body").html(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	});
	
	});
</script>
<style type="text/css">
	fieldset.evidenceData{
		border: 1px groove #ddd !important;
	    padding: -5px 10px 5px 10px!important;
	    margin: 5px 0 0 0 !important;
	    -webkit-box-shadow:  0px 0px 0px 0px #000;
	            box-shadow:  0px 0px 0px 0px #000;
	}
	legend.evidenceData {
	text-align: left !important;
	width:inherit; 
    border-bottom:none;
    margin: 0px;
    margin-left: 10px;
    margin-bottom : 5px;
    padding: 0px;
}
</style>
<div class="row compassrow${UNQID}">
<div class="col-sm-12">
	<div class="card card-primary addViewEDDModalForm">
		<div class="card-header paneladdEvidenceData${UNQID} clearfix">
			<h6 class="card-title pull-${dirL}">Evidence Data</h6>
		</div>
	<form action="javascript:void(0)" method="POST" id="addViewEDDForm${UNQID}">
		<div class="panelSearchForm kycDoc" style="padding: 0px 5px 5px 5px;">
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;" >KYC Documentation Opinion</legend>					
						<table class="table kycDocTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<c:set var="LABELSCOUNT" value="${f:length(DATA['KYCDOCUMENTATIONOPINION'])}"/>
							<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
							
							<c:forEach var="KYCDOCUMENTATIONOPINION" items="${DATA['KYCDOCUMENTATIONOPINION']}" varStatus="loop">
								<c:choose>
										<c:when test="${LABELSITRCOUNT % 2 == 0}">
											<tr>
												<td width="50%">
													<input type="radio" class="form-check-input" 
													id="KYCDOCUMENTATIONOPINION_${loop.index}" 
													name="KYCDOCUMENTATIONOPINION" 
													value="${KYCDOCUMENTATIONOPINION}"
													<c:if test="${KYCDOCUMENTATIONOPINION eq FETCHEDDETAILS['KYCDOCUMENTATIONOPINION'] }">checked="checked"</c:if> >
													<label for="KYCDOCUMENTATIONOPINION_${loop.index}" >${KYCDOCUMENTATIONOPINION}</label>
												</td>
										</c:when>
										<c:otherwise>
												<td>
													<input type="radio" class="form-check-input" id="KYCDOCUMENTATIONOPINION_${loop.index}"
													 name="KYCDOCUMENTATIONOPINION" value="${KYCDOCUMENTATIONOPINION}"
													 <c:if test="${KYCDOCUMENTATIONOPINION eq FETCHEDDETAILS['KYCDOCUMENTATIONOPINION'] }">checked="checked"</c:if>>
													<label for="KYCDOCUMENTATIONOPINION_${loop.index}" >${KYCDOCUMENTATIONOPINION}</label>
												</td>
											</tr>
										</c:otherwise>
								</c:choose>
								<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
							</c:forEach>
							<c:if test="${LABELSITRCOUNT % 2 != 0}">
									<td>&nbsp;</td>
								</tr>
							</c:if>
						</table>
			</fieldset>
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;" >Telephone Number Verification</legend>
						<table class="table telephoneNoVerificationTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<c:set var="LABELSCOUNT" value="${f:length(DATA['TNOVERIFICATION'])}"/>
							<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
							
							<c:forEach var="TNOVERIFICATION" items="${DATA['TNOVERIFICATION']}" varStatus="loop">
								<c:choose>
										<c:when test="${LABELSITRCOUNT % 2 == 0}">
											<tr>
												<td width="50%">
													<input type="radio" class="form-check-input" 
													id="TNOVERIFICATION_${loop.index}" 
													name="TNOVERIFICATION" 
													value="${TNOVERIFICATION}"
													<c:if test="${TNOVERIFICATION eq FETCHEDDETAILS['TNOVERIFICATION'] }">checked="checked"</c:if>>
													<label for="TNOVERIFICATION_${loop.index}" >${TNOVERIFICATION}</label>
												</td>
										</c:when>
										<c:otherwise>
												<td>
													<input type="radio" class="form-check-input" 
													id="TNOVERIFICATION_${loop.index}" 
													name="TNOVERIFICATION" 
													value="${TNOVERIFICATION}"
													<c:if test="${TNOVERIFICATION eq FETCHEDDETAILS['TNOVERIFICATION'] }">checked="checked"</c:if>>
													<label for="TNOVERIFICATION_${loop.index}" >${TNOVERIFICATION}</label>
												</td>
											</tr>
										</c:otherwise>
								</c:choose>
								<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
							</c:forEach>
							<c:if test="${LABELSITRCOUNT % 2 != 0}">
									<td>&nbsp;</td>
								</tr>
							</c:if>
						</table>
			</fieldset>
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;">CBS Address Verification Visit By</legend>
						<table class="table cbsAddressVisitTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
								<c:set var="LABELSCOUNT" value="${f:length(DATA['ADDRESSVERIFIEDBY'])}"/>
							<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
							
							<c:forEach var="ADDRESSVERIFIEDBY" items="${DATA['ADDRESSVERIFIEDBY']}" varStatus="loop">
								<c:choose>
										<c:when test="${LABELSITRCOUNT % 2 == 0}">
											<tr>
												<td width="50%">
													<input type="radio" class="form-check-input" 
													id="ADDRESSVERIFIEDBY" 
													name="ADDRESSVERIFIEDBY" 
													value="${ADDRESSVERIFIEDBY}"
													<c:if test="${ADDRESSVERIFIEDBY eq FETCHEDDETAILS['ADDRESSVERIFIEDBY'] }">checked="checked"</c:if>>
													<label for="ADDRESSVERIFIEDBY_${loop.index}" >${ADDRESSVERIFIEDBY}</label>
												</td>
										</c:when>
										<c:otherwise>
												<td>
													<input type="radio" class="form-check-input" 
													id="ADDRESSVERIFIEDBY_${loop.index}" 
													name="ADDRESSVERIFIEDBY" 
													value="${ADDRESSVERIFIEDBY}"
													<c:if test="${ADDRESSVERIFIEDBY eq FETCHEDDETAILS['ADDRESSVERIFIEDBY'] }">checked="checked"</c:if>>
													<label for="ADDRESSVERIFIEDBY_${loop.index}" >${ADDRESSVERIFIEDBY}</label>
												</td>
											</tr>
										</c:otherwise>
								</c:choose>
								<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
							</c:forEach>
							<c:if test="${LABELSITRCOUNT % 2 != 0}">
									<td>&nbsp;</td>
								</tr>
							</c:if>
						</table>
			</fieldset>		
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;">CBS Address Verification Findings</legend>
						<table class="table cbsAddressFindingsTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
								<c:set var="LABELSCOUNT" value="${f:length(DATA['ADDRESSVERIFICATIONFINDINGS'])}"/>
							<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
							
							<c:forEach var="ADDRESSVERIFICATIONFINDINGS" items="${DATA['ADDRESSVERIFICATIONFINDINGS']}" varStatus="loop">
								<c:choose>
										<c:when test="${LABELSITRCOUNT % 2 == 0}">
											<tr>
												<td width="50%">
													<input type="radio" class="form-check-input" 
													id="ADDRESSVERIFICATIONFINDINGS" 
													name="ADDRESSVERIFICATIONFINDINGS" 
													value="${ADDRESSVERIFICATIONFINDINGS}"
													<c:if test="${ADDRESSVERIFICATIONFINDINGS eq FETCHEDDETAILS['ADDRESSVERIFICATIONFINDINGS'] }">checked="checked"</c:if>>
													<label for="ADDRESSVERIFICATIONFINDINGS_${loop.index}" >${ADDRESSVERIFICATIONFINDINGS}</label>
												</td>
										</c:when>
										<c:otherwise>
												<td>
													<input type="radio" class="form-check-input" 
													id="ADDRESSVERIFICATIONFINDINGS_${loop.index}" 
													name="ADDRESSVERIFICATIONFINDINGS" 
													value="${ADDRESSVERIFICATIONFINDINGS}"
													<c:if test="${ADDRESSVERIFICATIONFINDINGS eq FETCHEDDETAILS['ADDRESSVERIFICATIONFINDINGS'] }">checked="checked"</c:if>>
													<label for="ADDRESSVERIFICATIONFINDINGS_${loop.index}" >${ADDRESSVERIFICATIONFINDINGS}</label>
												</td>
											</tr>
										</c:otherwise>
								</c:choose>
								<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
							</c:forEach>
							<c:if test="${LABELSITRCOUNT % 2 != 0}">
									<td>&nbsp;</td>
								</tr>
							</c:if>
						</table>
			</fieldset>
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;">Person contacted at Client's Office</legend>
						<table class="table personContactedTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<tr>
								<td width="15%" align="center" style="font-weight: bold;">Name</td>
								<td width="30%" align="center">
									<input type="text" class="form-control input-sm" id="CONTACTEDPERSON_NAME" name="CONTACTEDPERSON_NAME" value="${FETCHEDDETAILS['CONTACTEDPERSON_NAME']}" >
								</td>
								<td width="10%" align="center"></td>
								<td width="15%" align="center" style="font-weight: bold;">Designation</td>
								<td width="30%" align="center">
									<input type="text" class="form-control input-sm" id="CONTACTEDPERSON_DESIGNATION" name="CONTACTEDPERSON_DESIGNATION" value="${FETCHEDDETAILS['CONTACTEDPERSON_DESIGNATION']}">
								</td>
							</tr>
						</table>
			</fieldset>	
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;" >Authorized Signatory Availability</legend>
						<table class="table authSignatoryTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<c:set var="LABELSCOUNT" value="${f:length(DATA['SIGNATORY_AVAILABILITY'])}"/>
							<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
							
							<c:forEach var="SIGNATORY_AVAILABILITY" items="${DATA['SIGNATORY_AVAILABILITY']}" varStatus="loop">
								<c:choose>
										<c:when test="${LABELSITRCOUNT % 2 == 0}">
											<tr>
												<td width="50%">
													<input type="radio" class="form-check-input"
													 id="SIGNATORY_AVAILABILITY" 
													 name="SIGNATORY_AVAILABILITY" 
													 value="${SIGNATORY_AVAILABILITY}"
													 <c:if test="${SIGNATORY_AVAILABILITY eq FETCHEDDETAILS['SIGNATORY_AVAILABILITY'] }">checked="checked"</c:if>>
													<label for="SIGNATORY_AVAILABILITY_${loop.index}" >${SIGNATORY_AVAILABILITY}</label>
												</td>
										</c:when>
										<c:otherwise>
												<td>
													<input type="radio" class="form-check-input" 
													id="SIGNATORY_AVAILABILITY" 
													name="SIGNATORY_AVAILABILITY" 
													value="${SIGNATORY_AVAILABILITY}"
													<c:if test="${SIGNATORY_AVAILABILITY eq FETCHEDDETAILS['SIGNATORY_AVAILABILITY'] }">checked="checked"</c:if>>
													<label for="SIGNATORY_AVAILABILITY_${loop.index}" >${SIGNATORY_AVAILABILITY}</label>
												</td>
											</tr>
										</c:otherwise>
								</c:choose>
								<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
							</c:forEach>
							<c:if test="${LABELSITRCOUNT % 2 != 0}">
									<td>&nbsp;</td>
								</tr>
							</c:if>
						</table>
			</fieldset>
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;" >Customer Reaction(On enquiring about transaction)</legend>
						<table class="table custReactionTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<c:set var="LABELSCOUNT" value="${f:length(DATA['CUSTOMERREACTION'])}"/>
							<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
							
							<c:forEach var="CUSTOMERREACTION" items="${DATA['CUSTOMERREACTION']}" varStatus="loop">
								<c:choose>
										<c:when test="${LABELSITRCOUNT % 2 == 0}">
											<tr>
												<td width="50%">
													<input type="radio" class="form-check-input" 
													id="CUSTOMERREACTION" 
													name="CUSTOMERREACTION" 
													value="${CUSTOMERREACTION}"
													<c:if test="${CUSTOMERREACTION eq FETCHEDDETAILS['CUSTOMERREACTION'] }">checked="checked"</c:if>>
													<label for="CUSTOMERREACTION_${loop.index}" >${CUSTOMERREACTION}</label>
												</td>
										</c:when>
										<c:otherwise>
												<td>
													<input type="radio" class="form-check-input" 
													id="CUSTOMERREACTION" 
													name="CUSTOMERREACTION" 
													value="${CUSTOMERREACTION}"
													<c:if test="${CUSTOMERREACTION eq FETCHEDDETAILS['CUSTOMERREACTION'] }">checked="checked"</c:if>>
													<label for="CUSTOMERREACTION_${loop.index}" >${CUSTOMERREACTION}</label>
												</td>
											</tr>
										</c:otherwise>
								</c:choose>
								<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
							</c:forEach>
							<c:if test="${LABELSITRCOUNT % 2 != 0}">
									<td>&nbsp;</td>
								</tr>
							</c:if>
						</table>
			</fieldset>
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;">Business Premise Type</legend>
						<table class="table businessPremiseTypeTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
								<c:set var="LABELSCOUNT" value="${f:length(DATA['BUSINESSPREMISE_TYPE'])}"/>
							<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
							
							<c:forEach var="BUSINESSPREMISE_TYPE" items="${DATA['BUSINESSPREMISE_TYPE']}" varStatus="loop">
								<c:choose>
										<c:when test="${LABELSITRCOUNT % 2 == 0}">
											<tr>
												<td width="50%">
													<input type="radio" class="form-check-input" 
													id="BUSINESSPREMISE_TYPE" 
													name="BUSINESSPREMISE_TYPE" 
													value="${BUSINESSPREMISE_TYPE}"
													<c:if test="${BUSINESSPREMISE_TYPE eq FETCHEDDETAILS['BUSINESSPREMISE_TYPE'] }">checked="checked"</c:if>>
													<label for="BUSINESSPREMISE_TYPE_${loop.index}" >${BUSINESSPREMISE_TYPE}</label>
												</td>
										</c:when>
										<c:otherwise>
												<td>
													<input type="radio" class="form-check-input" 
													id=BUSINESSPREMISE_TYPE 
													name="BUSINESSPREMISE_TYPE" 
													value="${BUSINESSPREMISE_TYPE}"
													<c:if test="${BUSINESSPREMISE_TYPE eq FETCHEDDETAILS['BUSINESSPREMISE_TYPE'] }">checked="checked"</c:if>>
													<label for="BUSINESSPREMISE_TYPE_${loop.index}" >${BUSINESSPREMISE_TYPE}</label>
												</td>
											</tr>
										</c:otherwise>
								</c:choose>
								<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
							</c:forEach>
							<c:if test="${LABELSITRCOUNT % 2 != 0}">
									<td>&nbsp;</td>
								</tr>
							</c:if>
						</table>
			</fieldset>		
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;">Business Premise Size</legend>
						<table class="table businessPremiseSizeTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<c:set var="LABELSCOUNT" value="${f:length(DATA['BUSINESSPREMISE_SIZE'])}"/>
							<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
							
							<c:forEach var="BUSINESSPREMISE_SIZE" items="${DATA['BUSINESSPREMISE_SIZE']}" varStatus="loop">
								<c:choose>
										<c:when test="${LABELSITRCOUNT % 2 == 0}">
											<tr>
												<td width="50%">
													<input type="radio" class="form-check-input" id="BUSINESSPREMISE_SIZE" 
													name="BUSINESSPREMISE_SIZE" 
													value="${BUSINESSPREMISE_SIZE}"
													<c:if test="${BUSINESSPREMISE_SIZE eq FETCHEDDETAILS['BUSINESSPREMISE_SIZE'] }">checked="checked"</c:if>>
													<label for="BUSINESSPREMISE_SIZE_${loop.index}" >${BUSINESSPREMISE_SIZE}</label>
												</td>
										</c:when>
										<c:otherwise>
												<td>
													<input type="radio" class="form-check-input" 
													id="BUSINESSPREMISE_SIZE" 
													name="BUSINESSPREMISE_SIZE" 
													value="${BUSINESSPREMISE_SIZE}"
													<c:if test="${BUSINESSPREMISE_SIZE eq FETCHEDDETAILS['BUSINESSPREMISE_SIZE'] }">checked="checked"</c:if>>
													<label for="BUSINESSPREMISE_SIZE_${loop.index}" >${BUSINESSPREMISE_SIZE}</label>
												</td>
											</tr>
										</c:otherwise>
								</c:choose>
								<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
							</c:forEach>
							<c:if test="${LABELSITRCOUNT % 2 != 0}">
									<td>&nbsp;</td>
								</tr>
							</c:if>
						</table>
			</fieldset>
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;">Staff Strength</legend>
						<table class="table staffStrengthTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
								<c:set var="LABELSCOUNT" value="${f:length(DATA['STAFFSTRENGTH'])}"/>
							<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
							
							<c:forEach var="STAFFSTRENGTH" items="${DATA['STAFFSTRENGTH']}" varStatus="loop">
								<c:choose>
										<c:when test="${LABELSITRCOUNT % 2 == 0}">
											<tr>
												<td width="50%">
													<input type="radio" class="form-check-input" 
													id="STAFFSTRENGTH" 
													name="STAFFSTRENGTH" 
													value="${STAFFSTRENGTH}"
													<c:if test="${STAFFSTRENGTH eq FETCHEDDETAILS['STAFFSTRENGTH'] }">checked="checked"</c:if>>
													<label for="STAFFSTRENGTH_${loop.index}" >${STAFFSTRENGTH}</label>
												</td>
										</c:when>
										<c:otherwise>
												<td>
													<input type="radio" class="form-check-input" 
													id=STAFFSTRENGTH 
													name="STAFFSTRENGTH" 
													value="${STAFFSTRENGTH}"
													<c:if test="${STAFFSTRENGTH eq FETCHEDDETAILS['STAFFSTRENGTH'] }">checked="checked"</c:if>>
													<label for="STAFFSTRENGTH_${loop.index}" >${STAFFSTRENGTH}</label>
												</td>
											</tr>
										</c:otherwise>
								</c:choose>
								<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
							</c:forEach>
							<c:if test="${LABELSITRCOUNT % 2 != 0}">
									<td>&nbsp;</td>
								</tr>
							</c:if>
						</table>
			</fieldset>		
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;">Legal Constitution</legend>
						<table class="table legalConstitutionTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<c:set var="LABELSCOUNT" value="${f:length(DATA['LEGALCONSTITUTION'])}"/>
							<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
							
							<c:forEach var="LEGALCONSTITUTION" items="${DATA['LEGALCONSTITUTION']}" varStatus="loop">
								<c:choose>
										<c:when test="${LABELSITRCOUNT % 2 == 0}">
											<tr>
												<td width="50%">
													<input type="radio" class="form-check-input" 
													id="LEGALCONSTITUTION" 
													name="LEGALCONSTITUTION" 
													value="${LEGALCONSTITUTION}"
													<c:if test="${LEGALCONSTITUTION eq FETCHEDDETAILS['LEGALCONSTITUTION'] }">checked="checked"</c:if>>
													<label for="LEGALCONSTITUTION_${loop.index}" >${LEGALCONSTITUTION}</label>
												</td>
										</c:when>
										<c:otherwise>
												<td>
													<input type="radio" class="form-check-input" 
													id=LEGALCONSTITUTION 
													name="LEGALCONSTITUTION"
													value="${LEGALCONSTITUTION}"
													<c:if test="${LEGALCONSTITUTION eq FETCHEDDETAILS['LEGALCONSTITUTION'] }">checked="checked"</c:if>>
													<label for="LEGALCONSTITUTION_${loop.index}" >${LEGALCONSTITUTION}</label>
												</td>
											</tr>
										</c:otherwise>
								</c:choose>
								<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
							</c:forEach>
							<c:if test="${LABELSITRCOUNT % 2 != 0}">
									<td>&nbsp;</td>
								</tr>
							</c:if>
						</table>
			</fieldset>
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;">Customer's Business</legend>
						<table class="table networthTurnoverTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<tr>
								<td width="15%" align="center" style="font-weight: bold;">Networth(Lacs)</td>
								<td width="30%" align="center">
									<input type="text" class="form-control input-sm" id="BUSINESS_NETWORTHINLACS" name="BUSINESS_NETWORTHINLACS" value="${FETCHEDDETAILS['BUSINESS_NETWORTHINLACS']}" >
								</td>
								<td width="10%" align="center"></td>
								<td width="15%" align="center" style="font-weight: bold;">Turnover(Lacs)</td>
								<td width="30%" align="center">
									<input type="text" class="form-control input-sm" id="BUSINESS_TURNOVERINLACS" name="BUSINESS_TURNOVERINLACS" value="${FETCHEDDETAILS['BUSINESS_TURNOVERINLACS']}" >
								</td>
							</tr>
						</table>
			</fieldset>
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;" >Customer's Business Years</legend>
						<table class="table businessYearsTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<c:set var="LABELSCOUNT" value="${f:length(DATA['BUSINESS_YEARS'])}"/>
							<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
							
							<c:forEach var="BUSINESS_YEARS" items="${DATA['BUSINESS_YEARS']}" varStatus="loop">
								<c:choose>
										<c:when test="${LABELSITRCOUNT % 2 == 0}">
											<tr>
												<td width="50%">
													<input type="radio" class="form-check-input" 
													id="BUSINESS_YEARS" 
													name="BUSINESS_YEARS" 
													value="${BUSINESS_YEARS}"
													<c:if test="${BUSINESS_YEARS eq FETCHEDDETAILS['BUSINESS_YEARS'] }">checked="checked"</c:if>>
													<label for="BUSINESS_YEARS_${loop.index}" >${BUSINESS_YEARS}</label>
												</td>
										</c:when>
										<c:otherwise>
												<td>
													<input type="radio" class="form-check-input" 
													id=BUSINESS_YEARS 
													name="BUSINESS_YEARS" 
													value="${BUSINESS_YEARS}"
													<c:if test="${BUSINESS_YEARS eq FETCHEDDETAILS['BUSINESS_YEARS'] }">checked="checked"</c:if>>
													<label for="BUSINESS_YEARS_${loop.index}" >${BUSINESS_YEARS}</label>
												</td>
											</tr>
										</c:otherwise>
								</c:choose>
								<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
							</c:forEach>
							<c:if test="${LABELSITRCOUNT % 2 != 0}">
									<td>&nbsp;</td>
								</tr>
							</c:if>
						</table>
			</fieldset>
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;" >Customer's Industry</legend>
						<table class="table custIndustryTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<c:set var="LABELSCOUNT" value="${f:length(DATA['CUSTOMERINDUSTRY'])}"/>
							<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
							
							<c:forEach var="CUSTOMERINDUSTRY" items="${DATA['CUSTOMERINDUSTRY']}" varStatus="loop">
								<c:choose>
										<c:when test="${LABELSITRCOUNT % 2 == 0}">
											<tr>
												<td width="50%">
													<input type="radio" class="form-check-input" 
													id="CUSTOMERINDUSTRY" 
													name="CUSTOMERINDUSTRY" 
													value="${CUSTOMERINDUSTRY}"
													<c:if test="${CUSTOMERINDUSTRY eq FETCHEDDETAILS['CUSTOMERINDUSTRY'] }">checked="checked"</c:if>>
													<label for="CUSTOMERINDUSTRY_${loop.index}" >${CUSTOMERINDUSTRY}</label>
												</td>
										</c:when>
										<c:otherwise>
												<td>
													<input type="radio" class="form-check-input" 
													id=CUSTOMERINDUSTRY 
													name="CUSTOMERINDUSTRY" 
													value="${CUSTOMERINDUSTRY}"
													<c:if test="${CUSTOMERINDUSTRY eq FETCHEDDETAILS['CUSTOMERINDUSTRY'] }">checked="checked"</c:if>>
													<label for="CUSTOMERINDUSTRY_${loop.index}" >${CUSTOMERINDUSTRY}</label>
												</td>
											</tr>
										</c:otherwise>
								</c:choose>
								<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
							</c:forEach>
							<c:if test="${LABELSITRCOUNT % 2 != 0}">
									<td>&nbsp;</td>
								</tr>
							</c:if>
						</table>
			</fieldset>
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;">Customer's Business Segment</legend>
						<table class="table custBusinessSegmentTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
								<c:set var="LABELSCOUNT" value="${f:length(DATA['BUSINESS_SEGMENT'])}"/>
							<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
							
							<c:forEach var="BUSINESS_SEGMENT" items="${DATA['BUSINESS_SEGMENT']}" varStatus="loop">
								<c:choose>
										<c:when test="${LABELSITRCOUNT % 2 == 0}">
											<tr>
												<td width="50%">
													<input type="radio" class="form-check-input" 
													id="BUSINESS_SEGMENT" 
													name="BUSINESS_SEGMENT" 
													value="${BUSINESS_SEGMENT}"
													<c:if test="${BUSINESS_SEGMENT eq FETCHEDDETAILS['BUSINESS_SEGMENT'] }">checked="checked"</c:if>>
													<label for="BUSINESS_SEGMENT_${loop.index}" >${BUSINESS_SEGMENT}</label>
												</td>
										</c:when>
										<c:otherwise>
												<td>
													<input type="radio" class="form-check-input" 
													id=BUSINESS_SEGMENT 
													name="BUSINESS_SEGMENT" 
													value="${BUSINESS_SEGMENT}"
													<c:if test="${BUSINESS_SEGMENT eq FETCHEDDETAILS['BUSINESS_SEGMENT'] }">checked="checked"</c:if>>
													<label for="BUSINESS_SEGMENT_${loop.index}" >${BUSINESS_SEGMENT}</label>
												</td>
											</tr>
										</c:otherwise>
								</c:choose>
								<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
							</c:forEach>
							<c:if test="${LABELSITRCOUNT % 2 != 0}">
									<td>&nbsp;</td>
								</tr>
							</c:if>
						</table>
			</fieldset>		
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;">Practiced Transaction Pattern</legend>
						<table class="table transPatternTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<c:set var="LABELSCOUNT" value="${f:length(DATA['PRACTICEDTRANSACTIONPATTERN'])}"/>
							<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
							
							<c:forEach var="PRACTICEDTRANSACTIONPATTERN" items="${DATA['PRACTICEDTRANSACTIONPATTERN']}" varStatus="loop">
								<c:choose>
										<c:when test="${LABELSITRCOUNT % 2 == 0}">
											<tr>
												<td width="50%">
													<input type="radio" class="form-check-input" 
													id="PRACTICEDTRANSACTIONPATTERN" 
													name="PRACTICEDTRANSACTIONPATTERN" 
													value="${PRACTICEDTRANSACTIONPATTERN}"
													<c:if test="${PRACTICEDTRANSACTIONPATTERN eq FETCHEDDETAILS['PRACTICEDTRANSACTIONPATTERN'] }">checked="checked"</c:if>>
													<label for="PRACTICEDTRANSACTIONPATTERN_${loop.index}" >${PRACTICEDTRANSACTIONPATTERN}</label>
												</td>
										</c:when>
										<c:otherwise>
												<td>
													<input type="radio" class="form-check-input" 
													id=PRACTICEDTRANSACTIONPATTERN 
													name="PRACTICEDTRANSACTIONPATTERN" 
													value="${PRACTICEDTRANSACTIONPATTERN}"
													<c:if test="${PRACTICEDTRANSACTIONPATTERN eq FETCHEDDETAILS['PRACTICEDTRANSACTIONPATTERN'] }">checked="checked"</c:if>>
													<label for="PRACTICEDTRANSACTIONPATTERN_${loop.index}" >${PRACTICEDTRANSACTIONPATTERN}</label>
												</td>
											</tr>
										</c:otherwise>
								</c:choose>
								<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
							</c:forEach>
							<c:if test="${LABELSITRCOUNT % 2 != 0}">
									<td>&nbsp;</td>
								</tr>
							</c:if>
						</table>
			</fieldset>
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;">Customer's Transaction Observation</legend>
						<table class="table transObsTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<c:set var="LABELSCOUNT" value="${f:length(DATA['PRACTICEDTRANSACTIONPATTERN'])}"/>
							<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
							
							<c:forEach var="TRANSACTIONOBSERVATION" items="${DATA['TRANSACTIONOBSERVATION']}" varStatus="loop">
								<c:choose>
										<c:when test="${LABELSITRCOUNT % 2 == 0}">
											<tr>
												<td width="50%">
													<input type="radio" class="form-check-input" 
													id="TRANSACTIONOBSERVATION" 
													name="TRANSACTIONOBSERVATION" 
													value="${TRANSACTIONOBSERVATION}"
													<c:if test="${TRANSACTIONOBSERVATION eq FETCHEDDETAILS['TRANSACTIONOBSERVATION'] }">checked="checked"</c:if>>
													<label for="TRANSACTIONOBSERVATION_${loop.index}" >${TRANSACTIONOBSERVATION}</label>
												</td>
										</c:when>
										<c:otherwise>
												<td>
													<input type="radio" class="form-check-input" 
													id=TRANSACTIONOBSERVATION 
													name="TRANSACTIONOBSERVATION" 
													value="${TRANSACTIONOBSERVATION}"
													<c:if test="${TRANSACTIONOBSERVATION eq FETCHEDDETAILS['TRANSACTIONOBSERVATION'] }">checked="checked"</c:if>>
													<label for="TRANSACTIONOBSERVATION_${loop.index}" >${TRANSACTIONOBSERVATION}</label>
												</td>
											</tr>
										</c:otherwise>
								</c:choose>
								<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
							</c:forEach>
							<c:if test="${LABELSITRCOUNT % 2 != 0}">
									<td>&nbsp;</td>
								</tr>
							</c:if>
						</table>
			</fieldset>
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;">Credit In Account</legend>
						<table class="table creditInAccountTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<c:set var="LABELSCOUNT" value="${f:length(DATA['CREDIT_TYPES'])}"/>
							<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
							
							<c:forEach var="CREDIT_TYPES" items="${DATA['CREDIT_TYPES']}" varStatus="loop">
								<c:choose>
										<c:when test="${LABELSITRCOUNT % 2 == 0}">
											<tr>
												<td width="50%">
													<input type="radio" class="form-check-input" 
													id="CREDIT_TYPES"
													name="CREDIT_TYPES" 
													value="${CREDIT_TYPES}"
													<c:if test="${CREDIT_TYPES eq FETCHEDDETAILS['CREDIT_TYPES'] }">checked="checked"</c:if>>
													<label for="CREDIT_TYPES_${loop.index}" >${CREDIT_TYPES}</label>
												</td>
										</c:when>
										<c:otherwise>
												<td>
													<input type="radio" class="form-check-input" 
													id=CREDIT_TYPES 
													name="CREDIT_TYPES" 
													value="${CREDIT_TYPES}"
													<c:if test="${CREDIT_TYPES eq FETCHEDDETAILS['CREDIT_TYPES'] }">checked="checked"</c:if>>
													<label for="CREDIT_TYPES_${loop.index}" >${CREDIT_TYPES}</label>
												</td>
											</tr>
										</c:otherwise>
								</c:choose>
								<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
							</c:forEach>
							<c:if test="${LABELSITRCOUNT % 2 != 0}">
									<td>&nbsp;</td>
								</tr>
							</c:if>
						</table>
			</fieldset>		
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;">Debit In Account</legend>
						<table class="table debitInAccountTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<c:set var="LABELSCOUNT" value="${f:length(DATA['CREDIT_TYPES'])}"/>
							<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
							
							<c:forEach var="DEDIT_TYPES" items="${DATA['DEDIT_TYPES']}" varStatus="loop">
								<c:choose>
										<c:when test="${LABELSITRCOUNT % 2 == 0}">
											<tr>
												<td width="50%">
													<input type="radio" class="form-check-input" 
													id="DEDIT_TYPES" 
													name="DEDIT_TYPES" 
													value="${DEDIT_TYPES}"
													<c:if test="${DEDIT_TYPES eq FETCHEDDETAILS['DEDIT_TYPES'] }">checked="checked"</c:if>>
													<label for="DEDIT_TYPES_${loop.index}" >${DEDIT_TYPES}</label>
												</td>
										</c:when>
										<c:otherwise>
												<td>
													<input type="radio" class="form-check-input" 
													id=DEDIT_TYPES 
													name="DEDIT_TYPES" 
													value="${DEDIT_TYPES}"
													<c:if test="${DEDIT_TYPES eq FETCHEDDETAILS['DEDIT_TYPES'] }">checked="checked"</c:if>>
													<label for="DEDIT_TYPES_${loop.index}" >${DEDIT_TYPES}</label>
												</td>
											</tr>
										</c:otherwise>
								</c:choose>
								<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
							</c:forEach>
							<c:if test="${LABELSITRCOUNT % 2 != 0}">
									<td>&nbsp;</td>
								</tr>
							</c:if>
						</table>
			</fieldset>
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;">Transaction Pattern Indicator</legend>
						<table class="table tnxPatternIndicatorTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<c:set var="LABELSCOUNT" value="${f:length(DATA['TRANSACTIONPATTERNINDICATOR'])}"/>
							<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
							
							<c:forEach var="TRANSACTIONPATTERNINDICATOR" items="${DATA['TRANSACTIONPATTERNINDICATOR']}" varStatus="loop">
								<c:choose>
										<c:when test="${LABELSITRCOUNT % 2 == 0}">
											<tr>
												<td width="50%">
													<input type="radio" class="form-check-input" 
													id="TRANSACTIONPATTERNINDICATOR" 
													name="TRANSACTIONPATTERNINDICATOR" 
													value="${TRANSACTIONPATTERNINDICATOR}"
													<c:if test="${TRANSACTIONPATTERNINDICATOR eq FETCHEDDETAILS['TRANSACTIONPATTERNINDICATOR'] }">checked="checked"</c:if>>
													<label for="TRANSACTIONPATTERNINDICATOR_${loop.index}" >${TRANSACTIONPATTERNINDICATOR}</label>
												</td>
										</c:when>
										<c:otherwise>
												<td>
													<input type="radio" class="form-check-input" 
													id=TRANSACTIONPATTERNINDICATOR 
													name="TRANSACTIONPATTERNINDICATOR" 
													value="${TRANSACTIONPATTERNINDICATOR}"
													<c:if test="${TRANSACTIONPATTERNINDICATOR eq FETCHEDDETAILS['TRANSACTIONPATTERNINDICATOR'] }">checked="checked"</c:if>>
													<label for="TRANSACTIONPATTERNINDICATOR_${loop.index}" >${TRANSACTIONPATTERNINDICATOR}</label>
												</td>
											</tr>
										</c:otherwise>
								</c:choose>
								<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
							</c:forEach>
							<c:if test="${LABELSITRCOUNT % 2 != 0}">
									<td>&nbsp;</td>
								</tr>
							</c:if>
						</table>
			</fieldset>		
			<fieldset class="evidenceData">
					<legend class="evidenceData" ></legend>
						<table class="table custResponseTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<tr>
								<td width="35%" align="center" style="font-weight: bold;">Customer's Response Satisfaction</td>
								<td width="10%" align="center">&nbsp;</td>
								<td width="50%" align="center">
									<select class="form-control input-sm" id="CUSTOMERRESPONSE_SATISFACTION" name="CUSTOMERRESPONSE_SATISFACTION" >
										<option value=""></option>
										<option value="Y" <c:if test="${'Y' eq FETCHEDDETAILS['CUSTOMERRESPONSE_SATISFACTION']}">selected="selected"</c:if>>Yes</option>
										<option value="N"<c:if test="${'N' eq FETCHEDDETAILS['CUSTOMERRESPONSE_SATISFACTION']}">selected="selected"</c:if>>No</option>
									</select>
								</td>
							</tr>
							<tr>
								<td width="35%" align="center" style="font-weight: bold;">Any Other Relationship with Bank</td>
								<td width="10%" align="center">&nbsp;</td>
								<td width="50%" align="center">
									<input type="text" class="form-control input-sm" id="OTHERICICI_RELATIONSHIP" name="OTHERICICI_RELATIONSHIP" value="${FETCHEDDETAILS['OTHERICICI_RELATIONSHIP']}" >
								</td>
							</tr>
						</table>
			</fieldset>
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;">Final Relationship Recommendations</legend>
						<table class="table finalRelationTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<c:set var="LABELSCOUNT" value="${f:length(DATA['FINAL_RELATIONSHIP'])}"/>
							<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
							
							<c:forEach var="FINAL_RELATIONSHIP" items="${DATA['FINAL_RELATIONSHIP']}" varStatus="loop">
								<c:choose>
										<c:when test="${LABELSITRCOUNT % 2 == 0}">
											<tr>
												<td width="50%">
													<input type="radio" class="form-check-input" 
													id="FINAL_RELATIONSHIP" 
													name="FINAL_RELATIONSHIP" 
													value="${FINAL_RELATIONSHIP}"
													<c:if test="${FINAL_RELATIONSHIP eq FETCHEDDETAILS['FINAL_RELATIONSHIP'] }">checked="checked"</c:if>>
													<label for="FINAL_RELATIONSHIP_${loop.index}" >${FINAL_RELATIONSHIP}</label>
												</td>
										</c:when>
										<c:otherwise>
												<td>
													<input type="radio" class="form-check-input" 
													id=FINAL_RELATIONSHIP 
													name="FINAL_RELATIONSHIP" 
													value="${FINAL_RELATIONSHIP}"
													<c:if test="${FINAL_RELATIONSHIP eq FETCHEDDETAILS['FINAL_RELATIONSHIP'] }">checked="checked"</c:if>>
													<label for="FINAL_RELATIONSHIP_${loop.index}" >${FINAL_RELATIONSHIP}</label>
												</td>
											</tr>
										</c:otherwise>
								</c:choose>
								<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
							</c:forEach>
							<c:if test="${LABELSITRCOUNT % 2 != 0}">
									<td>&nbsp;</td>
								</tr>
							</c:if>
						</table>
			</fieldset>
			<fieldset class="evidenceData">
					<legend class="evidenceData" ></legend>
						<table class="table detailedNarrationTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<tr>
								<td width="35%" align="center" style="font-weight: bold;">Detailed Narration</td>
								<td width="10%" align="center">&nbsp;</td>
								<td width="50%" align="center">
									<input type="text" class="form-control input-sm" id="NARRATION" name="NARRATION" value="${FETCHEDDETAILS['NARRATION']}">
								</td>
							</tr>
						</table>
			</fieldset>
			<fieldset class="evidenceData">
					<legend class="evidenceData" style=" color:red; font-size: 13px; font-weight: bold;">Other Relevant Details</legend>
						<table class="table relevantDetailsTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<c:set var="LABELSCOUNT" value="${f:length(DATA['FINAL_RELATIONSHIP'])}"/>
							<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
							
							<c:forEach var="OTHERRELEVANT_DETAILS" items="${DATA['OTHERRELEVANT_DETAILS']}" varStatus="loop">
								<c:choose>
										<c:when test="${LABELSITRCOUNT % 2 == 0}">
											<tr>
												<td width="50%">
													<input type="radio" class="form-check-input" 
													id="OTHERRELEVANT_DETAILS" 
													name="OTHERRELEVANT_DETAILS" 
													value="${OTHERRELEVANT_DETAILS}"
													<c:if test="${OTHERRELEVANT_DETAILS eq FETCHEDDETAILS['OTHERRELEVANT_DETAILS'] }">checked="checked"</c:if>>
													<label for="OTHERRELEVANT_DETAILS_${loop.index}" >${OTHERRELEVANT_DETAILS}</label>
												</td>
										</c:when>
										<c:otherwise>
												<td>
													<input type="radio" class="form-check-input" 
													id=OTHERRELEVANT_DETAILS 
													name="OTHERRELEVANT_DETAILS" 
													value="${OTHERRELEVANT_DETAILS}"
													<c:if test="${OTHERRELEVANT_DETAILS eq FETCHEDDETAILS['OTHERRELEVANT_DETAILS'] }">checked="checked"</c:if>>
													<label for="OTHERRELEVANT_DETAILS_${loop.index}" >${OTHERRELEVANT_DETAILS}</label>
												</td>
											</tr>
										</c:otherwise>
								</c:choose>
								<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
							</c:forEach>
							<c:if test="${LABELSITRCOUNT % 2 != 0}">
									<td>&nbsp;</td>
								</tr>
							</c:if>
						</table>
			</fieldset>
			<input type="hidden" name = "seqNo" value="${seqNo}"> 
			<input type="hidden" name = "caseNoForEDD" value="${caseNoForEDD}">
		</div>
		<div class="card-footer clearfix">
			<div class="pull-${dirR}">
				<c:choose>
					<c:when test="${(seqNo) != '0'}">
						<button type="submit" id="updateEDD${UNQID}" class="btn btn-primary btn-sm">Update</button>
					</c:when>
					<c:otherwise>
						<button type="submit" id="saveEDD${UNQID}" class="btn btn-primary btn-sm">Save</button>
					</c:otherwise>
				</c:choose>
				<button type="reset" id="clearModal${UNQID}" class="btn btn-danger btn-sm">Clear</button>
				<button type="button" id="backToRecords${UNQID}" class="btn btn-primary btn-sm">Back</button>
			</div>
		</div>
	</div>
	</form>
	</div>
</div>
</div>	