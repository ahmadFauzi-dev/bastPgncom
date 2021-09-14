Ext.define('mapping.store.area', {
		extend: 'Ext.data.Store',
		model	: 'mapping.model.area',
		storeId	: 'areastore',		
		proxy: {
			type: 'pgascomProxy',
			url: base_url+'analisa/loadarea',
			reader: {
				type: 'json',
				root: 'data'
			}
		}	
	});
