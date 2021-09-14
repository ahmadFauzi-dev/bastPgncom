Ext.define('master.view.grid' ,{
			extend: 'Ext.grid.Panel',
			//alias : 'widget.formco',
			initComponent	: function()
			{
			Ext.define('m_grid',{
				extend	: 'Ext.data.Model',
				fields	: ["nama_station","sbu","jenis_station","status"]
			});
	
			var s_grid = Ext.create('Ext.data.JsonStore',{
			model	: 'm_grid',
			proxy	: {
			type	: 'pgascomProxy',
			url		: base_url+'admin/listRows',
			reader: {
				type: 'json',
				root: 'data'
				}
				}
			});
			s_grid.load();
			Ext.apply(this,{
				store		: s_grid,
				id			: 'gridDaily',
				columns		: [{"dataIndex":"nama_station","text":"nama_station"},{"dataIndex":"sbu","text":"sbu"},{"dataIndex":"jenis_station","text":"jenis_station"},{"dataIndex":"status","text":"status"}]
			});
			this.callParent(arguments);
			}
		})
