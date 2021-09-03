Ext.define('setting.store.storegroupsbu', {
		extend: 'Ext.data.TreeStore',
		fields	: ['id','text','act','parent','iconCls','path'],
		storeId: 'menustore',		
		clearOnLoad : true,
		proxy: {
			type: 'pgascomProxy',
			url: base_url+'admin/settings/showaccarea',
			reader: {
				type: 'json',
				root: 'data'
			},
			node: 'id',
			folderSort: true
		}
	});
