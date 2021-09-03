Ext.define('dashboard.form.searchvalidasiparetoanomalienergi' ,{
		extend: 'Ext.form.Panel',
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
						xtype			: 'datefield',
						name			: 'startdate',
						fieldLabel		: 'Tanggal',
						format			: 'Y-m-d',
		
					},
					{
						xtype			: 'datefield',
						name			: 'endd',
						fieldLabel		: 'Tanggal',
						format			: 'Y-m-d',
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
								var msclass = Ext.create('master.global.geteventmenu'); 
								var tiketnumber = msclass.getticket();
								var firstItem = Ext.getCmp('panelprovisionalvalidasi').items.first();
								Ext.getCmp('panelprovisionalvalidasi').remove(firstItem,true);
								
								var start_p = new Date(oksparams.endd);
								start_p.setMonth(start_p.getMonth() - 1);
								
									var d = new Date();
									month = '' + (d.getMonth() + 1);
									day = '' + d.getDate();
									year = d.getFullYear();
									
									if	(parseInt(month) < 10)
									{
										month = '0' + (d.getMonth() + 1);
									}
									if (parseInt(d.getDate()) < 10) 
									{
										day = '0' + d.getDate();
									}
									
									if	(oksparams.startdate == '')
									{
										oksparams.startdate = year+'-'+month+'- 01';
									}
									if (oksparams.endd == '')
									{
										oksparams.endd = msclass.formatDate(Date());
									}
								var panelchart = Ext.create('Ext.panel.Panel', {
									//autoScroll	: true,
									layout	: 'anchor',
									height	: 1000,				
									items	: [{
										xtype: 'tableauviz',
										height	: 1000,	
										flex	: 1,
										vizUrl	: "http://192.168.104.167:8000/trusted/"+tiketnumber+"/#/views/DashboardPencapaianEnergy/DashboardPemakaianVolumeM3?Area="+oksparams.area+"&start_date="+oksparams.startdate+"&end_date="+oksparams.endd+"&idreff="+oksparams.id_pel+"&nmpel="+oksparams.namapel+"&:refresh=yes&:tabs=no&group_id="+group_id+"&username="+username+"&sbu="+oksparams.sbu+""
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