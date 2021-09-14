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
	
	//var formco = Ext.create('EM.tools.view.form');
	 var gridDaily = Ext.create('EM.analisa.view.downgridpenyapp');
	 var gridDailyno = Ext.create('EM.analisa.view.gridnoflowcomp');
	//var gridHourly = Ext.create('EM.tools.view.gridhourly');
	
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
				title		: 'Realisasi Penyaluran',
				id			: name,
				xtype		: 'panel',
				iconCls		: iconCls,
				closable	: true,
				overflowY	: 'scroll',
				bodyPadding: '5 5 0',
				//layout		: 'fit',
				items		: [{
					xtype 		: 'tabpanel',
					title		: 'Realisasi Penyaluran',
					bodyPadding	: 5,
					id			: 'tabpenyalurandata',
					margins		: 10,
					activeTab	: 0,
					//layout		: 'fit',
					margins		: '10',
					items		: [{
						xtype	: 'tabpanel',
						title		: 'Realisasi Penyaluran',
						items		: [
						{
							xtype	: 'panel',
							title	: 'Realisasi',
							iconCls	: iconCls,
							closable	: false,
							//overflowY	: 'scroll',
							bodyPadding: '5 5 0',
							layout		: 'fit',
							items		: gridDaily
						},
						{
							xtype	: 'panel',
							title	: 'Taksasi',
							bodyPadding: '5 5 0',
							layout		: 'fit',
							items		: gridDailyno
						}
						]
					}]
					
				}]
			});
		tabPanel.setActiveTab(name);	
	}
}