Ext.define('EM.tools.view.grid' ,{
				extend: 'Ext.grid.Panel',
				//alias : 'widget.formco',
				initComponent	: function()
				{
				Ext.define('m1453402680grid',{
					extend	: 'Ext.data.Model',
					fields	: ["sbu"]
				});
	
			var s1453402680grid = Ext.create('Ext.data.JsonStore',{
				model	: 'm1453402680grid',
				proxy	: {
				type	: 'pgascomProxy',
				url		: base_url+'admin/listRows',
				reader: {
					type: 'json',
					root: 'data'
				}
				}
			});
			s1453402680grid.load();
			Ext.apply(this,{
				store		: s1453402680grid,
				id			: 'gridDaily',
				columns		: [{"dataIndex":"sbu","text":"sbu"}]
			});
			this.callParent(arguments);
			}
		})
