Ext.define('masterdata.view.form_klasifikasi' ,{
	
	extend: 'Ext.form.Panel',
	initComponent: function() {	
			var pageId = Init.idmenu;
			//console.log(pageId);
			//store_rekanan_m
			var msclass = Ext.create('master.global.geteventmenu'); 
			var filter = [];						
												
			Ext.apply(this, {
				xtype	: 'form',
				id		: 'formKlasifikasi',
				border	: true,
				url		: base_url+'simpel/act_klasifikasi',
				frame	: true,
				method	: 'POST',
				layout	: 'fit',
				items	: [{
					xtype		: 'fieldset',
					defaultType	: 'textfield',
					title		: '',
					collapsible	: false,
					border	: false,
					fileUpload	: false,
					layout		: 'anchor',
					defaults: {
						anchor: '100%'
					},
					
					items		: [
						{
							fieldLabel : 'rowid',
							name : 'rowid',
							id:'rowid'+pageId,
							//width : 400,
							hidden : true,
						},
						{
							fieldLabel : 'id_perusahaan',
							name : 'id_perusahaan',
							id:'id_perusahaan'+pageId,
							//width : 400,
							hidden : true,
						},
						{
							fieldLabel : 'Parent',
							name : 'parent',
							id:'parent'+pageId,
							//width : 400,
							hidden : true,
						},
						{
							fieldLabel	: 'Parent',
							width : 400,
							name : 'parent_name',
							disabled : true,
							id : 'parent_name'+pageId,
							displayField: 'parent_name',
							readonly:true
						},
						{
							xtype: 'fieldcontainer',
							fieldLabel: 'Code',
							layout: 'hbox',
							defaultType: 'textfield',
							 items: [
							{
								//fieldLabel	: 'Code',
								width : 150,
								disabled : true,
								name : 'code1',
								id : 'code1'+pageId,
								displayField: 'code1',
								//allowBlank  : false
							},
							{
								xtype: 'label',
								labelClsExtra:'text-align-center',  
								width: 15,
							},
							{
								//fieldLabel	: 'Code',
								width : 100,
								name : 'code2',
								id : 'code2'+pageId,
								displayField: 'code2',
								allowBlank  : false
							}]
						},
						{
							fieldLabel	: 'Name',
							//width : 400,
							value : '',
							name : 'name',
							id : 'name'+pageId,
							displayField: 'name',
							allowBlank  : false
						}]
				}],
				buttons			: [{
					text	: "Process",
					handler	: function()
					{
						Ext.getCmp('code1'+pageId).setDisabled(false);
						if(this.up('form').getForm().isValid()){
							this.up('form').getForm().submit({
								waitTitle	: 'Harap Tunggu',
								waitMsg		: 'Insert data',
								success	:function(form, action)
								{
									Ext.Msg.alert('Sukses','Input Data Entry Succes');
									Ext.getCmp('gridklasifikasi'+pageId).getStore().load({method: 'POST',params : {'node':'root'}});
									Ext.getCmp('code1'+pageId).setDisabled(true);
									Init.winss_formklasifikasi.close();
								},
								failure:function(form, action)
								{
									Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");
									Ext.getCmp('code1'+pageId).setDisabled(true);
								}
							});
						}
					}
				}]
			});

		this.callParent(arguments);
	}
});