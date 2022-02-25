<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<form method="POST" action="javascript:void(0)">
<input type="hidden" name="COMPASSREFERENCENO" value="${COMPASSREFERENCENO}">
<input type="hidden" name="LINENO" value="${LINENO}">
<input type="hidden" name="FORMTYPE" value="${FORMTYPE}">
<input type="hidden" name="IDFORMTYPE" value="${IDFORMTYPE}">
<input type="hidden" name="STATUS" value="${STATUS}">
<input type="hidden" name="CURRENTROLE" value="${CURRENTROLE}">
<input type="hidden" name="FORMLINENO" value="${FORMLINENO}">
<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
	<tr>
		<td width="15%">
			Identification Form For
		</td>
		<td width="33%">
			<label class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_FOR_C${UNQID}">
			  <input type="radio" id="IDF_FOR_C${UNQID}"  name="IDF_FOR" value="C"
			  <c:if test="${IDFORMTYPE eq 'MAINCUST'}">checked="checked"</c:if> disabled="disabled"
			  />
			  Customer  本人分 / Entity 団体
			</label>
			
			<label class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_FOR_CR${UNQID}">
			  <input type="radio" id="IDF_FOR_CR${UNQID}"  name="IDF_FOR_CR" value="CR"
			  <c:if test="${IDFORMTYPE eq 'AUTHSIGN'}">checked="checked"</c:if> disabled="disabled"
			  />
			  Customer’s representative  先方担当者
			</label>
		</td>
		<td width="4%">&nbsp;</td>
		<td width="48%" colspan="2">
			Customer’s representative : Person in charge of transaction for the corporate customer
		</td>
	</tr>
	<tr>
		<td colspan="5">
			<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
			<c:choose>
				<c:when test="${IDFORMTYPE eq 'MAINCUST'}">
					<tr>
						<td width="6%" rowspan="2" style="vertical-align: middle;">
							Customer / Entity<br/>本人 / 団体
						</td>
						<td width="15%">
							Name (individual or corporate) <br/>氏名（名称） 
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="IDF_CUSTOMERNAME" value="${IDF['IDF_CUSTOMERNAME']}"/> 
						</td>
						<td width="4$">&nbsp;</td>
						<td width="15%">
							Date of birth (or establishment) <br/>生年（設立）年月日 
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="IDF_DATEOFBIRTH" value="${IDF['IDF_DATEOFBIRTH']}"/> 
						</td>
					</tr>
					<tr>
						<td>Address (location)<br/>住所（所在地）</td>
						<td colspan="5">
							<textarea rows="2" cols="2" class="form-control input-sm" name="IDF_ADDRESS">${IDF['IDF_ADDRESS']}</textarea>
						</td>
					</tr>
				</c:when>
				<c:otherwise>
					<tr>
						<td width="6%" rowspan="2" style="vertical-align: middle;">
							Customer’s representative <br/>先方担当者
						</td>
						<td width="15%">
							Position/relationship with the customer/ Name of Department, Division etc<br/>役職/本人との関係/部署名
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="IDF_RELATIONWITHCUST" value="${IDF['IDF_RELATIONWITHCUST']}"/> 
						</td>
						<td width="4$">&nbsp;</td>
						<td width="15%">
							Name <br/>氏名 
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="IDF_CUSTOMERNAME" value="${IDF['IDF_CUSTOMERNAME']}"/> 
						</td>
					</tr>
					<tr>
						<td>
							Address<br/>住所
						</td>
						<td>
							<textarea rows="2" cols="2" class="form-control input-sm" name="IDF_ADDRESS">${IDF['IDF_ADDRESS']}</textarea>
						</td>
						<td>&nbsp;</td>
						<td>
							Date of birth<br/>生年年月日
						</td>
						<td>
							<input type="text" class="form-control input-sm" name="IDF_DATEOFBIRTH" value="${IDF['IDF_DATEOFBIRTH']}"/>
						</td>
					</tr>
				</c:otherwise>
			</c:choose>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			Changed Information<br/>
		</td>
		<td colspan="4">
			<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_CHNG_INFO_EN${UNQID}">
			  <input type="radio" id="IDF_CHNG_INFO_EN${UNQID}"  name="IDF_CHNG_INFO" value="AO"
			  <c:if test="${IDF['IDF_CHNG_INFO'] eq 'EN'}">checked="checked"</c:if>
			  />
			  Entity Name  団体名(名称)
			</label>
			
			<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_CHNG_INFO_REL${UNQID}">
			  <input type="radio" id="IDF_CHNG_INFO_REL${UNQID}"  name="IDF_CHNG_INFO" value="REL"
			  <c:if test="${IDF['IDF_CHNG_INFO'] eq 'SD'}">checked="checked"</c:if>
			  />
			  Relationship between the natural person and the entity  当該自然人と当該団体との関係
			</label>
			
			<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IIDF_CHNG_INFO_CUSTN${UNQID}">
			  <input type="radio" id="IDF_CHNG_INFO_CUSTN${UNQID}"  name="IDF_CHNG_INFO" value="CUSTN"
			  <c:if test="${IDF['IDF_CHNG_INFO'] eq 'CUSTN'}">checked="checked"</c:if>
			  />
			  Customer Name 本人氏名
			</label>
			
			<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_CHNG_INFO_CUSTA${UNQID}">
			  <input type="radio" id="IDF_CHNG_INFO_CUSTA${UNQID}"  name="IDF_CHNG_INFO" value="CUSTA"
			  <c:if test="${IDF['IDF_CHNG_INFO'] eq 'CUSTA'}">checked="checked"</c:if>
			  />
			  Customer Address  本人住所
			</label>
			
			<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_CHNG_INFO_REN${UNQID}">
			  <input type="radio" id="IDF_CHNG_INFO_REN${UNQID}"  name="IDF_CHNG_INFO" value="REN"
			  <c:if test="${IDF['IDF_CHNG_INFO'] eq 'REN'}">checked="checked"</c:if>
			  />
			  Representative’s Name 先方担当者氏名(名称)
			</label>
			<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_CHNG_INFO_REA${UNQID}">
			  <input type="radio" id="IDF_CHNG_INFO_REA${UNQID}"  name="IDF_CHNG_INFO" value="REA"
			  <c:if test="${IDF['IDF_CHNG_INFO'] eq 'REA'}">checked="checked"</c:if>
			  />
			  Representative’s Address 先方担当者住所(所在地)
			</label>
			
			<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_CHNG_INFO_OTR${UNQID}">
			  <input type="radio" id="IDF_CHNG_INFO_OTR${UNQID}"  name="IDF_CHNG_INFO" value="OTR"
			  <c:if test="${IDF['IDF_CHNG_INFO'] eq 'OTR'}">checked="checked"</c:if>
			  />
			  Other  その他
			</label>
		</td>
	</tr>
	<tr>
		<td>
			Other details その他 取引内容
		</td>
		<td colspan="4">
			<input type="text" class="form-control input-sm" name="IDF_CHNG_INFO_OTR" id="IDF_CHNG_INFO_OTR${UNQID}" value="${IDF['IDF_CHNG_INFO_OTR']}">
		</td>
	</tr>
	<tr>
		<td>
			Transaction type<br/>取引種類
		</td>
		<td colspan="4">
			<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_TXN_TYPE_AO${UNQID}">
			  <input type="radio" id="IDF_TXN_TYPE_AO${UNQID}"  name="IDF_TXN_TYPE" value="AO"
			  <c:if test="${IDF['IDF_TXN_TYPE'] eq 'AO'}">checked="checked"</c:if>
			  />
			  Account opening  口座開設
			</label>
			
			<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_TXN_TYPE_SD${UNQID}">
			  <input type="radio" id="IDF_TXN_TYPE_SD${UNQID}"  name="IDF_TXN_TYPE" value="SD"
			  <c:if test="${IDF['IDF_TXN_TYPE'] eq 'SD'}">checked="checked"</c:if>
			  />
			  Safe deposit box/safe custody  貸金庫/保護預り
			</label>
			
			<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_TXN_TYPE_LN${UNQID}">
			  <input type="radio" id="IDF_TXN_TYPE_LN${UNQID}"  name="IDF_TXN_TYPE" value="LN"
			  <c:if test="${IDF['IDF_TXN_TYPE'] eq 'LN'}">checked="checked"</c:if>
			  />
			  Loan 融資
			</label>
			
			<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_TXN_TYPE_CT${UNQID}">
			  <input type="radio" id="IDF_TXN_TYPE_CT${UNQID}"  name="IDF_TXN_TYPE" value="CT"
			  <c:if test="${IDF['IDF_TXN_TYPE'] eq 'CT'}">checked="checked"</c:if>
			  />
			  Cash transaction exceeding JPY 100,000  10万円超の現金取引
			</label>
			
			<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_TXN_TYPE_LCT${UNQID}">
			  <input type="radio" id="IDF_TXN_TYPE_LCT${UNQID}"  name="IDF_TXN_TYPE" value="LCT"
			  <c:if test="${IDF['IDF_TXN_TYPE'] eq 'LCT'}">checked="checked"</c:if>
			  />
			  Large Cash Transaction  大口現金取引
			</label>
			
			<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_TXN_TYPE_OTR${UNQID}">
			  <input type="radio" id="IDF_TXN_TYPE_OTR${UNQID}"  name="IDF_TXN_TYPE" value="OTR"
			  <c:if test="${IDF['IDF_TXN_TYPE'] eq 'OTR'}">checked="checked"</c:if>
			  />
			  Other  その他
			</label>
		</td>
	</tr>
	<tr>
		<td>
			Transaction type Details<br/>取引種類 取引内容
		</td>
		<td colspan="4">
			<input type="text" class="form-control input-sm" name="IDF_TXN_TYPE_OTR_DET" value="${IDF['IDF_TXN_TYPE_OTR_DET']}"/>
		</td>
	</tr>
	<tr>
		<td rowspan="3">
			Entity Method of Identification
		</td>
		<td colspan="4">
			<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_ENTITY_VERF${UNQID}">
			  <input type="radio" id="IDF_ENTITY_VERF${UNQID}"  name="IDF_ENTITY_VERF" value="DOCY"
			  <c:if test="${IDF['IDF_ENTITY_VERF'] eq 'DOCY'}">checked="checked"</c:if>
			  />
			  Document for verification obtained (the entity’s internal rules, minutes, etc.) <br/>
			  確認書類あり(当該団体の規約・会則・議事録等)

			</label>
			
			<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_ENTITY_VERF${UNQID}">
			  <input type="radio" id="IDF_ENTITY_VERF${UNQID}"  name="IDF_ENTITY_VERF" value="DOCN"
			  <c:if test="${IDF['IDF_ENTITY_VERF'] eq 'DOCN'}">checked="checked"</c:if>
			  />
			  Document for verification not obtained (Discuss why it was unavailable in) <br/>
			  確認書類なし(事由を(b)に記入)
			</label>
		</td>
	</tr>
	<tr>
		<td>
			Type of certificate
		</td>
		<td colspan="3">
			<input type="text" class="form-control input-sm" name="IDF_ENTITY_CERT_Y" value="${IDF['IDF_ENTITY_CERT_Y']}"/>
		</td>
	</tr>
	<tr>
		<td>
			Reason for being unavailable
		</td>
		<td colspan="3">
			<input type="text" class="form-control input-sm" name="IDF_ENTITY_CERT_N" value="${IDF['IDF_ENTITY_CERT_N']}"/>
		</td>
	</tr>
	<tr>
		<td style="vertical-align: middle;">
			<c:choose>
				<c:when test="${IDFORMTYPE eq 'MAINCUST'}">
					Method of identification (Corporation)  <br/>確認方法 (法人)
				</c:when>
				<c:otherwise>
					Method of identification (Individual)  <br/>確認方法 (個人)
				</c:otherwise>
			</c:choose>
		</td>
		<td colspan="4">
			<table class="table table-bordered table-striped">
				<tr>
					<td colspan="4">
						<c:choose>
							<c:when test="${IDFORMTYPE eq 'MAINCUST'}">					
								<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_FOR_CR${UNQID}">
								  <input type="radio" id="IDF_FOR_CR${UNQID}"  name="IDF_MOI" value="TCR"
								  <c:if test="${IDF['IDF_MOI'] eq 'TCR'}">checked="checked"</c:if>
								  />
								  Transcript of Company Registry   登記事項証明書
								</label>
								
								<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_MOI_SRC${UNQID}">
								  <input type="radio" id="IDF_MOI_SRC${UNQID}"  name="IDF_MOI" value="SRC"
								  <c:if test="${IDF['IDF_MOI'] eq 'SRC'}">checked="checked"</c:if>
								  />
								  Seal registration certificate   印鑑登録証明書
								</label>
								
								<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_MOI_OTR${UNQID}">
								  <input type="radio" id="IDF_MOI_OTR${UNQID}"  name="IDF_MOI" value="OTR"
								  <c:if test="${IDF['IDF_MOI'] eq 'OTR'}">checked="checked"</c:if>
								  />
								  Other document, etc. recognized locally as an official form of identification   その他、公的証明書として現地で認められているもの　等
								</label>
							</c:when>
							<c:otherwise>
								<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_MOI_SRC${UNQID}">
								  <input type="radio" id="IDF_MOI_SRC${UNQID}"  name="IDF_MOI" value="SRC"
								  <c:if test="${IDF['IDF_MOI'] eq 'SRC'}">checked="checked"</c:if>
								  />
								  Seal registration certificate corresponding to a registered seal (if used)  印鑑登録証明書（実印押印有）
								</label>
								
								<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_MOI_DL${UNQID}">
								  <input type="radio" id="IDF_MOI_DL${UNQID}"  name="IDF_MOI" value="DL"
								  <c:if test="${IDF['IDF_MOI'] eq 'DL'}">checked="checked"</c:if>
								  />
								  Driver’s license  運転免許証
								</label>
								
								<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_MOI_PP${UNQID}">
								  <input type="radio" id="IDF_MOI_PP${UNQID}"  name="IDF_MOI" value="PP"
								  <c:if test="${IDF['IDF_MOI'] eq 'PP'}">checked="checked"</c:if>
								  />
								  Passport  パスポート
								</label>
								
								<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_MOI_OTR${UNQID}">
								  <input type="radio" id="IDF_MOI_OTR${UNQID}"  name="IDF_MOI" value="OTR"
								  <c:if test="${IDF['IDF_MOI'] eq 'OTR'}">checked="checked"</c:if>
								  />
								  Other document, etc. recognized locally as an official form of identification   その他、公的証明書として現地で認められているもの　等
								</label>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<td>
						Type of certificate<br/>具体的名称
					</td>
					<td colspan="4">
						<input type="text" class="form-control input-sm" name="IDF_CERT_TYPE" value="${IDF['IDF_CERT_TYPE']}"/>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<table class="table table-bordered table-striped">
							<tr>
								<td width="15%">
									Issued by<br/>発行者
								</td>
								<td width="25%">
									<input type="text" class="form-control input-sm" name="IDF_CERT_ISSUED_BY" value="${IDF['IDF_CERT_ISSUED_BY']}"/>
								</td>
								<td width="15%">
									No<br/>記号・番号
								</td>
								<td width="25%">
									<input type="text" class="form-control input-sm" name="IDF_CERT_NO" value="${IDF['IDF_CERT_NO']}"/>
								</td>
								<td width="20%">
									<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_CERT_SHOWN_ORIGINALSHOWN${UNQID}">
									  <input type="radio" id="IDF_CERT_SHOWN_ORIGINALSHOWN${UNQID}"  name="IDF_CERT_SHOWN" value="ORIGINALSHOWN"
									  <c:if test="${IDF['IDF_CERT_SHOWN'] eq 'ORIGINALSHOWN'}">checked="checked"</c:if>
									  />
									  Original are presented  原本提示
									</label>
									<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_CERT_SHOWN_OTHER${UNQID}">
									  <input type="radio" id="IDF_CERT_SHOWN_OTHER${UNQID}"  name="IDF_CERT_SHOWN" value="OTHER"
									  <c:if test="${IDF['IDF_CERT_SHOWN'] eq 'OTHER'}">checked="checked"</c:if>
									  />
									  Other  その他
									</label>
								</td>
							</tr>
						</table>
					</td>					
				</tr>
			</table>
			<table class="table table-bordered table-striped">
				<tr>
					<td width="10%" rowspan="5" style="vertical-align: middle;">
						Transaction document sent (if any)<br/>
						 取引に係る文書の送付を行う場合
					</td>
					<td width="25%">Date on which the document is mailed or handed to the customer <br/>郵送又は持参した日</td>
					<td width="45%" colspan="2">
						<input type="text" class="form-control input-sm" name="IDF_DOCMAILEDDATE" value="${IDF['IDF_DOCMAILEDDATE']}"/>
					</td>
					<td width="20%" rowspan="5" style="text-align: center;">
						Sender<br/>取扱者
					</td>
				</tr>
				<tr>
					<td style="vertical-align: middle;">
						Title of document: (registered mail) 送付書類名:（簡易書留郵便）
					</td>
					<td colspan="2">
						<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_DOC_TITLE_AON${UNQID}">
						  <input type="radio" id="IDF_DOC_TITLE_AON${UNQID}"  name="IDF_DOC_TITLE" value="AON"
						  <c:if test="${IDF['IDF_DOC_TITLE'] eq 'AON'}">checked="checked"</c:if>
						  />
						  Notification of a/c opening (a/c no.) 口座開設(番号)通知書
						</label>
						<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_DOC_TITLE_TYL${UNQID}">
						  <input type="radio" id="IDF_DOC_TITLE_TYL${UNQID}"  name="IDF_DOC_TITLE" value="TYL"
						  <c:if test="${IDF['IDF_DOC_TITLE'] eq 'TYL'}">checked="checked"</c:if>
						  />
						  Thank you letter 取引の礼状
						</label>
						<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_DOC_TITLE_OTR${UNQID}">
						  <input type="radio" id="IDF_DOC_TITLE_OTR${UNQID}"  name="IDF_DOC_TITLE" value="OTR"
						  <c:if test="${IDF['IDF_DOC_TITLE'] eq 'OTR'}">checked="checked"</c:if>
						  />
						  Other その他
						</label>
					</td>
				</tr>
				<tr>
					<td>Define Other</td>
					<td colspan="2">
						<input type="text" class="form-control input-sm" name="IDF_DOC_TITLE_OTR_DETAILS" value="${IDF['IDF_DOC_TITLE_OTR_DETAILS']}"/>
					</td>
				</tr>
				<tr>
					<td rowspan="2">Delivery method <br/>送付方法</td>
					<td width="30%">
						<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_DLV_METHOD_MAIL${UNQID}">
						  <input type="radio" id="IDF_DLV_METHOD_MAIL${UNQID}"  name="IDF_DLV_METHOD" value="MAIL"
						  <c:if test="${IDF['IDF_DLV_METHOD'] eq 'MAIL'}">checked="checked"</c:if>
						  />
						  Mail 郵送 : Registered/ Delivery-certified/ Courier
						</label>
					</td>
					<td>
						<input type="text" class="form-control input-sm" name="IDF_DLV_MAIL_COURIER" value="${IDF['IDF_DLV_MAIL_COURIER']}"/>
					</td>
				</tr>
				<tr>
					<td colspan="2" style="vertical-align: middle;">
						<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_DLV_METHOD_PERSON${UNQID}">
						  <input type="radio" id="IDF_DLV_METHOD_PERSON${UNQID}"  name="IDF_DLV_METHOD" value="PERSON"
						  <c:if test="${IDF['IDF_DLV_METHOD'] eq 'PERSON'}">checked="checked"</c:if>
						  />
						  Delivered in person 持参
						</label>
					</td>
				</tr>
			</table>	
		</td>
	</tr>
	<tr>
		<td>Dept. in charge of identification 確認担当課</td>
		<td>
			<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_DIC_IDFIC_BPD${UNQID}">
			  <input type="radio" id="IDF_DIC_IDFIC_BPD${UNQID}"  name="IDF_DIC_IDFIC" value="BPD"
			  <c:if test="${IDF['IDF_DIC_IDFIC'] eq 'BPD'}">checked="checked"</c:if>
			  />
			  BPD
			</label>
			
			<label style="margin-bottom: 10px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="IDF_DIC_IDFIC_BPA${UNQID}">
			  <input type="radio" id="IDF_DIC_IDFIC_BPA${UNQID}"  name="IDF_DIC_IDFIC" value="BPA"
			  <c:if test="${IDF['IDF_DIC_IDFIC'] eq 'BPA'}">checked="checked"</c:if>
			  />
			  BPA
			</label>
		</td>
		<td>&nbsp;</td>
		<td width="15%">
			Time of Identification 確認時刻
		</td>
		<td width="33%">
			<input type="text" class="form-control input-sm" name="IDF_TIME_IDFIC" value="${IDF['IDF_TIME_IDFIC']}"/>
		</td>
	</tr>
	<tr>
		<td>
			Confirmation Date 確認日 
		</td>
		<td>
			<input type="text" class="form-control input-sm" name="IDF_COFM_DATE" value="${IDF['IDF_COFM_DATE']}"/>
		</td>
		<td>&nbsp;</td>
		<td>
			Transaction date取引日
		</td>
		<td>
			<input type="text" class="form-control input-sm" name="IDF_TXN_DATE" value="${IDF['IDF_TXN_DATE']}"/>
		</td>
	</tr>
	<c:if test="${(STATUS eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (STATUS eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
		<tr>
			<td colspan="5" style="text-align: center;">
				<button type="button" class="btn btn-success btn-sm" onclick="saveIdentificationForm(this)">Save</button>
			</td>
		</tr>
	</c:if>
	<tr>
		<td colspan="5">
			*(1) Transactional documents are sent if (i) the customer does not present an identification document, or (ii) the customer is an individual and presents an identification document other than a seal registration certificate (if a registered seal is used), driver's license and passport.<br/>
    		(i)本人確認書類の提示を受けない場合または(ii)個人の場合で「印鑑登録証明書（実印押印有）」「運転免許証」「パスポート」以外の本人確認書類の提示を受ける場合には、取引に係る文書を送付<br/>
			*(2) Fill in the date on which the customer identification document is presented or received by mail. No need to fill in the parenthesis if the transactions date is same as the confirmation date. 確認書類の提示あるいは送付を受けた日付を記入。確認日=取引日の場合( )内の記入省略可<br/>
			*(3) The approval needs to be given by a person responsible for prevention of money laundering or Manager in charge. 権限者:マネー・ローンダリング対応責任者または担当課長
		</td>
	</tr>
</table>
</form>