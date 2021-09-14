Ext.define('masterdata.view.form_srcklasifikasi' ,{
		extend: 'Ext.form.Panel',
		initComponent: function() {
			
			var pageId = Init.idmenu;
			var filter = [];
			var msclass = Ext.create('master.global.geteventmenu'); 
			var modelPer = msclass.getmodel("fn_getdatamastertype('TOD34')");
			var storePer =  msclass.getstore(modelPer,"fn_getdatamastertype('TOD34')",filter);
			storePer.load();
			
			Ext.apply(this, {
				frame		: false,
				border		: false,
				layout		: 'form',
				frame  		: false,
				method		: 'POST',
				bodyPadding: '5 5 0',
				fieldDefaults: {
					labelAlign: 'left',
					anchor: '60%'
				},
				id			: 'formsrcklasifikasi',
				items		: 
				[			
					{
						xtype		: 'combobox',
						fieldLabel	: 'Nama Perusahaan',						
						name		: 'id_perusahaan',
						displayField: 'desk',
						valueField: 'id',
						queryMode: 'local',									
						store: storePer
					},
					{
						xtype		: 'textfield',
						fieldLabel	: 'Nama klasifikasi',
						name		: 'name'
					}
				],
				buttons		: [{
							text	: 'Search',
							iconCls : 'magnifier',
							handler	: function()
							{
								var findform = this.up('form').getForm();
								oksparams = findform.getValues();
								var store_div = Ext.getCmp('gridklasifikasi'+pageId).getStore();
								store_div.getProxy().extraParams = {
									view :'v_klasifikasi',				
									limit : 'All',									
									"filter[0][field]" : "id_perusahaan",
									"filter[0][data][type]" : "string",
									"filter[0][data][comparison]" : "eq",
									"filter[0][data][value]" : oksparams.id_perusahaan,
									"filter[1][field]" : "name",
									"filter[1][data][type]" : "string",
									"filter[1][data][comparison]" : "",
									"filter[1][data][value]" : oksparams.name
								};
								store_div.load();
								Init.id_perusahaan = oksparams.id_perusahaan;
							}
						},
						{
							text	: 'Reset',
							iconCls : 'arrow_refresh',
							handler	: function()
							{
								this.up('form').getForm().reset();
							}
						}]
		});

		this.callParent(arguments);
	}
	});