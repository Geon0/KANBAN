<%@ include file="/jspf/head.portlet.jsp" %>
<style type="text/css">
.TextFieldEditor {ime-mode:active; padding: 6px 8px;height: 25px;line-height: 14px;width: 100%;color: #20232C;border: 1px solid #EDEDED;border-top-color: #C5C5C5;border-left-color: #C5C5C5;-moz-box-sizing: border-box;box-sizing: border-box;-webkit-appearance:none;}
.TextFieldEditor_normal {}
.TextFieldEditor_focus {border-color: #8598A5;outline:none;}
.TextFieldEditor_exam {color:#a3a3a3;}
.TextFieldEditor_original {color:#20232C}
.TextFieldEditor_readOnly {background-color: #F0F0F0;border-color: #E9E9E9;border-top-color: #C5C5C5;border-left-color: #C5C5C5;}
/*header*/
.card-detail${PORTLET_ID} .header{*zoom:1;height:47px;}
.card-detail${PORTLET_ID} .header:after{content:'';display:block;clear:both;}
.card-detail${PORTLET_ID} .header .btns{float:right;padding-left:20px;margin-top:14px;margin-right:16px;}
.card-detail${PORTLET_ID} .header .btnDel{position:relative;float:left;padding:5px 10px;margin-right:7px;color:#525252;font-size:12px;}
.card-detail${PORTLET_ID} .header .btnDel:before{content:'';position:absolute;top:5px;right:0;display:block;width:1px;height:12px;background:#d2d2d2;}
.card-detail${PORTLET_ID} .header .btnCloseLayer{float:left;display:block;width:12px;height:12px;padding:5px;background:url(css/img/btn_close_layer.png) 5px 5px no-repeat;font-size:0;text-indent:-9999px;}
.card-detail${PORTLET_ID} .header .btnCloseLayer:hover{background-image:url(css/img/btn_close_layer_hover.png);}
.card-detail${PORTLET_ID} .header .tit{color:#313131;font-size:16px;font-family:nanumgothic,'Gulim','Dotum';font-weight:700;letter-spacing:-0.5px;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;height:47px;}

/*description*/
.card-detail${PORTLET_ID} .description{padding:2px 25px 12px 25px;}
.card-detail${PORTLET_ID} .description .tit{*zoom:1;}
.card-detail${PORTLET_ID} .description .tit:after{content:'';display:block;clear:both;}
.card-detail${PORTLET_ID} .description .tit .txt{float:left;display:block;cursor:default;color:#313131;font-size:14px;font-family:nanumgothic,'Gulim','Dotum';font-weight:700;letter-spacing:-0.5px;}
.card-detail${PORTLET_ID} .description .tit .btnEdit{float:left;display:block;width:13px;height:13px;padding:5px;margin-top:-3px;margin-left:3px;background:url(css/img/btn_edit_tit_description.png) 5px 5px no-repeat;}
.card-detail${PORTLET_ID} .description .tit .btnEdit:hover{background-image:url(css/img/btn_edit_tit_description_hover.png);}
.card-detail${PORTLET_ID} .description .tit .btnEdit span{font-size:0;text-indent:-9999px;}
.card-detail${PORTLET_ID} .description .info{margin-top:5px;margin-bottom:8px;color:#525252;font-size:12px;letter-spacing:-0.5px;line-height:20px;}
.card-detail${PORTLET_ID} .description .editArea{margin:11px 1px 0 1px; display:block;}
.card-detail${PORTLET_ID} .description .editArea .btns{margin-top:20px;margin-left:1px;font-size:0;}
.card-detail${PORTLET_ID} .description .editArea .btns .btn{font-size:12px;}

</style>
<script type="text/javascript">
JSV.Block(function () {
	openEditor = $('#layer${PORTLET_ID}').parent().data('CTOpenEditor');
	var title = $('#layer${PORTLET_ID}').parent().data('CTGTitle');
	var TitleEditor${PORTLET_ID} = new TextFieldEditor($('#contentArea${PORTLET_ID}'), {'maxLength':'20'});
	TitleEditor${PORTLET_ID}.setValue(title);
	<%--닫기--%>
	$('#btnCloseLayer${PORTLET_ID}').click(function(){
		close${PORTLET_ID}();
	});
	
	$('#contentSave${PORTLET_ID}').click(function(){
		openEditor.callback.updateTitle(TitleEditor${PORTLET_ID}.getValue());
		close${PORTLET_ID}();
	});
	
	$('#contentCancel${PORTLET_ID}').click(function(){
		close${PORTLET_ID}();
	});
}, '${PORTLET_ID}');
var chargers${PORTLET_ID};
var attchment${PORTLET_ID};
var openEditor;

function loadFiles(value){
	attchment${PORTLET_ID}.setValue(value.attachments);
}
function close${PORTLET_ID}(){
	$('body').find('.CardOpenEditor').remove();
}
</script>
<div class="layer card-detail${PORTLET_ID}" id="layer${PORTLET_ID}">
	<div class="header">
		<div class="btns">
			<a href="javascript:void(0);" class="btnCloseLayer" id="btnCloseLayer${PORTLET_ID}"><kfmt:message key="pd.card.022"/></a>
		</div>
		<div class="tit" id="tit${PORTLET_ID}"><kfmt:message key="pd.card.036"/></div>
	</div>
	<div class="description" id="description${PORTLET_ID}">
		<p class="info" id="info${PORTLET_ID}"></p>
		<div class="editArea">
			<div id="contentArea${PORTLET_ID}"></div>
			<div class="btns">
				<a href="#" onclick="return false;" class="KButton btn H29_blue" id="contentSave${PORTLET_ID}" style="margin-right:3px;"><span class="btn_edge"></span><span class="btn_content" title="<kfmt:message key="pd.card.024"/>"><kfmt:message key="pd.card.024"/></span><span class="btn_edge"></span></a>
				<a href="#" onclick="return false;" class="KButton btn H29" id="contentCancel${PORTLET_ID}"><span class="btn_edge"></span><span class="btn_content" title="<kfmt:message key="pd.card.025"/>"><kfmt:message key="pd.card.025"/></span><span class="btn_edge"></span></a>
			</div>
		</div>
	</div>
</div>
<%@ include file="/jspf/tail.portlet.jsp" %>