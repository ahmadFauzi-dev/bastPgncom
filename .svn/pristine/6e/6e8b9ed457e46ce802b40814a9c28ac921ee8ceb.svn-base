Ext.define('masterdata.view.jenis_workflow',{
	extend: 'Ext.grid.Panel',
	initComponent	: function()
	{
			//var dataselect;
			var msclass = Ext.create('master.global.geteventmenu'); 
			var pageId = Init.idmenu;
			var filter = [];
			var columns = msclass.getcolumn('public.ms_activity');
			//store.load();
			
			var model = msclass.getmodel('public.ms_activity');
			var store =  msclass.getstore(model,'public.ms_activity',filter);
												
			var model = msclass.getmodel('public.module_type');
			var store_module =  msclass.getstore(model,'public.module_type',filter);
			
			//store_module.load();

			
			columns[1].hidden = true;
			columns[2] =  {
					text	: 'Nama',
					width : '95%',
					align	: 'left',
					dataIndex : columns[2].dataIndex,
			};
			columns[3].hidden	= true;
			columns[4].hidden	= true;
			
			Ext.apply(this, {
						store		: store,
						title	:'Jenis Workflow',
						multiSelect	: true,
						height		: 200,	
						autoScroll	: true,
						id			: 'jenis_workflow',
						dockedItems	: [{
							 xtype: 'fieldcontainer',
							 labelStyle: 'font-weight:bold;padding:0',
							 layout: 'hbox',
							 height:35,
							 defaultType: 'textfield',
							 items: [
							 {
									xtype: 'label',
									labelClsExtra:'text-align-center',  
									width: 5,
							 },
							 {
								 xtype: 'fieldcontainer',
								 labelStyle: 'font-weight:bold;padding:0',
								 layout: 'vbox',
								 height:35,
								 defaultType: 'textfield',
								 items: [
								 {
									id : 'jobpositionparams'+pageId,
									hidden:true,
								}, 
								 {
									xtype: 'label',
									labelClsExtra:'text-align-center',  
									height: 5,
								 },
								  {
			                            xtype : 'combobox',
										id: 'combobox_module'+pageId,
										fieldLabel : 'Module',										
										store : store_module,
										name: 'modul_type_id',
										displayField: 'name',
										width: 450,
										valueField: 'rowid',
										editable : true, 
										triggerAction : 'all',
										queryMode : 'local',
										listeners: {
											select: function(combo, record, index){										
												//console.log(combo.value);
												store.getProxy().extraParams = {
													view :'ms_activity',
													"filter[0][field]" : "module_type_id",
													"filter[0][data][type]" : "numeric",
													"filter[0][data][comparison]" : "eq",
													"filter[0][data][value]" : combo.value
												};
												store.reload();
												
											}
										}
			                        }]
							}]
						}],
						columns		: columns,
						listeners		: {
									itemclick: function (grid, record, item, index, e, eOpts) 
									{
										dataselect = record.data;
										var jobposition = Ext.getCmp( 'jobpositionparams'+pageId).getValue();
										var grid_workflow = Ext.getCmp( 'grid_workflow').getStore();
										
										grid_workflow.getProxy().extraParams = {
													view :'v_workflow',
													"filter[0][field]" : "reffactivity",
													"filter[0][data][type]" : "numeric",
													"filter[0][data][comparison]" : "eq",
													"filter[0][data][value]" : dataselect.id,
													"filter[1][field]" : "createbyt",
													"filter[1][data][type]" : "numeric",
													"filter[1][data][comparison]" : "eq",
													"filter[1][data][value]" : jobposition
										};
										grid_workflow.load();
										
										Init.reffactivity = dataselect.id;
										Init.createbyt = jobposition;
									}
						}
					});
					this.callParent(arguments);
	}
});
