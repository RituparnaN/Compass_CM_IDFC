<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.quantumdataengines.app.compass.util.fatca.validfile.*, 
    com.quantumdataengines.app.compass.util.fatca.errorfile.*, java.text.*, com.quantumdataengines.app.compass.util.fatca.validfile.FieldErrorGrpType"%>
<%! 
public String changeDateFormat(String dateString, String format){
	String returnDateString = "";
	try{
		SimpleDateFormat sdf1 = new SimpleDateFormat(format);
		SimpleDateFormat sdf2 = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss a");
		java.util.Date date = sdf1.parse(dateString);
		returnDateString = sdf2.format(date);
	}catch(Exception e){}
	return returnDateString;
}

public String toDate(javax.xml.datatype.XMLGregorianCalendar calendar){
	java.util.Date date = calendar.toGregorianCalendar().getTime();
	SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
    return sdf.format(date);
}
%>

<%
FATCAValidFileNotificationType fatcaValidFileNotificationType = (FATCAValidFileNotificationType) request.getAttribute("PAYLOAD_VALID");
FATCAFileErrorNotificationType fatcaFileErrorNotificationType = (FATCAFileErrorNotificationType) request.getAttribute("PAYLOAD_ERROR");
boolean readSuccessful = (Boolean) request.getAttribute("READ_SUCCESS");
%>

<div style="overflow: auto;">
<%if(readSuccessful){%>
<table class='table table-bordered table-striped'>
	<%if(fatcaValidFileNotificationType != null){%>
	<%
	com.quantumdataengines.app.compass.util.fatca.validfile.FATCANotificationHeaderGrpType fatcaNotificationHeaderGrp = fatcaValidFileNotificationType.getFATCANotificationHeaderGrp();
	com.quantumdataengines.app.compass.util.fatca.validfile.OriginalFileMetadataGrpType originalFileMetadataGrpType = fatcaValidFileNotificationType.getOriginalFileMetadataGrp();
	com.quantumdataengines.app.compass.util.fatca.validfile.OriginalFileMessageSpecGrpType originalFileMessageSpecGrpType = fatcaValidFileNotificationType.getOriginalFileMessageSpecGrp();
	String notificationContentTxt = fatcaValidFileNotificationType.getNotificationContentTxt();
	com.quantumdataengines.app.compass.util.fatca.validfile.OriginalFileProcessingDataGrpType originalFileProcessingDataGrpType = fatcaValidFileNotificationType.getOriginalFileProcessingDataGrp();
	String hctaTreatyStampTxt = fatcaValidFileNotificationType.getHCTATreatyStampTxt();
	com.quantumdataengines.app.compass.util.fatca.validfile.FATCARecordErrorGrpType fatcaRecordErrorGrpType = fatcaValidFileNotificationType.getFATCARecordErrorGrp();
	String version = fatcaValidFileNotificationType.getVersion();
	%>
	<tr>
		<td colspan="2" style="font-size: 14px;<% if(fatcaRecordErrorGrpType != null && fatcaRecordErrorGrpType.getFATCARecordErrorFIGrp().size() > 0){ %> color:red; <%}else{%> color:green;<%} %>">
			The transmission for which we have got this Notification was accepted by IRS.
			<%
			if(fatcaRecordErrorGrpType != null && fatcaRecordErrorGrpType.getFATCARecordErrorFIGrp().size() > 0){
			%>
			<br/>But there are <%=fatcaRecordErrorGrpType.getFATCARecordErrorFIGrp().size()%> error(s) mentioned by IRS. Please check Record Error Group section for error details.
			<%}else{ %>
			<br/>And there are no error mentioned in this Notification.
			<%} %>
		</td>
	</tr>
	<% if(version != null){ %>
	<tr>
		<th width="15%">
			Version
		</th>
		<td width="85%">
			<%=version%>
		</td>
	</tr>
	<%} %>
	<% if(fatcaNotificationHeaderGrp != null){ %>
	<tr>
		<th width="15%">
			FATCA Notification Header Group
		</th>
		<td width="85%">
			<table class='table table-bordered'>
				<tr>
					<td width="30%">Notification Create On</td>
					<td width="70%"><strong><%=changeDateFormat(fatcaNotificationHeaderGrp.getFATCANotificationCreateTs(), "yyyy-MM-dd'T'hh:mm:ss'Z'")%></strong></td>
				</tr>
				<tr>
					<td>Notification Reference ID</td>
					<td><strong><%=fatcaNotificationHeaderGrp.getFATCANotificationRefId()%></strong></td>
				</tr>
				<tr>
					<td>Notification Code</td>
					<td><strong><%=fatcaNotificationHeaderGrp.getFATCANotificationCd()%></strong></td>
				</tr>
				<tr>
					<td>Notification Sender ID</td>
					<td><strong><%=fatcaNotificationHeaderGrp.getFATCAEntitySenderId()%></strong></td>
				</tr>
				<tr>
					<td>Notification Receiver ID</td>
					<td><strong><%=fatcaNotificationHeaderGrp.getFATCAEntityReceiverId()%></strong></td>
				</tr>
				<tr>
					<td>Contact Information</td>
					<td><strong><%=fatcaNotificationHeaderGrp.getContactInformationTxt()%></strong></td>
				</tr>
			</table>
		</td>
	</tr>
	<%} %>
	<% if(notificationContentTxt != null){ %>
	<tr>
		<th width="15%">
			Notification
		</th>
		<td width="85%" style="<%if(fatcaRecordErrorGrpType != null && fatcaRecordErrorGrpType.getFATCARecordErrorFIGrp().size() > 0){%> color:red; <%}else{%> color:green;<%} %>">			
			<%=notificationContentTxt%>
		</td>
	</tr>
	<%} %>
	<% if(hctaTreatyStampTxt != null){ %>
	<tr>
		<th width="15%">
			HCTA Treaty Stamp Text
		</th>
		<td width="85%">			
			<%=hctaTreatyStampTxt%>
		</td>
	</tr>
	<%} %>
	<% if(fatcaRecordErrorGrpType != null){
		java.util.List<FATCARecordErrorFIGrpType> errorFIGrpTypeList = fatcaRecordErrorGrpType.getFATCARecordErrorFIGrp();
	%>
	<tr>
		<th width="15%">
			Record Error Group
		</th>
		<td width="85%">
			<table class='table table-bordered'>
				<tr>
					<td width="20%">Record Error(s)</td>
					<td width="80%">
						<% 
						for(int i = 0; i < errorFIGrpTypeList.size(); i++){ 
							FATCARecordErrorFIGrpType errorFIGrpType = errorFIGrpTypeList.get(i);
						%>
							<table class='table table-bordered'>
								<tr>
									<td width="25%">
										Reporting FI
									</td>
									<td width="75%">
										<%=errorFIGrpType.getReportingFINm()%> (<%=errorFIGrpType.getReportingFIGIIN()%>)
									</td>
								</tr>
								<%
								if(errorFIGrpType.getSponsorNm() != null){
								%>
								<tr>
									<td>
										Sponsor
									</td>
									<td>
										<%=errorFIGrpType.getSponsorNm()%> (<%=errorFIGrpType.getSponsorGIIN()%>)
									</td>
								</tr>
								<%} %>								
								<%
								java.util.List<FATCARecordErrorDetailGrpType> errorDetailGrpsList = errorFIGrpType.getFATCARecordErrorDetailGrp();
								for(int j = 0; j < errorDetailGrpsList.size(); j++){
									FATCARecordErrorDetailGrpType detailGrpType = errorDetailGrpsList.get(j);
									
									%>
									<tr>
										<td>Document Reference ID</td>
										<td><%=detailGrpType.getDocRefId()%></td>
									</tr>
									<tr>
										<td>Document Type Code</td>
										<td><%=detailGrpType.getDocTypeIndicCd().value()%></td>
									</tr>
									<% if(detailGrpType.getCorrDocRefId() != null){ %>
									<tr>
										<td>Correct Document Reference ID</td>
										<td><%=detailGrpType.getCorrDocRefId()%></td>
									</tr>
									<%} %>
									<% if(detailGrpType.getCorrMessageRefId() != null){ %>
									<tr>
										<td>Correct Message Reference ID</td>
										<td><%=detailGrpType.getCorrMessageRefId()%></td>
									</tr>
									<%} %>
									<tr>
										<td>Record Level Error Code</td>
										<td><%=detailGrpType.getRecordLevelErrorCd()%></td>
									</tr>
									<tr>
										<td>FATCA Report Type Code</td>
										<td><%=detailGrpType.getFATCAReportTypeCd().value()%></td>
									</tr>
									<%
										java.util.List<FieldErrorGrpType> errorGrpType = detailGrpType.getFieldErrorGrp();
										for(int k = 0; k < errorGrpType.size(); k++){
											FieldErrorGrpType fieldErrorGrpType = errorGrpType.get(k);
									%>
										<tr style="color: red;">
											<td><%=fieldErrorGrpType.getFieldNm()%></td>
											<td>
												<% if(fieldErrorGrpType.getFieldErrorTxt() != null){%>
													Field Error : <%=fieldErrorGrpType.getFieldErrorTxt()%><br/>
												<%} %>
												
												<% if(fieldErrorGrpType.getFieldErrorCd() != null){ %>
													Field Error Code : <%=fieldErrorGrpType.getFieldErrorCd()%><br/>
												<%} %>
												
												<% if(fieldErrorGrpType.getFieldLineNum() != null){ %>
													Field Line Number : <%=fieldErrorGrpType.getFieldLineNum()%><br/>
												<%} %>
												
												<% if(fieldErrorGrpType.getFieldPartNum() != null){ %>
													Field Part Number : <%=fieldErrorGrpType.getFieldPartNum()%><br/>
												<%} %>
											</td>
										</tr>
									<%} %>
									<tr style="color: green;">
										<td>Action Requested</td>
										<td><%=detailGrpType.getActionRequestedGrp().getActionRequestedTxt()%></td>
									</tr>
									<tr style="color: blue;">
										<td>Due Date</td>
										<td><%=detailGrpType.getActionRequestedGrp().getActionRequestedDueDateTxt()%></td>
									</tr>
									<%
								}
								%>
							</table>
						<%} %>
					</td>
				</tr>
				<tr>
					<td>Potential Effect</td>
					<td><strong><%=fatcaRecordErrorGrpType.getPotentialEffectTxt() != null ? fatcaRecordErrorGrpType.getPotentialEffectTxt() : ""%></strong></td>
				</tr>
				<tr>
					<td>Record Error Info Header</td>
					<td><strong><%=fatcaRecordErrorGrpType.getRecordErrorInfoHeaderTxt() != null ? fatcaRecordErrorGrpType.getRecordErrorInfoHeaderTxt() : ""%></strong></td>
				</tr>
			</table>
		</td>
	</tr>
	<%} %>
	<% if(originalFileProcessingDataGrpType != null){ %>
	<tr>
		<th width="15%">
			Original File Processing Data Group
		</th>
		<td width="85%">
			<table class="table table-bordered">
				<tr>
					<td width="45%">File Type Code</td>
					<td width="55%"><%=originalFileProcessingDataGrpType.getFileTypeCd() != null ? originalFileProcessingDataGrpType.getFileTypeCd() : ""%></td>
				</tr>
				<tr>
					<td>Financial Institution Count</td>
					<td><%=originalFileProcessingDataGrpType.getFinancialInstitutionCnt() != null ? originalFileProcessingDataGrpType.getFinancialInstitutionCnt() : ""%></td>
				</tr>
				<tr>
					<td>Record Count</td>
					<td><%=originalFileProcessingDataGrpType.getRecordCnt() != null ? originalFileProcessingDataGrpType.getRecordCnt() : ""%></td>
				</tr>
				<tr>
					<td>Account Report Record Count</td>
					<td><%=originalFileProcessingDataGrpType.getNonDupAccountReportRecordCnt() != null ? originalFileProcessingDataGrpType.getNonDupAccountReportRecordCnt() : ""%></td>
				</tr>
				<tr>
					<td>Duplicate Account Report Record Count</td>
					<td><%=originalFileProcessingDataGrpType.getDupAccountReportRecordCnt() != null ? originalFileProcessingDataGrpType.getDupAccountReportRecordCnt() : ""%></td>
				</tr>
				<tr>
					<td>Pool Report Record Count</td>
					<td><%=originalFileProcessingDataGrpType.getPooledReportRecordCnt() != null ? originalFileProcessingDataGrpType.getPooledReportRecordCnt() : ""%></td>
				</tr>
			</table>
		</td>
	</tr>
	<%} %>
	<% if(originalFileMetadataGrpType != null){ %>
	<tr>
		<th width="15%">
			Original File Metadata Group
		</th>
		<td width="85%">
			<table class='table table-bordered'>
				<tr>
					<td width="30%">IDES Transmission ID</td>
					<td width="70%"><strong><%=originalFileMetadataGrpType.getIDESTransmissionId() != null ? originalFileMetadataGrpType.getIDESTransmissionId() : ""%></strong></td>
				</tr>
				<tr>
					<td>IDES Sending Time</td>
					<td><strong><%=originalFileMetadataGrpType.getIDESSendingTs() != null ? changeDateFormat(originalFileMetadataGrpType.getIDESSendingTs(), "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'") : ""%></strong></td>
				</tr>
				<tr>
					<td>Sender File ID</td>
					<td><strong><%=originalFileMetadataGrpType.getSenderFileId() != null ? originalFileMetadataGrpType.getSenderFileId() : ""%></strong></td>
				</tr>
				<% if(originalFileMetadataGrpType.getUncompressedFileSizeKBQty() != null){ %>
				<tr>
					<td>Uncompressed File Size</td>
					<td><strong><%=originalFileMetadataGrpType.getUncompressedFileSizeKBQty() != null ? originalFileMetadataGrpType.getUncompressedFileSizeKBQty()+" KB" : ""%> </strong></td>
				</tr>
				<%} %>
			</table>
		</td>
	</tr>
	<%} %>
	<% if(originalFileMessageSpecGrpType != null){ %>
	<tr>
		<th width="15%">
			Original File Message Specification Group
		</th>
		<td width="85%">
			<table class='table table-bordered'>
				<tr>
					<td width="30%">Message Reference ID</td>
					<td width="70%"><strong><%=originalFileMessageSpecGrpType.getMessageRefId() != null ? originalFileMessageSpecGrpType.getMessageRefId() : ""%></strong></td>
				</tr>
				<% if(originalFileMessageSpecGrpType.getCorrMessageRefId() != null){ %>
				<tr>
					<td>Correct Message Reference ID</td>
					<td><strong><%=originalFileMessageSpecGrpType.getCorrMessageRefId()%></strong></td>
				</tr>
				<%} %>
				<tr>
					<td>Message Type Code</td>
					<td><strong><%=originalFileMessageSpecGrpType.getMessageTypeCd() != null ? originalFileMessageSpecGrpType.getMessageTypeCd().value() : ""%></strong></td>
				</tr>
				<tr>
					<td>Sender GIIN</td>
					<td><strong><%=originalFileMessageSpecGrpType.getSendingCompanyGIIN() != null ? originalFileMessageSpecGrpType.getSendingCompanyGIIN() : ""%></strong></td>
				</tr>
				<tr>
					<td>Sender Country Code</td>
					<td><strong><%=originalFileMessageSpecGrpType.getTransmittingCountryCd() != null ? originalFileMessageSpecGrpType.getTransmittingCountryCd().value() : ""%> </strong></td>
				</tr>
				<tr>
					<td>Transmitting Country Code</td>
					<td><strong><%=originalFileMessageSpecGrpType.getReceivingCountryCd() != null ? originalFileMessageSpecGrpType.getReceivingCountryCd().value() : ""%> </strong></td>
				</tr>
				<tr>
					<td>Reporting Period</td>
					<td><strong><%=originalFileMessageSpecGrpType.getReportingPeriodDt() != null ? toDate(originalFileMessageSpecGrpType.getReportingPeriodDt()) : ""%></strong></td>
				</tr>
			</table>
		</td>
	</tr>
	<%} %>
	
	<%}else if(fatcaFileErrorNotificationType!= null){ %>
	<%
	com.quantumdataengines.app.compass.util.fatca.errorfile.FATCANotificationHeaderGrpType fatcaNotificationHeaderGrp = fatcaFileErrorNotificationType.getFATCANotificationHeaderGrp();
	com.quantumdataengines.app.compass.util.fatca.errorfile.OriginalFileMetadataGrpType originalFileMetadataGrpType = fatcaFileErrorNotificationType.getOriginalFileMetadataGrp();
	com.quantumdataengines.app.compass.util.fatca.errorfile.ActionRequestedGrpType actionRequestedGrpType = fatcaFileErrorNotificationType.getActionRequestedGrp();
	String notificationContentTxt = fatcaFileErrorNotificationType.getNotificationContentTxt();
	String hctaTreatyStampTxt = fatcaFileErrorNotificationType.getHCTATreatyStampTxt();
	String version = fatcaFileErrorNotificationType.getVersion();
	%>
	<tr>
		<td colspan="2" style="font-size: 14px; color:red;">
			The transmission for which we have got this Notification was not accepted by IRS.
		</td>
	</tr>
	<% if(version != null){ %>
	<tr>
		<th width="20%">
			Version
		</th>
		<td width="80%">
			<%=version%>
		</td>
	</tr>
	<% } %>
	<% if(fatcaNotificationHeaderGrp != null){ %>
	<tr>
		<th width="20%">
			FATCA Notification Header Group
		</th>
		<td width="80%">
			<table class='table table-bordered'>
				<tr>
					<td width="30%">Notification Create On</td>
					<td width="70%"><strong><%=changeDateFormat(fatcaNotificationHeaderGrp.getFATCANotificationCreateTs(), "yyyy-MM-dd'T'hh:mm:ss'Z'")%></strong></td>
				</tr>
				<tr>
					<td>Notification Reference ID</td>
					<td><strong><%=fatcaNotificationHeaderGrp.getFATCANotificationRefId()%></strong></td>
				</tr>
				<tr>
					<td>Notification Code</td>
					<td><strong><%=fatcaNotificationHeaderGrp.getFATCANotificationCd()%></strong></td>
				</tr>
				<tr>
					<td>Notification Sender ID</td>
					<td><strong><%=fatcaNotificationHeaderGrp.getFATCAEntitySenderId()%></strong></td>
				</tr>
				<tr>
					<td>Notification Receiver ID</td>
					<td><strong><%=fatcaNotificationHeaderGrp.getFATCAEntityReceiverId()%></strong></td>
				</tr>
				<tr>
					<td>Contact Information</td>
					<td><strong><%=fatcaNotificationHeaderGrp.getContactInformationTxt()%></strong></td>
				</tr>
			</table>
		</td>
	</tr>
	<%} %>
	<% if(notificationContentTxt != null){ %>
	<tr>
		<th>
			Notification
		</th>
		<td style="color:red;">			
			<%=notificationContentTxt%>
		</td>
	</tr>
	<%} %>
	<% if(hctaTreatyStampTxt != null){ %>
	<tr>
		<th width="15%">
			HCTA Treaty Stamp Text
		</th>
		<td width="85%">			
			<%=hctaTreatyStampTxt%>
		</td>
	</tr>
	<%} %>
	<% if(actionRequestedGrpType != null){ %>
	<tr>
		<td>Action Requested</td>
		<td style="color: green;"><%=actionRequestedGrpType.getActionRequestedTxt()%></td>
	</tr>
	<tr>
		<td>Due Date</td>
		<td style="color: blue;"><%=actionRequestedGrpType.getActionRequestedDueDateTxt()%></td>
	</tr>
	<%} %>
	<% if(originalFileMetadataGrpType != null){ %>
	<tr>
		<th width="15%">
			Original File Metadata Group
		</th>
		<td width="85%">
			<table class='table table-bordered'>
				<tr>
					<td width="30%">IDES Transmission ID</td>
					<td width="70%"><strong><%=originalFileMetadataGrpType.getIDESTransmissionId() != null ? originalFileMetadataGrpType.getIDESTransmissionId() : ""%></strong></td>
				</tr>
				<tr>
					<td>IDES Sending Time</td>
					<td><strong><%=originalFileMetadataGrpType.getIDESSendingTs() != null ? changeDateFormat(originalFileMetadataGrpType.getIDESSendingTs(), "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'") : ""%></strong></td>
				</tr>
				<tr>
					<td>Sender File ID</td>
					<td><strong><%=originalFileMetadataGrpType.getSenderFileId() != null ? originalFileMetadataGrpType.getSenderFileId() : ""%></strong></td>
				</tr>
				<% if(originalFileMetadataGrpType.getUncompressedFileSizeKBQty() != null){ %>
				<tr>
					<td>Uncompressed File Size</td>
					<td><strong><%=originalFileMetadataGrpType.getUncompressedFileSizeKBQty() != null ? originalFileMetadataGrpType.getUncompressedFileSizeKBQty()+" KB" : ""%> </strong></td>
				</tr>
				<%} %>
			</table>
		</td>
	</tr>
	<%} %>
	<% } %>
</table>
<%}else{ %>
	Couldn't read IRS Notification File
<%} %>
</div>