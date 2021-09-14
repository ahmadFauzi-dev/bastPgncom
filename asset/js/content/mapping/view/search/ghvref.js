Ext.define('mapping.view.search.ghvref' ,{
		extend: 'Ext.form.Panel',
		alias : 'widget.ghvrefsearch',
		initComponent: function() {		
			
			Init.storeSBU.load();
			Init.storeArea.load();
			
			Ext.apply(this, {
				frame		: false,
				border		: false,
				layout		: 'form',
				frame  		: false,
				method		: 'POST',
				bodyPadding	: '5 5 0',
				fieldDefaults	: {
					labelAlign	: 'left',
					anchor		: '60%'
				},
				id			: 'formvalid'+Init.idmenu,
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
								//combo.setLoading(true,true);
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
									/* for(var name in oksparams) {
										alert(oksparams[name]);
									} */
								var storevalid = Ext.getCmp(''+Init.idmenu+'gridghv').getStore();
								storevalid.getProxy().extraParams = {
									view :'v_mapmultisources',
									"filter[0][field]" : "tanggal_mapping",
									"filter[0][data][type]" : "date",
									"filter[0][data][comparison]" : "gt",
									"filter[0][data][value]" : oksparams.startt,
									
									"filter[1][field]" : "tanggal_mapping",
									"filter[1][data][type]" : "date",
									"filter[1][data][comparison]" : "lt",
									"filter[1][data][value]" : oksparams.endd,
									
									"filter[2][field]" : "sbu",
									"filter[2][data][type]" : "string",
									"filter[2][data][comparison]" : "eq",
									"filter[2][data][value]" : oksparams.sbu,
									
									"filter[3][field]" : "area",
									"filter[3][data][type]" : "string",
									"filter[3][data][comparison]" : "eq",
									"filter[3][data][value]" : oksparams.area,
									
									"filter[4][field]" : "idrefpelanggan",
									"filter[4][data][type]" : "string",
									//"filter[3][data][comparison]" : "eq",
									"filter[4][data][value]" : oksparams.id_pel,

									"filter[5][field]" : "pelname",
									"filter[5][data][type]" : "string",
									//"filter[3][data][comparison]" : "eq",
									"filter[5][data][value]" : oksparams.namapel									
								};
								/*
								storevalid.getProxy().extraParams = {
									startt : oksparams.startt,
									endd : oksparams.endd,
									sbu : oksparams.sbu,
									area : oksparams.area,
									id_pel : oksparams.id_pel,
									namapel : oksparams.namapel									
								};
								*/
								storevalid.loadPage(1);	
								// storevalid.reload({method: 'POST'});
								// stoe.reload();
								//Ext.getCmp('searchvalidasiform').collapse();			
								
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