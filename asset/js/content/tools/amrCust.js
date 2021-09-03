function apps(name,iconCls)
{
	Ext.QuickTips.init();
	var tabPanel = Ext.getCmp('contentcenter');
	var items = tabPanel.items.items;
	var exist = false;
	//var tb = 'tb_role_type';
	var me = this;
	
	
	for(var i = 0; i < items.length; i++)
	{
        if(items[i].id == name){
				tabPanel.setActiveTab(name);
                exist = true;
        }
    }
	
	if(!exist){
			Ext.getCmp('contentcenter').add({
				title		: 'Pelanggan Industri AMR',
				id			: name,
				xtype		: 'panel',
				iconCls		: iconCls,
				closable	: true,
				overflowY	: 'scroll',
				bodyPadding: '5 5 0',
				items		: [{
					xtype 		: 'panel',
					title		: 'Pelanggan industri AMR',
					bodyPadding	: 5,
					margins		: '10'
				}]
			});
		tabPanel.setActiveTab(name);	
	}
}