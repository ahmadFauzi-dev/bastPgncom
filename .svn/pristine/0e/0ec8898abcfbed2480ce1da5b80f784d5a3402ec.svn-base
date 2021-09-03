Ext.define('masterdata.view.grid_workflow' ,{
	extend: 'Ext.grid.Panel',
	initComponent	: function()
	{
		var pageId = Init.idmenu;
		var msclass = Ext.create('master.global.geteventmenu'); 
		var filter = [];
		var columns = msclass.getcolumn('public.v_workflow');
		
		
		//var data_items;
		//var role = {"p_export"	: true};
		//console.log (role.p_export);
		
		var m_karyawan_jabatan = msclass.getmodel('public.v_jabatan_karyawan');
		var store_karyawan_jabatan =  msclass.getstore(m_karyawan_jabatan,'public.v_jabatan_karyawan',filter);
		store_karyawan_jabatan.getProxy().extraParams = {
			view :'public.v_jabatan_karyawan',
			limit : "All"
		};
		store_karyawan_jabatan.load();
		
		var m_workflow = msclass.getmodel('public.v_workflow');
		var store_workflow =  msclass.getstore(m_workflow,'public.v_workflow',filter);
		store_workflow.getProxy().extraParams = {
			view :'public.v_workflow',
			limit : "All"
		};
		//store_workflow.load();
		
		var store_reffeven = Ext.create('Ext.data.Store', {
		fields: ['rowid'],
		data : [
			{"rowid":"Create"},
			{"rowid":"Approval"}
		]
		});

			columns[1].hidden = true;
			columns[2].hidden = true;
			columns[3] =  {
					text	: 'Nama Jabatan',
					width : '40%',
					align	: 'left',
					dataIndex : columns[3].dataIndex,
					renderer: function(val, meta, record, rowIndex){
							var jabatan  	= record.data.jabatan ;
							return jabatan;
					},
					editor : {
							xtype: 'combobox',
							name: columns[3].dataIndex,
							value: columns[3].dataIndex,
							store: store_karyawan_jabatan,
							valueField: 'rowid',
							displayField: 'name',
							queryMode: 'local',
							listeners: {
									select: function(value, record, index){
											var nama_karyawan = value.valueModels[0].data.nama_karyawan;
											//console.log(name_karyawan);
											Ext.getCmp(columns[5].dataIndex+'gridworkflow').setValue(nama_karyawan);
									}
							}
					}
			};
			columns[4].hidden = true;
			columns[5] = {
					text	: 'Nama Karyawan',
					width : '30%',
					align	: 'left',
					dataIndex : columns[5].dataIndex,
					editor : {
						xtype : 'textfield',
						id : columns[5].dataIndex+'gridworkflow',
						name : columns[5].dataIndex,
						value : columns[5].dataIndex,
						readonly:true,
					}
			};
			columns[6] = {
					text	: 'Priority',
					width : '15%',
					align	: 'center',
					dataIndex : columns[6].dataIndex,
					editor : {
						xtype : 'textfield',
						name : columns[6].dataIndex,
						value : columns[6].dataIndex,
					}
			};
			columns[7].hidden = true;
			
			columns[8] = {
					text	: 'Event',
					width : '10%',
					align	: 'left',
					dataIndex : columns[8].dataIndex,
					editor : {
						xtype: 'combobox',
							name: columns[8].dataIndex,
							value: columns[8].dataIndex,
							store: store_reffeven,
							valueField: 'rowid',
							displayField: 'rowid',
							queryMode: 'local'
					}
			};
			
		var editing = Ext.create('Ext.grid.plugin.RowEditing', {
			  clicksToEdit: 2,
			  listeners :
				{					
					'edit' : function (editor,e) {
						var grid = e.grid;
						var record = e.record;					 
						var recordData = record.data;
						recordData.id = 'grid_workflow';
						msclass.savedata(recordData , base_url+'sppd/update_workflow');
					}
				}
		});
		
		
		Ext.apply(this, {
			store		: store_workflow,
			multiSelect	: true,
			layout: 'fit',
			height		: 290,
			autoScroll	: true,
			id			: 'grid_workflow',
			plugins		: editing,
			tools		: [
			{
				type	: 'refresh',
				handler	: function()
				{
					store_workflow.load();
				}
			}],
			dockedItems	: [
			{
				xtype: 'toolbar',
				items	: [
				{
					text	: 'Delete',
					iconCls	: 'bin',
					xtype	: 'button',
						handler		: function()
						{
							var rec = Ext.getCmp('grid_workflow').getView().getSelectionModel().getSelection()[0];
							var rowid 	= rec.get('rowid');				
							
							var params = {
								"filter[0][field]" : "rowid",
								"filter[0][data][type]" : "numeric",
								"filter[0][data][comparison]" : "eq",
								"filter[0][data][value]" : rowid,
							}
							
							var table = 'public.ms_workflow';
							params.id = 'grid_workflow';
							msclass.deletedata(params,table,base_url+'sppd/deletedata');
						}
				},
				{	
					iconCls	: 'add',
					text	: 'Add',
					handler	: function(){
						var r = {
									rowid  	:'0',
									reffactivity	:Init.reffactivity,
									createbyt	:Init.createbyt,
									reffjobpos	:'',
									jabatan	:'',
									nama_kartawan	:'',
									priority: '0'
						}
						store_workflow.insert(0, r);				
					}
				}]
			}],
			//features	: [groupingFeature],	
			columns		: columns,
			listeners		: {
				itemclick	: function(view, record, item, index, e, eOpts)
				{
					//data = record.data;
				},
				itemdblclick: function (grid, record, item, index, e, eOpts) 
				{
						
				}
			}
		});
		this.callParent(arguments);
	}
})