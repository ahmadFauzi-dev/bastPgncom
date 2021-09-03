Ext.define('setting.store.storegriduser', {
		extend	: 'Ext.data.Store',
		fields	: ['username','password','nama','active','usernameldap'],
		//model	: 'mapping.model.mpelangganindustri',
		storeId	: 'pelstore',	
		autoLoad: false,	
		proxy: {
			type: 'pgascomProxy',
			url: base_url+'admin/settings/showuser',
			reader: {
				type: 'json',
				root: 'data'
			}
		}	
});
