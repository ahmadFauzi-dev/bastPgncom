Ext.define('EM.tools.view.grid' ,{
				extend: 'Ext.grid.Panel',
				//alias : 'widget.formco',
				initComponent	: function()
				{
				Ext.define('m1453403912grid',{
					extend	: 'Ext.data.Model',
					fields	: ["area","sbu"]
				});
	
			var s1453403912grid = Ext.create('Ext.data.JsonStore',{
				model	: 'm1453403912grid',
				proxy	: {
				type	: 'pgascomProxy',
				url		: base_url+'admin/s1453403912grid',
				reader: {
					type: 'json',
					root: 'data'
				}
				}
			});
			s1453403912grid.load();
			Ext.apply(this,{
				store		: s1453403912grid,
				id			: 'gridDaily',
				columns		: [{"dataIndex":"area","text":"area"},{"dataIndex":"sbu","text":"sbu"}]
			});
			this.callParent(arguments);
			}
		})
