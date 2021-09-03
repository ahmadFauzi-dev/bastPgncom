Ext.define('setting.store.storegridevent', {
		extend	: 'Ext.data.Store',
		fields	: ['event_id','event_name','menu_id','setopts','checked'],
		//model	: 'mapping.model.mpelangganindustri',
		storeId	: 'pelstore',	
		autoLoad: false,	
		proxy: {
			type: 'pgascomProxy',
			url: base_url+'admin/settings/showevent',
			reader: {
				type: 'json',
				root: 'data'
			}
		}	
	});
