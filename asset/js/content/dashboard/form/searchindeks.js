Ext.define('dashboard.form.searchindeks' ,{
		extend: 'Ext.form.Panel',
		// alias : 'widget.formvalidamr',
		initComponent: function() {
						
			Init.storeSBU.load();
			Init.storeArea.load();
			
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
				id			: 'formanomali',
				items		: 
				[			
						
					{
						xtype: 'monthfield',
						submitFormat: 'Y-m',
						name: 'startt',
						fieldLabel: 'Bulan',
						format: 'F, Y',
						id : 'bulandatanya'
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
								// console.log(record.data.rowid);
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
								// Ext.getCmp('searchanomaliform').collapse();
								var findform = this.up('form').getForm();
								var oksparams = findform.getValues();
								
								var fmonth = oksparams.startt.substr(5, 2);
								var fyear = oksparams.startt.substr(0, 4);
								var d = new Date(parseInt(fyear),parseInt(fmonth)-1);
								//console.log(oksparams.startt+'-01');
								var start_date = oksparams.startt+'-01';
								var end_date = oksparams.startt+'-31';
								
								
								
								var msclass = Ext.create('master.global.geteventmenu'); 
								var tiketnumber = msclass.getticket();
								var firstItem = Ext.getCmp('panelprovisionalvalidasi').items.first();
								//console.log(oksparams.sbu);
								
								var start_p = new Date(start_date);
								start_p.setMonth(start_p.getMonth() + 1);
								start_p.setDate(start_p.getDate() - 1);
								var end_date = msclass.formatDate(start_p);
								
								console.log(start_date);
								console.log(end_date);
								var gdmr = '';
								if(oksparams.sbu == 'RD 1')
								{
									gdmr = 'GDMR1'
								}
								if(oksparams.sbu == 'RD 2')
								{
									gdmr = 'GDMR2'
								}
								if(oksparams.sbu == 'RD 3')
								{
									gdmr = 'GDMR3'
								}else
								{
									gdmr = '';
								}
								
								Ext.getCmp('panelprovisionalvalidasi').remove(firstItem,true);
								var panelchart = Ext.create('Ext.panel.Panel', {
									//layout	: 'fit',
									//autoScroll	: true,
									layout: 'fit',
									//height	: 1000,
									items	: [{
										xtype: 'tableauviz',
										//height	: 1000,
										id		: 'tableauviz',
										flex	: 1,
										vizUrl	: "http://192.168.104.167:8000/trusted/"+tiketnumber+"/#/views/DataIndeks/Dashboard?start_date="+start_date+"&end_date="+end_date+"&sbu="+gdmr+"&area="+oksparams.area+"&idreff="+oksparams.id_pel+"&nm_pel="+oksparams.namapel+"&:refresh=yes&:toolbar=yes&:tabs=no&group_id="+group_id+"&username="+username+""
									}]
								});
								
								Ext.getCmp("panelprovisionalvalidasi").add(panelchart);
								Ext.getCmp("panelprovisionalvalidasi").doLayout();
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