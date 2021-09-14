Ext.define('masterdata.view.form_email_template' ,{
		extend: 'Ext.form.Panel',
		initComponent: function() {
			var pageId = Init.idmenu;
			//tbl_rekanan	
				Ext.apply(this,{
						xtype	: 'form',
						//id		: 'formAct',
						fileUpload: true,
						border	: false,
						defaultType : 'textfield',
						url		: base_url+'masterdata/update_template',
						frame	: false,
						method	: 'POST',
						layout	: 'fit',
						items		: [								
								{
									name: 'rowid',
									id			: 'id_emails',
									hidden : true
								},
								{									
									xtype: 'textareafield',
									layout	: 'fit',
									name: 'template',
									id			: 'template_email',
									anchor: '100%',
								}],
						buttons			: [{
							text	: "Save",
							handler	: function()
							{
								
								this.up('form').getForm().submit({
									waitTitle	: 'Harap Tunggu',
									waitMsg		: 'Insert data',
									success	:function(form, action)
									{
										Ext.Msg.alert('Sukses','Input Data Entry Sukses');
										Ext.getCmp('grid_emailtemplate'+pageId).getSelectionModel().clearSelections();
										var grid_emailtemplate = Ext.getCmp('grid_emailtemplate'+pageId).getStore();
										grid_emailtemplate.reload();
										//console.log(initComponent);
										Init.winss_tmpl_email.close();
									},
									failure:function(form, action)
									{
										Ext.Msg.alert('Fail !','Input Data Entry Gagal');
										Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");
									}
								});
							}
						},
						{
							text	: 'Cancel',
							handler	: function()
							{
								Init.winss_tmpl_email.close();
							}
						}]
					});
		this.callParent(arguments);
	}
});