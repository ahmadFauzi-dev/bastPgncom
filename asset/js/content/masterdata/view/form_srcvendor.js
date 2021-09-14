Ext.define('masterdata.view.form_srcvendor' ,{
		extend: 'Ext.form.Panel',
		initComponent: function() {
			
			var pageId = Init.idmenu;
			var filter = [];
			var msclass = Ext.create('master.global.geteventmenu'); 
			
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
				id			: 'form_srcvendor',
				items		: 
				[			
					{
						xtype		: 'textfield',						
						fieldLabel	: 'Nama Vendor',
						name		: 'nama_vendor'
					},
					{
						xtype		: 'textfield',
						fieldLabel	: 'Npwp',
						name		: 'npwp'
					},
					{
						xtype		: 'textfield',
						fieldLabel	: 'Alamat',
						name		: 'alamat'
					}
				],
				buttons		: [{
							text	: 'Search',
							iconCls : 'magnifier',
							handler	: function()
							{
								var findform = this.up('form').getForm();
								oksparams = findform.getValues();
								var store_div = Ext.getCmp('gridvendor'+pageId).getStore();
								
								var nama_vendor = oksparams.nama_vendor
								var alamat = oksparams.alamat
								var npwp = oksparams.npwp
								
								store_div.getProxy().extraParams = {
									view :'v_vendor',				
									limit : 'All',									
									"filter[0][field]" : "nama_vendorlow",
									"filter[0][data][type]" : "string",
									"filter[0][data][comparison]" : "",
									"filter[0][data][value]" : nama_vendor.toLowerCase(),
									"filter[1][field]" : "npwp",
									"filter[1][data][type]" : "string",
									"filter[1][data][comparison]" : "",
									"filter[1][data][value]" : oksparams.npwp,
									"filter[2][field]" : "alamatlow",
									"filter[2][data][type]" : "string",
									"filter[2][data][comparison]" : "",
									"filter[2][data][value]" : alamat.toLowerCase()
								};
								store_div.load();
								Ext.getCmp('gridpic'+pageId).getStore().removeAll();
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