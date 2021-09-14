Ext.define('master.view.griddetailrole' ,{
		extend: 'Ext.grid.Panel',
		//alias : 'widget.formco',
		initComponent	: function()
		{
		
		Ext.define('modelGrid',{
			extend	: 'Ext.data.Model',
			fields	: ["id_ms_liberrorcode","formula"]
		});
		var idRole = Ext.getCmp('idrole').getValue();
		console.log(idRole);
		var s_grid = Ext.create('Ext.data.JsonStore',{
		model	: 'modelGrid',
		proxy	: {
		type	: 'pgascomProxy',
		url		: base_url+'admin/listDetailRole',
		//params	: {'id_ms_liberrorcode' :idRole},
		reader: {
			type: 'json',
			root: 'data'
			}
		}
		});
		s_grid.load({
			params: {id_ms_liberrorcode: idRole}
		});
		//s_grid.load(params : {'id_ms_liberrorcode':idRole});
		Ext.apply(this,{
			store		: s_grid,
			id			: 'griddetailrole',
			columns		: [{'text' : 'Role ID','dataIndex':'id_ms_liberrorcode'},{'text' : 'Formula','dataIndex':'formula',flex:1}]
			//columns		: [{"dataIndex":"nama_station","text":"nama_station"},{"dataIndex":"sbu","text":"sbu"},{"dataIndex":"jenis_station","text":"jenis_station"},{"dataIndex":"status","text":"status"}]
		});
		this.callParent(arguments);
		}
	})
