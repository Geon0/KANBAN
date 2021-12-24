<%@ include file="/sys/jsv/template/template.head.jsp" %>
<%@ include file="/kanban/jsv-kanban-ext.jsp" %>
<link href="<%=request.getContextPath()%>/kanban/css/workboard.css" rel="stylesheet">
<link type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/lib/com/kcube/jsv/plugin/jquery/ui/jquery-ui-1.12.1.custom.css">
<script type="text/javascript" src="<%=request.getContextPath()%>/lib/com/kcube/jsv/plugin/jquery/ui/jquery-ui-1.12.1.custom.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/lib/com/kcube/jsv/plugin/jquery/ui/i18n/jquery-ui-i18n.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/lib/com/kcube/jsv/plugin/jquery/contextmenu/jquery.ui-contextmenu.js"></script>
<script type="text/javascript">

<%--
기본 화면 리사이즈
--%>
function resizeMain() {
	var bodyHeight = $(window).height();
	var cardAreaHeight = $('.cardArea').height();
	var ctHeaderHeight = $('.ctHeader').height();
	var wbHeight = $('.wb-header').height();
	var Height = bodyHeight-2*(ctHeaderHeight+wbHeight);
	$('.cardList').css("overflow", "auto");
	$('.cardList').css("height", Height);
	$(window).resize(function() {
		var windowHeight = $(window).height();
		var diHeight = bodyHeight-windowHeight;
		 $('.cardList').css({height: Height - diHeight});
	});
}

<%--
백업된 삭제된 카드 보관함 리사이즈
--%>
function resizeCardBox() {
	var bodyHeight = $(window).height();
	var cardAreaHeight = $('.cardArea').height();
	var ctHeaderHeight = $('.ctHeader').height();
	var wbHeight = $('.wb-header').height();
	var Height = bodyHeight-1.5*(ctHeaderHeight+wbHeight);
	$('.cardList').css("overflow", "auto");
	$('.cardList').css("height", Height);
	$(window).resize(function() {
		var windowHeight = $(window).height();
		var diHeight = bodyHeight-windowHeight;
		 $('.cardList').css({height: Height - diHeight});
	});
}


function workMainBoard(parent, style){
	this.parent = parent;
	this.style = style;
	this.isDel = 'N';
	this.updateLayoutUrl = style.updateLayout;
	this.delLayoutUrl = style.delLayout;
	this.backupLayoutUrl = style.backupLayout;
	this.restoreLayoutUrl = style.restoreLayout;
	this.registCardUrl = style.registCard;
	this.categoryUpdate = style.categoryUpdate;
	this.dragUpdateCardsUrl = style.dragUpdateCards;
	this.init();
}

<%--
검색창 엔터키 처리 
--%>

function searchValue(){
	if (window.event.keyCode == 13) {
		var searchValue = $('#search').val();
		if(searchValue){
			localStorage.setItem('search', searchValue);
		}else{
			localStorage.clear();
		}
		window.location.reload();
		$('#search').attr('value',searchValue);
	
	}
}

workMainBoard.prototype.init = function(){
	this.drowMainLayout();
	this.p_wbtit.text(this.style.title ? this.style.title : 'WORKBOARD');
	this.drowCtHeader();
	this.finishFoldingEvent();
	this.categoryAddEvent();
	this.commonEvent();	
}
workMainBoard.prototype.clear = function(){
	this.div_workboard.remove();
}
workMainBoard.prototype.changedelbox = function(){
	this.isDel = 'Y';
	this.div_workboard.remove();
	this.init();
	if(this.initValue != null){
		this.setValue(this.initValue);
	}
	resizeCardBox();
}
workMainBoard.prototype.changebox = function(){
	this.isDel = 'N';
	this.div_workboard.remove();
	this.init();
	if(this.initValue != null){
		this.setValue(this.initValue);
	}
	resizeMain();
}
workMainBoard.prototype.changebackupbox = function(){
	this.isDel = 'B';
	this.div_workboard.remove();
	this.init();
	if(this.initValue != null){
		this.setValue(this.initValue);
	}
	resizeCardBox();
}
workMainBoard.prototype.commonEvent = function(){
	var component = this;
	$('body').css("overflow-y", "hidden");
	$('body').on('mouseup.gategoryDrag', function(event, ui){
		if(workMainBoard.dragCategoryObject){
			workMainBoard.dragCategoryObject.css({'position':'','top':'','width': '', 'height': '', 'z-index': ''});
			workMainBoard.dragCategoryObject.css({});
			workMainBoard.dragCategoryObject.removeClass('dragclose');
		}
		$('.category-wrap .category').each(function(index, item) {
			$(item).removeClass('dragclose');
		});
	});
	this.delcardbox.on('click', function(){
		if(component.isDel == 'N'){
			component.changedelbox();
		}else{
			component.changebox();
		}
	})
	this.backupcardbox.on('click', function(){
		if(component.isDel == 'N'){
			component.changebackupbox();
		}else{
			component.changebox();
		}
	}) 
}
workMainBoard.prototype.setValue = function(value){
	this.initValue = value;
	this.itemid = value.id;
	var addP = '&isDel=' + this.isDel;
	
	<%-- 
	백업하기 버튼 
	모달창
	--%>
	this.backupButton.on('click',function(){
		var param = {};
	    JSV.showLayerModalDialog(JSV.getContextPath('/kanban/set.mybackup.jsp'), param, {title:'<fmt:message key="ptl.manager.056"/>', width:873, height:406, resizable: true}, function(value) {
	    });
	})
	
	<%-- 
	검색 버튼
	검색 창 setValue
	--%>
	var searchValue = null;
	
	this.searchBtn.on('click',function(){
		searchValue = $('#search').val();
		if(searchValue){
			localStorage.setItem('search', searchValue);
		}else{
			localStorage.clear();
		}
		window.location.reload();
	})

	$('#search').val(localStorage.getItem('search'));
	
	this.home.on('click',function(){
		localStorage.removeItem('search');
		window.location.reload();
	})
	
	console.log('this',this.isDel);
	this.permission = true;
	this.cardList = JSV.loadJSON(value.cardInfo + addP);
	if(this.isDel == 'B'){
		this.layoutInfo = JSV.loadJSON(value.categoryBackupInfo + addP);
		this.div_workboard.find('.BackupBtn').remove();
		this.div_workboard.find('.btnOutbox').remove();
	}else if(this.isDel == 'Y'){
		this.layoutInfo = JSV.loadJSON(value.categoryInfo + addP);
		this.div_workboard.find('.BackupBtn').remove();
		this.div_workboard.find('.BtnOutbox').remove();
	}else{
		this.layoutInfo = JSV.loadJSON(value.categoryInfo + addP);
	}
	if(this.isDel == 'B' || this.isDel == 'Y'){
		this.permission = false;
	}
	this.setValueCategory();
	this.setValueCard();
	this.doPermission();
	this.foldingInfo();
}

workMainBoard.prototype.doPermission = function(){
	if(!this.permission){
		this.div_workboard.find('.btnEdit').remove();
		this.div_workboard.find('.btnDelete').remove();
		this.div_workboard.find('.btnAdd').remove();
		this.div_workboard.find('.btnAddContents').remove();
		this.div_workboard.find('.delBtn').remove();
		this.div_workboard.find('.delBtnHide').remove();
		this.div_workboard.find('.search').remove();
		this.div_workboard.find('.searchBtn').remove();
	}
	if(this.isDel == 'N') {
		$('.btnRestore').hide();
	}
}

<%--
왼쪽 분류 카테고리 setValue function
--%>

workMainBoard.prototype.setValueCategory = function(){
	var value = this.layoutInfo;
	for(var i = 0; i < value.length; i++){
		var ct = this.makeCategory(this.cardAreaUL);
		ct.categoryWideTit.text(value[i].title);
		ct.categoryTit.html(value[i].title.replace(/\s/gi, '<div class="ctBr"></div>'));
		ct.categoryTit.attr('title',value[i].title);
		ct.wrap.attr('uuid',value[i].uuid);
		var ctFold = JSON.parse(localStorage.getItem(value[i].uuid));
		if(ctFold == 1){
			ct.category.addClass("category close");
		}
		this.categoryBtnEvent(ct);
	}
	if(this.isDel == 'N'){
		if(this.permission) this.categoryDragEvent();
	}else if(this.isDel == 'B'){
		var ct = this.makeCategory(this.cardAreaUL);
		ct.wrap.remove();
		this.categoryBtnEvent(ct);
	}
	else{
		var ct = this.makeCategory(this.cardAreaUL);
		ct.categoryTit.text(JSV.getLang('WorkBoard','delCtgTit'));
		ct.wrap.attr('uuid',workMainBoard.deleteCtg);
		this.categoryBtnEvent(ct);
	}

}

<%--
setValueCare function
카드를 만든 후 정보를 업데이트한다.
--%>

workMainBoard.prototype.setValueCard = function(){
	var value = this.cardList.array;
	var searchValue = localStorage.getItem('search');
	
	for(var i = 0; i < value.length; i++){
		if(value[i].title.indexOf(searchValue) == 0 || searchValue == null) {
			var ctg = this.findCategory(value[i].rowPoint, value[i].columnPoint);
			var card = this.makeCard(ctg[0], ctg[1]);
			this.updateCardInfo(card, value[i]);
			this.cardClickEvent(card);
			this.foldCardInfo(card, value[i]);
		}
		if(value[i].content !== null && value[i].content.indexOf(searchValue) == 0) {
			var ctg = this.findCategory(value[i].rowPoint, value[i].columnPoint);
			var card = this.makeCard(ctg[0], ctg[1]);
			this.updateCardInfo(card, value[i]);
			this.cardClickEvent(card);
			this.foldCardInfo(card, value[i]);
		}
	}
	if(this.isDel == 'N' && this.permission){
		this.cardDragEvent();
	}
	this.countCard();
}
workMainBoard.prototype.countCard = function(){
	var waitCount = 0;
	var ingCount = 0;
	var finishCount = 0;
	this.cardArea.find('.card-wrap').each(function(index, item){
		if($(item).parent().hasClass('wait')){
			waitCount++;
		}else if($(item).parent().hasClass('ing')){
			ingCount++;
		}else if($(item).parent().hasClass('finish')){
			finishCount++;
		} 
	});
	this.ctHeaderStatusWait.num.text(waitCount);
	this.ctHeaderStatusIng.num.text(ingCount);
	this.ctHeaderStatusFinish.num.text(finishCount);
	this.categoryResize(false);
}
workMainBoard.prototype.categoryResize = function(reset){
	$('.titBox').each(function(n){
		if(reset){
			$(this).find('span.txt').css({'max-height':86});
		}else{
			$(this).find('span.txt').css({'max-height':$(this).height() - 129});
		}
	})
}
workMainBoard.dragCategoryObject = null;

<%--
왼쪽 분류 카테고리 DragEvent function
--%>

workMainBoard.prototype.categoryDragEvent = function(){
	var component = this;
	this.div_workboard.find(".cardList").sortable({
		connectWith : ".category-wrap",
		handle : ".dragArea",
		placeholder : "category-placeholder"
	});
	
	var ulObject = this.cardAreaUL;
	
	this.div_workboard.find( ".dragArea" ).on('mousedown',function(e){
		var target = $(this).parent().parent().parent();
		if(!target.hasClass('dragclose')){
			target.addClass('dragclose');
		}
		$('.category-wrap .category').each(function(index, item) {
			if(!$(item).hasClass('dragclose')){
				$(item).addClass('dragclose');
			}
		});
		var parentOffset = $(this).parent().offset(); 
		var relY = e.pageY - parentOffset.top;
		target.css({'top':relY - 42, 'z-index':999});
		workMainBoard.dragCategoryObject = target;
	});
	this.div_workboard.find( ".dragArea" ).on('mouseup',function(event, ui){
	});
	this.div_workboard.find( ".cardList" ).on( "sortstart", function( event, ui ) {

	} );
	this.div_workboard.find( ".cardList" ).on( "sortstop", function( event, ui ) {
		if($(ui.item).hasClass('category-wrap')){
			$('.category-wrap .category').each(function(index, item) {
				$(item).removeClass('dragclose');
			});
			$(ui.item).css({'width': null, 'height': null});
		}
	} );
	this.div_workboard.find( ".cardList" ).on( "sortupdate", function( event, ui ) {
		if($(ui.item).hasClass('category-wrap')){
			component.updateLayout();
		}
	} );	
}

<%--
카드 DragEvent function
--%>

workMainBoard.prototype.cardDragEvent = function(){
	var component = this;	
	this.div_workboard.find(".column").sortable({
		connectWith : ".column",
		handle : ".card",
		placeholder : "card-placeholder",
		update: function (event, ui) {
			component.countCard();
		}
	});
	$( ".column" ).on( "sortstart", function( event, ui ) {
		ui.placeholder.height(ui.item.height());
		component.categoryResize(true);
	} );
	$( ".column" ).on( "sortstop", function( event, ui ) {
	} );
	this.div_workboard.find( ".column" ).on( "sortupdate", function( event, ui ) {
		if($(ui.item).hasClass('card-wrap')){
			if(ui.sender){
				component.cardsUpdate(ui.sender);
			}else{
				component.cardsUpdate(ui.item.parent());
			}
		}
	} );
}
workMainBoard.prototype.cardClickEvent = function(card){
	
	var component = this;
	card.updateTitle = function(title){
		if(title){
			card.cardTit.text(title);
		}
	};
	card.deleteCard = function(){
		card.wrap.remove();
		card = null;
		component.countCard();
	}
	card.updateContent = function(content){
		if(content){
			card.cardContent.setValue(content);
		}
	}
	
	card.updateColor = function(color){
		if(color){
			card.cardColor.css('border-left-color', '#'+ color);
		}
	}
	
	card.updateFileCnt = function(cnt){
		card.fileNum.text(cnt);
		card.fileNumHide.text(cnt);
	}
	
	card.updateCount = function(cnt){
		card.replyNum.text(cnt);
		card.replyNumHide.text(cnt);
	}
	
	card.updateSec = function(sec){
		card.sec = sec;
		if(sec){
			card.lock.css('display','block');
		}else{
			card.lock.css('display','none');
		}
	}
	
	card.updateDate = function(obj){
		card.dateTermValue = [];
		var isStart = true;
		var isEnd = true;
		if(obj.startDate){
			card.dateTermValue[0] = obj.startDate;
		}else{
			isStart = false;
		}
		if(obj.endDate){
			card.dateTermValue[1] = obj.endDate;
		}else{
			isEnd = false;
		}
		if(!isStart && !isEnd){
			card.dateTerm.widget.hide();
		}else{
			card.dateTerm.widget.show();
			card.dateTerm.setValue(card.dateTermValue);
		}
	}

	card.cardTit.on('click',function(){
		if(component.permission && component.isDel == 'N'){
			var coe = new CardOpenEditor($('body'),{url:'/kanban/usr.card.edit.jsp?id=', callback: card});
			coe.setValue(card.cardid);
		}else{
			var coe = new CardOpenEditor($('body'),{url:'/kanban/usr.card.read.jsp?id=', callback: card});
			coe.setValue(card.cardid);
		}
	})
	
	<%-- 
	카드 폴딩 이벤트
	--%>
	card.folddingBar.on('click',function(){
		var parent = $(this).parent().parent();
		var isFold = $(this).parent().parent().parent().parent();
		var isFoldValue = $(this).parent().parent().parent().parent().attr('fold');
		if (isFoldValue == 0) {
			parent.find('#fileNumHide').show();
			parent.find('#replyNumHide').show();
			parent.find('#delBtnHide').show();
			parent.parent().find('.cardCt').hide();
			parent.parent().find('.cardBtm').hide();
			isFold.attr('fold',1);
			var cardid = card.cardid;
			localStorage.setItem(cardid, 1);
		} else {
			parent.find('#fileNumHide').hide();
			parent.find('#replyNumHide').hide();
			parent.find('#delBtnHide').hide();
			parent.parent().find('.cardCt').show();
			parent.parent().find('.cardBtm').show();
			isFold.attr('fold',0);
			var cardid = card.cardid;
			localStorage.removeItem(cardid);
			localStorage.setItem(cardid, 0);
		}
	})
	
	card.delBtn.on('click',function(){
		if(confirm('<fmt:message key="pub.003"/>')){
			$.ajax({
				url : JSV.getContextPath('/jsl/KbItemCardUser.CardDelete.jsl'),
				data : {id:card.cardid${PORTLET_ID}},
				dataType : 'json',
				success : function(data) {
					close${PORTLET_ID}();
					location.reload();
				},
				error : function() {
					alert('<kfmt:message key="pd.128"/>');
				}
			});
		}
	})

}

<%--
카드 DragEvent에 카드 정보 Update function
--%>

workMainBoard.prototype.cardsUpdate = function(column){
	var component = this;
	var ctgObj = column.closest(".category-wrap").data('categoryObj');
	var ctgUUID = ctgObj.wrap.attr('uuid');
	var ctgTit = ctgObj.categoryWideTit.text();
	var colTit = column.attr('columnTit');
	var colPoint = column.attr('columnPoint');
	var updateCards = [];
	column.find('.card-wrap').each(function(i){
		var cardObj = $(this).data('cardObj');
		var card = {};
		card.cardid = cardObj.cardid;
		card.sort = i;
		card.rowPoint = ctgUUID;
		card.rowTitle = ctgTit;
		card.columnPoint = colPoint;
		card.columnTitle = colTit;
		updateCards.push(card);
	})
	$.ajax({
 		url : component.dragUpdateCardsUrl,
 		data : {cards:JSV.toJSON(updateCards)},
 		dataType : 'json',
 		success : function(data) {
 		},
 		error : function() {}
 	});
	this.cardArea.find('.column.wait').each(function(index, item){
		var cnt = $(item).find('.card-wrap').length;
		$(item).find('.foldingCnt').text(cnt);
	});
	this.cardArea.find('.column.ing').each(function(index, item){
		var cnt = $(item).find('.card-wrap').length;
		$(item).find('.foldingCnt').text(cnt);
	});
	this.cardArea.find('.column.finish').each(function(index, item){
		var cnt = $(item).find('.card-wrap').length;
		$(item).find('.foldingCnt').text(cnt);
	});
}

<%--
카테고리 수정 버튼 Event function
--%>

workMainBoard.prototype.categoryBtnEvent = function(obj){
	var component = this;
	obj.btnOc.click(function(){
		var ctFold = obj.category.attr('class');
		if(ctFold == "category"){
			obj.category.toggleClass('close');
			localStorage.setItem(obj.wrap.attr('uuid'), 1);
		}else {
			obj.category.toggleClass('close');
			localStorage.setItem(obj.wrap.attr('uuid'), 0);
		}
    });
	obj.btnEdit.on('mousedown', function(e){
		e.stopPropagation();
		var coe = new CTOpenEditor($('body'),{url:'/kanban/usr.ct.edit.jsp?id=', callback: obj});
		coe.open(obj.categoryWideTit.text());
		
	});
	obj.updateTitle = function(title){
		if(title && obj.categoryWideTit.text() != title){
			obj.categoryWideTit.text(title);
			obj.categoryTit.html(title.replace(/\s/gi, '<div class="ctBr"></div>'));

			component.cardInfoUpdate(obj.wrap.attr('uuid'), title);
			component.updateLayout();
		}
	};
	obj.btnEdit.click(function(){
		
	});
	obj.btnDelete.on('mousedown', function(e){
		e.stopPropagation();
		if(confirm('<kfmt:message key="pd.card.037"/>')) {
		    $.ajax({
 		 		url : component.delLayoutUrl,
 		 		data : {'uuid':obj.wrap.attr('uuid')},
 		 		dataType : 'json',
 		 		success : function(data) {
 		 			if(data && data.error != null){
 		 			}else{
 		 				obj.wrap.remove();
 		 		 		component.updateLayout();
 		 			}
 		 			
 		 		},
 		 		error : function() {
 		 		}
 		 	});	
		}
	});
	
	obj.btnRestore.on('mousedown', function(e){
		e.stopPropagation();
		if(confirm('<kfmt:message key="pd.card.048"/>')) {
		     $.ajax({
 		 		url : component.restoreLayoutUrl,
 		 		data : {'uuid':obj.wrap.attr('uuid'),'title':obj.categoryWideTit.text()},
 		 		dataType : 'json',
 		 		success : function(data) {
 		 			if(data && data.error != null){
 		 			}else{
 		 				obj.wrap.remove();
 		 			}
 		 			
 		 		},
 		 		error : function() {
 		 		}
 		 	});	 
		}
	});
	
	
	
	obj.btnAdd.click(function(){
		
		var cardInfo = {};
		cardInfo.title = workMainBoard.defaultCardTitle;
 		cardInfo.itemId = component.itemid;
 		cardInfo.rowPoint = obj.wrap.attr('uuid');
 		cardInfo.rowTitle = obj.categoryWideTit.text();
 		cardInfo.columnPoint = workMainBoard.defaultStatusCode;
 		cardInfo.columnTitle = workMainBoard.defaultStatusTitle;
        cardInfo.sort = obj.cardWaitArea.find('.card-wrap').length;
        $.ajax({
 			url : component.registCardUrl,
			data : {item:JSV.toJSON(cardInfo)},
 			dataType : 'json',
			success : function(data) {
				var card = component.makeCard(obj, obj.cardWaitArea);
				component.updateCardInfo(card, data);
				component.cardClickEvent(card);
				component.cardDragEvent();
				component.countCard();
			},
			error : function() {}
		});
		
    });
}

<%--
카테고리 추가 버튼 클릭 이벤트 function
--%>

workMainBoard.prototype.categoryAddEvent = function(){
	var component = this;
	this.div_addCategory.bind('click',function(){
		var ct = component.makeCategory(component.cardAreaUL);
		ct.categoryTit.text(JSV.getLang('WorkBoard','newCategory'));
		ct.categoryWideTit.text(JSV.getLang('WorkBoard','newCategory'));
		ct.wrap.attr('uuid',workMainBoard.generateUUID());
		component.categoryBtnEvent(ct);
		component.categoryDragEvent();
		component.updateLayout();
		component.cardDragEvent();
	})
}

<%--
왼쪽 분류 카테고리 Folding 처리 function
--%>

workMainBoard.prototype.finishFoldingEvent = function(){
	var component = this;
	
	//대기 버튼 클릭
	this.ctHeaderStatusWait.a.click(function(){
		$(this).toggleClass('close');
		if($(this).hasClass('close')) {
			$('.column.wait').addClass('folding');
			localStorage.setItem($(this).parent().parent().attr('class'), 1);
			component.cardArea.find('.column.wait').each(function(index, item){
				var cnt = $(item).find('.card-wrap').length;
				$(item).find('.foldingCnt').text(cnt);
			});
		} else {
			$('.column.wait').removeClass('folding');
			localStorage.setItem($(this).parent().parent().attr('class'), 0);
		}
    });	
	
	//진행 버튼 클릭
	this.ctHeaderStatusIng.a.click(function(){
		$(this).toggleClass('close');
		if($(this).hasClass('close')) {
			$('.column.ing').addClass('folding');
			localStorage.setItem($(this).parent().parent().attr('class'), 1);
			component.cardArea.find('.column.ing').each(function(index, item){
				var cnt = $(item).find('.card-wrap').length;
				$(item).find('.foldingCnt').text(cnt);
			});
		} else {
			$('.column.ing').removeClass('folding');
			localStorage.setItem($(this).parent().parent().attr('class'), 0);
		}
    });
	
	//완료 버튼 클릭
	this.ctHeaderStatusFinish.a.click(function(){
		$(this).toggleClass('close');
		if($(this).hasClass('close')) {
			$('.column.finish').addClass('folding');
			localStorage.setItem($(this).parent().parent().attr('class'), 1);
			component.cardArea.find('.column.finish').each(function(index, item){
				var cnt = $(item).find('.card-wrap').length;
				$(item).find('.foldingCnt').text(cnt);
			});
		} else {
			$('.column.finish').removeClass('folding');
			localStorage.setItem($(this).parent().parent().attr('class'), 0);
		}
    });
	
}

workMainBoard.prototype.foldingInfo = function(){
	var ss = localStorage.getItem('status finish');
	var oo = localStorage.getItem('status wait');
	var uu = localStorage.getItem('status ing');
	
	if(uu == 1){
		var uu = this.ctHeaderStatusIng.a;
		uu.toggleClass('close');
		if(uu.hasClass('close')){
		$('.column.ing').addClass('folding');
		this.cardArea.find('.column.ing').each(function(index, item){
			var cnt = $(item).find('.card-wrap').length;
			$(item).find('.foldingCnt').text(cnt);
		});
		}
	}
	
	 if(ss == 1){
		var cc = this.ctHeaderStatusFinish.a;
		cc.toggleClass('close');
		if(cc.hasClass('close')){
		$('.column.finish').addClass('folding');
		this.cardArea.find('.column.finish').each(function(index, item){
			var cnt = $(item).find('.card-wrap').length;
			$(item).find('.foldingCnt').text(cnt);
		});
		}
	} 
	
	if(oo == 1){
		var oo = this.ctHeaderStatusWait.a;
		oo.toggleClass('close');
		if(oo.hasClass('close')){
		$('.column.wait').addClass('folding');
		this.cardArea.find('.column.wait').each(function(index, item){
			var cnt = $(item).find('.card-wrap').length;
			$(item).find('.foldingCnt').text(cnt);
		});
		}
	}	
}


<%-- 
메인화면 그려주는 function
this.isDel == 'Y' 이면 삭제된 카드 보관함
--%>

workMainBoard.prototype.drowMainLayout = function(){
	this.div_workboard = $('<div>').addClass('workboard').appendTo(this.parent);
	this.div_wbheader = $('<div class="wb-header"><p class="wb-tit" id="workboardtitle"></p><div class="btns"><input type="text" id="search" class="search" onkeypress="searchValue();" required minlength="4" maxlength="8" size="10"><a class="searchBtn"><img src="<%=request.getContextPath()%>/kanban/css/img/btn_sch_depth01.png" alt="lock" class="lock"></a><a class="BackupBtn"><span id="backupbutton">' + JSV.getLang('WorkBoard','backupButton') + '</span></a><a class="BtnOutbox"><span id="backupbox">' + JSV.getLang('WorkBoard','backupCardBox') + '</span></a><a class="btnOutbox"><span id="delcardbox">' + JSV.getLang('WorkBoard','delCardBox') + '</span></a></div></div>').appendTo(this.div_workboard);
	this.p_wbtit = this.div_wbheader.find('#workboardtitle');
	this.div_wbcontainer = $('<div class="workboard"><div class="wb-container"><div class="contents"><div class="ctHeader" id="ctHeader"></div><div class="cardArea"><ul class="cardList"></ul></div><a class="btnAddContents"><span id="addCategory">' + JSV.getLang('WorkBoard','addCategory') + '</span></a></div></div></div>').appendTo(this.div_workboard);
	this.cardArea = this.div_wbcontainer.find('.cardArea');
	this.cardAreaUL = this.div_wbcontainer.find('.cardList');
	this.div_ctHeader = this.div_wbcontainer.find('#ctHeader');
	this.div_addCategory = this.div_wbcontainer.find('#addCategory');
	this.delcardbox = this.div_wbheader.find('.btnOutbox');
	this.backupcardbox = this.div_wbheader.find('.BtnOutbox');
	this.backupButton = this.div_wbheader.find('.BackupBtn');
	this.search = this.div_wbheader.find('#search');
	this.searchBtn = this.div_wbheader.find('.searchBtn');
	this.home = this.div_wbheader.find('.wb-tit');
	if(this.isDel == 'Y'){
		this.div_workboard.addClass('del');
		this.delcardbox.find('span').text(JSV.getLang('WorkBoard','returnBox'));
	}else if (this.isDel == 'B'){
		this.div_workboard.addClass('backup');
		this.backupcardbox.find('span').text(JSV.getLang('WorkBoard','returnBox'));
	}
}

<%-- 
대기, 진행, 완료 카테고리 그려주는 function
--%>

workMainBoard.prototype.drowCtHeader = function(){
	var statusWrapHTML = '<div class="status-wrap"><div class="status"><p class="num">0</p><p class="tit"></p></div></div>';
	this.ctHeaderStatusWait = {};
	this.ctHeaderStatusWait.wrap = $(statusWrapHTML).appendTo(this.div_ctHeader);
	this.ctHeaderStatusWait.status = this.ctHeaderStatusWait.wrap.find('.status').addClass('wait');
	this.ctHeaderStatusWait.num = this.ctHeaderStatusWait.wrap.find('.num');
	this.ctHeaderStatusWait.tit = this.ctHeaderStatusWait.wrap.find('.tit')
	this.ctHeaderStatusWait.a = $('<a class></a>').appendTo(this.ctHeaderStatusWait.tit);
	this.ctHeaderStatusWait.a.text(JSV.getLang('WorkBoard','waitTit'));
	
	this.ctHeaderStatusIng = {};
	this.ctHeaderStatusIng.wrap = $(statusWrapHTML).appendTo(this.div_ctHeader);
	this.ctHeaderStatusIng.status = this.ctHeaderStatusIng.wrap.find('.status').addClass('ing');
	this.ctHeaderStatusIng.num = this.ctHeaderStatusIng.wrap.find('.num');
	this.ctHeaderStatusIng.tit = this.ctHeaderStatusIng.wrap.find('.tit')
	this.ctHeaderStatusIng.a = $('<a class></a>').appendTo(this.ctHeaderStatusIng.tit);
	this.ctHeaderStatusIng.a.text(JSV.getLang('WorkBoard','ingTit'));
	
	this.ctHeaderStatusFinish = {};
	this.ctHeaderStatusFinish.wrap = $(statusWrapHTML).appendTo(this.div_ctHeader);
	this.ctHeaderStatusFinish.status = this.ctHeaderStatusFinish.wrap.find('.status').addClass('finish');
	this.ctHeaderStatusFinish.num = this.ctHeaderStatusFinish.wrap.find('.num');
	this.ctHeaderStatusFinish.tit = this.ctHeaderStatusFinish.wrap.find('.tit');
	this.ctHeaderStatusFinish.a = $('<a class></a>').appendTo(this.ctHeaderStatusFinish.tit);
	this.ctHeaderStatusFinish.a.text(JSV.getLang('WorkBoard','finishTit'));
}

workMainBoard.prototype.getLayoutVal = function(){
	var val = [];
	this.cardAreaUL.find('.category-wrap').each(function(i){
		var info = {};
		info.uuid = $(this).attr('uuid');
		info.title = $(this).find('.categoryTit').find('.widetxt').text();
		val.push(info);
	})
	return val;
}

workMainBoard.prototype.updateLayout = function(){
	var layout = this.getLayoutVal();
	var component = this;
	$.ajax({
 		url : component.updateLayoutUrl,
 		data : {ctg:JSV.toJSON(layout), id:component.itemid},
 		dataType : 'json',
 		success : function(data) {
 		},
 		error : function() {}
 	});
}

workMainBoard.prototype.findCategory = function(rowPoint, columnPoint){
	var val = [];
	val[0] = this.cardAreaUL.find('li[uuid="' + rowPoint + '"]');
	
	var obj = val[0].data('categoryObj');
	if(obj){
		if(columnPoint == workMainBoard.waitPoint){
			val[1] = obj.cardWaitArea;
		}else if(columnPoint == workMainBoard.ingPoint){
			val[1] = obj.cardIngArea;
		}else{
			val[1] = obj.cardFinishArea;
		}
	}
		
	return val;
}

workMainBoard.prototype.makeCategory = function(cardAreaUL){
	var categoryHTML = '<li class="category-wrap">' + 
		'<div class="category">'  +
			'<div class="titBox-wrap">' + 
				'<div class="titBox">' + 
					'<div class="dragArea">' + 
					'<div class="tit-wrap">' + 
					'<p class="categoryTit"><span class="txt"></span><span class="widetxt"></span><a class="btnEdit" title=' + JSV.getLang('WorkBoard','btnEditText') + '></a><a class="btnDelete" title=' + JSV.getLang('WorkBoard','btnDeleteText') + '></a><a class="btnRestore" title=' + JSV.getLang('WorkBoard','btnRestore') + '></a></p>' + 
					'</div>' + 
					'</div>' + 
					'<a class="btnOpen"><span id="btnOc">' + JSV.getLang('WorkBoard','btnOcText') + '</span></a>' + 
					'<a class="btnAdd"><span>' + JSV.getLang('WorkBoard','btnAddText') + '</span></a>' + 
				'</div>' +
			'</div>' + 
			'<div class="cards">' + 
				'<div class="column wait">' +
					'<div class="folding-cards">' + 
						'<div class="txt-wrap"><p class="txt">' + JSV.getLang('WorkBoard','txtFolding1') + '<br>' + JSV.getLang('WorkBoard','txtFolding2') + ' <span class="foldingCnt"></span>' + JSV.getLang('WorkBoard','txtFolding3') + '</p></div>' + 
					'</div>' +
				'</div>' + 
				'<div class="column ing">' +
					'<div class="folding-cards">' + 
						'<div class="txt-wrap"><p class="txt">' + JSV.getLang('WorkBoard','txtFolding1') + '<br>' + JSV.getLang('WorkBoard','txtFolding2') + ' <span class="foldingCnt"></span>' + JSV.getLang('WorkBoard','txtFolding3') + '</p></div>' + 
					'</div>' + 
				'</div>' + 
				'<div class="column finish" id="finish">' + 
					'<div class="folding-cards">' + 
						'<div class="txt-wrap"><p class="txt">' + JSV.getLang('WorkBoard','txtFolding1') + '<br>' + JSV.getLang('WorkBoard','txtFolding2') + ' <span class="foldingCnt"></span>' + JSV.getLang('WorkBoard','txtFolding3') + '</p></div>' + 
					'</div>' + 
				'</div>' + 
			'</div>' + 
		'</div>' + 
	'</li>';
	
	var categoryObj = {};
	categoryObj.wrap = $(categoryHTML).appendTo(cardAreaUL);
	categoryObj.category = categoryObj.wrap.find('.category');
	categoryObj.categoryTit = categoryObj.category.find('.categoryTit').find('.txt');
	categoryObj.categoryWideTit = categoryObj.category.find('.categoryTit').find('.widetxt');
	categoryObj.btnOc = categoryObj.category.find('.btnOpen');
	categoryObj.btnEdit = categoryObj.category.find('.btnEdit');
	categoryObj.btnDelete = categoryObj.category.find('.btnDelete');
	categoryObj.btnRestore = categoryObj.category.find('.btnRestore');
	categoryObj.btnAdd = categoryObj.category.find('.btnAdd');
	categoryObj.cardArea = categoryObj.category.find('.cards');
	categoryObj.cardWaitArea = categoryObj.cardArea.find('.wait');
	categoryObj.cardIngArea = categoryObj.cardArea.find('.ing');
	categoryObj.cardFinishArea = categoryObj.cardArea.find('.finish');
	categoryObj.cardFinishFoldingArea = categoryObj.cardArea.find('.folding-cards');
	categoryObj.cardWaitArea.attr('columnPoint', workMainBoard.waitPoint);
	categoryObj.cardWaitArea.attr('columnTit', JSV.getLang('WorkBoard','waitTit'));
	categoryObj.cardIngArea.attr('columnPoint', workMainBoard.ingPoint);
	categoryObj.cardIngArea.attr('columnTit', JSV.getLang('WorkBoard','ingTit'));
	categoryObj.cardFinishArea.attr('columnPoint', workMainBoard.finishPoint);
	categoryObj.cardFinishArea.attr('columnTit', JSV.getLang('WorkBoard','finishTit'));
	categoryObj.wrap.data('categoryObj', categoryObj);
	return categoryObj;
	
}
workMainBoard.prototype.makeCard = function(category, cardArea){
	var cardHTML = '<div class="card-wrap" fold="0">' + 
		'<div class="card" id="cardColor">' + 
			'<div class="cardTit">' + 
				'<img src="<%=request.getContextPath()%>/kanban/css/img/ico_lock.png" alt="lock" class="lock">' + 
				'<p class="tit">' +
				'<a id="cardTit"></a>' +
				'<a id="folddingBar" class="folddingBar"><img src="<c:url value="/kanban/css/img/i_select_arr.gif"/>"></a>' + 
				'<div class="file"><span class="num" id="fileNumHide" style="display:none"></span></div>' + 
				'<div class="reply"><span class="num" id="replyNumHide" style="display:none"></span></div>' + 
				'<div class="delBtn"><span class="num" id="delBtnHide" style="display:none"><img src="<c:url value="/kanban/css/img/btn_ico_del.png"/>"></span></div>' + 
				'</p>' +
			'</div>' + 
			'<div class="cardCt" id="cardCt">' + 
				'<div class="data">' + 
					'<div class="ct" id="cardContent"></div>' + 
					'<p class="date"><span id="cardDate"></span></p>' + 
				'</div>' + 
			'</div>' + 
			'<div class="cardBtm" id="cardBtm">' + 
				'<div class="bL">' + 
					'<div class="reply"><span class="num" id="replyNum"></span></div>' + 
					'<div class="file"><span class="num" id="fileNum"></span></div>' + 
				'</div>' + 
				'<div class="bR">' + 
					'<ul class="userList">' + 
					'</ul>' + 
					'<p class="delBtn"><img src="<c:url value="/kanban/css/img/btn_ico_del.png"/>"></p>' + 
				'</div></div></div></div>';
	
	var cardObj = {};
	cardObj.wrap = $(cardHTML).appendTo(cardArea);
	cardObj.cardColor = cardObj.wrap.find('#cardColor');
	cardObj.cardCt = cardObj.wrap.find('#cardCt');
	cardObj.cardBtm = cardObj.wrap.find('#cardBtm');
	cardObj.cardTit = cardObj.wrap.find('#cardTit');
	cardObj.folddingBar = cardObj.wrap.find('#folddingBar');
	cardObj.cardContent  = new TextAreaViewer(cardObj.wrap.find('#cardContent'));
	cardObj.cardDate = cardObj.wrap.find('#cardDate');
	cardObj.replyNum = cardObj.wrap.find('#replyNum');
	cardObj.replyNumHide = cardObj.wrap.find('#replyNumHide');
	cardObj.fileNum = cardObj.wrap.find('#fileNum');
	cardObj.fileNumHide = cardObj.wrap.find('#fileNumHide');
	cardObj.delBtn = cardObj.wrap.find('.delBtn');
	cardObj.delBtnHide = cardObj.wrap.find('#delBtnHide');
	cardObj.lock = cardObj.wrap.find('.lock');
	cardObj.wrap.data('cardObj', cardObj);
	return cardObj;
	
}
workMainBoard.prototype.drowCharge = function(area, value){
	area.empty();
	for(var i=0; i < value.length; i++){
		var li = $('<li><a class="user"></a></li>').appendTo(area);
		li.find('.user')
		$('<IMG>', {'src':JSV.getContextPath('/jsl/inline/ImageAction.Download?path='+value[i].id+'&type=' + JSV.EMPTHUMB_TYPE)}).on('error', function() {
			$(this).attr('src', JSV.getContextPath(EmpImageViewer.DEFAULT_IMAGE));
		}).attr('title',value[i].displayName).appendTo(li.find('.user'));
		if(i == 3) break;
	}
}
workMainBoard.prototype.updateCardInfo = function(card, cardInfo){
	
	if(cardInfo.itemId){
		card.itemId = cardInfo.itemId;
	}
	if(cardInfo.color){
		card.cardColor.css('border-left-color', '#' + cardInfo.color);
	}
	if(cardInfo.columnPoint){
		card.columnPoint = cardInfo.columnPoint;
	}
	if(cardInfo.columnTitle){
		card.columnTitle = cardInfo.columnTitle;
	}
	if(cardInfo.rowPoint){
		card.rowPoint = cardInfo.rowPoint;
	}
	if(cardInfo.rowTitle){
		card.rowTitle = cardInfo.rowTitle;
	}
	card.dateTermValue = [];
	if(cardInfo.startDate){
		card.dateTermValue[0] = cardInfo.startDate;
	}
	if(cardInfo.endDate){
		card.dateTermValue[1] = cardInfo.endDate;
	}
	card.dateTerm = new DateTermViewer(card.cardDate, {format:'yyyy/MM/dd'});
	card.dateTerm.setValue(card.dateTermValue);
	
	if (cardInfo.id){
		card.cardid = cardInfo.id;
		card.wrap.attr('cardid', card.cardid);
	}
	if(cardInfo.attachments){
		card.fileNum.text(cardInfo.attachments.length);
		card.fileNumHide.text(cardInfo.attachments.length);
	}else if(cardInfo.fileCnt){
		card.fileNum.text(cardInfo.fileCnt);
		card.fileNumHide.text(cardInfo.fileCnt);
	}else{
		card.fileNum.text(0);
		card.fileNumHide.text(0);
	}

	if(cardInfo.opinions){
		card.replyNum.text(cardInfo.opinions.total);
		card.replyNumHide.text(cardInfo.opinions.total);
	}else if(cardInfo.opnCnt){
		card.replyNum.text(cardInfo.opnCnt);
		card.replyNumHide.text(cardInfo.opnCnt);
	}else{
		card.replyNum.text(0);
		card.replyNumHide.text(0);
	}
	card.sec = cardInfo.sec;
	if(cardInfo.sec){
		card.lock.css('display','block');
	}else{
		card.lock.css('display','none');
		
	}
	if(cardInfo.sort){
		card.sort = cardInfo.sort;
	}
	if(cardInfo.status){
		card.status = cardInfo.status;
	}
	if(cardInfo.title){
		card.cardTit.text(cardInfo.title).attr('title',cardInfo.title);
	}
	if(cardInfo.content){
		card.cardContent.setValue(cardInfo.content);
	}
}
workMainBoard.prototype.cardInfoUpdate = function(uuid, title){
	var component = this;
	$.ajax({
 		url : component.categoryUpdate,
 		data : {'id':component.itemid, 'uuid':uuid, 'title':title},
 		dataType : 'json',
 		success : function(data) {
 		},
 		error : function() {}
 	});
}
workMainBoard.prototype.foldCardInfo = function(card, cardInfo){
	var foldId = JSON.parse(localStorage.getItem(cardInfo.id));
		if (foldId == 1) {
	 		$('.card-wrap').attr('fold',1);
			card.cardCt.hide();
			card.cardBtm.hide();
			card.delBtnHide.show();
			card.fileNumHide.show();
			card.replyNumHide.show();
		}
}
workMainBoard.generateUUID = function() {
	var s = [];
	var hexDigits = "0123456789abcdef";
	for ( var i = 0; i < 36; i++) {
		s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
	}
	s[14] = "4"; // bits 12-15 of the time_hi_and_version field to 0010
	s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1); // bits 6-7 of the clock_seq_hi_and_reserved to 01
	s[8] = s[13] = s[18] = s[23] = "-";

	var uuid = s.join("");
	return uuid;
};
workMainBoard.defaultStatusCode = '1-wait';
workMainBoard.waitPoint = '1-wait';
workMainBoard.ingPoint = '2-ing';
workMainBoard.finishPoint = '3-finish';
workMainBoard.deleteCtg = 'DELETE';


workMainBoard.defaultStatusTitle = JSV.getLang('WorkBoard','waitTit');
workMainBoard.defaultCardTitle = JSV.getLang('WorkBoard','newCardTitle');
JSV.Block(function () {
	var model = JSV.loadJSON(JSV.getModuleUrl('/jsl/KbItemOwner.LoadOrCreateByItem.json'));
	var id = model.id;
	JSV.setState('id',id);
	
	var cardsValue${PORTLET_ID} = {};
	cardsValue${PORTLET_ID}.id = id${PORTLET_ID};
	cardsValue${PORTLET_ID}.categoryInfo = '/jsl/KbItemOwner.LoadLayoutByOwner.json?id='+id;
	cardsValue${PORTLET_ID}.categoryBackupInfo = JSV.getModuleUrl('/jsl/KbItemOwner.LoadBackupLayoutByOwner.json?id='+id);
	cardsValue${PORTLET_ID}.cardInfo = '/jsl/KbItemCardUser.CardListByUser.json?id='+id;

	var style = {'title':'KanBan', 
			'updateLayout':JSV.getContextPath(JSV.getModuleUrl('/jsl/KbItemOwner.SaveLayoutByOwner.json')),
			'delLayout':JSV.getContextPath(JSV.getModuleUrl('/jsl/KbItemCardUser.DelLayoutByUser.jsl')),
			'backupLayout':JSV.getContextPath(JSV.getModuleUrl('/jsl/KbItemCardUser.BackUpLayoutByUser.jsl')),
			'restoreLayout':JSV.getContextPath(JSV.getModuleUrl('/jsl/KbItemCardUser.restoreLayoutByUser.jsl')),
			'registCard':JSV.getContextPath(JSV.getModuleUrl('/jsl/KbItemCardUser.DoRegister.json')),
			'categoryUpdate':JSV.getContextPath(JSV.getModuleUrl('/jsl/KbItemOwner.CategoryUpdateByOwner.json')),
			'dragUpdateCards':JSV.getContextPath(JSV.getModuleUrl('/jsl/KbItemCardUser.SaveDragCardsByUser.json'))}
	var main = new workMainBoard($('#wbmainboard'), style);
	main.setValue(cardsValue${PORTLET_ID});
	
	<%--
	메인 헤더 고정
	--%>
	$(document).ready(function() {
		resizeMain();
 	});
		
});

</script>
<%@ include file="/sys/jsv/template/template.body.jsp" %>
<div style="background:#e8eaec;" id="wbmainboard">
</div>
<%@ include file="/sys/jsv/template/template.tail.jsp" %>