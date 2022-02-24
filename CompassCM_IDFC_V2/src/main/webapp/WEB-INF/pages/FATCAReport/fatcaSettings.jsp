<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.util.*"%>
<%
String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
Map<String, String> formData = request.getAttribute("FATCASETTINGS") != null ? (Map<String, String>) request.getAttribute("FATCASETTINGS") : new HashMap<String, String>();
String message = request.getAttribute("MESSAGE") != null ? (String) request.getAttribute("MESSAGE") : "";
%>
<script type="text/javascript">
	$(document).ready(function(){
		var message = '<%=message%>';
		if(message != '')
			alert(message);
		
		$("#updateFATCASettings").submit(function(e){
			var formObj = $("#updateFATCASettings");
			var formData = $(formObj).serialize();
			$.ajax({
				url: "${pageContext.request.contextPath}/common/updateFATCASettings",
				cache: false,
				type: "POST",
				data : formData,
				success: function(res) {
					alert(res);
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
			e.preventDefault();
		});
	});
</script>
<div class="row">
	<div class="col-xs-12">
	<form action="javascript:void(0)" method="POST" id="updateFATCASettings">
		<table class="table table-bordered table-stripped">
			<tr>
				<td colspan="2">
					Sender Private Key Path
					<br/>
					<input type="text" class="input-sm form-control" id="SENDER_PRIVATEKEY_PATH" name="SENDER_PRIVATEKEY_PATH" 
					value="<%= formData.get("SENDER_PRIVATEKEY_PATH") != null ? formData.get("SENDER_PRIVATEKEY_PATH") : "" %>"/>
				</td>
			</tr>
			<tr>
				<td width="50%">
					Sender Private Key Type
					<br/>
					<input type="text" class="input-sm form-control" id="SENDER_PRIVATEKEY_TYPE" name="SENDER_PRIVATEKEY_TYPE" 
					value="<%= formData.get("SENDER_PRIVATEKEY_TYPE") != null ? formData.get("SENDER_PRIVATEKEY_TYPE") : "" %>"/>
				</td>
				<td width="50%">
					Sender Private Key Alias
					<br/>
					<input type="text" class="input-sm form-control" id="SENDER_PRIVATEKEY_ALIAS" name="SENDER_PRIVATEKEY_ALIAS" 
					value="<%= formData.get("SENDER_PRIVATEKEY_ALIAS") != null ? formData.get("SENDER_PRIVATEKEY_ALIAS") : "" %>"/>
				</td>
			</tr>
			<tr>
				<td>
					Sender Private Keystore Password
					<br/>
					<input type="text" class="input-sm form-control" id="SENDER_PRIVATEKEY_STOREPASS" name="SENDER_PRIVATEKEY_STOREPASS" 
					value="<%= formData.get("SENDER_PRIVATEKEY_STOREPASS") != null ? formData.get("SENDER_PRIVATEKEY_STOREPASS") : "" %>"/>
				</td>
				<td>
					Sender Private Key Password
					<br/>
					<input type="text" class="input-sm form-control" id="SENDER_PRIVATEKEY_PASS" name="SENDER_PRIVATEKEY_PASS" 
					value="<%= formData.get("SENDER_PRIVATEKEY_PASS") != null ? formData.get("SENDER_PRIVATEKEY_PASS") : "" %>"/>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					Sender Certificate / Public Key Path
					<br/>
					<input type="text" class="input-sm form-control" id="SENDER_PUBLICKEY_PATH" name="SENDER_PUBLICKEY_PATH" 
					value="<%= formData.get("SENDER_PUBLICKEY_PATH") != null ? formData.get("SENDER_PUBLICKEY_PATH") : "" %>"/>
				</td>
			</tr>
			<tr>
				<td>
					Sender Certificate / Public Key Type
					<br/>
					<input type="text" class="input-sm form-control" id="SENDER_PUBLICKEY_TYPE" name="SENDER_PUBLICKEY_TYPE" 
					value="<%= formData.get("SENDER_PUBLICKEY_TYPE") != null ? formData.get("SENDER_PUBLICKEY_TYPE") : "" %>"/>
				</td>
				<td>
					Sender Certificate / Public Key Alias
					<br/>
					<input type="text" class="input-sm form-control" id="SENDER_PUBLICKEY_ALIAS" name="SENDER_PUBLICKEY_ALIAS" 
					value="<%= formData.get("SENDER_PUBLICKEY_ALIAS") != null ? formData.get("SENDER_PUBLICKEY_ALIAS") : "" %>"/>
				</td>
			</tr>
			<tr>
				<td>
					Sender Certificate / Public Key Password
					<br/>
					<input type="text" class="input-sm form-control" id="SENDER_PUBLICKEY_PASS" name="SENDER_PUBLICKEY_PASS" 
					value="<%= formData.get("SENDER_PUBLICKEY_PASS") != null ? formData.get("SENDER_PUBLICKEY_PASS") : "" %>"/>
				</td>
				<td>
					Sender GIIN
					<br/>
					<input type="text" class="input-sm form-control" id="SENDER_GIIN" name="SENDER_GIIN" 
					value="<%= formData.get("SENDER_GIIN") != null ? formData.get("SENDER_GIIN") : "" %>"/>
				</td>
			</tr>
			<tr>
				<td>
					Sending Model
					<br/>
					<input type="text" class="input-sm form-control" id="SENDING_MODEL" name="SENDING_MODEL" 
					value="<%= formData.get("SENDING_MODEL") != null ? formData.get("SENDING_MODEL") : "" %>"/>
				</td>
				<td>
					Sender Email ID
					<br/>
					<input type="text" class="input-sm form-control" id="SENDERE_EMAIL" name="SENDERE_EMAIL" 
					value="<%= formData.get("SENDERE_EMAIL") != null ? formData.get("SENDERE_EMAIL") : "" %>"/>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					IRS Certificate / Public Key Path
					<br/>
					<input type="text" class="input-sm form-control" id="IRS_PUBLICKEY_PATH" name="IRS_PUBLICKEY_PATH" 
					value="<%= formData.get("IRS_PUBLICKEY_PATH") != null ? formData.get("IRS_PUBLICKEY_PATH") : "" %>"/>
				</td>
			</tr>
			<tr>
				<td>
					IRS Certificate / Public Key Type
					<br/>
					<input type="text" class="input-sm form-control" id="IRS_PUBLICKEY_TYPE" name="IRS_PUBLICKEY_TYPE" 
					value="<%= formData.get("IRS_PUBLICKEY_TYPE") != null ? formData.get("IRS_PUBLICKEY_TYPE") : "" %>"/>
				</td>
				<td>
					IRS Certificate / Public Key Alias
					<br/>
					<input type="text" class="input-sm form-control" id="IRS_PUBLICKEY_ALIAS" name="IRS_PUBLICKEY_ALIAS" 
					value="<%= formData.get("IRS_PUBLICKEY_ALIAS") != null ? formData.get("IRS_PUBLICKEY_ALIAS") : "" %>"/>
				</td>
			</tr>
			<tr>
				<td>
					IRS Certificate / Public Key Password
					<br/>
					<input type="text" class="input-sm form-control" id="IRS_PUBLICKEY_PASS" name="IRS_PUBLICKEY_PASS" 
					value="<%= formData.get("IRS_PUBLICKEY_PASS") != null ? formData.get("IRS_PUBLICKEY_PASS") : "" %>"/>
				</td>
				<td>
					IRS GIIN
					<br/>
					<input type="text" class="input-sm form-control" id="IRS_GIIN" name="IRS_GIIN" 
					value="<%= formData.get("IRS_GIIN") != null ? formData.get("IRS_GIIN") : "" %>"/>
				</td>
			</tr>
			<tr>
				<td>
					Approver Certificate / Public Key Path
					<br/>
					<input type="text" class="input-sm form-control" id="APPROVER_PUBLICKEY_PATH" name="APPROVER_PUBLICKEY_PATH" 
					value="<%= formData.get("APPROVER_PUBLICKEY_PATH") != null ? formData.get("APPROVER_PUBLICKEY_PATH") : "" %>"/>
				</td>
			</tr>
			<tr>
				<td>
					Approver Certificate / Public Key Type
					<br/>
					<input type="text" class="input-sm form-control" id="APPROVER_PUBLICKEY_TYPE" name="APPROVER_PUBLICKEY_TYPE" 
					value="<%= formData.get("APPROVER_PUBLICKEY_TYPE") != null ? formData.get("APPROVER_PUBLICKEY_TYPE") : "" %>"/>
				</td>
				<td>
					Approver Certificate / Public Key Alias
					<br/>
					<input type="text" class="input-sm form-control" id="APPROVER_PUBLICKEY_ALIAS" name="APPROVER_PUBLICKEY_ALIAS" 
					value="<%= formData.get("APPROVER_PUBLICKEY_ALIAS") != null ? formData.get("APPROVER_PUBLICKEY_ALIAS") : "" %>"/>
				</td>
			</tr>
			<tr>
				<td>
					Approver Certificate / Public Key Password
					<br/>
					<input type="text" class="input-sm form-control" id="APPROVER_PUBLICKEY_PASS" name="APPROVER_PUBLICKEY_PASS" 
					value="<%= formData.get("APPROVER_PUBLICKEY_PASS") != null ? formData.get("APPROVER_PUBLICKEY_PASS") : "" %>"/>
				</td>
				<td>
					Approver GIIN
					<br/>
					<input type="text" class="input-sm form-control" id="APPROVER_GIIN" name="APPROVER_GIIN" 
					value="<%= formData.get("APPROVER_GIIN") != null ? formData.get("APPROVER_GIIN") : "" %>"/>
				</td>
			</tr>
		</table>
		<div class="modal-footer">
	      	<button type="submit" class="btn btn-sm btn-success">Save</button>
	      	<button type="button" class="btn btn-sm btn-danger" data-dismiss="modal">Close</button>
      </div>
	</form>
	</div>
	</div>