Ext.define('master.view.gridpointname' ,{
	extend: 'Ext.grid.Panel',
	initComponent	: function()
	{
	var msclass = Ext.create('master.global.geteventmenu'); 
	var model = msclass.getmodel('pointalias');
	var columns = msclass.getcolumn('pointalias');
	var filter = [];
	
	var store =  msclass.getstore(model,'pointalias',filter);
	store.load();
	columns[1].flex = 1;
	columns[2].flex = 2;
	
	console.log(columns);
	var storesbu	= Ext.create('mapping.store.sbu');
	var storearea 	= Ext.create('mapping.store.area');
	
	var itemsarea = new Array();
	var itemssbu = new Array();
	
	storearea.load(function(records){
		Ext.each(records, function(record){
			itemsarea.push(record.get('area'));
					//n++;
		});
	});
	storesbu.load(function(records){
		Ext.each(records, function(record){
			itemssbu.push(record.get('description'));
		});
	});
	
	
		var filterconfig = {ftype	: 'filters',
			filters	: [
				{
					type	: 'date',
					dateFormat	: 'Y-m-d',
					dataIndex	: 'tanggal'
				},
				{
					type		: 'list',
					dataIndex	: 'name_area',
					options		: itemsarea,
					phpMode		: true
				},
				{
					type		: 'list',
					dataIndex	: 'name_sbu',
					options		: itemssbu,
					phpMode		: true
				}
			]
		};
		var role = {"p_export"	: true};
		//console.log(role.p_export);
		
		Ext.apply(this, {
			store		: store,
			multiSelect	: true,
			height		: 300,
			autoScroll	: true,
			id			: Init.idmenu+'grid',
			dockedItems	: [
				{
					xtype: 'toolbar',
					items	: [{
						iconCls	: 'page_white_excel',
						xtype	: 'exporterbutton',
						text	: 'Export',
						//hidden	: role.p_export,
						format	: 'excel'
					}]
				}
			],
			columns		: columns,
			features	: [filterconfig],
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