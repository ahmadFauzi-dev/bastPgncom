Ext.define('mapping.store.sbu', {
		extend: 'Ext.data.Store',
		model	: 'mapping.model.sbu',
		storeId: 'sbustore',		
		proxy: {
			type: 'pgascomProxy',
			url: base_url+'analisa/loadsbu',
			pageParam: false, 
			startParam: false, 
			limitParam: false,
			reader: {
				type: 'json',
				root: 'data'
			}
		}	
	});
