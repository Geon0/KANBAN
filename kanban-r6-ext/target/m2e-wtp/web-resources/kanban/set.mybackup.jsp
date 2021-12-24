<%@ include file="/jspf/head.portlet.jsp" %>
<style type="text/css">
.portletManage-layer${PORTLET_ID}{position:relative;height:100%;overflow:hidden;box-sizing:border-box;-moz-box-sizing:border-box;}
.portletManage-layer${PORTLET_ID} *{font-family:'Malgun Gothic','<fmt:message key="doc.250"/>';}
.portletManage-layer${PORTLET_ID}.has-bottomBtn{padding-bottom:94px;}
.portletManage-layer${PORTLET_ID} .contents{height:100%;overflow:auto;}
.portletManage-layer${PORTLET_ID} .bottom_btns{position:absolute;bottom:0;left:0;right:0;}
.portletManage-layer${PORTLET_ID} .bottom_btns .tiButtons{padding:30px;font-size:0;text-align:center;}
.portletManage-layer${PORTLET_ID} .bottom_btns .tiButtons .KButton{margin:0 5px;}
.portletManage-layer${PORTLET_ID} .home-builitin-ptl_set_data .groupDiv{*zoom:1;padding:30px 30px 0 30px;}
.portletManage-layer${PORTLET_ID} .home-builitin-ptl_set_data .groupDiv:after{content:'';display:block;clear:both;}
.portletManage-layer${PORTLET_ID} .home-builitin-ptl_set_data .ListViewer{border:none;background:#FFF;}
.portletManage-layer${PORTLET_ID} .home-builitin-ptl_set_data .leftArea{float:left;width:320px;border:1px solid #eaeaea;border-radius:4px;box-sizing:border-box;-moz-box-sizing:border-box;}
.portletManage-layer${PORTLET_ID} .home-builitin-ptl_set_data .rightArea{float:left;width:320px;border:1px solid #eaeaea;border-radius:4px;box-sizing:border-box;-moz-box-sizing:border-box;}
.portletManage-layer${PORTLET_ID} .home-builitin-ptl_set_data .rightArea .ListViewer{border:none;}
.portletManage-layer${PORTLET_ID} .home-builitin-ptl_set_data .rightArea .header{height:48px;padding:0 15px;border-bottom:1px solid #eaeaea;overflow:hidden;}
.portletManage-layer${PORTLET_ID} .home-builitin-ptl_set_data .rightArea .header .guide{position:relative;display:block;min-height:30px;padding-left:24px;margin-top:15px;color:#777;font-size:13px;letter-spacing:-0.25px;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;}
.portletManage-layer${PORTLET_ID} .home-builitin-ptl_set_data .rightArea .header .guide .info{position:absolute;top:0;left:0;display:block;width:16px;height:16px;border:1px solid rgba(0,0,0,0.18);border-radius:50%;}
.portletManage-layer${PORTLET_ID} .home-builitin-ptl_set_data .rightArea .header .guide .info span{display:block;width:2px;height:8px;margin:4px auto 0 auto;background:url(<c:url value="/img/ico_infox000.png"/>) 0 0 no-repeat;opacity:0.3;font-size:0;text-indent:-9999px;}
.portletManage-layer${PORTLET_ID} .home-builitin-ptl_set_data .middleArea{float:left;width:72px;padding-top:172px;text-align:center;}
.portletManage-layer${PORTLET_ID} .home-builitin-ptl_set_data .middleArea .ico_wrap{position:relative;display:inline-block;}
.portletManage-layer${PORTLET_ID} .home-builitin-ptl_set_data .middleArea .ico_wrap .ico_area{cursor:pointer;display:block;padding:8px;transition:all .15s ease-out;-moz-transition:all .15s ease-out;-webkit-transition:all .15s ease-out;-ms-transition:all .15s ease-out;-o-transition:all .15s ease-out;}
.portletManage-layer${PORTLET_ID} .home-builitin-ptl_set_data .middleArea .ico_wrap .ico_area img{position:relative;z-index:1;display:block;width:18px;height:18px;opacity:0.5;}
.portletManage-layer${PORTLET_ID} .home-builitin-ptl_set_data .middleArea .ico_wrap .ico_area:before{content:'';position:absolute;top:0;bottom:0;left:0;right:0;border-radius:50%;background:rgba(0,0,0,0.05);transition:all .15s ease-out;-moz-transition:all .15s ease-out;-webkit-transition:all .15s ease-out;-ms-transition:all .15s ease-out;-o-transition:all .15s ease-out;}
</style>
<script type="text/javascript">
JSV.Block(function () {
	var ptlMapId = JSV.modal.layerArgs.ptlMapId || null;
	if (ptlMapId == null)
		$('.ui-dialog-title').text('<kfmt:message key="pd.134"/>');
	var model = JSV.loadJSON(JSV.getModuleUrl('/jsl/KbItemOwner.GetCategoryInfo.json')).array;
	var mUrl = JSV.getModuleUrl('/jsl/KbItemOwner.GetCategoryInfo.json');
		
	var orgModel = [];
	var myModel = [];

	for(var i = 0; i<model.length; i++){
		orgModel = JSON.parse(model[i].content);
	}

	

	
	function MyBoardLabelProvider() {
	}
	MyBoardLabelProvider.prototype.getText = function(obj) {
		return obj.title; 
	}
	
	var leftList = new ListViewer($('#myLeftArea${PORTLET_ID}'), {height:410, isAllDraw:true});
	leftList.setLabelProvider(new MyBoardLabelProvider());
	leftList.ondblclick = function(obj) {
		var val = rightList.getValue();
		val.push(JSV.clone(obj));
		leftList.removeSelection();
		rightList.setValue(val);
	}
	leftList.setValue(orgModel);
	
	var rightList = new ListViewer($('#myRightArea${PORTLET_ID}'), {height:361, isDel:true, isSortable:true});
	rightList.setLabelProvider(new MyBoardLabelProvider());
	rightList.ondblclick = function(obj) {
		var val = leftList.getValue();
		val.push(JSV.clone(obj));
		rightList.removeSelection();
		leftList.setValue(val);
	}
	rightList.onDelClick = function(dataObj, delBtn, clickId, succDelFunc) {
		var val = leftList.getValue();
		val.push(JSV.clone(dataObj));
		leftList.setValue(val);
		succDelFunc();
	}
	rightList.setValue(myModel);
	

	$('#moveIcon${PORTLET_ID}').click(function() {
		var sel = leftList.getSelected();
		if (sel) {
			var val = rightList.getValue();
			val.push(JSV.clone(sel));
			leftList.removeSelection();
			rightList.setValue(val);
		} else {
			JSV.alert('<fmt:message key="pub.007"/>');
		}
	});
	var tiButtons = $('#setTiButtons${PORTLET_ID}');
	var isOk = false;
	var okBtn = new KButton(tiButtons, <fmt:message key="btn.pub.set.icon"/>);
	okBtn.onclick = function() {
		if (isOk) {
			JSV.alert('<fmt:message key="ecm.doc.127"/>');
		} else {
			isOk = true;
			var item = {item:[]};
			var val = rightList.getValue();
			for (var i = 0; i < val.length; i++) {
				var obj = {uuid:val[i].uuid,title:val[i].title};
				item.item.push(obj);
			}
			var sUrl = '/jsl/KbItemOwner.DoBackupCard.jsl';
			$.ajax({
    			url : JSV.getContextPath(JSV.getModuleUrl(sUrl)),
    			type : 'POST',
    			dataType : 'json',
    			data : {item:JSV.toJSON(item)},
    			success : function(data, status){
    				JSV.layerDialogClose();
    				location.reload();
    			},
    			error : function(xhr){
    				isOk = false;
    				JSV.alert('<fmt:message key="space.417"/>');
    			}
    		});
		}		
	}
	
	var cancelBtn = new KButton(tiButtons, <fmt:message key="btn.pub.cancel_bg"/>);	
	cancelBtn.onclick = function() {
		JSV.layerDialogClose();
	}
});
</script>
<div class="portletManage-layer${PORTLET_ID} has-bottomBtn"><!--add class:has-bottomBtn(버튼포함한 팝업)-->
	<div class="contents">
		<div class="home-builitin-ptl_set_data">
			<div id="groupDiv${PORTLET_ID}" class="groupDiv">
				<div id="myLeftArea${PORTLET_ID}" class="leftArea"></div>
				<div class="middleArea">
					<div class="ico_wrap"><span id="moveIcon${PORTLET_ID}" class="ico_area"><img src="<c:url value="/img/btn/pub/btn_ico_move_right.png"/>" alt="" class="ico"></span></div>
				</div>
				<div id="myRightArea${PORTLET_ID}" class="rightArea">
					<div class="header">
						<p class="guide"><span class="info"><span>!</span></span><kfmt:message key="pd.135"/></p>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="bottom_btns">
		<div id="setTiButtons${PORTLET_ID}" class="tiButtons"></div>
	</div>
</div>
<%@ include file="/jspf/tail.portlet.jsp" %>