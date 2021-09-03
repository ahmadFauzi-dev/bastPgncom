function apps(name,iconCls)
{
	Ext.require([
    'Ext.grid.*',
    'Ext.data.*',
    'Ext.util.*',
    'Ext.state.*'
	]);
	
	Ext.Loader.setConfig({
		enabled : true,
		paths: {
        'estimasibulk'    : ''+base_url+'asset/js/content/setting/anomali'
		}
	
	});
	
	var form = Ext.create('estimasibulk.view.form');
	
	var tabPanel = Ext.getCmp('contentcenter');
	var items = tabPanel.items.items;
	var exist = false;
	
	for(var i = 0; i < items.length; i++)
	{
        if(items[i].id == name){
				tabPanel.setActiveTab(name);
                exist = true;
        }
    }
	
	if(!exist){
			Ext.getCmp('contentcenter').add({
				title		: 'Estimasi Bulk Customer',
				id			: name,
				xtype		: 'panel',
				iconCls		: iconCls,
				closable	: true,
				overflowY	: 'scroll',
				bodyPadding: '5 5 0',
				items		: [{
					xtype 		: 'panel',
					title		: 'Estimasi Bulk Customer',
					bodyPadding	: 5,
					width		: 600,
					margins		: '10',
					items		: form
					//items		: []
				}]
			});
		tabPanel.setActiveTab(name);	
	}
}