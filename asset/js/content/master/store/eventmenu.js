Ext.define('master.store.eventmenu', {
		extend	: 'Ext.data.Store',
		fields	: ['event_id','event_name','menu_id'],
		storeId	: 'eventmenustore',		
		proxy: {
			type: 'pgascomProxy',
			url: base_url+'admin/settings/showevent',
			reader: {
				type: 'json',
				root: 'data'
			}
		}	
});
