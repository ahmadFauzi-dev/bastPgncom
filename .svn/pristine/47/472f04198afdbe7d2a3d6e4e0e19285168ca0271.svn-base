Ext.define('masterdata.view.form_add_divisi' ,{
	
		extend: 'Ext.form.Panel',
		initComponent: function() {	
			var pageId = Init.idmenu;
			var msclass = Ext.create('master.global.geteventmenu'); 
			var filter = [];
			var modeltype = msclass.getmodel("fn_getdatamastertype('TOD35')");
			var store_type =  msclass.getstore(modeltype,"fn_getdatamastertype('TOD35')",filter);
			store_type.load();
			
			var modelkepala = msclass.getmodel("v_jabatan");
			var store_kepala =  msclass.getstore(modelkepala,"v_jabatan",filter);
			store_kepala.getProxy().extraParams = {
						view :'v_jabatan',
						limit : "All",
						"filter[0][field]" : "id_perusahaan",
						"filter[0][data][type]" : "string",
						"filter[0][data][comparison]" : "eq",
						"filter[0][data][value]" : Init.id_perusahaans
					};
			store_kepala.load();
			
			var modelsekertaris = msclass.getmodel("v_jabatan");
			var store_sekertaris =  msclass.getstore(modelsekertaris,"v_jabatan",filter);
			store_sekertaris.getProxy().extraParams = {
						view :'v_jabatan',
						limit : "All",
						"filter[0][field]" : "id_perusahaan",
						"filter[0][data][type]" : "string",
						"filter[0][data][comparison]" : "eq",
						"filter[0][data][value]" : Init.id_perusahaans
					};
			store_sekertaris.load();
			
												
			Ext.apply(this, {
				xtype	: 'form',
				id		: 'formAddDivisi',
				border	: true,
				url		: base_url+'simpel/update_divisi',
				frame	: true,
				method	: 'POST',
				layout	: 'fit',
				items	: [{
					xtype		: 'fieldset',
					defaultType	: 'textfield',
					title		: 'Add divisi',
					collapsible	: false,
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
							width : 400,
							hidden : true,
						},
						{
							fieldLabel : 'Parent',
							name : 'parent',
							id:'parent'+pageId,
							width : 400,
							hidden : true,
						},
						{
							fieldLabel	: 'Parent',
							width : 400,
							name : 'parent_name',
							id : 'parent_name'+pageId,
							displayField: 'name',
							readonly:true
						},
						{
							fieldLabel	: 'Code',
							width : 400,
							name : 'code',
							id : 'code'+pageId,
							displayField: 'code',
							allowBlank  : false
						},
						{
							fieldLabel	: 'id_perusahaan',
							width : 400,
							name : 'id_perusahaan',
							id : 'id_perusahaan'+pageId,
							displayField: 'id_perusahaan',
							allowBlank  : false,
							hidden : true
						},
						{
							fieldLabel	: 'Name',
							width : 400,
							value : '',
							name : 'name',
							id : 'name'+pageId,
							displayField: 'name',
							allowBlank  : false
						},
						{
							xtype : 'combobox',
							id:'id_typedivisi'+pageId,
							fieldLabel : 'Tipe Divisi',										
							store : store_type,
							name : 'id_typedivisi',
							displayField: 'nama',
							valueField: 'id',
							editable : true, 
							//value : npwp,
							//emptyText		: '',
							triggerAction : 'all',
							queryMode : 'local'
						},
						{
							xtype : 'combobox',
							id:'reffkepala'+pageId,
							fieldLabel : 'Pimpinan',										
							store : store_kepala,
							name : 'reffkepala',
							displayField: 'name',
							valueField: 'id',
							editable : true, 
							//value : npwp,
							//emptyText		: '',
							triggerAction : 'all',
							queryMode : 'local'
						},
						{
							xtype : 'combobox',
							id:'reffsekertaris'+pageId,
							fieldLabel : 'Sekretaris',										
							store : store_sekertaris,
							name : 'reffsekertaris',
							displayField: 'name',
							valueField: 'id',
							editable : true, 
							//value : npwp,
							//emptyText		: '',
							triggerAction : 'all',
							queryMode : 'local'
						},
						{
							fieldLabel	: 'No Surat',
							width : 400,
							name : 'last_numbersk',
							id : 'last_numbersk'+pageId,
							displayField: 'last_numbersk',
							allowBlank  : false
						},
						{
							fieldLabel	: 'No Disposisi',
							width : 400,
							name : 'last_numberdispo',
							id : 'last_numberdispo'+pageId,
							displayField: 'last_numberdispo',
							allowBlank  : false
						},]
				}],
				buttons			: [{
					text	: "Process",
					handler	: function()
					{
						
						this.up('form').getForm().submit({
							waitTitle	: 'Harap Tunggu',
							waitMsg		: 'Insert data',
							success	:function(form, action)
							{
								Ext.Msg.alert('Sukses','Input Data Entry Succes');
								Ext.getCmp('griddivisi'+pageId).getStore().reload();
								Init.winss_adddivisi.close();
							},
							failure:function(form, action)
							{
								Ext.Msg.alert('Fail !','Input Data Entry Fail');
							}
						});
					}
				}]
			});

		this.callParent(arguments);
	}
});