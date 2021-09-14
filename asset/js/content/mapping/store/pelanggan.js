Ext.define('mapping.store.pelanggan', {
		extend: 'Ext.data.Store',
		model	: 'mapping.model.pelanggan',
		storeId: 'pelstore',	
		autoLoad: false,	
		proxy: {
			type: 'pgascomProxy',
			url: base_url+'admin/pelanggan',
			reader: {
				type: 'json',
				root: 'data'
			}
		}	
	});
