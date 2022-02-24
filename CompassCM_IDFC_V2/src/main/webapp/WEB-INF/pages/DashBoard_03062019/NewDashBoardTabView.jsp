<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<%
Map<String, Object> dashBoardMap = (Map<String, Object>) request.getAttribute("DashBoardData");
String headerName = ""; 
%>
<script type="text/javascript">
	$(document).ready(function() {
		
		var id = '${UNQID}';
		var tableClass = 'searchResultGenericTable${UNQID}';
		compassDatatable.construct(tableClass, "searchResultGenericTable", true);
	});
</script>
<style type="text/css">
	.modalNav li a{
		font-size: 12px;
		padding: 5px 10px;
	}
</style>
<%
			if(dashBoardMap != null && dashBoardMap.size() > 0){
				Iterator<String> tabNameItr = dashBoardMap.keySet().iterator();
		%>
					<div role="tabpanel">
						<ul class="nav nav-pills modalNav" role="tablist" id="dashBoardTab">
							<%
							int tabIndex = 1;
							while(tabNameItr.hasNext()){
							%>
								<li role="presentation" class='<%=tabIndex == 1 ? "active" : ""%>'>
									<a class="subTab" href="#dashBoardTab<%=tabIndex%>" aria-controls="dashBoardTab<%=tabIndex%>" role="tab" data-toggle="tab"><%=tabNameItr.next()%></a>
								</li>
							<%
								tabIndex++;
							}
							%>
						</ul>
					    <div class="tab-content">
							<%
							tabIndex = 1;
							tabNameItr = dashBoardMap.keySet().iterator();
							while(tabNameItr.hasNext()){
								String tabName = tabNameItr.next();
								HashMap<String, ArrayList<ArrayList<String>>> tabDetailsMap = (HashMap<String, ArrayList<ArrayList<String>>>) dashBoardMap.get(tabName);

								ArrayList<ArrayList<String>> headerList = tabDetailsMap.get("listResultHeader");
								ArrayList<ArrayList<String>> dataList = tabDetailsMap.get("listResultData");
							%>
								<div role="tabpanel" class="tab-pane <%=tabIndex == 1 ? "active" : ""%>" id="dashBoardTab<%=tabIndex%>">
									<% if(dataList.size() == 0){%>
										<br/><center>No Record Found</center><br/>
									<%}else{%>
										<table class="table table-striped table-bordered searchResultGenericTable${UNQID}" id="dashBoardTable<%=tabIndex%>" >
											<thead>
												<tr>
												<%
													for(int headMainIndex = 0; headMainIndex < headerList.size(); headMainIndex++){
														ArrayList<String> headerListSub = headerList.get(headMainIndex);
														%>
															<th width='6px'><spring:message code="app.common.SONO"/></th>
                                                        <%   
														for(int headSubIndex = 0; headSubIndex < headerListSub.size(); headSubIndex++){
															headerName = headerListSub.get(headSubIndex);
															%>
															<th><spring:message code="<%=headerName%>"/></th>
												<%}		}%>
												</tr>
											<thead>

											<tbody>
												<%
													for(int rowIndex = 0; rowIndex < dataList.size(); rowIndex++){
													ArrayList<String> rowList = dataList.get(rowIndex);
												%>
														<tr>
														<td><%=rowIndex+1%></td>
															<%
																for(int colIndex = 0; colIndex < rowList.size(); colIndex++){
																 if(colIndex == 0) {
															%>
																<td style="font-weight:bold;font-size:12px;color:black"><%=rowList.get(colIndex)%></td>
                                                            <%} else { %>
																<td><%=rowList.get(colIndex) != null ? rowList.get(colIndex) : "-"%></td>
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

		<%}%>

