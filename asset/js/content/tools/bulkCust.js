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
        'EM'    : ''+base_url+'asset/js/content/'
	}
	
	});
	
	var formco = Ext.create('EM.tools.view.form');
	var gridDaily = Ext.create('EM.tools.view.grid');
	var gridHourly = Ext.create('EM.tools.view.gridhourly');
	
	//Ext.Loader.setPath('MyApp', 'view/form.js');
	Ext.QuickTips.init();
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
				title		: 'Bulk Customer',
				id			: name,
				xtype		: 'panel',
				iconCls		: iconCls,
				closable	: true,
				overflowY	: 'scroll',
				bodyPadding: '5 5 0',
				items		: [{
					xtype 		: 'panel',
					title		: 'Bulk Customer',
					bodyPadding	: 5,
					margins		: '10',
					items	: [
					formco,
					{
						xtype	: 'tabpanel',
						plain	:true,
						activeTab: 0,
						bodyPadding	: 5,
						margins		: '10',
						defaults:{
							//bodyPadding: 10
						},
						items	: [{
							title	: 'Monitoring Daily',
							items	: gridDaily
						},
						{
							title	: 'Monitoring Hourly',
							items	: gridHourly
						},
						{
							title	: 'Monitoring Snapshot'
						}]
					}]
				}]
			});
		tabPanel.setActiveTab(name);	
	}
}