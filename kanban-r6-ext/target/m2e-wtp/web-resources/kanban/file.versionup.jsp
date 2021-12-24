<%@ include file="/jspf/head.portlet.jsp" %>
<style type="text/css">
.layer_file${PORTLET_ID} {padding: 23px 25px 25px 25px;}
.layer_file${PORTLET_ID} .layer_top{position: relative;margin-bottom: 15px;border: 1px solid #DDDDE1;color: #333;}
.layer_file${PORTLET_ID} .layer_top .info_box{padding: 13px 15px 11px 82px;border: none;background-color: #F0F0F0;color: #333;vertical-align: top;}
.layer_file${PORTLET_ID} .layer_top .info_box .box_txt{position: absolute;left: 15px;top: 13px;line-height: 16px;font-weight: bold;}
.layer_file${PORTLET_ID} .layer_top .btn_area{padding: 8px 10px 0 10px;border-bottom: 1px solid #EDEDED;}
.layer_file${PORTLET_ID} .layer_top .btn_area .btn_inner_wrap{height: 32px;}
.layer_file${PORTLET_ID} .layer_top .btn_area .txt{float: left;margin: 0 8px 0 0;height: 25px;line-height: 26px;color: #3f474a;}
.layer_file${PORTLET_ID} .layer_top .btn_area .btn{float: left;}
.layer_file${PORTLET_ID} .layer_top .file_area{padding: 12px 10px 15px 10px;border-bottom: 1px solid #EDEDED;}
.layer_file${PORTLET_ID} .layer_top .file_area .no_file{}
.layer_file${PORTLET_ID} .layer_top .file_area .no_file:after{display: block;content:"";clear: both;}
.layer_file${PORTLET_ID} .layer_top .file_area .no_file i{float: left;margin: 0 3px 0 0;}
.layer_file${PORTLET_ID} .layer_top .file_area .no_file .txt{float: left;height: 16px;line-height: 16px;;color: #919393;}
.layer_file${PORTLET_ID} .layer_top .file_area .file_list{display: none;}
.layer_file${PORTLET_ID} .layer_top .file_area .file_item{position: relative;padding: 0 166px 0 0;}
.layer_file${PORTLET_ID} .layer_top .file_area .file_item .status{position: absolute;right:24px;top: 2px;}
.layer_file${PORTLET_ID} .layer_top .file_area .file_item .btn_del{display:none;position: absolute;right: 2px;top: 0;width: 16px;height: 16px;background: url(<c:url value="/img/layout/i_close.gif"/>) 0 0 no-repeat;font-size: 0;line-height: 0;}
.layer_file${PORTLET_ID} .layer_top .file_area .file_item .btn_del:hover{background-position: 0 -16px;}
.layer_file${PORTLET_ID} .layer_top .file_area .file_item .progress{float: left;width: 100px;height: 6px;border: 1px solid #A5AAB1;background-color: #F6F6F6;margin: 2px 5px 0 0;}
.layer_file${PORTLET_ID} .layer_top .file_area .file_item .progress .percent{background-color: #9DC7FB;height: 100%;width:20%;font-size: 0;line-height: 0;}
.layer_file${PORTLET_ID} .layer_top .file_area .file_item .progress .done{background-color: #D0D0D0;}
.layer_file${PORTLET_ID} .layer_top .file_area .file_item .statusText{color: #666;}
.layer_file${PORTLET_ID} .layer_top .file_name{display: inline;line-height: 16px;color: #333;font-weight: bold;vertical-align: top;}
.layer_file${PORTLET_ID} .layer_top .file_name .i_file{margin: -1px 4px 0 0 ;width: 16px;height: 16px;vertical-align: top;}
.layer_file${PORTLET_ID} .layer_top .file_size{display: inline;margin: 0 0 0 7px;line-height: 15px;color: #A9A8A8;font-size: 11px;font-family:'Malgun Gothic','맑은 고딕';vertical-align: top;}
.layer_file${PORTLET_ID} .layer_top .vrsn_area{padding: 12px 10px 15px 10px;border-bottom: 1px solid #EDEDED;}
.layer_file${PORTLET_ID} .layer_top .vrsn_area .vrsn_title{padding: 0 0 5px 0;}
.layer_file${PORTLET_ID} .form_wrap{padding-top: 9px;}
.layer_file${PORTLET_ID} .form_wrap .form_title{margin-bottom: 9px;line-height: 14px;font-size: 13px;color: #3f474a;font-weight: bold;font-family:'Malgun Gothic','맑은 고딕';}
.layer_file${PORTLET_ID} .file_version{display:none;}
.layer_file${PORTLET_ID} .radiobox_wrap{margin-bottom: 9px;color: #3B3B3B;}
.layer_file${PORTLET_ID} .radiobox_wrap .q_area{margin-bottom: 8px;padding: 9px 0;border-bottom: 1px solid #EDEDED;}
.layer_file${PORTLET_ID} .radiobox_wrap .q_area .q_txt{line-height: 13px;}
.layer_file${PORTLET_ID} .radiobox_wrap .radio_area{padding: 0 3px;}
.layer_file${PORTLET_ID} .radiobox_wrap .radio_list{}
.layer_file${PORTLET_ID} .radiobox_wrap .radio_list .radio_item{padding: 4px 0;}
.layer_file${PORTLET_ID} .radiobox_wrap .radio_list .replace_doc{display:none;}
.layer_file${PORTLET_ID} .radiobox_wrap .radio_item label{display: inline-block;}
.layer_file${PORTLET_ID} .radiobox_wrap .radio_item input{margin: 0 7px 0 0;width: 13px;height: 13px;vertical-align: -2px;}
.layer_file${PORTLET_ID} .radiobox_wrap .radio_checked label{font-weight: bold;}
.layer_file${PORTLET_ID} .layer_bottom{padding: 13px 0 0 0;text-align: center;}
</style>
<script type="text/javascript">
JSV.Block(function () {
	var fileId = JSV.getParameter('fileId', '${PORTLET_ID}');
	var id = JSV.getParameter('id', '${PORTLET_ID}');
	var size = JSV.getParameter('size', '${PORTLET_ID}');
	var fileVer = JSV.getParameter('vrsn', '${PORTLET_ID}');
	
	var useHTML5 = window.File && window.FileList && window.FileReader;
	var notSupported = '';
	var totalSize = -1;
	var fileSize = -1;	
	
	var fileData = null;
	
	var filename = JSV.decodeXSS(JSV.getParameter('filename', '${PORTLET_ID}'));
	$('#oldFileIcon${PORTLET_ID}').css('background-image', 'url(' + JSV.getContextPath(FileViewer.DIR + FileViewer.getIconName(filename)) + ')'); 
	$('#oldFileName${PORTLET_ID}').text(filename);
	$('#oldFileSize${PORTLET_ID}').text('(' + FileViewer.getSize(size) + ')');
	$('#regText${PORTLET_ID}').text('<kfmt:message key="pd.card.003"/>');
	
	if (totalSize > 0) {
		totalSize = FileFieldEditor.GetKByte(totalSize) - parseInt(docFileSize);
		if (size)
			totalSize += parseInt(size);
		totalSize = totalSize * 1024 * 1024; 
	}
	
	if(useHTML5){
		var fileInput = $('<input>').attr('type', 'file').appendTo($('#fileBtn${PORTLET_ID}')).hide();
		var addBtn = new KButton($('#fileBtn${PORTLET_ID}'), JSV.getLang('FileFieldEditor', 'addBtn'));
		addBtn.onclick = function() {
			fileInput.val('').click();
		}
		fileInput.change(function(e){
			sendFile(e.target.files[0]);
		});

		function sendFile(file) {
			if (!FileFieldEditor.CheckExt(file["name"], notSupported))
				return;
			if (fileSize >= 0 && fileSize < file["size"]) {
				alert(JSV.getLang('SwfUploadObject','error') + JSV.getLang('SwfUploadObject','file_exceeds_size_limit') + JSV.getLang('SwfUploadObject','error2'));
				return;
			}
			if (totalSize >= 0 && totalSize < file["size"]) {
				alert(JSV.getLang('FileFieldEditor','warning'));
				return;
			}
			initFileProgressBar(file);
			var fileItem = {'method':'editor', 'type':1, 'path':'com.kcube.jsv.file.', 'filename':file.name, 'size':file.size};			
			var formData = new FormData();
			formData.append('upload', JSV.toJSON(fileItem));
			formData.append('com.kcube.jsv.file.', file);
			$.ajax({
				xhr: function() {
					var xhrobj = $.ajaxSettings.xhr();
					if (xhrobj.upload) {
						xhrobj.upload.addEventListener('progress', function(e) {
							var nPerc = 0;
							var position = e.loaded || e.position;
							var total = e.total;
							if (e.lengthComputable) {
								nPerc = Math.ceil(position / total * 100);
							}
							setProgress(nPerc);
						}, false);
					}
					return xhrobj;
				},
				url: JSV.getContextPath(FileUploadObject.UPLOAD_URL),
				dataType : 'html',
				data: formData,
				cache: false,
				contentType: false,
				processData: false,
				type:'POST',
				success: function (data) {
					setProgress(100);
					onSuccess(data);
				}
			});
		}
	}else{
		FileUploadEditor.prototype.onUploadError = function(file, errorCode, message){}
		var fileStyle = {
				'btnImage' : '/img/btn/doc/btn25_swf.gif',
				'btnText' : '<kfmt:message key="pd.card.004"/>',
				'fileSize' : fileSize,
				'totalSize' : totalSize,
				'notSupport' : notSupported,
				'sessionKey' : '${sessionKey}', 
				'useSwfUploader' : 'true'
		};
		var swfFile = new FileUploadEditor($('#fileBtn${PORTLET_ID}'), fileStyle);
		/*파일 선택시에 대한 처리 */
		swfFile.select = function(file) {
			fileData = null;
			var fileItem = {'method':'editor', 'type':1, 'path':'com.kcube.jsv.file.', 'filename':file['name'], 'size':file['size']};
			this.swfUploader.addFileParam(file['id'], "upload", JSV.toJSON(fileItem));
			initFileProgressBar(file);
			this.StartUpload();
		}
		/* Flash업로드 완료 후에 대한 처리 */
		swfFile.success = function(file, serverData) {
			onSuccess(serverData);
		}
		/* Flash업로드 중 처리 (Progress bar) */
		swfFile.progress = function(file, nPerc) {
			setProgress(nPerc);
		}
	}
	
	var method = new RadioGroupFieldEditor($('#vrsnArea${PORTLET_ID}'), {'options':'<kfmt:message key="pd.card.013"/>','useVertical':'true'});
	method.setValue(null);
	//
	/* 파일에 대한 삭제 버튼 클릭 시 동작 */
	$('#fileClose${PORTLET_ID}').click(function() {
		fileData = null;
		$('#fileList${PORTLET_ID}').hide();
		$('#noFileList${PORTLET_ID}').show();
	});
	
	function setProgress(nPerc) {
		var div = $('#fileUpdPer${PORTLET_ID}').width(nPerc + '%');
		if (nPerc == 100)
			div.addClass('done');
		$('#fileUpdText${PORTLET_ID}').text(nPerc + '%');
		if(register){
			register.buttons[0].widget.unbind('click.KButton').bind('click.KButton', this, function(event){
				alert('<kfmt:message key="pd.card.005"/>');
				return false;
			});
		}
	}

	function onSuccess(serverData) {
		if (!serverData) {
			alert('<kfmt:message key="pd.card.006"/>');
			return false;
		}
		$('#fileClose${PORTLET_ID}').show();
		fileData = serverData;
		if(register){
			register.buttons[0].widget.unbind('click.KButton');
			register.buttons[0].bind();
		}
	}

	function initFileProgressBar(file) {
		$('#newFileIcon${PORTLET_ID}').css('background-image', 'url(' + JSV.getContextPath(FileViewer.DIR + FileViewer.getIconName(file['name'])) + ')'); 
		$('#newFileName${PORTLET_ID}').text(file['name']);
		$('#newFileSize${PORTLET_ID}').text('(' + FileViewer.getSize(file['size']) + ')');
		
		$('#noFileList${PORTLET_ID}').hide();
		$('#fileUpdPer${PORTLET_ID}').width('0%').removeClass('done');
		$('#fileUpdText${PORTLET_ID}').text('0%');
		$('#fileClose${PORTLET_ID}').hide();
		$('#fileList${PORTLET_ID}').show();
	}
	
	var $this = this;
	
	/*확인 버튼 */
	var register = new KButton($('#fncBtn${PORTLET_ID}'), {text:'<fmt:message key="doc.012"/>', className:'blue'});
	register.onclick = function() {
		var file = {};
		if (fileData == null) {
			alert('<kfmt:message key="pd.card.007"/>');
			return false;
		}
		file.id = fileId;
		fileData = fileData.split('|');
		file.method = 'editor';
		file.type = fileData[0];
		file.path = fileData[1];
		
		var tmp = {id:id,  attachments:[file]};
		
		$.ajax({
			url : JSV.getContextPath(JSV.getModuleUrl('/jsl/KbItemCardUser.DoFileUpdate.json')),
			dataType : 'json',
			async : false,
			type : 'POST',
			data : {'item' : JSV.toJSON(tmp),
				'method' : method.getValue()
				},
			success : function(data, status){
				if(data && data.error){
					
				}else{
					loadFiles(data);
					$(".fixedCardLayer", document).hide();
				}
			},
			error : function(xhr) {
			}
		});	
	}
	/*취소 버튼 */
	var cancel = new KButton($('#fncBtn${PORTLET_ID}'), {text:'<fmt:message key="doc.013"/>'});
	cancel.onclick = function() {
		$(".fixedCardLayer", document).hide();
	}
}, '${PORTLET_ID}');
</script>
<div class="layer_file${PORTLET_ID}">
	<div class="layer_top" id="layerTop${PORTLET_ID}">
		<div id="oldFile${PORTLET_ID}" class="info_box">
			<span class="box_txt"><kfmt:message key="pd.card.008"/> :</span><span class="file_name"><i id="oldFileIcon${PORTLET_ID}" class="i_file"></i><span id="oldFileName${PORTLET_ID}"></span></span><span class="file_size" id="oldFileSize${PORTLET_ID}"></span>
		</div>
		<div class="btn_area" id="selectFile${PORTLET_ID}">
			<div class="btn_inner_wrap">
				<span class="txt"><span id="regText${PORTLET_ID}"></span><kfmt:message key="pd.card.009"/></span><span id="fileBtn${PORTLET_ID}"></span>
			</div>
		</div>
		<div class="file_area" id="selectedFile${PORTLET_ID}">
			<div id="noFileList${PORTLET_ID}" class="no_file">
				<i class="i_clip"></i><span class="txt"><kfmt:message key="pd.card.010"/></span>
			</div>
			<ul id="fileList${PORTLET_ID}" class="file_list">
				<li class="file_item">
					<span class="file_name"><i class="i_file" id="newFileIcon${PORTLET_ID}"></i><span id="newFileName${PORTLET_ID}"></span></span><span id="newFileSize${PORTLET_ID}" class="file_size"></span>
					<div class="status">
						<div class="progress">
							<div id="fileUpdPer${PORTLET_ID}" class="percent"></div>
						</div>
						<span id="fileUpdText${PORTLET_ID}" class="statusText"></span>
					</div>
					<a id="fileClose${PORTLET_ID}" href="javascript:void(0);" title="<kfmt:message key="pd.card.011"/>" class="btn_del"><fmt:message key="pd.card.011"/></a>
				</li>
			</ul>
		</div>
		<div class="vrsn_area">
			<div class="vrsn_title"><kfmt:message key="pd.card.012"/></div>
			<div id="vrsnArea${PORTLET_ID}"></div>
		</div>
	</div>
	<div class="layer_bottom">
		<div class="btn_area" id="fncBtn${PORTLET_ID}"></div>
	</div>
</div>
<%@ include file="/jspf/tail.portlet.jsp" %>