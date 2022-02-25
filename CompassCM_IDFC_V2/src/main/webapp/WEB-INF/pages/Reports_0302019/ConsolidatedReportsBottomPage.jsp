<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
Map<String, Object> consolidatedReportsMap = (Map<String, Object>) request.getAttribute("ConsolidatedReportsData");
%>
<script type="text/javascript">
	$(document).ready(function(){
		compassDatatable.construct("consolidatedReports", "Consolidated Reports", false);
	});
</script>
<%
    if(consolidatedReportsMap != null && consolidatedReportsMap.size() > 0){
	Iterator<String> tabNameItr = consolidatedReportsMap.keySet().iterator();
%>
	<div class="row">
		<div class="col-xs-12" style="width:100%; ">
				<div role="tabpanel">
					<ul class="nav nav-tabs" role="tablist" id="consolidatedReportsTab">
						<%
						int tabIndex = 1;
						while(tabNameItr.hasNext()){
						%>
							<li role="presentation" class='<%=tabIndex == 1 ? "active" : ""%>'>
								<a href="#consolidatedReportsTab<%=tabIndex%>" aria-controls="consolidatedReportsTab<%=tabIndex%>" role="tab" data-toggle="tab"><%=tabNameItr.next()%></a>
							</li>
						<%
							tabIndex++;
						}
						%>
					</ul>
				    <div class="tab-content">
						<%
						tabIndex = 1;
						tabNameItr = consolidatedReportsMap.keySet().iterator();
						while(tabNameItr.hasNext()){
							String tabName = tabNameItr.next();
							HashMap<String, ArrayList<ArrayList<String>>> tabDetailsMap = (HashMap<String, ArrayList<ArrayList<String>>>) consolidatedReportsMap.get(tabName);

							ArrayList<ArrayList<String>> headerList = tabDetailsMap.get("listResultHeader");
							ArrayList<ArrayList<String>> dataList = tabDetailsMap.get("listResultData");
						%>
							<div role="tabpanel" class="tab-pane <%=tabIndex == 1 ? "active" : ""%>" id="consolidatedReportsTab<%=tabIndex%>" style="overflow: auto;">
								<% if(dataList.size() == 0){%>
									<br/><center>No Record Found</center><br/>
								<%}else{%>
									<table class="table table-striped table-bordered consolidatedReports"  >
										<thead>
											<tr>
											<%
												for(int headMainIndex = 0; headMainIndex < headerList.size(); headMainIndex++){
													ArrayList<String> headerListSub = headerList.get(headMainIndex);
													%>
														<th width='6px'>S.No.</th>
                                                       <%   
													for(int headSubIndex = 0; headSubIndex < headerListSub.size(); headSubIndex++){
														%>
														<th><%=headerListSub.get(headSubIndex)%></th>
											<%}		}%>
											</tr>
										<thead>

										<tbody>
											<%
												for(int rowIndex = 0; rowIndex < dataList.size(); rowIndex++){
												ArrayList<String> rowList = dataList.get(rowIndex);
											%>
													<tr >
													<td><%=rowIndex+1%></td>
														<%
															for(int colIndex = 0; colIndex < rowList.size(); colIndex++){
															 if(colIndex == 0) {
														%>
															<td style="font-weight:bold;font-size:12px;color:black"><%=rowList.get(colIndex)%></td>
                                                           <%} else { %>
															<td><%=rowList.get(colIndex)%></td>
                                                        <%}%>
														<%}%>
													</tr>
											<%}%>
										</tbody>
									</table>
								<%}%>
							</div>
						<%
							tabIndex++;
						}
						%>
				    </div>
			</div>
		</div>
	</div>

	<%}%>