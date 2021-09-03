Ext.define('setting.view.formttdupload' ,{
	
	extend: 'Ext.form.Panel',
	initComponent: function() {	
			var pageId = Init.idmenu;
			//console.log(pageId);
			//store_rekanan_m
			var msclass = Ext.create('master.global.geteventmenu'); 
			var filter = [];
			
												
		Ext.apply(this, {
				xtype : 'form',
				header:false,
				frame : true,
				//id:'formttdupload'+pageId,
    			fileUpload : true,
				defaultType : 'textfield',
				url			: base_url+'simpel/form_ttdupload',
				method		: 'POST',
				bodyPadding: '5 5 0',
				fieldDefaults: {
					labelAlign: 'left',
				},
				items		: [
					{
						fieldLabel	: 'user_id',
						id				: 'ttduser_id'+pageId,
						name		: 'user_id',
						//value		:  no_usulan,
						hidden		: true
					},
					{
						xtype		: 'fieldset',
						//title			: 'Image',
						fileUpload	: false,
						border		: false,
						layout		: 'vbox',
						collapsible: false,
						layout		: 'anchor',
						defaults: {
							anchor: '70%'
						},
						items		: [
						{
							xtype : 'image',
							style: 'border: 1px solid black;margin-left:100px',
							//name:'url_ttd',
							id:'uplurl_ttd'+pageId,
							width:250,
							height:150,
							src : '',
							mode : 'image'
						},
						{
							xtype: 'label',
							style: 'border: 0px solid black;margin-left:100px',
							//fieldLabel	: 'Name',
							//text : pic_ttd,
							id : 'nama_td'+pageId,
							border: false,
							align : 'center',
							readOnly:true,
							//name		: 'nama',
							allowBlank: false
						}]
					},
					{
						xtype: 'filefield',
						//id: 'uplurl_ttd'+pageId,
						disabled:false,
						afterLabelTextTpl: required,
						//width: 150,
						fieldLabel: 'Edit',
						name: 'url_ttd',
						buttonText: 'Upload'
					}],
					buttons		: [
								{
									text: 'Upload',
									id: 'BtnUpload'+pageId,
									disabled:false,
									iconCls:'folder_go',
									//hidden:!ROLE.DRAFT_DATA,
									handler: function(){
										if(this.up('form').getForm().isValid()){
											this.up('form').getForm().submit({
												waitTitle	 	: 'Harap Tunggu',
												waitMsg 	: 'Upload data',
												success	:function(response,opt)
												{
													var ar = Ext.JSON.decode(opt.response.responseText);
													Ext.getCmp('uplurl_ttd'+pageId).setSrc(base_url+'signature/'+ar.data.url_ttd);
													Ext.getCmp('nama_td'+pageId).setText(ar.data.nama_ttd);
													Ext.getCmp('griduser').getStore().reload();
													Ext.Msg.alert('Sukses','Upload Sukses');
												},
												failure:function(response,opt)
												{
													//console.log(action);
													Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + opt.response.responseText + "");
												}
											});
									
										}
									}

								} 
						]
		});

		this.callParent(arguments);

		
	}
});