Ext.define('measurement.view.formkalibrasi' ,{
		extend: 'Ext.form.Panel',
		initComponent: function() {	
		
			var msclass 	 = Ext.create('master.global.geteventmenu');
			var combomodel = msclass.getmodel('v_group_pel');
			var filter = [];
			var combostore = msclass.getstore(combomodel,'v_group_pel', filter);
			combostore.load();
			
			Init.storeSBU.load();
			Init.storeArea.load();
			
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
				id			: 'formkalibras',
				items		: 
				[	
					{
						xtype		: 'datefield',
						fieldLabel	: 'Start Date',
						name		: 'startt',
						format		: 'Y-m-d'
					},
					{
						xtype			: 'datefield',
						name			: 'endd',
						fieldLabel		: 'End Date',
						format			: 'Y-m-d'		
					},					
					{
						xtype		: 'combobox',
						fieldLabel	: 'RD',						
						name		: 'sbu',
						displayField: 'description',
						valueField: 'description',
						queryMode: 'local',									
						store: Init.storeSBU,
						listeners : {
							select: function(combo) 
							{
								 var values = combo.getValue(),
								 record = combo.findRecordByValue(values);
								 //console.log(record.data.rowid);
								 Init.storeArea.reload({ params : { sbu : record.data.rowid }});
								
							 }
						 }

						
					},
					{
						xtype		: 'combobox',
						fieldLabel	: 'Area',						
						name		: 'area',
						displayField: 'namearea',
						valueField: 'namearea',
						queryMode: 'local',									
						store: Init.storeArea
					},
					{
						xtype		: 'combobox',
						fieldLabel	: 'Pelanggan',						
						name		: 'pelanggan',
						displayField: 'typeofpel',
						valueField: 'typeofpel',
						queryMode: 'local',
						store:  combostore						
					},
					{
						xtype		: 'textfield',
						fieldLabel	: 'Asset Number',
						name		: 'asset'
					},					
					{
						xtype		: 'textfield',
						fieldLabel	: 'ID Pelanggan',
						name		: 'id_pel'
					},
					{
						xtype		: 'textfield',
						fieldLabel	: 'Nama Pelanggan',
						name		: 'namapel'
					}					
					
				
				],
				buttons		: [{
							text	: 'Search',
							iconCls : 'magnifier',
							handler	: function()
							{
								var findform = this.up('form').getForm();
								var oksparams = findform.getValues();
								var gridkalibrasi = Ext.getCmp('gridkalibrasi').getStore();		gridkalibrasi.getProxy().extraParams = {
									view : " getmaintenance_asset('', '', '"+oksparams.startt+"', '"+oksparams.endd+"', '"+oksparams.sbu+"', '"+oksparams.area+"', '1,2', '"+oksparams.id_pel+"', '"+oksparams.namapel+"')"	,
									"filter[0][field]" : "typeofpel",
									"filter[0][data][type]" : "string",
									"filter[0][data][comparison]" : "eq",
									"filter[0][data][value]" : oksparams.pelanggan,
									"filter[1][field]" : "serialnumber",
									"filter[1][data][type]" : "string",
									"filter[1][data][comparison]" : "eq",
									"filter[1][data][value]" : oksparams.asset
									};								
								
								gridkalibrasi.loadPage(1);
								
							}
						},
						{
							text	: 'Reset',
							iconCls : 'arrow_refresh',
							handler	: function()
							{
								this.up('form').getForm().reset();
							}
						}
				]
		});

		this.callParent(arguments);
	}
	});