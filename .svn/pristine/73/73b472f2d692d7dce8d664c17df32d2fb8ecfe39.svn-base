Ext.define('master.view.gridstationdetailconfig' ,{
    extend: 'Ext.grid.Panel',
    initComponent: function() {
	
	Ext.define('mstationconfigdetail',{
		extend	: 'Ext.data.Model',
		fields	: ["stationname","confname","value"]
	});
	
	var storegridstationconfigdetail = Ext.create('Ext.data.JsonStore',{
				model	: 'mstationconfigdetail',
				proxy	: {
				type			: 'pgascomProxy',
				url				: base_url+'admin/showdetailconfig',
				extraParams 	: {id : '24'},
				reader: {
					type: 'json',
					root: 'data'
				}
				}
	});
	
	storegridstationconfigdetail.load();
		Ext.apply(this, {
			store		: storegridstationconfigdetail,
			title		: 'Station',
			//height		: 200,
			multiSelect	: true,
			autoScroll	: true,
			id			: 'gridstationconfigdetail',
			tbar		: [{
				text	: 'Add Config',
				iconCls : 'add',
				handler	: function()
				{
					var formaddconfig = Ext.create('master.view.formaddconfig');
					
					win = Ext.widget('window', {
						title		: 'Detail Config',
						width		: 600,
						height		: 400,
						autoScroll	: true,
						id			: "windetrole",
						resizable	: true,
						modal		: true,
						bodyPadding	: 5,
						items		: [formaddconfig]
					});
					win.show();
					//console.log(idrow);
				}
			}],
			columns		: [
			{
				"text"	: "Station Name",
				"dataIndex" : "stationname"
			},
			{
				"text"	: "Parameter",
				"dataIndex" : "confname"
			},
			{
				"text"	: "Value",
				"flex"	: 1,
				"dataIndex" : "value"
			}],
			bbar: Ext.create('Ext.PagingToolbar', {
				pageSize: 10,
				store: storegridstationconfigdetail,
				displayInfo: true
			})
		});

        this.callParent(arguments);
    }
});