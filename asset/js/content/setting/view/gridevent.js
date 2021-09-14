Ext.define('setting.view.gridevent' ,{
			extend: 'Ext.grid.Panel',
			id : 'gridevent',
			//width : 400,
			initComponent	: function()
			{
				var storegrid 	= Ext.create('setting.store.storegridevent');
				storegrid.load();
				
				var editing = Ext.create('Ext.grid.plugin.RowEditing', {
				  clicksToEdit: 2,
				  listeners :
					{					
						'edit' : function (editor,e) {
								 
								 var grid 	= e.grid;
								 var record = e.record;
								 
								var recordData = record.data; 
								console.log(recordData);
								
								Ext.Ajax.request({ 
									url: base_url+'admin/settings/insertevent',
									method: 'POST',
									params: recordData,
									success: function(response,requst){
										storegrid.proxy.extraParams = {
												"filter[0][field]" : "menu_id",
												"filter[0][data][type]" : "numeric",
												"filter[0][data][comparison]" : "eq",
												"filter[0][data][value]" : recordData.menu_id.substring(3)
										};
										storegrid.reload();
										//storegrid.reload();
									},
									failure:function(response,requst)
									{
										Ext.Msg.alert('Fail !','Input Data Entry Gagal');
										Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");
									}
												
								})
								
									
						}
					}
				});
				Ext.apply(this,{
					//fit		: true,
					split	: true,
					// filterable	: true,				
					store		: storegrid,
					multiSelect	: true,
					selType		: 'checkboxmodel',	
					id			: 'gridevent',
					dockedItems: [
					{
						xtype: 'toolbar',
						items: [
							{
								iconCls: 'add',
								itemId: 'addevent',
								text: 'Add event',
								handler	: function()
								{
									var r = [];
									var r = {
										"event_id"		: '',
										"event_name"	: '',
										"menu_id"		: eventact.id
									};
									
									storegrid.insert(0, r);
									//console.log(eventact);
								}
								//action: 'add'
							},
							{
								iconCls : 'disk',
								text	: 'Save',
								handler	: function()
								{
									storegrid.each(function(record){
									  //if(record.data.selectopts == true)
									  //{
											
											var data = [{
												role_menu_event_id : parseInt(record.data.event_id),
												menu_id			   : parseInt(eventact.id.substring(3)),
												group_id		   : Init.acc_group,
												//dataopts 		   : record.data.selectopts
											}];
											Ext.Ajax.request({	 
												
												url		: base_url+'admin/settings/insertevenmenuevent',
												method	: 'POST',
												params	: {
													data : Ext.encode(data),
													dataopts	: record.data.selectopts
												},
												success	: function(response,requst){
													
													//storegridstationconfigdetail.reload();
												},
												failure	:function(response,requst)
												{
													Ext.Msg.alert('Fail !','Input Data Entry Gagal');
													Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");
												}
															
											});
											console.log(record.data);
											
										
									  //}
									});
									
								}
							}]
					},
					{
						xtype: 'pagingtoolbar',
						dock: 'bottom',
						store: storegrid,
						displayInfo: true,
						items : [{
							xtype: 'button',
							text: 'Clear All',
							tooltip  : 'Clear Filters',
							iconCls  : 'page_white_magnify',
							handler:function(){
								storegrid.clearFilters();
								// cilukba.filters.clearFilters();
							}
						}]
					}],
					columns		: [
					Ext.create('Ext.grid.RowNumberer',
						{
							header: 'No', 
							width: 40
						}
						),				
						{	
							dataIndex 	: 'event_name',
							text 		: 'Event Name',
							flex		: 1,
							editor		: {
								xtype	: 'textfield',
								name	: 'event_name'
							}

						},
						{
							dataIndex 	: 'menu_id',
							text 		: 'Id Menu',
						}],
					plugins	: editing,
					listeners	: 
						{
						'render': function(component) {
							this.store.on('load', function(records) {
									Ext.each(records, function(record){
										var n = 0;
										var ch = false;
										Ext.each(record.data.items, function(data){
											
											var ch = data.data.checked;
											var grid = Ext.getCmp('gridevent');
											console.log(n);
											console.log(ch);
											
											if(ch == true)
											{
												grid.getView().getSelectionModel().select(n,true);
											}
											n++;
											
											//getSelectionModel().select(n,ch);
										
											//console.log(data.data);
											//console.log(n);
										});
										//itemsarea.push(record.get('area'));
													//n++;
									});
									//
									//this.getView().getSelectionModel().selectAll();
									//this.getView().getSelectionModel().selectRow(0);
									//this.getView().getSelectionModel().selectRow(1);
									
									//this.getView().getSelectionModel().select(1,true);
									//this.getView().getSelectionModel().select(1);
									//grid.getView().focusRow(0);
								}, this, {
									multiSelect: true
								});

						},	
							beforeitemcontextmenu: function(view, record, item, index, e)
							{
								e.stopEvent();
								data = record.data;
								medugridkelengkapan.showAt(e.getXY());
							},
							itemclick	: function(view, record, item, index, e, eOpts)
							{
								console.log(record.data);
							},
							select: function (model, record, index, eOpts) {
								//console.log(record.data);
								//record.data.selectopts = true;
								record.set('selectopts',true);
							},
							deselect: function (view, record, item, index, e, eOpts) {
								//console.log('deselect fired'+index);
								//record.data.selectopts = false;
								record.set('selectopts',false);
							}
						}	
				});
				this.callParent(arguments);
			}
		})
