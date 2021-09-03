Ext.define('master.view.searchstation' ,{
		extend: 'Ext.form.Panel',
		// alias : 'widget.formvalidamr',
		initComponent: function() {	
			
			Init.storeSBU.load();
			Init.storeArea.load();
			var filter 		= [];
			
			var msclass 			= Ext.create('master.global.geteventmenu');
			var model 				= msclass.getmodel('v_jenissbu');
			var storejenissbu 		= msclass.getstore(model,'v_jenissbu',filter);
			
			var modeljenisstation 	= msclass.getmodel('v_jenisstation');
			var storejenisstation	= msclass.getstore(modeljenisstation,'v_jenisstation',filter);
			
			storejenissbu.load();
			storejenisstation.load();
			
			Ext.apply(this, {
				frame		: false,
				border		: false,
				layout		: 'form',
				frame  		: false,
				method		: 'POST',
				// url			: base_url+'admin/findamr',
				bodyPadding: '5 5 0',
				fieldDefaults: {
					labelAlign: 'left',
					anchor: '60%'
				},
				id			: 'searchform',
				items		: 
				[					
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
						fieldLabel	: 'Jenis Station',
						name		: 'jenisstation',
						displayField	: 'confname',
						valueField		: 'confname',
						store			: storejenisstation
					},
					{
						xtype		: 'textfield',
						fieldLabel	: 'Station ID',
						name		: 'stationid'
					},
					{
						xtype		: 'textfield',
						fieldLabel	: 'Nama Station',
						name		: 'stationname'
					}	
				],
				buttons		: [{
							text	: 'Search',
							iconCls : 'magnifier',
							handler	: function()
							{
								var findform  = this.up('form').getForm();
								var oksparams = findform.getValues();
								var store 	  = Ext.getCmp('stationlistgrid').getStore();
								
								//console.log(oksparams);
								store.getProxy().extraParams = {
									view :'v_station',
									"filter[0][field]" : "jenis_station",
									"filter[0][data][type]" : "string",
									"filter[0][data][comparison]" : "eq",
									"filter[0][data][value]" : oksparams.jenisstation,
									
									"filter[1][field]" : "sbu",
									"filter[1][data][type]" : "string",
									"filter[1][data][comparison]" : "eq",
									"filter[1][data][value]" : oksparams.sbu,
									
									"filter[2][field]" : "stationid",
									"filter[2][data][type]" : "string",
									//"filter[2][data][comparison]" : "eq",
									"filter[2][data][value]" : oksparams.stationid,
									
									"filter[2][field]" : "stationname",
									"filter[2][data][type]" : "string",
									//"filter[2][data][comparison]" : "eq",
									"filter[2][data][value]" : oksparams.stationname,
								}
								store.load();
								//var storekelamr = Ext.getCmp('gridKelamr').getStore();
								
								/*
								if(oksparams.sbu != 'undefined' && oksparams.area == '')
								{
									
									var v_area = "";
									var v_reffcode = "";
									Init.storeArea.each(function(record){
										Ext.each(record.data, function(datarow, index) {
										  v_area +=""+datarow.namearea+",";
										  v_reffcode +=""+datarow.reffcd+"','";
										});
										
										
									});
									var v_area = v_area.substring(0, v_area.length - 1);
									var v_reffcode = v_reffcode.substring(0, v_reffcode.length - 3);
									
									oksparams.area = v_area;
									
								}
								
								storekelamr.getProxy().extraParams = {
									startt : oksparams.startt,
									endd : oksparams.endd,
									sbu : oksparams.sbu,
									area : oksparams.area,
									id_pel : oksparams.id_pel,
									namapel : oksparams.namapel,									
									reffcode : v_reffcode									
								};
								//var extraParams = storekelamr.proxy.extraParams;
								//extraParams.getauto = 0;
								
								//storekelamr.getProxy().extraParams = extraParams;
								
								storekelamr.load({method: 'POST'});	
								*/	
								
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