Ext.define('mapping.view.formmapping' ,{
		extend: 'Ext.form.Panel',
		alias : 'widget.formmapping',
		initComponent: function() {		
			var sbuval;
			var station_id = 0;
			var msclass 	= Ext.create('master.global.geteventmenu');
			
			
			var model 		= msclass.getmodel('idx_configuration');	
			var modelmsatation = msclass.getmodel('v_msatationnotbulk');
			//var modelsingle = msclass.getmodel('');
			var filterstation = [];
			var filtermultisource = [];
			var filtermulti = [];
			var storeismultisource =  msclass.getstore(model,'idx_configuration',filtermultisource);
			var storemstation 	   = msclass.getstore(modelmsatation,'v_msatationnotbulk',filterstation);
			var storemulti 	       = msclass.getstore(modelmsatation,'idx_configuration',filtermulti);
			
			storeismultisource.getProxy().extraParams = {
				view 				: "idx_configuration",
				"filter[0][field]"  : "typeof",
				"filter[0][data][type]" : "string",
				"filter[0][data][comparison]" : "eq",
				"filter[0][data][value]" : "ITC1"
			};
			
			storemulti.getProxy().extraParams = {
				view 				: "idx_configuration",
				"filter[0][field]"  : "typeof",
				"filter[0][data][type]" : "string",
				"filter[0][data][comparison]" : "eq",
				"filter[0][data][value]" : "ITC4"
			};
			storeismultisource.load();
			//storemstation.load();
			storemulti.load();
			
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
				//id			: 'formmapping'+Init.idmenu+'',
				url			: base_url+'admin/mapping/mappingpelanggansource',
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
						name		: 'ismulti',
						fieldLabel	: 'Is Multi Source',
						store		: storemulti,
						displayField: 'confname',
						valueField	: 'rowid'
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
								sbuval = record.data.rowid;
								//console.log(record.data.rowid);
								//Init.storeArea.reload({ params : { sbu : record.data.rowid }});
								
							}
						}						
					},
					{
						xtype		: 'combobox',
						fieldLabel	: 'Jenis Station',
						displayField: 'confname',
						store		: storeismultisource,
						valueField	: 'rowid',
						id			: 'multi',
						listeners : {
						select: function(combo) 
							{
								//combo.setLoading(true,true);
								var values = combo.getValue(),
								record = combo.findRecordByValue(values);
								//console.log(record.data.rowid);
								storemstation.removeAll();
								storemstation.getProxy().extraParams = {
									view : "v_msatationnotbulk",
										"filter[0][field]" : "stationtype",
										"filter[0][data][type]" : "string",
										"filter[0][data][comparison]" : "eq",
										"filter[0][data][value]" : record.data.rowid,
										"filter[1][field]" 			  : "sbucd",
										"filter[1][data][type]" 	  : "string",
										"filter[1][data][comparison]" : "eq",
										"filter[1][data][value]" 	  : sbuval
								};	
								 storemstation.reload();
								
							}
						}
					},
					{
						xtype			: 'combobox',
						fieldLabel		: 'Station',
						displayField	: 'stationname',
						name			: 'stationname',
						valueField		: 'rowid',
						store			: storemstation,						
						listeners : {
							select: function(combo) 
							{
								var values = combo.getValue(),
								record = combo.findRecordByValue(values);
								station_id = record.data.reffidstation;
								Ext.getCmp('stationid').setValue(station_id);						
							}
						}
					},
					{
						xtype : 'hidden',  
						name  : 'station_id',
						value : station_id,
						id	 : 'stationid'
					}
				],
				buttons		: [{
							text	: 'Submit',
							iconCls : 'disk_multiple',
							handler	: function()
							{
								var getstore = Ext.getCmp('11gridpelindustri').getStore();
								var datasubmit = [];
								//console.log(getstore);
								getstore.each(function(record){
									
									if(record.data.selectopts == true)
									{
										//console.log();
										datasubmit.push(record.data);
									}
								});
								//console.log(datasubmit);
								
								var data = Ext.encode(datasubmit);
								var findform = this.up('form').getForm();
								var oksparams = findform.getValues();
								console.log(oksparams);
								var params = {
										data	: data,
										endd	: oksparams.endd,
										startt	: oksparams.startt,
										ismulti	: oksparams.ismulti,
										sbu		: oksparams.sbu,
										station_id	: oksparams.station_id,
										stationname	: oksparams.stationname,
										id		: '11gridpelindustri'
										
								};
								var url = base_url+'admin/mapping/mappingpelanggansource';
								msclass.savedata(params,url);
								var storelegend = Ext.getCmp('Gridlegend').getStore();
								storelegend.loadPage(1);
								//console.log(params);
								/*
								this.up('form').getForm().submit({
									waitTitle	: 'Harap Tunggu',
									waitMsg		: 'Insert data',
									/*
									params		: {
										data	: data,
										endd	: oksparams.oksparams,
										startt	: oksparams.startt,
										ismulti	: oksparams.oksparams,
										sbu		: oksparams.sbu,
										station_id	: oksparams.station_id,
										stationname	: oksparams.stationname
										
									},
									
									success	:function(form, action)
									{
										//store_site.reload();
										Ext.Msg.alert('Sukses','Penambahan Content Sukses');
										Ext.getCmp('winmanualghv').hide();
									},
									failure:function(form, action)
									{
										Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");
									}
								});
								*/
								this.up('form').getForm().reset();								
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