Ext.define('setting.store.storemenu', {
		extend: 'Ext.data.TreeStore',
		fields	: ['id','text','act','parent','iconCls','path'],
		storeId: 'menustore',		
		proxy: {
			type: 'pgascomProxy',
			url: base_url+'admin/settings',
			reader: {
				type: 'json',
				root: 'data'
			},
			node: 'id',
			folderSort: true
		}
	});
