<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	$(".datepicker").datepicker({
		changeMonth: true,
		changeYear: true,
		dateFormat: "dd/mm/yy"
	});
	
	$("#saveAFA").click(function(){
		var formObj = $("#afaForm").serialize();
		$.ajax({
			url : "${pageContext.request.contextPath}/cddFormCommon/saveAFA",
			type : "POST",
			cache : false,
			data : formObj,
			success : function(res){
				alert(res);
			},
			error : function(a,b,c){
				alert("Error while saving form"+a+b+c);
			}
		});
	});
});
</script>
<form method="POST" action="javascript:void(0)" id="afaForm">
<input type="hidden" name="COMPASSREFERENCENO" value="${COMPASSREFERENCENO}">
<input type="hidden" name="LINENO" value="${LINENO}">
<input type="hidden" name="KYOGIFOR" value="${KYOGIFOR}">
<input type="hidden" name="CURRENTROLE" value="${CURRENTROLE}">
<input type="hidden" name="STATUS" value="${STATUS}">
<input type="hidden" name="STRKYOGIFOR" value="${STRKYOGIFOR}">
<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
<tr>
	<td colspan="5" style="text-align: center; background : #BBB;">
		<strong>IN-HOUSE APPLICATION FOR OPENING OF ${STRKYOGIFOR}</strong>
	</td>
</tr>
<tr>
	<td width="20%" style="text-align: center;">
		GM
	</td>
	<td width="20%" style="text-align: center;">
		JGM
	</td>
	<td width="20%" style="text-align: center;">
		Compliance
	</td>
	<td width="20%" style="text-align: center;">
		BPD
	</td>
	<td width="20%" style="text-align: center;">
		BPA
	</td>
</tr>
<tr>
	<td style="text-align: center;">
		<c:choose>
			<c:when test="${f:length(AFADATA['GMCHECKED']) > 0}">
				${AFADATA['GMCHECKED']}
			</c:when>
			<c:otherwise>
				<label class="btn btn-outline btn-primary btn-sm radio-inline" for="KYOGIAPPROVAL_GM">
					<input type="radio" id="KYOGIAPPROVAL_GM"  name="KYOGIAPPROVAL" value="GM" 
					<c:if test="${CURRENTROLE ne 'ROLE_GM'}">disabled="disabled"</c:if>/>
					Approve
				</label>
			</c:otherwise>
		</c:choose>
	</td>
	<td style="text-align: center;">
		<c:choose>
			<c:when test="${f:length(AFADATA['JGMCHECKED']) > 0}">
				${AFADATA['JGMCHECKED']}
			</c:when>
			<c:otherwise>
				<label class="btn btn-outline btn-primary btn-sm radio-inline" for="KYOGIAPPROVAL_JGM">
					<input type="radio" id="KYOGIAPPROVAL_JGM"  name="KYOGIAPPROVAL" value="JGM" 
					<c:if test="${CURRENTROLE ne 'ROLE_JGM'}">disabled="disabled"</c:if>/>
					Approve
				</label>
			</c:otherwise>
		</c:choose>
	</td>
	<td style="text-align: center;">
		<c:choose>
			<c:when test="${f:length(AFADATA['COMPCHECKED']) > 0}">
				${AFADATA['COMPCHECKED']}
			</c:when>
			<c:otherwise>
				<label class="btn btn-outline btn-primary btn-sm radio-inline" for="KYOGIAPPROVAL_COMP">
					<input type="radio" id="KYOGIAPPROVAL_COMP"  name="KYOGIAPPROVAL" value="COMP" 
					<c:if test="${CURRENTROLE ne 'ROLE_COMPLIANCECHECKER'}">disabled="disabled"</c:if>/>
					Approve
				</label>
			</c:otherwise>
		</c:choose>
	</td>
	<td style="text-align: center;">
		<c:choose>
			<c:when test="${f:length(AFADATA['BPDCHECKED']) > 0}">
				${AFADATA['BPDCHECKED']}
			</c:when>
			<c:otherwise>
				<label class="btn btn-outline btn-primary btn-sm radio-inline" for="KYOGIAPPROVAL_BPD">
					<input type="radio" id="KYOGIAPPROVAL_BPD"  name="KYOGIAPPROVAL" value="BPD" 
					<c:if test="${CURRENTROLE ne 'ROLE_BPDCHECKER'}">disabled="disabled"</c:if>/>
					Approve
				</label>
			</c:otherwise>
		</c:choose>
	</td>
	<td style="text-align: center;">
		<c:choose>
			<c:when test="${f:length(AFADATA['BPACHECKED']) > 0}">
				${AFADATA['BPACHECKED']}
			</c:when>
			<c:otherwise>
				<label class="btn btn-outline btn-primary btn-sm radio-inline" for="KYOGIAPPROVAL_BPA">
					<input type="radio" id="KYOGIAPPROVAL_BPA"  name="KYOGIAPPROVAL" value="BPA" 
					<c:if test="${CURRENTROLE ne 'ROLE_BPACHECKER'}">disabled="disabled"</c:if>/>
					Approve
				</label>
			</c:otherwise>
		</c:choose>
	</td>
</tr>
</table>
<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
	<tr>
		<td colspan="5" style="text-align: center; background : #BBB;"><strong>PARTICULARS OF CUSTOMER</strong></td>
	</tr>
	<tr>
		<td width="15%">
			Customer Name
		</td>
		<td colspan="4" width="85%">
			<input type="text" class="form-control input-sm" readonly="readonly" name="CUSTOMERNAME" value="${AFADATA['CUSTOMERNAME']}"/>
		</td>
	</tr>
	<tr>
		<td width="15%">
			Correspondence Address
		</td>
		<td colspan="4" width="85%">
			<input type="text" class="form-control input-sm" readonly="readonly" name="CORRESPONDENCEADDRESS" value="${AFADATA['MAILINGADDRESS']}"/>
		</td>
	</tr>
	<tr>
		<td width="15%">
			Registered Address
		</td>
		<td colspan="4" width="85%">
			<input type="text" class="form-control input-sm" readonly="readonly" name="REGISTEREDADDRESS" value="${AFADATA['RESIDENTIALADDRESS']}"/>
		</td>
	</tr>
	<tr>
		<td width="15%">
			Line of Business
		</td>
		<td colspan="4" width="85%">
			<input type="text" class="form-control input-sm" name="LINEOFBUSINESS" value="${AFADATA['LINEOFBUSINESS']}"/>
		</td>
	</tr>
	<tr>
		<td>
			Authorized Share Capital 
		</td>
		<td width="33%">
			<input type="text" class="form-control input-sm" name="AUTHORISEDSHARECAPITAL" value="${AFADATA['AUTHORISEDSHARECAPITAL']}"/>
		</td>
		<td width="4%">
			&nbsp;
		</td>
		<td>
			Number of Staff
		</td>
		<td width="33%">
			<input type="text" class="form-control input-sm" name="NUMBEROFSTAFF" value="${AFADATA['NUMBEROFSTAFF']}"/>
		</td>
	</tr>
	<tr>
		<td>
			Date of Incorporation 
		</td>
		<td width="33%">
			<input type="text" class="form-control input-sm" readonly="readonly" name="DATEOFINCORPORATION" value="${AFADATA['DATEOFINCORPORATION']}"/>
		</td>
		<td width="4%">
			&nbsp;
		</td>
		<td>
			History
		</td>
		<td width="33%">
			<input type="text" class="form-control input-sm" name="HISTORY" value="${AFADATA['HISTORY']}"/>
		</td>
	</tr>
	<tr>
		<td>
			Monthly TurnOver
		</td>
		<td width="33%">
			<input type="text" class="form-control input-sm" name="MONTHLYTURNOVER" value="${AFADATA['MONTHLYTURNOVER']}"/>
		</td>
		<td width="4%">
			&nbsp;
		</td>
		<td rowspan="3" style="vertical-align: middle;">
			Parent Company
		</td>
		<td width="33%" rowspan="3">
			<table class="table">
				<tr>
					<td width="25%">
						Parent
					</td>
					<td width="75%">
						<input type="text" class="form-control input-sm" name="PARENTCOMPANY" value="${AFADATA['PARENTCOMPANY']}"/>
					</td>
				</tr>
				<tr>
					<td>
						Ultimate Parent
					</td>
					<td>
						<input type="text" class="form-control input-sm" name="ULTIMATEPARENTCOMPANY" value="${AFADATA['ULTIMATEPARENTCOMPANY']}"/>
					</td>
				</tr>
				<tr>
					<td>
						Bank
					</td>
					<td>
						<input type="text" class="form-control input-sm" name="BANK" value="${AFADATA['BANK']}"/>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			Their Sales
		</td>
		<td>
			<input type="text" class="form-control input-sm" name="THEIRSALES" value="${AFADATA['THEIRSALES']}"/>
		</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			Their Purchase
		</td>
		<td>
			<input type="text" class="form-control input-sm" name="THEIRPURCHASE" value="${AFADATA['THEIRPURCHASE']}"/>
		</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="5" style="text-align: center; background : #BBB;"><string>BANKERS</string></td>
	</tr>
	<tr>
		<td colspan="5" style="text-align: center;">-</td>
	</tr>
	<tr>
		<td colspan="5" style="text-align: center; background : #BBB;"><string>CHECK OF DOCUMENTS SUBMITTED / TO BE SUBMITTED</string></td>
	</tr>
	<tr>
		<td colspan="5">
			<textarea rows="5" cols="3" class="form-control input-sm" name="DOCUMENTSSUBMITTED">${AFADATA['DOCUMENTSSUBMITTED']}</textarea>
		</td>
	</tr>
	<tr>
		<td rowspan="4">
			Remarks
		</td>
		<td rowspan="4">
			<textarea rows="10" cols="3" class="form-control input-sm" name="REMARKS">${AFADATA['REMARKS']}</textarea>
		</td>
		<td rowspan="4">&nbsp;</td>
		<td>
			Date of Visit to Customer
		</td>
		<td>
			<input type="text" class="form-control input-sm datepicker" name="DATEOFVISITTOCUSTOMER"  value="${AFADATA['DATEOFVISITTOCUSTOMER']}"/>
		</td>
	</tr>
	<tr>
		<td>
			Visited By
		</td>
		<td>
			<input type="text" class="form-control input-sm" name="VISITEDBY"  value="${AFADATA['VISITEDBY']}"/>
		</td>
	</tr>
	<tr>
		<td>
			Customer Identification Confirmed
		</td>
		<td>
			<input type="text" class="form-control input-sm" name="CUSTOMERIDCONFIRMED"  value="${AFADATA['CUSTOMERIDCONFIRMED']}"/>
		</td>
	</tr>
	<tr>
		<td>
			Risk Category
		</td>
		<td>
			<input type="text" class="form-control input-sm" readonly="readonly"  value="${AFADATA['FINALRISKRATING']}"/>
		</td>
	</tr>
	<tr>
		<td rowspan="5" style="vertical-align: middle;">
			PEP Checks & Sanctions Checks
		</td>
		<td>
			Dow Jones Risk & Compliance Check
		</td>
		<td>&nbsp;</td>
		<td>
			<input type="text" class="form-control input-sm datepicker" name="DOWJONESRISKCHECKDATE" value="${AFADATA['DOWJONESRISKCHECKDATE']}">
		</td>
		<td>
			<input type="text" class="form-control input-sm" name="DOWJONESRISKCHECKREMARK" value="${AFADATA['DOWJONESRISKCHECKREMARK']}">
		</td>
	</tr>
	<tr>
		<td>
			Economic Sanctions List HO searched on
		</td>
		<td>&nbsp;</td>
		<td>
			<input type="text" class="form-control input-sm datepicker" name="ESLHOSEARCHONDATE" value="${AFADATA['ESLHOSEARCHONDATE']}">
		</td>
		<td>
			<input type="text" class="form-control input-sm" name="ESLHOSEARCHONREMARK" value="${AFADATA['ESLHOSEARCHONREMARK']}">
		</td>
	</tr>
	<tr>
		<td>
			UN Consolidated Check searched on
		</td>
		<td>&nbsp;</td>
		<td>
			<input type="text" class="form-control input-sm datepicker" name="UNCONCHECKDATE" value="${AFADATA['UNCONCHECKDATE']}">
		</td>
		<td>
			<input type="text" class="form-control input-sm" name="UNCONCHECKREMARK" value="${AFADATA['UNCONCHECKREMARK']}">
		</td>
	</tr>
	<tr>
		<td>
			PAN Verification Check searched on
		</td>
		<td>&nbsp;</td>
		<td>
			<input type="text" class="form-control input-sm datepicker" name="PANVERIFICATIONCHECKDATE" value="${AFADATA['PANVERIFICATIONCHECKDATE']}">
		</td>
		<td>
			<input type="text" class="form-control input-sm" name="PANVERIFICATIONCHECKREMARK" value="${AFADATA['PANVERIFICATIONCHECKREMARK']}">
		</td>
	</tr>
	<tr>
		<td>
			CRILC Database search
		</td>
		<td>&nbsp;</td>
		<td>
			<input type="text" class="form-control input-sm datepicker" name="CRILCCHECKDATE" value="${AFADATA['CRILCCHECKDATE']}">
		</td>
		<td>
			<input type="text" class="form-control input-sm" name="CRILCCHECKREMARK" value="${AFADATA['CRILCCHECKREMARK']}">
		</td>
	</tr>
	<tr>
		<td>
			Management's Comment
		</td>
		<td>
			<textarea rows="2" cols="2" class="form-control" name="MANAGEMENTCOMMENT">${AFADATA['MANAGEMENTCOMMENT']}</textarea>
		</td>
		<td>&nbsp;</td>
		<td>
			Date of Opening
		</td>
		<td>
			<input type="text" class="form-control input-sm datepicker" name="DATEOFOPENING" value="${AFADATA['DATEOFOPENING']}">
		</td>
	</tr>
	<tr>
		<td style="text-align: center;" colspan="5">
			<button type="button" class="btn btn-success btn-sm" id="saveAFA">Save</button>
		</td>
	</tr>
</table>
</form>