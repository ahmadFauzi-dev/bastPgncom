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
			'mapping'    : ''+base_url+'asset/js/content/mapping/',
			'analisa'    : ''+base_url+'asset/js/content/analisa/'
		}
	
	});
	
	var grid = Ext.create('master.view.gridpointname');
	
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
				title		: 'Point Name',
				id			: name,
				xtype		: 'panel',
				iconCls		: iconCls,
				closable	: true,
				bodyPadding: '5 5 0',
				
				items		: [{
					xtype 		: 'panel',
					title		: 'Point Name',
					bodyPadding	: 5,
					//overflowY	: 'scroll',
					items		: grid,
					margins		: '10'
				}]
			});
		tabPanel.setActiveTab(name);	
	}
}
