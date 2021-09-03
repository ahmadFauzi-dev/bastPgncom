Ext.define('mapping.view.search.pellsourcesearch' ,{
		extend: 'Ext.form.Panel',
		alias : 'widget.pellsourcesearch',
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
				//id			: 'as',
				items		: 
				[	
					{
						xtype: 'monthfield',
						submitFormat: 'Y-m',
						name: 'startt',
						fieldLabel: 'Start Month',
						format: 'F, Y',
						id : 'stbulandatanya'
					},
				
				
					// {
						// xtype		: 'datefield',
						// fieldLabel	: 'Start Date',
						// name		: 'startt',
						// format		: 'Y-m-d',
					// },
					// {
						// xtype			: 'datefield',
						// name			: 'endd',
						// fieldLabel		: 'End Date',
						// format			: 'Y-m-d',
		
					// },
					{
						xtype: 'monthfield',
						submitFormat: 'Y-m',
						name: 'endd',
						fieldLabel: 'End Month',
						format: 'F, Y',
						id : 'endbulandatanya'
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
					/* {
						xtype		: 'combobox',
						fieldLabel	: 'Status',						
						name		: 'status',
						displayField: 'name',
						valueField: 'id',
						queryMode: 'local',
						store: new Ext.data.ArrayStore({
									id: 0,
									fields: [
										'id',
										'name'
									],
									data: [[1, 'Mapping'], [2, 'Unmapping'],[3, 'All']]
						}), 						
					}, */				
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
								 var paramsearch = [{
									 field :"sbu",
									 data  : {
										 type : "string",
										 comparison : "eq",
										 value	   : oksparams.sbu
									 } 
								 },
								 {
								 field :"area",
									 data : {
										 type : "string",
										 comparison : "eq",
										 value	   : oksparams.area
									 }
								 },
								 {
									 field :"idrefpelanggan",
									 data  : {
										 type : "string",
										 comparison : "eq",
										 value	   : oksparams.id_pel
									 }
								 },
								 {
									 field :"pelname",
									 data  : {
										 type : "string",
										 comparison : "eq",
										value	   : oksparams.namapel
									 }
								}];
								
								var storevalid = Ext.getCmp('11gridpelindustri').getStore();
								var storelegend = Ext.getCmp('Gridlegend').getStore();
								/*
								storevalid.getProxy().extraParams = {
									view :'v_pelangganindustri',
									search	: Ext.encode(paramsearch),
									"filter[2][field]" : "sbu",
									"filter[2][data][type]" : "string",
									"filter[2][data][comparison]" : "eq",
									"filter[2][data][value]" : oksparams.sbu,
									
									"filter[3][field]" : "namearea",
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
								};*/
								
								storevalid.getProxy().extraParams = {
									startt : oksparams.startt,
									endd : oksparams.endd,
									sbu : oksparams.sbu,
									area : oksparams.area,
									station : oksparams.station,
									id_pel : oksparams.id_pel,
									namapel : oksparams.namapel,
									//search	: 	paramsearch,
									search	: Ext.encode(paramsearch),
								};
								storevalid.loadPage(1);
								// storevalid.reload({method: 'POST'});
								// stoe.reload();
								//Ext.getCmp('searchvalidasiform').collapse();		

								storelegend.getProxy().extraParams = {
									startt : oksparams.startt,
									endd : oksparams.endd,
									sbu : oksparams.sbu,
									area : oksparams.area,
									station : oksparams.station,
									id_pel : oksparams.id_pel,
									namapel : oksparams.namapel,
									//search	: 	paramsearch,
									search	: Ext.encode(paramsearch),
								};
								storelegend.loadPage(1);								
								
								
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