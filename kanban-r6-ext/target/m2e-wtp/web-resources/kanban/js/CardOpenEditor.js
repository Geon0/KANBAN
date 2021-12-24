/**
 * 
 * @param parent
 * @param style
 * @returns
 */
function CardOpenEditor(parent, style) {
	this.parent = parent;
	this.style = style || {};
	this.callback = this.style.callback;
	this.url = this.style.url || 'usr.card.edit.jsp?id=';
	this.className = this.style.className || 'CardOpenEditor';
}
CardOpenEditor.prototype.setValue = function(value) {
	var _this = this;
	if ($(this.parent).find('.CardOpenEditor').length > 0) {
		$(this.parent).find('.CardOpenEditor').remove();
	}
	
	var LayerBody = $('<div></div>').addClass('CardOpenEditor');
	LayerBody.appendTo(this.parent);
	LayerBody.height(this.parent.height());
	var LayerBg = $('<div>').addClass('CardOpenEditorBg').css('z-index','10').appendTo(LayerBody);
	
	this.layerDiv = $('<div>').addClass('cardLayer card-detail').attr('id', 'CardOpenLayer').appendTo(LayerBody);
	this.layerDiv.data('CardOpenEditor', this);
	this.layerDiv.resize(function(e) {
		_this.resize();
	});
	$(window).resize(function(e){
		_this.resize();
	})
	var url = this.url+value;
	var ptlId = CardOpenEditor.CARDOPEN_PTLID+'_'+JSV.SEQUENCE++;
	var q = 'PORTLET_ID=' + ptlId;
	setTimeout(function() {
		_this.layerDiv.load(JSV.getContextPath(JSV.getModuleUrl(url), q), function(data, status, xhr) {
		});
	}, 2);
	
	LayerBg.on('click',function(){
		$('#layer'+ptlId).slimScroll({destroy:true});
		$('body').find('.CardOpenEditor').hide();
	})
}
CardOpenEditor.prototype.resize = function() {
	var winWidth = $(window).width()/2;
	var layerWidth = $(this.layerDiv).width()/2;
	$(this.layerDiv).css('left', (winWidth-layerWidth) + 'px');
	$(this.layerDiv).css('top',$(window).scrollTop() + 200);
	
}
CardOpenEditor.CARDOPEN_PTLID = 'CARDOPEN';