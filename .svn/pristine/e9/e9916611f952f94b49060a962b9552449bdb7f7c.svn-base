Ext.define('masterdata.view.form_add_jabatan' ,{
	
		extend: 'Ext.form.Panel',
		initComponent: function() {	
			var pageId = Init.idmenu;
			var msclass = Ext.create('master.global.geteventmenu'); 
			var filter = [];
			var modeltype = msclass.getmodel('v_divisi');
			var store_divisi =  msclass.getstore(modeltype,'v_divisi',filter);
			store_divisi.getProxy().extraParams = {
				view : "v_divisi",
				limit : "All"		
			};
			store_divisi.load();
			
			var modelpangkat = msclass.getmodel("fn_getdatamastertype('TOD36')");
			var store_pangkat =  msclass.getstore(modelpangkat,"fn_getdatamastertype('TOD36')",filter);
			store_pangkat.getProxy().extraParams = {
				view : "fn_getdatamastertype('TOD36')",
				limit : "All"		
			};
			store_pangkat.load();
			
			
												
			Ext.apply(this, {
				xtype	: 'form',
				id		: 'formAddJabatan',
				border	: false,
				url		: base_url+'simpel/update_jabatan',
				frame	: false,
				method	: 'POST',
				layout	: 'fit',
				items	: [{
					xtype		: 'fieldset',
					defaultType	: 'textfield',
					title		: 'Add Jabatan',
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
							fieldLabel	: 'id_perusahaan',
							width : 400,
							name : 'id_perusahaan',
							id : 'id_perusahaan'+pageId,
							displayField: 'id_perusahaan',
							allowBlank  : false,
							hidden : true
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
							id:'divisi_id'+pageId,
							fieldLabel : 'Divisi',										
							store : store_divisi,
							name : 'divisi_id',
							displayField: 'nama_divisi',
							valueField: 'id',
							editable : true, 
							triggerAction : 'all',
							queryMode : 'local',
						},
						{
							xtype : 'combobox',
							id:'pangkat_id'+pageId,
							fieldLabel : 'Pangkat',										
							store : store_pangkat,
							name : 'pangkat_id',
							displayField: 'nama',
							valueField: 'id',
							editable : true, 
							triggerAction : 'all',
							queryMode : 'local',
						}]
				}],
				buttons			: [
							{
								text: 'Disposisi',
								//id: 'Btn'+pageId+'add',
								disabled:false,
								border : true,
								iconCls:'disk',
								//hidden:!ROLE.DRAFT_DATA,
								handler: function(){									
									
									if(this.up('form').getForm().isValid()){
										this.up('form').getForm().submit({
											waitTitle	: 'Harap Tunggu',
											waitMsg		: 'Insert data', 
											success	:function(form, action)
											{
												Ext.getCmp('gridjabatan'+pageId).getStore().reload();
												Init.winss_addjabatan.close();
											},
											failure:function(form, action)
											{
												Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");
											}
										});
									}
								}
							}]
			});

		this.callParent(arguments);
	}
});