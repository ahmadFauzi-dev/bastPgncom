Ext.define('siangsa.validator.formrevised' ,{	
		extend: 'Ext.form.Panel',
		initComponent: function() {	
			var pageId = Init.idmenu;
			var ActionCombobox = Ext.create('Ext.data.Store', {
			fields: ['rowid', 'name'],
			data : [
				{"rowid":"MD419", "name":"Revisi"}
			]
			});
			ActionCombobox.load();
			
		Ext.apply(this, {
				xtype		: 'form',
				frame		: false,
				collapsed :false,
				url			: base_url+'siangsa/form_action',
				border		: false,
				//title		: "Form Revise",
				autoScroll	:true,
				fileUpload	: true,
				frame  		: false,
				method		: 'POST',
				//bodyPadding: '5 5 0',
				fieldDefaults: {
					labelAlign: 'left',
					anchor: '60%'
				},
				id					: 'formrevised',
				flex 				: 1,
				defaultType	: 'textfield',
				items		: [
				{		
						xtype		: 'fieldset',
						defaultType	: 'textfield',
						//id			: 'fieldsetformNewRelocation',
						border		: false,
						layout		: 'anchor',
						defaults: {
							anchor: '100%'
						},
						items		: [
								{
									xtype: 'label',
									labelClsExtra:'text-align-center',  
									height: 20,
								},
								{
									fieldLabel: "rowid",
									name: "rowid",
									id: "rowidrv"+pageId,
									hidden : true
									//fieldStyle: 'background:none'								
								},
								{
									xtype: 'combobox',
									fieldLabel: 'Action',
									name: 'reffstatus',
									//allowBlank	: false,
									store: ActionCombobox,
									valueField: 'rowid',
									editable: false,
									displayField: 'name',
									queryMode: 'local',
								},
								{
									xtype	  : 'textareafield',
									id 		  :'description',
									height	  : 200,
									fieldLabel: 'Keterangan',
									name	  : 'description'								
								}
						]
				}],
				buttons			: [
				{
							text: 'Kirim',
				            //id: 'Btntaskskdetail'+pageId,
				            disabled:false,
							border : true,
				            iconCls:'disk',
				            //hidden:!ROLE.DRAFT_DATA,
				            handler: function(){
								if(this.up('form').getForm().isValid()){
				            		this.up('form').getForm().submit({
										waitTitle	: 'Harap Tunggu',
										waitMsg		: 'Insert data', 
										params:{ 
											table : 'tb_bast',
											column : 'reffstatus'
										},
										success	:function(form, action)
										{
											//myMask.hide();
											Ext.Msg.alert('Sukses','Draft sudah tersimpan');
											Ext.getCmp('idgrid_permohonanbastcreator').getStore().reload();
											Ext.getCmp('formrevised').getForm().destroy();
											
											var tabPanel = Ext.getCmp('contentcenter');
											tabPanel.items.each(function(c){
												if (c.id == 'editdraft') {
													tabPanel.remove(c);
												}
											});
											Ext.getCmp('idgrid_permohonanbastcreator').getStore().load();											
											Init.winss_formrevisi.close();
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