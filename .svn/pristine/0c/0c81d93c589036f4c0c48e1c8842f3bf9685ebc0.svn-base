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
			'master'    : ''+base_url+'asset/js/content/master/',
			'setting' : '' + base_url + 'asset/js/content/setting'
		}
	
	});
	
	var grid = Ext.create('setting.view.gridsbu');
	
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
				title		: 'SBU / Area',
				id			: name,
				xtype		: 'panel',
				iconCls		: iconCls,
				closable	: true,
				overflowY	: 'scroll',
				items		: grid
			});
		tabPanel.setActiveTab(name);	
	}
}