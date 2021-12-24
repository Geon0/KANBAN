function CardFileViewer(parent, style) {
	this.style = style || {};
	this.className = this.style.className || 'CardFileViewer';
	this.seq = JSV.SEQUENCE++;
	this.fileSeqId = 1;
	this.fileCount = 0;
	this.xhrObjs = {};
	this.count = 0;
	this.ptlId = this.style.ptlId;
	this.dataName = 'data.attachments';
	this.cardId = JSV.getParameter('id', this.ptlId) || this.style.cardId;
	this.attachUrl = this.style.attach;
	this.registerUrl = this.style.register;
	this.removeUrl = this.style.remove;
	this.add = this.style.add || JSV.getLang('CardFileViewer', 'fileAdd');
	this.parentWidget = $('<div></div>').appendTo(parent).addClass('CardFile');
	this.widget = $('<div>\
			<div class="title"></div>\
	</div>').addClass(this.className).appendTo(
	this.parentWidget);
	var hideDiv = $('<div>').addClass('hide').appendTo(this.widget);
	this.ul = $('<ul>').addClass('file_list').appendTo(this.widget);
	
	var addFile = new KButton(this.widget.find('div.title'), {
		text : this.add,
		className : 'H24'
	});
	addFile.comp = this;
	addFile.onclick = function() {
		CardFileViewer.component = this.comp;
		var file;
		if (this.comp.widget.find('div.title >  input[type=file]').length > 0) {
			file = this.comp.widget.find('div.title >  input[type=file]');
		} else {
			file = $('<input>').attr({
				type : 'file',
				multiple : 'multiple'
			}).appendTo(this.comp.widget.find('div.title')).hide().change(function(e) {
				CardFileViewer.component.selectHandler(e.target.files);
			}).click(function(e) {
				e.stopPropagation();
			});
		}
		file.val('').click();
	}
	JQueryUI.load($.proxy(this, 'initDialog'));
}
CardFileViewer.prototype.setValue = function(value){
	var ul = this.ul;
	$(ul).empty();
	if (value && value.length > 0) {
		for ( var i = 0; i < value.length; i++) {
			this.createFile(ul, value[i], i);
		}
	}
}
CardFileViewer.prototype.createFile = function(parent, value, index) {
	var $this = this;
	var li = $('<li>').addClass('file_item').appendTo(parent);
	$('<img>').addClass('fileIcon').attr('src',
			JSV.getContextPath(FileViewer.DIR + FileViewer.getIconName(value.filename))).appendTo(li);
	
	var name = '<span class="nameDiv">' + value.filename + '</span>';
	var size = '<span class="sizeDiv">&nbsp;(' + FileViewer.getSize(value.size) + ')</span>';
	
	var titleA = $('<a>').addClass('fileName').attr('title', value.filename).html(name + size).appendTo(li);
	this.manageAnchor(titleA, value);
	
	var saveA = $('<a>').addClass('save').text(JSV.getLang('FileViewer', 'save')).appendTo(li);
	this.manageAnchor(saveA, value);
	
	$('<span>').addClass('block').text('| ').appendTo(li);
	
	var editA = $('<a>').addClass('edit').text(JSV.getLang('ContentViewer', 'edit')).appendTo(li);
	editA.on('click',value,function(e){
		$this.openFileManager(e.data);
	})
	
	$('<span>').addClass('block').text('| ').appendTo(li);
	
	var delA = $('<a>').addClass('del').text(JSV.getLang('ContentViewer', 'del')).appendTo(li);
	delA.on('click',value,function(e){
		if(confirm(JSV.getLang('PortalManager','doDelete'))){
			$.ajax({
				url : JSV.getContextPath($this.removeUrl),
				dataType : 'json',
				data : {
					id : e.data.gid,
				},
				async : false,
				type : 'POST',
				success : function(data) {
					if (data.error) {
						$this.onError(data);
						return;
					}
					if (data != null) {
						$this.setValue(eval($this.dataName));
					}
				},
				error : function(xhr) {
				}
			});
		}
	})
}
CardFileViewer.prototype.openFileManager = function(args) {
	var _this = this;
	var bottom = $('body');
	if ($(bottom).find('.fixedCardLayer').length > 0) {
		$(bottom).find('.fixedCardLayer').remove();
	}
	/** 상위 Layer감싸는 Div * */
	var LayerBody = $('<div></div>').addClass('fixedCardLayer');
	LayerBody.appendTo(bottom);
	LayerBody.css({'position':'absolute','top':'0','left':'0','width':'100%'});
	LayerBody.height(bottom.height());
	
	var backGround = $('<div>').addClass('subfixedBg').appendTo(LayerBody);
	backGround.css({'z-index':'111','background-color':'#b9b9b9'});
	
	/** 해당 Layer Div * */
	this.layerDiv = $('<div>').addClass('subfixedLayerArea').appendTo(LayerBody);
	this.layerDiv.css('z-index', '112');
	this.layerDiv.appendTo(LayerBody);
	this.layerDiv.resize(function(e) {
		_this.resize();
	});
	$(window).resize(function(e){
		_this.resize();
	})
	/** 해당 Layer Header Div * */
	var LayerHeader = $('<div>').addClass('subfixedTaskLayerHeader');
	LayerHeader.appendTo(this.layerDiv);
	
	/** 해당 Layer Header Title * */
	$('<h1>').addClass('layerTitle').text(JSV.getLang('CardFileViewer', 'fileTitle')).appendTo(LayerHeader);

	/** 해당 Layer Content * */
	var LayerContent = $('<div>', {
		id : 'subTaskContent'
	}).addClass('subfixedTaskLayerContent');
	LayerContent.css('width', '630px');
	LayerContent.css('height', '330px');
	LayerContent.appendTo(this.layerDiv);

	_this.layerWidget = $(LayerContent).get(0);

	/** 해당 Layer Close Div * */
	var LayerClose = $('<span>').addClass('subfixedLayerClose');
	LayerClose.appendTo(LayerHeader);
	LayerClose.click(function() {
		$(".fixedCardLayer", document).hide();
	});

	var subCardChagersDiv = LayerContent;
	var q = 'PORTLET_ID=' + CardFileViewer.UPLOAD_PTLID;
	setTimeout(function() {
		subCardChagersDiv.load(JSV.getContextPath(_this.style.vrsnUrl, q),{'id':_this.cardId ,'fileId':args.id,'size':args.size,'filename':args.filename,'vrsn':args.vrsnNum});
	}, 2);
}
CardFileViewer.prototype.resize = function(){
	var winWidth = $(window).width()/2;
	var layerWidth = $(this.layerDiv).width()/2;
	$(this.layerDiv).css('left', (winWidth-layerWidth) + 'px');
	$(this.layerDiv).css('top',$(window).scrollTop() + 200);
}
CardFileViewer.prototype.manageAnchor = function(a, value) {
	var url = JSV.getContextPath(JSV.merge(this.attachUrl, value));
	if (JSV.browser.msie) {
		a.click(function() {
			url += '&isFF=true';
			a.attr('href', url);
		});
	} else {
		if (JSV.browser.firefox){
			url += '&isFF=true';
		}
		a.attr('href', url);
	}
}
CardFileViewer.prototype.selectHandler = function(files){
	for(var i = 0 ; i < files.length ; i++){
		files[i].id = this.fileSeqId++;
		this.sendFile(files[i], i, files.length);
	}
}
CardFileViewer.prototype.sendFile = function sendFile(file, idx, fileLength) {
	/*
	 * if (!FileFieldEditor.CheckExt(file["name"], this.notSupported)) { return; } if (file["size"] <= 0) { alert('[' +
	 * file.name + '] ' + JSV.getLang('SwfUploadObject', 'zero_byte_file') + JSV.getLang('SwfUploadObject', 'error2'));
	 * return; } if (this.fileSize > 0 && file["size"] >= this.fileSize) { alert(JSV.getLang('SwfUploadObject',
	 * 'file_exceeds_size_limit') + JSV.getLang('SwfUploadObject', 'error2')); return; }
	 */
	var _this = this;
	var fileItem = {
			'method' : 'editor',
			'type' : 1,
			'path' : 'com.kcube.jsv.file.',
			'filename' : file.name,
			'size' : file.size
		};
	this.fileCount++;
	var formData = new FormData();
	formData.append('upload', JSV.toJSON(fileItem));
	formData.append('com.kcube.jsv.file.', file);
	var tr = this.addProgress(file, file['id']);
	var successCallback = function(file) {
		var obj = new Object();
		obj.id = _this.cardId;
		obj.attachments = [file];
		$.ajax({
			url : JSV.getContextPath(_this.registerUrl),
			dataType : 'json',
			data : {
				item : JSV.toJSON(obj),
				method : 'add'
			},
			async : false,
			type : 'POST',
			success : function(data) {
				if (data.error) {
					_this.onError(data);
					return;
				}
				if (data != null) {
					_this.setValue(eval(_this.dataName));
				}
			},
			error : function(xhr) {
			}
		});
	};
	// 파일 전송 ajax
	var fileResponse = null;
	$.ajax({
		xhr: function() {
			var xhrobj = $.ajaxSettings.xhr();
			_this.xhrObjs[file.id] = xhrobj;
			xhrobj.upload.addEventListener('progress', function(e) {
				var nPerc = 0;
				var position = e.loaded || e.position;
				var total = e.total;
				if (e.lengthComputable) {
					nPerc = Math.ceil(position / total * 100);
				}
				// Set progress
				_this.setProgress(tr, nPerc);
			}, false);
			return xhrobj;
		},
		url : JSV.getContextPath(FileUploadObject.UPLOAD_URL),
		dataType : 'html',
		data : formData,
		cache : false,
		contentType : false,
		processData : false,
		type : 'POST',
		success : function(data) {
			_this.xhrObjs[file.id] = null;
			_this.setProgress(tr, 100);
			if (++_this.count == _this.fileCount) {
				_this.count = 0;
				_this.fileCount = 0;
				_this.dialogClose();
			}
			var results = data.split('|');
			fileResponse = {
				'method' : 'editor',
				'type' : results[0],
				'path' : results[1],
				'filename' : file.name,
				'size' : file.size
			};
			successCallback(fileResponse);
		}
	});
}
CardFileViewer.prototype.initDialog = function() {
	this.dialogDiv = $(
			'<div class="layerFileupLoad">\
		<div class="fileUploadList">\
			<table border="0" cellspacing="0" cellpadding="0" id="fileUploadTable">\
				<colgroup>\
					<col width="251"/>\
					<col width="89"/>\
					<col width="*"/>\
				</colgroup>\
				<tr>\
					<th>'
					+ JSV.getLang('DocFileViewer', 'fileName')
					+ '</th>\
					<th>'
					+ JSV.getLang('DocFileViewer', 'fileSize')
					+ '</th>\
					<th>'
					+ JSV.getLang('DocFileViewer', 'fileUploadStatus')
					+ '</th>\
				</tr>\
				<tr style="height:7px;">\
				</tr>\
			</table>\
		</div>\
	</div>')
			.attr({
				'title' : JSV.getLang('DocFileViewer', 'fileUpload'),
				'id' : 'fileUploadDialog' + this.seq
			}).appendTo(this.widget);

	// File Progress Dialog
	var _this = this;
	this.fileDialog = $('#fileUploadDialog' + this.seq).dialog({
		width : 560,
		height : 350,
		modal : true,
		resizable : false,
		autoOpen : false,
		dialogClass : 'CardFileViewer LayerModalDialog FileModal',
		beforeClose : function(e) {
			for ( var key in _this.xhrObjs) {
				if (_this.xhrObjs.hasOwnProperty(key) && _this.xhrObjs[key]) {
					_this.xhrObjs[key].abort();
				}
			}
			_this.count = 0;
			_this.fileCount = 0;
			$('#fileUploadTable tr.uploadTr').remove();
		}
	});
}
CardFileViewer.prototype.dialogOpen = function() {
	this.fileDialog.dialog('open');
}
CardFileViewer.prototype.dialogClose = function() {
	this.fileDialog.dialog('close');
}
CardFileViewer.prototype.addProgress = function(file, id) {
	if (!this.fileDialog.dialog('isOpen')) {
		this.dialogOpen();
	}

	var tr = $('<tr>').addClass('uploadTr').appendTo(this.dialogDiv.find('#fileUploadTable'));
	$('<td>').addClass('fileName').html(
			'<img src="' + JSV.getContextPath(FileViewer.DIR + FileViewer.getIconName(file['name'])) + '"/>'
					+ file['name']).appendTo(tr);
	$('<td>').addClass('fileSize').html(FileViewer.getSize(file['size'])).appendTo(tr);
	var pTd = $('<td>').addClass('status').appendTo(tr);
	var pDiv = $('<div>').addClass('progress').appendTo(pTd);
	$('<div>').addClass('percent').width(0).html('&nbsp;').appendTo(pDiv);
	$('<span>').addClass('statusText').appendTo(pTd);

	if (id)
		tr.attr('id', 'fileUpdTr' + id);
	return tr;
}
CardFileViewer.prototype.setProgress = function(tr, nPerc) {
	var percentDiv = tr.find('div.percent');
	percentDiv.width(nPerc + '%');
	if (nPerc == 100)
		percentDiv.addClass('done')
	tr.find('span.statusText').text(nPerc == 100 ? JSV.getLang('DocFileViewer', 'complete') : nPerc + '%');
}
CardFileViewer.prototype.onError = function(data) {
	if (data.error.indexOf('CardUploadDeniedException') > -1) {
		alert(JSV.getLang('DocFileViewer', 'uploadDenied'));
	} else if (data.error.indexOf('DrmFilePermissionDenied') > -1) {
		alert(JSV.getLang('DocFileViewer', 'addFileDrmError'));
	} else {
		alert(JSV.getLang('DocFileViewer', 'addError'));
	}
}
CardFileViewer.UPLOAD_PTLID = 'CARD_FILE_UPLOAD';
