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
	var grid = Ext.create('master.view.gridstationconfig');
	var gridDetailConfig = Ext.create('master.view.gridstationdetailconfig');
	var idrow;
	var refid;
	var statname;
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
				title		: 'Mapping Station Config',
				id			: name,
				xtype		: 'panel',
				iconCls		: iconCls,
				closable	: true,
				overflowY	: 'scroll',
				bodyPadding: '5 5 0',
				items		: [{
					xtype 		: 'panel',
					title		: 'Mapping Station Config',
					bodyPadding	: 5,
					//width		: 600,
					margins		: '10',
					items		: [grid,gridDetailConfig]
					
				}]
			});
		tabPanel.setActiveTab(name);	
	}
}