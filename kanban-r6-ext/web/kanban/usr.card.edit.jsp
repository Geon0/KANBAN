<%@ include file="/jspf/head.portlet.jsp" %>
<link type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/kanban/css/CardFileViewer.css">
<script type="text/javascript" src="<%=request.getContextPath()%>/kanban/js/CardFileViewer.js"></script>

<style type="text/css">
.CardTextFieldEditor {ime-mode:active; margin: 11px 0px 8px 14px; padding: 0px 10px 0px 10px; height: 31px;line-height: 14px;width: 438px;color: #20232C;border: none;-moz-box-sizing: border-box;box-sizing: border-box;-webkit-appearance:none;font-size: 16px;font-weight: 700;}
.CardTextFieldEditor:hover {border:#b8bbbf solid 1px;height:31px; }
.CardTextFieldEditor_normal {}
.CardTextFieldEditor_focus {border:#7387a9 solid 1px; height:31px; margin: 11px 0px 8px 14px;padding: 0px 10px 0px 10px; outline:none;}
.CardTextFieldEditor_exam {color:#a3a3a3;}
.CardTextFieldEditor_original {color:#20232C}
/*header*/
.card-detail${PORTLET_ID} .header${PORTLET_ID}{*zoom:1;height:47px;}
.card-detail${PORTLET_ID} .header${PORTLET_ID}:after{content:'';display:block;clear:both;}
.card-detail${PORTLET_ID} .header${PORTLET_ID} .btns{float:right;padding-left:20px;margin-top:14px;margin-right:16px;}
.card-detail${PORTLET_ID} .header${PORTLET_ID} .btnDel{position:relative;float:left;padding:5px 10px;margin-right:7px;color:#525252;font-size:12px;}
.card-detail${PORTLET_ID} .header${PORTLET_ID} .btnDel:before{content:'';position:absolute;top:5px;right:0;display:block;width:1px;height:12px;background:#d2d2d2;margin-top:2px;}
.card-detail${PORTLET_ID} .header${PORTLET_ID} .btnCloseLayer{float:left;display:block;width:12px;height:12px;padding:5px;background:url(<c:url value="/kanban/css/img/btn_close_layer.png"/>) 5px 5px no-repeat;font-size:0;text-indent:-9999px;margin-top:2px;}
.card-detail${PORTLET_ID} .header${PORTLET_ID} .btnCloseLayer:hover{background-image:url(<c:url value="/kanban/css/img/btn_close_layer_hover.png"/>);}
.card-detail${PORTLET_ID} .header${PORTLET_ID} .tit${PORTLET_ID}{color:#313131;font-size:16px;font-family:nanumgothic,'Gulim','Dotum';font-weight:700;letter-spacing:-0.5px;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;height:47px;}
/*cardSet*/
.card-detail${PORTLET_ID} .cardSet{position:relative;z-index:10;min-height:30px;padding-bottom:8px;border-top:1px solid #ebebeb;border-bottom:1px solid #ebebeb;background:#f5f5f8;}
.card-detail${PORTLET_ID} .cardSet .setL{margin-right:200px;}
.card-detail${PORTLET_ID} .cardSet .setR{*zoom:1;position:absolute;top:5px;right:22px;}
.card-detail${PORTLET_ID} .cardSet .setR:after{content:'';display:block;clear:both;}
/*cardSet > sltBtns*/
.card-detail${PORTLET_ID} .sltBtns${PORTLET_ID}{float:left;}
.card-detail${PORTLET_ID} .sltBtns${PORTLET_ID}:after{content:'';display:block;clear:both;}
.card-detail${PORTLET_ID} .sltBtn{position:relative;float:left;padding-left:16px;margin-left:10px;}
.card-detail${PORTLET_ID} .sltBtn:before{content:'';position:absolute;top:0;left:0;display:block;width:1px;height:19px;background:#dedee0;}
.card-detail${PORTLET_ID} .sltBtn:first-child{padding-left:0;margin-left:0;z-index: 1;}
.card-detail${PORTLET_ID} .sltBtn:first-child:before{display:none;}
.card-detail${PORTLET_ID} .sltBtn .btn{display:block;padding-right:10px;background-position:right 0;background-repeat:no-repeat;}
/*cardSet > sltBtns > pulldown*/
.card-detail${PORTLET_ID} .pulldown .btn{background-image:url(css/img/arr_contents_open.png); margin-top:16px; margin-left:26px;}
.card-detail${PORTLET_ID} .pulldown .btn-layer{position:absolute;top:23px;left:16px;display:none;border:1px solid #8d8d8d;background:#FFF;}
.card-detail${PORTLET_ID} .pulldown:first-child .btn-layer{left:0;}
.card-detail${PORTLET_ID} .pulldown.on .btn{background-image:url(css/img/arr_contents_close.png);}
.card-detail${PORTLET_ID} .pulldown.on .btn-layer{display:block;overflow:hidden;}
/*cardSet > sltBtns > pulldown > lock/unlock*/
.card-detail${PORTLET_ID} .sltBtn.lock .btn{background-position:right 8px;}
.card-detail${PORTLET_ID} .sltBtn.lock .btn .txt{display:block;padding:4px 0;min-width:41px;color:#525252;font-size:12px;letter-spacing:-0.5px;}
.card-detail${PORTLET_ID} .sltBtn.lock .btn-layer{width:53px;}
.card-detail${PORTLET_ID} .sltBtn.lock .btn-layer li{border-top:1px solid #ececec;}
.card-detail${PORTLET_ID} .sltBtn.lock .btn-layer li:first-child{border-top:none;}
.card-detail${PORTLET_ID} .sltBtn.lock .btn-layer a{display:block;padding:8px 10px;}
.card-detail${PORTLET_ID} .sltBtn.lock .btn-layer a:hover{background:#f1f1f1;font-weight:700;}
.card-detail${PORTLET_ID} .sltBtn.lock .btn-layer .txt{color:#000;font-size:12px;font-family:nanumgothic,'Gulim','Dotum';letter-spacing:-0.5px;}
/*cardSet > sltBtns > pulldown > color*/
.card-detail${PORTLET_ID} .sltBtn.color .btn{background-position:right 8px;}
.card-detail${PORTLET_ID} .sltBtn.color .color{display:block;width:17px;height:17px;margin-right:8px;font-size:0;text-indent:-9999px;}
.card-detail${PORTLET_ID} .sltBtn.color .color.c-b2b7bd{background:#b2b7bd;border:1px solid #abb1b9;}
.card-detail${PORTLET_ID} .sltBtn.color .color.c-ff0000{background:#ff0000;border:1px solid #ff0000;}
.card-detail${PORTLET_ID} .sltBtn.color .color.c-ffa500{background:#ffa500;border:1px solid #ffa500;}
.card-detail${PORTLET_ID} .sltBtn.color .color.c-ffff00{background:#ffff00;border:1px solid #ffff00;}
.card-detail${PORTLET_ID} .sltBtn.color .color.c-008000{background:#008000;border:1px solid #008000;}
.card-detail${PORTLET_ID} .sltBtn.color .color.c-87ceeb{background:#87ceeb;border:1px solid #87ceeb;}
.card-detail${PORTLET_ID} .sltBtn.color .color.c-150aca{background:#150aca;border:1px solid #150aca;}
.card-detail${PORTLET_ID} .sltBtn.color .color.c-800080{background:#800080;border:1px solid #800080;}
.card-detail${PORTLET_ID} .sltBtn.color .color.c-63b9eb{background:#63b9eb;border:1px solid #58abdb;}
.card-detail${PORTLET_ID} .sltBtn.color .color.c-edc564{background:#edc564;border:1px solid #cfab53;}
.card-detail${PORTLET_ID} .sltBtn.color .color.c-ef9687{background:#ef9687;border:1px solid #db8171;}
.card-detail${PORTLET_ID} .sltBtn.color .btn-layer{width:29px;}
.card-detail${PORTLET_ID} .sltBtn.color .btn-layer li{border-top:1px solid #ececec;}
.card-detail${PORTLET_ID} .sltBtn.color .btn-layer li:first-child{border-top:none;}
.card-detail${PORTLET_ID} .sltBtn.color .btn-layer a{display:block;padding:5px;}
.card-detail${PORTLET_ID} .sltBtn.color .btn-layer a:hover{background:#f1f1f1;}
/*description*/
.card-detail${PORTLET_ID} .description{padding:20px 25px 12px 25px;}
.card-detail${PORTLET_ID} .description .tit{*zoom:1;}
.card-detail${PORTLET_ID} .description .tit:after{content:'';display:block;clear:both;}
.card-detail${PORTLET_ID} .description .tit .txt{float:left;display:block;cursor:default;color:#313131;font-size:14px;font-family:nanumgothic,'Gulim','Dotum';font-weight:700;letter-spacing:-0.5px;}
.card-detail${PORTLET_ID} .description .tit .btnEdit{float:left;display:block;width:13px;height:13px;padding:5px;margin-top:-3px;margin-left:3px;background:url(<c:url value="/kanban/css/img/btn_edit_tit_description.png"/>) 5px 5px no-repeat;}
.card-detail${PORTLET_ID} .description .tit .btnEdit:hover{background-image:url(<c:url value="/kanban/css/img/btn_edit_tit_description_hover.png"/>);}
.card-detail${PORTLET_ID} .description .tit .btnEdit span{font-size:0;text-indent:-9999px;}
.card-detail${PORTLET_ID} .description .info{margin-top:5px;margin-bottom:8px;color:#525252;font-size:12px;letter-spacing:-0.5px;line-height:20px;}
.card-detail${PORTLET_ID} .description .editArea{display:none;margin:11px 1px 0 1px;}
.card-detail${PORTLET_ID} .description .editArea textarea{display:block;background:#fff;resize:none;border-radius:3px;width:100%;height:81px;border:1px solid #dbddde;outline-width:0;color:#949393;line-height:16px;padding:10px;box-sizing: border-box;-o-box-sizing: border-box;-ms-box-sizing: border-box;-moz-box-sizing: border-box;-webkit-box-sizing: border-box;font-size:12px;}
.card-detail${PORTLET_ID} .description .editArea textarea:hover{border:1px solid #bbc1c7;box-shadow: inset 1px 1px 2px #f0f0f0}
.card-detail${PORTLET_ID} .description .editArea textarea:focus{border:1px solid #77d2af;box-shadow: inset 1px 1px 2px #f0f0f0}
.card-detail${PORTLET_ID} .description .editArea textarea:disabled{border:1px solid #dbddde;cursor:default;background:#f3f3f3}
.card-detail${PORTLET_ID} .description .editArea textarea_error{border:1px solid #d86767;box-shadow: inset 1px 1px 2px #f0f0f0}
.card-detail${PORTLET_ID} .description .editArea textarea_exam{color:#a3a3a3;}
.card-detail${PORTLET_ID} .description .editArea textarea_original{color:#20232C}
.card-detail${PORTLET_ID} .description .editArea .btns{margin-top:6px;margin-left:1px;font-size:0;}
.card-detail${PORTLET_ID} .description .editArea .btns .btn{font-size:12px;}
.card-detail${PORTLET_ID} .description.edit .tit .btnEdit{display:none;}
.card-detail${PORTLET_ID} .description.edit .info{display:none;}
.card-detail${PORTLET_ID} .description.edit .editArea{display:block;}
/*component-area*/
.card-detail${PORTLET_ID} .component-area{padding:0 25px;}
.OpnViewer .writerArea {display:none;}
.OpnWriter {position: relative;margin-top: 10px;}
.OpnViewer .opnVwCntBDiv {padding:10px 0 13px 0;}
.OpnViewer .opnCntA .arrow {display: inline;margin: 6px 0 0 6px;padding: 0;vertical-align: top;}
.TemplateLayoutLeft {margin-left:-35px;}
.CardFileViewer .file_list .file_item {padding: 20px 5px 5px 0px;}
</style>
<script type="text/javascript">
JSV.Block(function () {
	var id${PORTLET_ID} = JSV.getParameter('id', '${PORTLET_ID}');
	var data${PORTLET_ID} = JSV.loadJSON('/jsl/KbItemCardUser.ReadByUser.json?id='+id${PORTLET_ID});
	var content${PORTLET_ID} = data${PORTLET_ID}.content;
	cardOpenEditor = $('#layer${PORTLET_ID}').parent().data('CardOpenEditor');
	var titleData${PORTLET_ID} = data${PORTLET_ID}.title;
	<%-- 제목 --%>
	var title${PORTLET_ID} = new TextFieldEditor($('#tit${PORTLET_ID}'),{'className':'CardTextFieldEditor','maxLength':'30'});
	title${PORTLET_ID}.onfocusout = function(e){
		if(title${PORTLET_ID}.getValue() == ''){
			alert('<kfmt:message key="pd.card.042"/>');
			title${PORTLET_ID}.setValue(titleData${PORTLET_ID});
			return false;
		}		
		var obj = {};
		obj.title = title${PORTLET_ID}.getValue();
		obj.id = id${PORTLET_ID};
		$.ajax({
			url : JSV.getContextPath(JSV.getModuleUrl('/jsl/KbItemCardUser.CardTitleUpdate.jsl')),
			data : {item:JSV.toJSON(obj)},
			dataType : 'json',
			success : function(data) {
				titleData${PORTLET_ID} = obj.title;
				cardOpenEditor.callback.updateTitle(obj.title);
			},
			error : function() {
				alert('<kfmt:message key="pd.128"/>');
			}
		});
	}
	title${PORTLET_ID}.onkeydown = function(e){
		if (e.keyCode == 13) {
			title${PORTLET_ID}.widget.trigger('blur');
		}
	};
	title${PORTLET_ID}.setValue(titleData${PORTLET_ID});
	
	<%--삭제--%>
	$('#btnDel${PORTLET_ID}').click(function(){
		if(confirm('<fmt:message key="pub.003"/>')){
			$.ajax({
				url : JSV.getContextPath('/jsl/KbItemCardUser.CardDelete.jsl'),
				data : {id:id${PORTLET_ID}},
				dataType : 'json',
				success : function(data) {
					close${PORTLET_ID}();
					cardOpenEditor.callback.deleteCard();
				},
				error : function() {
					alert('<kfmt:message key="pd.128"/>');
				}
			});
		}
	})
	
	<%-- 색상 --%>
	$('#colorSet${PORTLET_ID}').addClass('c-'+data${PORTLET_ID}.color).text(data${PORTLET_ID}.color);
	
	$('.sltBtns${PORTLET_ID} .pulldown').each(function(index, item) {
		$(item).children('.btn').click(function(){
			$(item).addClass('on');
		});
		$(document).on('click', function(event) {
			if($(item).length) {
				if(!$(item).has(event.target).length == 0) {
					return;
				}
				else {
					$(item).removeClass('on');
				}
			}
		});
	});
	
	<%-- 컬러 설정 --%>
	$('#colorArea${PORTLET_ID}').find('li').click(function(){
		var obj = {};
		obj.color = $(this).attr('cl');
		obj.id = id${PORTLET_ID};
		$.ajax({
			url : JSV.getContextPath('/jsl/KbItemCardUser.CardColorUpdate.jsl'),
			data : {item:JSV.toJSON(obj)},
			dataType : 'json',
			success : function(data) {
				$('#colorSet${PORTLET_ID}').removeClass().addClass('color c-'+obj.color).text(obj.color);
				$('#colorDiv${PORTLET_ID}').removeClass('on');
				cardOpenEditor.callback.updateColor(obj.color);
			},
			error : function() {
				alert('<kfmt:message key="pd.128"/>');
			}
		});
	})
	
	<%--본문내용--%>
	var contentViewer${PORTLET_ID} = new TextAreaViewer($('#info${PORTLET_ID}'));
	contentViewer${PORTLET_ID}.setValue(content${PORTLET_ID});
	var contentEditor${PORTLET_ID} = new TextAreaEditor($('#contentArea${PORTLET_ID}'),{'maxLength':'200'});
	
	<%-- 본문 저장버튼 --%>
	$('#contentSave${PORTLET_ID}').on('click', function(e){
		var obj = {};
		obj.content = contentEditor${PORTLET_ID}.getValue();
		obj.id = id${PORTLET_ID};
		
		$.ajax({
			url : JSV.getContextPath('/jsl/KbItemCardUser.CardContentUpdate.jsl'),
			data : {item:JSV.toJSON(obj)},
			dataType : 'json',
			success : function(data) {
				content${PORTLET_ID} = contentEditor${PORTLET_ID}.getValue();
				contentViewer${PORTLET_ID}.setValue(content${PORTLET_ID});
				$(contentEditor${PORTLET_ID}.widget).val('');
				$('#description${PORTLET_ID}').removeClass('edit');
				
				cardOpenEditor.callback.updateContent(obj.content);
			},
			error : function() {
				alert('<kfmt:message key="pd.128"/>');
			}
		});
	})
	
	
	<%-- 본문 수정버튼 --%>
	$('#btnEdit${PORTLET_ID}').on('click',function(e){
		contentEditor${PORTLET_ID}.setValue(content${PORTLET_ID});
		$('#description${PORTLET_ID}').addClass('edit');
	});
	
	<%-- 본문 취소버튼 --%>
	$('#contentCancel${PORTLET_ID}').on('click',function(e){
		$('#description${PORTLET_ID}').removeClass('edit');
	});
	
	<%-- 최종수정자--%>
	var lastUser${PORTLET_ID} = new EmpHtmlViewer($('#lastUser${PORTLET_ID}'), {'displayName':'name'});
	lastUser${PORTLET_ID}.setValue(data${PORTLET_ID}.lastUser);
	
	<%-- 기간 --%>
	var dateTerm${PORTLET_ID} = new DateTermEditor($('#dateTerm${PORTLET_ID}'), {});
	dateTerm${PORTLET_ID}.setValue([data${PORTLET_ID}.startDate,data${PORTLET_ID}.endDate]);
	dateTerm${PORTLET_ID}.onchange = function(){
		var obj = {};
		obj.startDate = dateTerm${PORTLET_ID}.getStartDate();
		obj.endDate =  dateTerm${PORTLET_ID}.getEndDate();
		obj.id = id${PORTLET_ID};
		$.ajax({
			url : JSV.getContextPath('/jsl/KbItemCardUser.CardDateUpdate.jsl'),
			data : {item:JSV.toJSON(obj)},
			dataType : 'json',
			success : function(data) {
				cardOpenEditor.callback.updateDate(obj);
			},
			error : function() {
				alert('<kfmt:message key="pd.128"/>');
			}
		});
	}
	
	<%-- 기간초기화 --%>
	$('#dateReset${PORTLET_ID}').click(function(){
		dateTerm${PORTLET_ID}.start.value = null;
		dateTerm${PORTLET_ID}.end.value = null;
		dateTerm${PORTLET_ID}.start.input.val('');
		dateTerm${PORTLET_ID}.end.input.val('');
		var obj = {};
		obj.startDate = null;
		obj.endDate =  null;
		obj.id = id${PORTLET_ID};
		$.ajax({
			url : JSV.getContextPath('/jsl/KbItemCardUser.CardDateUpdate.jsl'),
			data : {item:JSV.toJSON(obj)},
			dataType : 'json',
			success : function(data) {
				cardOpenEditor.callback.updateDate(obj);
			},
			error : function() {
				alert('<kfmt:message key="pd.128"/>');
			}
		});
	})
	
	<%-- 첨부파일 --%>
	var attStyle${PORTLET_ID} = {'template':'false',
			'attach' : '/jsl/attach/KbItemCardUser.DownloadByUser?id=@{id}',
			'register' : '/jsl/KbItemCardUser.DoFileRegister.json',
			'remove' : '/jsl/KbItemCardUser.RemoveFile.json',
			'vrsnUrl' : '/kanban/file.versionup.jsp',
			'cardId' : id${PORTLET_ID},
			'ptlId':'${PORTLET_ID}',
			'add' : '<kfmt:message key="pd.card.002"/>',
			'userId' : '<%=com.kcube.sys.usr.UserService.getUserId()%>',
			'notSupport' : '',
			'fileSize' : '',
			'totalSize' : ''
			};
	
	attchment${PORTLET_ID} = new CardFileViewer($('#files${PORTLET_ID}'), attStyle${PORTLET_ID});
	attchment${PORTLET_ID}.setValue = function(value){
		var ul = this.ul;
		$(ul).empty();
		if (value && value.length > 0) {
			for ( var i = 0; i < value.length; i++) {
				this.createFile(ul, value[i], i);
			}
		}
		cardOpenEditor.callback.updateFileCnt(value.length);
	}
	attchment${PORTLET_ID}.setValue(data${PORTLET_ID}.attachments); 
	
	<%--닫기--%>
	$('#btnCloseLayer${PORTLET_ID}').click(function(){
		close${PORTLET_ID}();
	});
	
	<%-- 의견 --%>
	var opnStyle${PORTLET_ID} = {'userId':<%=com.kcube.sys.usr.UserService.getUserId()%>,
			'reloadUrl':'/kb/card/usr.card.edit.jsp',
			'actionUrl':'/jsl/KbItemCardOpinion.DeleteOpinion.jsl',
			'actionAddUrl':'/jsl/KbItemCardOpinion.AddOpinion.json',
			'opnDelete':'KbItemCardOpinion.DeleteOpinion',
			'opnUpdate':'KbItemCardOpinion.UpdateOpinion',
			'isCenter' : false
	};
	
	var opinionWriter${PORTLET_ID} = new OpnWriter($('#opinionArea${PORTLET_ID}'), {'itemId':data${PORTLET_ID}.itemId, 'reloadUrl':'/kb/card/usr.read.jsp', 'maxLength':'600', 'actionUrl':'/jsl/KbItemCardOpinion.AddOpinion.json'});
	opinionWriter${PORTLET_ID}.setId(data${PORTLET_ID}.id);
	
	var opinionViewer${PORTLET_ID} = new OpnViewer($('#opinionArea${PORTLET_ID}'), opnStyle${PORTLET_ID});
	opinionViewer${PORTLET_ID}.setValue(data${PORTLET_ID}.opinions, new function(){
		this.layout = {};
		this.getProperty = function(field){
			return JSV.getProperty(data${PORTLET_ID}, field);
		}
	});
	
	JSV.register(opinionWriter${PORTLET_ID}, opinionViewer${PORTLET_ID});
	JSV.register(opinionViewer${PORTLET_ID}, cardOpenEditor.callback, 'updateCount');
	
	$('#layer${PORTLET_ID}').slimscroll({height:'420px'
		,size:'7px'
        ,color:'#d8d8d8'
        ,opacity:0.5});
	
}, '${PORTLET_ID}');
var chargers${PORTLET_ID};
var attchment${PORTLET_ID};
var cardOpenEditor;
function loadChargers(values){
	chargers${PORTLET_ID}.setValue(values.array);
	cardOpenEditor.callback.updateCharge(values.array);
}
function loadFiles(value){
	attchment${PORTLET_ID}.setValue(value.attachments);
}
function close${PORTLET_ID}(){
	$('#layer${PORTLET_ID}').slimScroll({destroy:true});
	$('body').find('.CardOpenEditor').hide();
}
</script>
<div class="layer card-detail${PORTLET_ID}" id="layer${PORTLET_ID}">
	<div class="header${PORTLET_ID}">
		<div class="sltBtns${PORTLET_ID}">
		<div class="sltBtn pulldown color" id="colorDiv${PORTLET_ID}">
					<a href="javascript:void(0);" class="btn"><span class="color" id="colorSet${PORTLET_ID}"></span><!-- c-b2b7bd/c-63b9eb/c-edc564/c-ef9687 --></a>
					<div class="btn-layer">
						<ul id="colorArea${PORTLET_ID}">
							<li cl="b2b7bd"><a href="javascript:void(0);"><span class="color c-b2b7bd">b2b7bd</span></a></li>
							<li cl="ff0000"><a href="javascript:void(0);"><span class="color c-ff0000">ff0000</span></a></li>
							<li cl="edc564"><a href="javascript:void(0);"><span class="color c-edc564">edc564</span></a></li>
							<li cl="ffff00"><a href="javascript:void(0);"><span class="color c-ffff00">ffff00</span></a></li>
							<li cl="008000"><a href="javascript:void(0);"><span class="color c-008000">008000</span></a></li>
							<li cl="63b9eb"><a href="javascript:void(0);"><span class="color c-63b9eb">63b9eb</span></a></li>
							<li cl="150aca"><a href="javascript:void(0);"><span class="color c-150aca">150aca</span></a></li>
							<li cl="800080"><a href="javascript:void(0);"><span class="color c-800080">800080</span></a></li>
						</ul>
					</div>
				</div>
				</div>
		<div class="btns">
			<a href="javascript:void(0);" class="btnDel" id="btnDel${PORTLET_ID}"><img src="<c:url value="/kanban/css/img/btn_ico_del.png"/>"></a>
			<a href="javascript:void(0);" class="btnCloseLayer" id="btnCloseLayer${PORTLET_ID}"><kfmt:message key="pd.card.022"/></a>
		</div>
		<div class="tit${PORTLET_ID}" id="tit${PORTLET_ID}"></div>
	</div>
	 <%-- <div class="cardSet">
		<div class="setL">
			<div class="sltBtns${PORTLET_ID}">
				 <div class="sltBtn pulldown color" id="colorDiv${PORTLET_ID}">
					<a href="javascript:void(0);" class="btn"><span class="color" id="colorSet${PORTLET_ID}"></span><!-- c-b2b7bd/c-63b9eb/c-edc564/c-ef9687 --></a>
					<div class="btn-layer">
						<ul id="colorArea${PORTLET_ID}">
							<li cl="b2b7bd"><a href="javascript:void(0);"><span class="color c-b2b7bd">b2b7bd</span></a></li>
							<li cl="ff0000"><a href="javascript:void(0);"><span class="color c-ff0000">ff0000</span></a></li>
							<li cl="edc564"><a href="javascript:void(0);"><span class="color c-edc564">edc564</span></a></li>
							<li cl="ffff00"><a href="javascript:void(0);"><span class="color c-ffff00">ffff00</span></a></li>
							<li cl="008000"><a href="javascript:void(0);"><span class="color c-008000">008000</span></a></li>
							<li cl="63b9eb"><a href="javascript:void(0);"><span class="color c-63b9eb">63b9eb</span></a></li>
							<li cl="150aca"><a href="javascript:void(0);"><span class="color c-150aca">150aca</span></a></li>
							<li cl="800080"><a href="javascript:void(0);"><span class="color c-800080">800080</span></a></li>
						</ul>
					</div>
				</div> 
			</div>
		</div>
		<div class="setR" id="setR${PORTLET_ID}"></div>
	</div>  --%>
	<div class="description" id="description${PORTLET_ID}">
		<p class="tit"><span class="txt"><kfmt:message key="pd.card.023"/></span><a href="javascript:void(0);" class="btnEdit" id="btnEdit${PORTLET_ID}"><span><kfmt:message key="pd.card.003"/></span></a></p>
		<p class="info" id="info${PORTLET_ID}"></p>
		<div class="editArea">
			<div id="contentArea${PORTLET_ID}"></div>
			<div class="btns">
				<a href="#" onclick="return false;" class="KButton btn H29_blue" id="contentSave${PORTLET_ID}" style="margin-right:3px;"><span class="btn_edge"></span><span class="btn_content" title="<kfmt:message key="pd.card.024"/>"><kfmt:message key="pd.card.024"/></span><span class="btn_edge"></span></a>
				<a href="#" onclick="return false;" class="KButton btn H29" id="contentCancel${PORTLET_ID}"><span class="btn_edge"></span><span class="btn_content" title="<kfmt:message key="pd.card.025"/>"><kfmt:message key="pd.card.025"/></span><span class="btn_edge"></span></a>
			</div>
		</div>
	</div>
	<div class="component-area">
		<table class="TemplateLayoutFrame" cellpadding="0" cellspacing="0">
			<tbody>
				<tr>
					<td>
						<div class="TemplateLayoutLeft">
							<table class="TemplateLayoutTitle" cellpadding="0" cellspacing="0">
								<tbody>
									<tr class="titleTr">
										<td class="TemplateLayoutTitleLeft" align="left"></td>
										<td class="TemplateLayoutTitleCenter" align="center"></td>
										<td class="TemplateLayoutTitleRight" align="right"></td>
									</tr>
								</tbody>
							</table>
							<table class="TemplateLayoutPath" cellpadding="0" cellspacing="0">
								<tbody>
									<tr class="pathTr">
										<td class="pathTd" align="center"></td>
									</tr>
								</tbody>
							</table>
							<div class="TemplateLayoutLeftView">
								<table class="TemplateLayoutMain" cellpadding="0" cellspacing="0">
									<tbody>
										<tr class="mainTr">
											<td class="mainTd">
												<div class="ItemLayout">
													<div class="itemLayoutDiv1" style="display: block;">
														<table class="ItemLayoutMainHead" id="ItemLayoutMainHead1" cellspacing="0" cellpadding="0">
															<tbody>
																<tr class="mainHeadTr">
																	<td class="ItemLayoutMainHeadLeft" id="ItemLayoutMainHeadLeft1" align="left"></td>
																	<td class="ItemLayoutMainHeadCenter" id="ItemLayoutMainHeadCenter1" align="center"></td>
																	<td class="ItemLayoutMainHeadRight" id="ItemLayoutMainHeadRight1" align="right"></td>
																</tr>
															</tbody>
														</table>
													</div>
													<div class="itemLayoutDiv2">
														<table class="ItemLayoutMainBody" cellpadding="0" cellspacing="0">
															<tbody>
																<tr class="ItemLayoutMainBodyTr">
																	<td class="ItemLayoutMainBodyTd" id="ItemLayoutMainBodyTd1">
																		<div class="iLwriteDiv">
																			<table cellpadding="0" cellspacing="0" class="iLwriteTable">
																				<colgroup class="iLcolGroup" span="6">
																					<col width="100px">
																					<col>
																					<col width="55px">
																					<col width="100px">
																					<col>
																					<col width="55px">
																				</colgroup>
																				<tbody class="iLtableBody">
																					<tr class="iLwriteBasicTr">
																						<td class="iLwriteHeaderTd" colspan="1" rowspan="1">
																							<div class="ItemHeader">
																								<span class="iHwrite"><kfmt:message key="pd.card.030"/></span>
																							</div>
																						</td>
																						<td class="iLwriteTd" colspan="5" rowspan="1" id="dateTerm${PORTLET_ID}"><span id="dateReset${PORTLET_ID}" style="position:absolute;margin: 7px 0 0 230px; cursor: pointer; color: #818181;"><fmt:message key="pub.015"/></span></td>
																						</tr>
																					<tr class="iLwriteBasicTr">
																						<td class="iLwriteHeaderTd" colspan="1" rowspan="1">
																							<div class="ItemHeader">
																								<span class="iHwrite"><kfmt:message key="pd.card.031"/></span>
																							</div>
																						</td>
																						<td class="iLwriteTd" colspan="5" rowspan="1" id="files${PORTLET_ID}"></td>
																					</tr>
																				</tbody>
																			</table>
																		</div>
																	</td>
																</tr>
															</tbody>
														</table>
													</div>
													<div class="itemLayoutDiv3">
														<table class="ItemLayoutMainFoot" id="ItemLayoutMainFoot1" cellspacing="0" cellpadding="0" width="100%">
															<tbody>
																<tr class="mainFootTr">
																	<td class="ItemLayoutMainFootLeft" id="ItemLayoutMainFootLeft1"></td>
																	<td class="ItemLayoutMainFootCenter" id="ItemLayoutMainFootCenter1"></td>
																	<td class="ItemLayoutMainFootRight" id="ItemLayoutMainFootRight1"></td>
																</tr>
															</tbody>
														</table>
													</div>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
								<table class="TemplateLayoutEtc" cellspacing="0" cellpadding="0">
									<tbody>
										<tr class="etcTr">
											<td class="TemplateLayoutEtcLeft" align="left"></td>
											<td class="TemplateLayoutEtcCenter" align="center"></td>
											<td class="TemplateLayoutEtcRight" align="right"></td>
										</tr>
									</tbody>
								</table>
								<table class="TemplateLayoutDuplex" cellspacing="0" cellpadding="0">
									<tbody>
										<tr class="duplexTr">
											<td class="duplexTd"></td>
										</tr>
									</tbody>
								</table>
								<table class="TemplateLayoutOpinionTbl" cellspacing="0" cellpadding="0">
									<tbody>
										<tr>
											<td class="TemplateLayoutExtension" align="left" id="opinionArea${PORTLET_ID}"></td>
										</tr>
									</tbody>
								</table>
								<table class="TemplateLayoutTail" cellspacing="0" cellpadding="0">
									<tbody>
										<tr class="tailTr">
											<td class="tailTd" align="left"></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</td>
					<td>
						<div class="TemplateLayoutRight">
							<div class="TemplateLayoutContent"></div>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>
<%@ include file="/jspf/tail.portlet.jsp" %>