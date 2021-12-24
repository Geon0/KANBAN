/**
 * 
 * @param parent
 * @param style
 * @returns
 */
function CTOpenEditor(parent, style) {
	this.parent = parent;
	this.style = style || {};
	this.callback = this.style.callback;
	this.url = this.style.url || 'usr.ct.edit.jsp?id=';
	this.className = this.style.className || 'CardOpenEditor';
}
CTOpenEditor.prototype.open = function(title) {
	var _this = this;
	if ($(this.parent).find('.CardOpenEditor').length > 0) {
		$(this.parent).find('.CardOpenEditor').remove();
	}
	var LayerBody = $('<div></div>').addClass('CardOpenEditor');
	LayerBody.appendTo(this.parent);
	LayerBody.height(this.parent.height());
	$('<div>').addClass('CardOpenEditorBg').appendTo(LayerBody);
	
	this.layerDiv = $('<div>').addClass('cardLayer card-detail').attr('id', 'CardOpenLayer').appendTo(LayerBody);
	this.layerDiv.data('CTOpenEditor', this);
	this.layerDiv.data('CTGTitle', title);
	this.layerDiv.resize(function(e) {
		_this.resize();
	});
	$(window).resize(function(e){
		_this.resize();
	})
	var url = this.url;
	var q = 'PORTLET_ID=' + CardOpenEditor.CARDOPEN_PTLID+'_'+JSV.SEQUENCE++;
	setTimeout(function() {
		_this.layerDiv.load(JSV.getContextPath(JSV.getModuleUrl(url), q), function(data, status, xhr) {
		});
	}, 2);
}
CTOpenEditor.prototype.resize = function() {
	var winWidth = $(window).width()/2;
	var layerWidth = $(this.layerDiv).width()/2;
	$(this.layerDiv).css('left', (winWidth-layerWidth) + 'px');
	$(this.layerDiv).css('top',$(window).scrollTop() + 200);
	
}
CTOpenEditor.CARDOPEN_PTLID = 'CTOPEN';