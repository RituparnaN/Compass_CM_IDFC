<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		let sourceCustomerID = "${SOURCECUSTOMERID}";
		let destinationCustomerId = "${DESTINATIONCUSTOMERID}";
		$('#select_all_source'+id).on("click", function (e) {
			let status = this.checked;
			$(".sourceAccountNos"+id).each(function(){ 
				this.checked = status;
			});
		});
		
		$('#select_all_destination'+id).on("click", function (e) {
			let status = this.checked;
			$(".destinationAccountNos"+id).each(function(){ 
				this.checked = status;
			});
		});
		
		$("#addEntityRelation"+id).on("click",function(e){
			let sourceAccountNOs = [];
			let destinationAccountNOs = [];
			let entityRelationData = {};
			let entityRelation = $("#entityRelation"+id).val();
			let remark = $("#remark"+id).val();
			$(".sourceAccountNos"+id).each(function(){ 
				if(this.checked == true){
					sourceAccountNOs.push($(this).val())
				}
			});
			
			$(".destinationAccountNos"+id).each(function(){ 
				if(this.checked == true){
					destinationAccountNOs.push($(this).val())
				}
			});
			
			if(sourceAccountNOs.length == 0 || destinationAccountNOs.length == 0  ){
				alert("Please select atleast one account from source and destination");
				return false;
			}
			
			if(entityRelation && entityRelation == ""){
				alert("Please select entity relation");
				return false;
			}
			
			if(remark && remark == ""){
				alert("Please enter remark");
				return false;
			}
			
			
			entityRelationData['SOURCECUSTOMERID'] = sourceCustomerID;
			entityRelationData['SOURCEACCOUNTNO'] = sourceAccountNOs.join();
			entityRelationData['DESTINATIONCUSTOMERID'] = destinationCustomerId;
			entityRelationData['DESTINATIONACCOUNTNO'] = destinationAccountNOs.join();
			entityRelationData['RELATIONSHIPCODE'] = entityRelation;
			entityRelationData["REMARKS"] = remark;
			
			$.ajax({
				url: "${pageContext.request.contextPath}/common/saveEntityLinkage",
				type:"POST",
				data:entityRelationData,
				success: function(result){
			    	alert(result);
			 	}
			});
			
			
		});
		
		
	});
</script>

<div class="card-body">
<div class="col-sm-12">
	<div class="col-sm-4">
	<table class="table table-bordered">
		<thead>
			<tr>
				<th><input type="checkbox" id="select_all_source${UNQID}" /></th>
				<th>Account List for:-  ${SOURCECUSTOMERID}</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items = "${SOURCEACCOUNTLIST}" var = "accountNo">
			<tr>
				<td><input class="sourceAccountNos${UNQID}" type="checkbox" value="${accountNo}" /></td>
				<td> ${accountNo}</td>
			</tr>
		
		</c:forEach> 
		</tbody>
	</table>
	</div>
	<div class="col-sm-4">
	
	<div class="form-group">
	  <label for="entityRelation${UNQID}">Select Relation:</label>
	  <select class="form-control" id="entityRelation${UNQID}">
	    <c:forEach items="${RELATIONTYPE}" var = "relation">
	    	<option value = "${relation.key}">${relation.value}</option>
	    </c:forEach>
	  </select>
	</div>
	<div class="form-group">
		  <label for="remark${UNQID}">Remarks:</label>
		  <textarea class="form-control" rows="5" id="remark${UNQID}"></textarea>
	</div>
	
	</div>
	<div class="col-sm-4">
	<table class="table table-bordered">
		<thead>
			<tr>
				<th><input type="checkbox" id="select_all_destination${UNQID}" /></th>
				<th>Account List for:-  ${DESTINATIONCUSTOMERID}</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items = "${DESTINATIONACCOUNTLIST}" var = "accountNo">
			<tr>
				<td><input class="destinationAccountNos${UNQID}" type="checkbox" value="${accountNo}" /></td>
				<td> ${accountNo}</td>
			</tr>
		
		</c:forEach> 
		</tbody>
	</table>
	</div>
</div>
<div class="pull-${dirR}">
	<button type="button" id="addEntityRelation${UNQID}" class="btn btn-success btn-sm">Add Entity Relation</button>
</div>
</div>