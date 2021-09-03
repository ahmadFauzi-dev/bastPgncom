Ext.define('master.view.sbugrid' ,{
				extend: 'Ext.grid.Panel',
				//alias : 'widget.formco',
				initComponent	: function()
				{
				Ext.define('m1453402769grid',{
					extend	: 'Ext.data.Model',
					fields	: ["sbu"]
				});
	
			var s1453402769grid = Ext.create('Ext.data.JsonStore',{
				model	: 'm1453402769grid',
				proxy	: {
				type	: 'pgascomProxy',
				url		: base_url+'admin/s453402284',
				reader: {
					type: 'json',
					root: 'data'
				}
				}
			});
			
			s1453402769grid.load();
			Ext.apply(this,{
				store		: s1453402769grid,
				id			: '1453402769',
				columns		: [{"dataIndex":"sbu","text":"sbu"}]
			});
			this.callParent(arguments);
			}
		})
