<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>

<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/bootstrap-datetimepicker.min.css" />

<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/moment.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/bootstrap-datetimepicker.min.js"></script>

<style>
	td {
		max-width: 550px;
		word-break: break-word;
	}
	
	textarea{
		min-height: 50px;
		overflow: auto;
		resize: vertical;
	}
	
</style>
<script type="text/javascript">
$(document).ready(function() {
	var id = "${UNQID}";
	var saveDeleteResponse = '${SAVEDELETERESPONSE}';
	if(saveDeleteResponse != ""){
		alert(saveDeleteResponse);
	}
	
	var tableClass = 'userNotesTable';
	compassDatatable.construct(tableClass, "userNotes", true);
	compassDatatable.enableCheckBoxSelection();
	
	$('#datetimepicker'+id).datetimepicker({
		format: 'DD/MM/YYYY HH:mm',
		defaultDate: moment(),
		stepping: 1		//minutes interval
	});
	
	var wholeData = [];
	<c:forEach var="WHOLEDATA" items="${NOTESDATA}">
		var eachData = {};
		<c:forEach var="EACHDATA" items="${WHOLEDATA}">
			eachData["${EACHDATA.key}"] = "${EACHDATA.value}";
		</c:forEach>
		wholeData.push(eachData);
	</c:forEach>
	
	
	//Add new notes
	$("#addNotes"+id).click(function(){
		var newNoteContent = $("#newNoteTextarea"+id).val();
		var newNoteReminderDatetime = "";
		
		if($("#datetimeCheckbox"+id).prop("checked") == true){
			newNoteReminderDatetime = $("#newNoteReminderDatetime"+id).val();
		}
		//alert(newNoteReminderDatetime);
		
		if(newNoteContent != ""){
			$.ajax({
				url: "${pageContext.request.contextPath}/common/saveUserNotes",
				cache: false,
				type: "POST",
				data: "newNoteContent="+newNoteContent+"&newNoteReminderDatetime="+newNoteReminderDatetime,
				success: function(res){
					//alert(saveDeleteResponse);
					//$("#compassSearchModuleModal").modal("hide");
					$("#compassSearchModuleModal-body").html(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		}else{
			alert("Please enter some notes for saving.");
		}
	});
	
	//Delete the notes
	$("#deleteNotes"+id).click(function(){
		var seqNoList = "";
		var selectedCount = 0;
		
		$("#userNotesTable"+id).children("tbody").children("tr").each(function(){
			var row = $(this).children("td").eq(0).children("input[type='checkbox']");
			if($(row).prop("checked")){
				seqNoList = seqNoList+$(this).children("td:nth-child(2)").html().trim()+",";
				selectedCount++;
			}
		});
		//alert(seqNoList);
		if(selectedCount == 0){
			alert('Please select atleast one record to delete.');
			return false;
		}else{
			if(confirm("Do you want to delete "+selectedCount+" notes?")){
				//alert(seqNoArray);
				$.ajax({
					url: "${pageContext.request.contextPath}/common/deleteUserNotes",
					cache: false,
					type: "POST",
					data: "seqNoList="+seqNoList,
					success: function(res){
						//alert(saveDeleteResponse);
						//$("#compassSearchModuleModal").modal("hide");
						$("#compassSearchModuleModal-body").html(res);
					},
					error: function(a,b,c){
						alert(a+b+c);
					}
				});
			}
		}
	});
	
	/*  Passing the data, unqid and interval of 60 seconds with the action. */
	compassUserNotes.userNotesInterval(wholeData, id, 60000, "Start");
	
});
</script>

<div class="card card-default ">
	<div class="card-body" style="padding:0px;">
		<div class="col-sm-12 table-responsive" style="margin-top: 20px; overflow: auto; max-height: 250px;">
			<table class="table table-bordered table-striped userNotesTable" id="userNotesTable${UNQID}" border="1" bordercolor="#a4d4f6">
				<thead>
					<th class="no-sort" style="text-align: center;">
						<input type="checkbox" class="checkbox-check-all" compassTable="userNotesTable" id="userNotesTable">
					</th>
					<th>Sequence No.</th>
					<th>Notes</th>
					<th>Reminder Time</th>
					<th>Updated Time</th>
				</thead>
				<tbody>
					<c:forEach var="WHOLEDATA" items="${NOTESDATA}">
					<tr>
						<td class="no-sort" style="text-align: center;">
							<input type="checkbox"/>	
						</td>
						<c:forEach var="EACHDATA" items="${WHOLEDATA}">
							<td>
								${EACHDATA.value}
							</td>
						</c:forEach>
					</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
	<%-- <textarea rows="3" cols="60" style="width: 90%; margin: 20px;" class="form-control input-sm">${NOTESDATA}</textarea> --%>
	
	<div class="card-body" style="width: 100%; padding: 0px;">
		<table class="table table-striped" >
			<tr>
				<th width="75%" style="padding-left: 20px; font">
					Notes
				</th>
				<th width="25%">
					Reminder Time
				</th>
			</tr>
			<tr style="text-align: center;">
				<td width="75%">
					<textarea rows="3" cols="60" style="width: 95%; margin: 10px 0 0 10px;" id="newNoteTextarea${UNQID}" class="form-control input-sm" placeholder="Enter some notes" onkeydown="return (event.keyCode!=13);"></textarea>
				</td>
				<td width="25%" style="padding-top: 30px;">
					<input type="checkbox" style="width: 10%; float: left; margin-top: 10px;" id="datetimeCheckbox${UNQID}"/>
					
					<div class='input-group date' style="width: 90%; float: right;" id='datetimepicker${UNQID}'>
			            <input type='text' class="form-control" id="newNoteReminderDatetime${UNQID}"/>
			            <span class="input-group-addon formSearchIcon">
			                <span class="fa fa-calendar"></span>
			            </span>
			        </div>
				</td>
			</tr>
		</table>
	</div>
	
	<%-- <div class="card-body" style="width: 100%; padding: 0px;">
		<textarea rows="3" cols="60" style="width: 60%; margin: 20px;" id="newNoteTextarea${UNQID}" class="form-control input-sm" placeholder="Enter some notes"></textarea>
		<div class='input-group date' style="width: 30%;" id='datetimepicker${UNQID}'>
            <input type='text' class="form-control" />
            <span class="input-group-addon">
                <span class="fa fa-calendar"></span>
            </span>
        </div>
		/<textarea rows="3" cols="60" style="width: 95%; margin: 20px;" id="newNoteTextarea${UNQID}" class="form-control input-sm" placeholder="Enter some notes"></textarea>
	</div> --%>
	
	<div class="card-footer clearfix">
		<div class="pull-${dirR}">
			<button type="button" class="btn btn-primary" id="addNotes${UNQID}" style="font-size: 12px;">Add</button>
			<button type="button" class="btn btn-danger" id="deleteNotes${UNQID}" style="font-size: 12px;">Delete</button>
		</div>
	</div>
</div>
