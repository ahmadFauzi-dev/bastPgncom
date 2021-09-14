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
			'master'    : ''+base_url+'asset/js/content/master/'
		}
	
	});
	
	//var form = Ext.create('master.view.libmessageanomaligrid');
	var grid = Ext.create('master.view.gridmappingcol');
	
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
				title		: 'Mapping Variable',
				id			: name,
				xtype		: 'panel',
				iconCls		: iconCls,
				closable	: true,
				overflowY	: 'scroll',
				bodyPadding: '5 5 0',
				items		: [{
					xtype 		: 'panel',
					title		: 'Mapping Variable',
					bodyPadding	: 5,
					//layout		: 'fit',
					//width		: 600,
					margins		: '10',
					//items		: [form,grid]
					items		: grid
				}]
			});
		tabPanel.setActiveTab(name);	
	}
}