Ext.define('masterdata.view.form_srcdivisi' ,{
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
				id			: 'formsrcdivisi',
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
						fieldLabel	: 'Nama Divisi',
						name		: 'nama_divisi'
					}
				],
				buttons		: [{
							text	: 'Search',
							iconCls : 'magnifier',
							handler	: function()
							{
								var findform = this.up('form').getForm();
								oksparams = findform.getValues();
								var store_div = Ext.getCmp('griddivisi'+pageId).getStore();
								Init.id_perusahaans = oksparams.id_perusahaan;
								store_div.getProxy().extraParams = {
									view :'v_divisi',				
									limit : 'All',									
									"filter[0][field]" : "id_perusahaan",
									"filter[0][data][type]" : "string",
									"filter[0][data][comparison]" : "eq",
									"filter[0][data][value]" : oksparams.id_perusahaan,
									"filter[1][field]" : "nama_divisi",
									"filter[1][data][type]" : "string",
									"filter[1][data][comparison]" : "",
									"filter[1][data][value]" : oksparams.nama_divisi
								};
								store_div.load();
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