Ext.define('setting.store.storegridgrouppermission', {
		extend	: 'Ext.data.Store',
		fields	: ['group_id','name','koordinatoruser','id_perusahaan','nama_perusahaan'],
		//model	: 'mapping.model.mpelangganindustri',
		storeId	: 'pelstore',	
		autoLoad: false,	
		proxy: {
			type: 'pgascomProxy',
			url: base_url+'admin/settings/showgroup',
			reader: {
				type: 'json',
				root: 'data'
			}
		}	
	});
