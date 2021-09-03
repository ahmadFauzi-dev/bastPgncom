Ext.define('dashboard.form.searchvalidasiprovisional' ,{
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
						xtype		: 'datefield',
						fieldLabel	: 'Start Date',
						name		: 'startt',
						format		: 'Y-m-d',
					},
					{
						xtype			: 'datefield',
						name			: 'endd',
						fieldLabel		: 'End Date',
						format			: 'Y-m-d',
		
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
									
								if	(oksparams.startt == '')
								{
									oksparams.startt = year+'-'+month+'- 01';
								}
								if (oksparams.endd == '')
								{
									oksparams.endd = msclass.formatDate(Date());
								}
								var panelchart = Ext.create('Ext.panel.Panel', {
									layout			: 'anchor',
									height			: 1000,
									items	: [{
										autoScroll		: true,
										xtype: 'tableauviz',
										height	: 1000,
										id		: 'tableauviz',
										flex	: 1,
										vizUrl	: "http://192.168.104.167:8000/trusted/"+tiketnumber+"/#/views/Dashboardvalidasipelangganprovisionalpersentase/Dashboard1?startdate="+oksparams.startt+"&endate="+oksparams.endd+"&:refresh=yes&:toolbar=no&:tabs=no&group_id="+group_id+"&username="+username+""
									}]
								});
								
								
								
								Ext.getCmp("panelprovisionalvalidasi").add(panelchart);
								Ext.getCmp("panelprovisionalvalidasi").doLayout();
								
									var viz = Ext.getCmp('tableauviz');
									var me = this;
									viz.on('marksselected', function(cmp, marks) {
										
										
										if(marks[0][1].formattedValue == "Approve")
										{
											
												var firstItem = Ext.getCmp('panelprovisionalvalidasi').items.first();
												Ext.getCmp('panelprovisionalvalidasi').remove(firstItem,true);
												var tiketnumber2 = msclass.getticket();
												var panelchart = Ext.create('Ext.panel.Panel', {
													autoScroll	: true,
													layout	: 'anchor',
													height	: 1000,	
													items	: [{
														xtype: 'tableauviz',
														height	: 1000,
														//id		: 'tableauviz',
														flex	: 1,
														vizUrl	: "http://192.168.104.167:8000/trusted/"+tiketnumber2+"#/views/DashboardPelangganWaktuvalidasi/Dashboard1?Area="+marks[0][0].formattedValue+"&start_date="+oksparams.startt+"&end_date="+oksparams.endd+"&:tabs=no&:toolbar=yes&:refresh=yes"
													}]
												});
												
												Ext.getCmp("panelprovisionalvalidasi").add(panelchart);
												Ext.getCmp("panelprovisionalvalidasi").doLayout();
											
											
											/*
											console.log("Masuk");
											var name = "Data";
											var msclass = Ext.create('master.global.geteventmenu'); 
											var tiketnumber2 = msclass.getticket();
											var tabPanel = Ext.getCmp('contentcenter');
												tabPanel.items.each(function(c){
													if (c.id == '3detailwaktuvalidasi') {
														tabPanel.remove(c);
													}
												});
												console.log(tabPanel);
												
												var items = tabPanel.items.items;
												var exist = false;
												
												//if (!exist) {
													// Ext.getCmp('contentcenter')
													tabPanel.add({
														title: 'Data',
														id: '3detailwaktuvalidasi',
														xtype: 'panel',
														iconCls: iconCls,
														closable: true,
														layout: 'border',
														// overflowY	: 'scroll',
														defaults: {
															collapsible: true,
															split: true,
															//bodyStyle: 'padding:5px'
														},
														// bodyPadding: '5 5 0',
														items: [
														{
															xtype : 'panel',
															title : " Area "+marks[0][0].formattedValue,
															frame	: true,
															region : 'center',
															//layout: 'fit',
															collapsible: false,
															flex: 3,		
															//items	: gridanomaliamr,
															// autoScroll : true,
															border: false,
															height	: 1000,
															autoScroll	: true,
															items	: [{
																xtype: 'tableauviz',
																height	: 1000,
																flex	: 1,
																vizUrl	: "http://192.168.104.167:8000/trusted/"+tiketnumber2+"#/views/DashboardPelangganWaktuvalidasi/Dashboard1?Area="+marks[0][0].formattedValue+"&start_date=2017-08-01&end_date=2017-08-07"
															}]
														}]
													});
													tabPanel.setActiveTab('3detailwaktuvalidasi');
													//Ext.getCmp("contentcenter").doLayout();
													*/
										}
												
										});
							
								
								
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