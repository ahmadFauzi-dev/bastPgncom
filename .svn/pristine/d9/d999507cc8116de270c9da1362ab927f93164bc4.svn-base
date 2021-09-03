Ext.define('siangsa.validator.formuploadbast' ,{	
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
				id:'formuploadbast'+pageId,
    			fileUpload : true,
				defaultType : 'textfield',
				url			: base_url+'siangsa/form_uploadbast',
				method		: 'POST',
				bodyPadding: '5 5 0',
				fieldDefaults: {
					labelAlign: 'left',
				},
				items		: [
					{
						fieldLabel	: 'rowid',
						id		: 'rowid'+pageId,
						name		: 'rowid',
						hidden	: true
					},
					{
						xtype: 'filefield',
						disabled:false,
						afterLabelTextTpl: required,
						width: 460,
						fieldLabel: 'Dokumen',
						name: 'url_document',
						buttonText: 'Unggah'
					}],
					buttons		: [
								{
									text: 'Upload',
									//id: 'BtnUpload'+pageId,
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
													Ext.Msg.alert('Sukses','Upload Sukses');
													Ext.getCmp('formuploadbast'+pageId).getForm().destroy();
													Init.winss_form.close();
													Ext.getCmp('idgrid_bastcreator').getStore().reload();												},
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