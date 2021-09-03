Ext.define('mapping.store.ismultisource', {
		extend: 'Ext.data.Store',
		fields	: ['rowid','confname'],
		storeId: 'ismultisourcestore',		
		proxy: {
			type: 'pgascomProxy',
			url: base_url+'admin/mapping/getismulti',
			method: 'GET',
			params : {
					"filter[0][field]" : "typeof",
					"filter[0][data][type]" : "numeric",
					"filter[0][data][comparison]" : "eq",
					"filter[0][data][value]" : 4
			},
			//pageParam: false, 
			//startParam: false, 
			//limitParam: false,
			reader: {
				type: 'json',
				root: 'data'
			}
		}	
	});
