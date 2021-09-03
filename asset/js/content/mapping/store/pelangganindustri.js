Ext.define('mapping.store.pelangganindustri', {
		extend	: 'Ext.data.Store',
		model	: 'mapping.model.mpelangganindustri',
		storeId	: 'pelstore',	
		autoLoad: false,	
		proxy: {
			type: 'pgascomProxy',
			url: base_url+'admin/showpelangganindustri',
			reader: {
				type: 'json',
				root: 'data'
			}
		}	
	});
