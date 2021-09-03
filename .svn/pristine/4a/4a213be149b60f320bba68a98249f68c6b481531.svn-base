Ext.define('master.view.gridstationconfig' ,{
    extend: 'Ext.grid.Panel',
    //alias : 'widget.formco',
    initComponent: function() {
	Ext.define('mstationconfig',{
		extend	: 'Ext.data.Model',
		fields	: ["reffidstation","stationcd","stationname","rowid"]
	});
	
	var storegridstationconfig = Ext.create('Ext.data.JsonStore',{
				model	: 'mstationconfig',
				proxy	: {
				type	: 'pgascomProxy',
				url		: base_url+'admin/showstationconfig',
				reader: {
					type: 'json',
					root: 'data'
				}
				}
	});
	storegridstationconfig.load();
		Ext.apply(this, {
			store		: storegridstationconfig,
			title		: 'Station',
			height		: 200,
			multiSelect	: true,
			autoScroll	: true,
			id			: 'gridstationconfig',
			tbar		: [{
				text	: 'Add Config'
				
			}],
			columns		: [
			{
				"dataIndex" : "rowid",
				hidden		: true
			},
			{
				"text"	: "Id Station",
				"dataIndex" : "reffidstation"
			},
			{
				"text"	: "Code Station",
				"dataIndex" : "stationcd"
			},
			{
				"text"	: "Station Name",
				"flex"	: 1,
				"dataIndex" : "stationname"
			}],
			listeners : {
				itemclick	: function(view, record, item, index, e )
				{
					var id 	= record.get('rowid');
					var refidstation  = record.get('reffidstation');
					var storedetailconfig = Ext.getCmp('gridstationconfigdetail').getStore();
					//storedetailconfig.load({par});
					idrow = id;
					refid = refidstation;
					statname = record.get('stationname');
					storedetailconfig.proxy.extraParams = { id : id};
					storedetailconfig.load();
					//console.log(id);
				}
			},
			bbar: Ext.create('Ext.PagingToolbar', {
				pageSize: 10,
				store: storegridstationconfig,
				displayInfo: true
			})
		});

        this.callParent(arguments);
    }
});