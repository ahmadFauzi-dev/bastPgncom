function apps(name,iconCls){
	
	Ext.QuickTips.init();
	var tabPanel = Ext.getCmp('contentcenter');
	var items = tabPanel.items.items;
	var exist = false;
	//var tb = 'tb_role_type';
	var me = this;
	
	
	Ext.Loader.setConfig({
    enabled : true,
    paths: {
        'EM'    : ''+base_url+'asset/js/content/'
	}
	
	});
	var gridDaily = Ext.create('EM.analisa.view.realisasipenyaluranfinal');
	//var gridDailyno = Ext.create('EM.analisa.view.gridnoflowcompapp');
	 
	for(var i = 0; i < items.length; i++)
	{
        if(items[i].id == name){
				tabPanel.setActiveTab(name);
                exist = true;
        }
    }
	
	if(!exist){
			Ext.getCmp('contentcenter').add({
				title		: 'Realisasi Penyaluran Final Bulk Customer',
				id			: name,
				xtype		: 'panel',
				iconCls		: iconCls,
				closable	: true,
				overflowY	: 'scroll',
				bodyPadding: '5 5 0',
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
						
						xtype	: 'panel',
						title	: 'Realisasi Penyaluran',
						iconCls	: iconCls,
						closable	: false,
						//overflowY	: 'scroll',
						bodyPadding: '5 5 0',
						layout		: 'fit',
							items		: gridDaily
						
					}]
					
				}]
			});
		tabPanel.setActiveTab(name);	
	}
}