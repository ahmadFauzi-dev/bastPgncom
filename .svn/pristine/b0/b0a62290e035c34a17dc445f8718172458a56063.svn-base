Ext.define('master.view.gridjenisstation' ,{
	extend: 'Ext.grid.Panel',
	initComponent	: function()
	{
		
	var filter = [];

	var msclass = Ext.create('master.global.geteventmenu'); 
	
	var modeljenisstation = msclass.getmodel('idx_configuration');
	var storejenisstation =  msclass.getstore(modeljenisstation,'idx_configuration',filter);
	
	
	storejenisstation.getProxy().extraParams = {
		view : "idx_configuration",
		"filter[0][field]" : "typeof",
		"filter[0][data][type]" : "string",
		"filter[0][data][comparison]" : "eq",
		"filter[0][data][value]" :'ITC1'
	};	
	
	storejenisstation.load();
	Init.storeSBU.load();
	var coldisplay = [];	
	
	var model = msclass.getmodel('v_station');
	var columns = msclass.getcolumn('v_station');
	var filter = [];
	
	coldisplay = columns;
	
	coldisplay[1] = {
		text		: 'Nama Station',
		dataIndex	: columns[3].dataIndex,
		flex		: 1,
		editor		: {
			xtype			: 'textfield',
			name			: columns[3].dataIndex
		}
	}
	coldisplay[2] = {
		text		: 'Jenis Station',
		dataIndex	: columns[4].dataIndex,
		flex		: 1,
		editor		: {
			xtype	: 'combobox',
			name	: columns[4].dataIndex,
			//name			: columns[5].dataIndex,
			store			: storejenisstation,
			displayField	: 'confname',
			queryMode		: 'local',
			valueField		: 'rowid'
		}
	}
	coldisplay[3] = {
		text		: 'RD',
		dataIndex	: columns[5].dataIndex,
		flex		: 1,
		editor		: {
			xtype	: 'combobox',
			name	: columns[5].dataIndex,
			store	: Init.storeSBU,
			displayField: 'description',
			valueField: 'rowid',
		}
	}
	
	coldisplay[4].hidden = true;
	coldisplay[5].hidden = true;
	coldisplay[6].hidden = true;
	coldisplay[7].hidden = true;
	coldisplay[8].hidden = true;
	coldisplay[9].hidden = true;
	coldisplay[10].hidden = true;
	coldisplay[11].hidden = true;
	
	var store =  msclass.getstore(model,'v_station',filter);
	store.load();
		
	var role = {"p_export"	: true};
	//console.log(role.p_export);
	var editing = Ext.create('Ext.grid.plugin.RowEditing', {
		  clicksToEdit: 2,
		  listeners :
			{					
				'edit' : function (editor,e) {
					 // console.log("asd");
					var grid 	= e.grid;
					var record = e.record;					 
					var recordData = record.data; 
					recordData.id = 'stationlistgrid';
					msclass.savedata(recordData , base_url+'masterdata/updatestation');
				}
			}
	});
		
		
		Ext.apply(this, {
			store		: store,
			multiSelect	: true,
			height		: 300,
			autoScroll	: true,
			//id			: Init.idmenu+'gridstation',
			id			: 'stationlistgrid',
			plugins		: editing,
			dockedItems	: [
				{
					xtype: 'toolbar',
					items	: [{
						iconCls	: 'page_white_excel',
						text	: 'Export',
						xtype	: 'button',
						handler	: function()
						{
							msclass.exportdata('stationlistgrid','v_station');
						}
					},
					,'-',
					{
						iconCls	: 'add',
						text	: 'Create Station',
						xtype	: 'button',
						handler	: function()
						{
							var r = {
								stationname		: '',
								jenis_station	: '',
								sbu				: ''
							}
							store.insert(0, r);	
						}
					}]
				}
			],
			columns		: coldisplay,
			//plugins	: editing,
			bbar: Ext.create('Ext.PagingToolbar', {
				pageSize: 10,
				store: store,
				displayInfo: true
			})
		});
		this.callParent(arguments);
	}
})