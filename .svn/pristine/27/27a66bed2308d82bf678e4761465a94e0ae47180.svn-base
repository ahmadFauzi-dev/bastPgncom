Ext.define('mapping.view.gridpelanggan' ,{
	extend: 'Ext.grid.Panel',
	alias : 'widget.ghvrefgrid',
	initComponent	: function()
	{
	var msclass = Ext.create('master.global.geteventmenu'); 
	var model = msclass.getmodel('v_mapmultisources');
	var columns = msclass.getcolumn('v_mapmultisources');
	var filter = [];
	
	var store =  msclass.getstore(model,'v_mapmultisources',filter);
	store.load();
	//columns[0].hidden = true;
	columns[1].hidden = true;
	columns[3].hidden = true;
	
		//store.load();
	
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
					//options		: itemsarea,
					phpMode		: true
				},
				{
					type		: 'list',
					dataIndex	: 'name_sbu',
					//options		: itemssbu,
					phpMode		: true
				}
			]
		};
		var role = {"p_export"	: true};
		//console.log(role.p_export);
		
		Ext.apply(this, {
			store		: store,
			multiSelect	: true,
			id			: ''+Init.idmenu+'gridghv',
			dockedItems	: [
				{
					xtype: 'toolbar',
					items	: [{
						iconCls	: 'page_white_excel',
						xtype	: 'exporterbutton',
						text	: 'Export',
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