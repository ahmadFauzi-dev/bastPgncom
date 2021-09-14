Ext.define('master.view.v_gridjenisstation' ,{
	extend: 'Ext.grid.Panel',
	initComponent	: function()
	{
		
	var coldisplay = [];	
	var msclass = Ext.create('master.global.geteventmenu'); 
	var model = msclass.getmodel('v_jenisstation');
	var columns = msclass.getcolumn('v_jenisstation');
	var filter = [];
	
	coldisplay = columns;
	
	coldisplay[1] = {
		text	: 'Nama Station',
		dataIndex	: columns[3].dataIndex,
		flex	: 1
	}
	
	
	coldisplay[2].hidden = true;
	coldisplay[3].hidden = true;
	coldisplay[4].hidden = true;
	
	var store =  msclass.getstore(model,'v_jenisstation',filter);
	store.load();
		
	var role = {"p_export"	: true};
	//console.log(role.p_export);
	
		Ext.apply(this, {
			store		: store,
			multiSelect	: true,
			height		: 300,
			autoScroll	: true,
			//id			: Init.idmenu+'gridstation',
			id			: 'v_gridjenisstationlist',
			dockedItems	: [
				{
					xtype: 'toolbar',
					items	: [{
						iconCls	: 'page_white_excel',
						text	: 'Export',
						xtype	: 'button',
						handler	: function()
						{
							msclass.exportdata('v_gridjenisstationlist','v_station');
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