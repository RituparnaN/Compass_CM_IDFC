<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var searchButton = '${SEARCHBTN}';

		$("#assignSectionToRole").click(function(){
			var roleSelected = $("#roleIdForRoleSectionMapping").val();
			var button = $(this);
			var buttonMessage = $(button).html();
			var sectionSelected = "";
			var selected = "";
			var sectionSelectCount = 0;
			var sectionUnSelected = "";
			var unSelected = "";
			var sectionUnSelectCount = 0;
			var message = "Are you sure";
			$(".roleSectionMapping").find(".sectionsUnassigned").each(function(i, obj){
				if($(obj).is(":checked")){
					sectionSelected = sectionSelected+$(obj).attr("compsssId")+",";
					selected = selected+$(obj).attr("id")+",";
					sectionSelectCount++;
				}
			});
			
			$(".roleSectionMapping").find(".sectionsUnassigned").each(function(i, obj){
				if(!$(obj).is(":checked")){
					sectionUnSelected = sectionUnSelected+$(obj).attr("compsssId")+",";					
					unSelected = unSelected+$(obj).attr("id")+",";
					sectionUnSelectCount++;
				}
			});
			
			if(sectionSelectCount > 0){
				message = message+" you want to assign "+sectionSelected+" to "+roleSelected;
			}
			
			if(sectionUnSelectCount > 0){
				if(sectionSelectCount > 0){
					message = message+" and remove "+sectionUnSelected+" for "+roleSelected;
				}else{
					message = message+" you want to remove "+sectionUnSelected+" for "+roleSelected;
				}
			}
			var fullData = "role="+roleSelected+"&sectionSelected="+sectionSelected;
			//alert(fullData);
			if(sectionSelectCount > 0 || sectionUnSelectCount > 0){
				if(confirm(message)){
					$(button).html("Assigning...");
					$(button).attr("disabled","disabled");
					//alert(fullData);
					$.ajax({
			    		url : "${pageContext.request.contextPath}/admin/assignSectionsToRole",
			    		cache : false,
			    		type : 'POST',
			    		data : fullData,
			    		success : function(resData){
			    			alert(resData);
			    			$(button).html("Assign");
							$(button).removeAttr("disabled");
							$("#"+searchButton).click();
			  			},
			    		error : function(){
			    			alert("Something went wrong");
			    		}
			    	});
				}
			}else{
				alert("Please make some changes and try to assign.");
			}
		});
	});
</script>
<c:set var="MAPPEDSECTIONS" value="${SELECTEDSECTIONS}"/>
<%-- <c:set var="ALLSECTIONS" value="${ALLSECTIONS}"/> --%>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary">
			<div class="card-header clearfix">
				<h6 class="card-title pull-${dirL}">Map Sections for ${ROLEID}</h6>
				<input type="hidden" id="roleIdForRoleSectionMapping" value="${ROLEID}"/>
			</div>
			<div class="card-body roleSectionMapping" >
				<c:choose>
				<c:when test="${f:length(MAPPEDSECTIONS) > 0}">
					<c:forEach var="allSections" items="${MAPPEDSECTIONS}">
						<div class="btn-group-html" style="margin-bottom: 5px; margin-right: 5px;">
						  <c:if test="${allSections['ISSELECTED'] eq 'Y'}">
						  	<div class="btn btn-success btn-sm">
							  	<input type="checkbox" class="sectionsUnassigned" compsssId="${allSections['SECTIONNAME']}" id="${allSections['SECTIONNAME']}" style="margin-top: 0px;"
							  		<c:if test="${allSections['ISSELECTED'] eq 'Y'}">checked="checked"</c:if>	/>
							  	<label for="${allSections['SECTIONNAME']}" style="margin-bottom: 0px;">${allSections['SERIALNO']} - ${allSections['SECTIONNAME']} (${allSections['DESCRIPTION']})</label>
						 	</div>
						  </c:if>
						   <c:if test="${allSections['ISSELECTED'] eq 'N'}">
						  	<div class="btn btn-info btn-sm">
							  	<input type="checkbox" class="sectionsUnassigned" compsssId="${allSections['SECTIONNAME']}" id="${allSections['SECTIONNAME']}" style="margin-top: 0px;"
							  		<c:if test="${allSections['ISSELECTED'] eq 'Y'}">checked="checked"</c:if>	/>
							  	<label for="${allSections['SECTIONNAME']}" style="margin-bottom: 0px;">${allSections['SERIALNO']} - ${allSections['SECTIONNAME']} (${allSections['DESCRIPTION']})</label>
						 	</div>
						  </c:if>
						</div>
					</c:forEach>								
				</c:when>
				<c:otherwise>
					<div class="message"><center>No section available for assigning to ${ROLEID}.</center></div>
				</c:otherwise>
				</c:choose>
			</div>
			<div class="card-footer clearfix">
			<div class="pull-${dirR}">
				<button type="button" class="btn btn-primary btn-sm"
					id="assignSectionToRole">Assign</button>
			</div>
		</div>
	</div>
</div>