function apps(name, iconCls){
    Ext.require(['Ext.ux.grid.FiltersFeature']);					
	var eventact;
	
	var gridvendor = Ext.create('masterdata.view.gridvendor');
	var gridpic		= Ext.create('masterdata.view.gridpic');
	var formsearch = Ext.create('masterdata.view.form_srcvendor');	
	
	

    var tabPanel = Ext.getCmp('contentcenter');
    var items = tabPanel.items.items;
    var exist = false;
    for (var i = 0; i < items.length; i++) {
        if (items[i].id == name) {
            tabPanel.setActiveTab(name);
            exist = true;
        }
    }
    if (!exist) {
        Ext.getCmp('contentcenter').add({
            title : 'Master Vendor', 
			id : name, 
			xtype : 'panel', 
			iconCls : iconCls, 
			closable : true, 
			layout : 'fit',
			defaults: {
                collapsible: true,
                split: true
            },
			//autoScroll	: true,	
			items : [ {
                xtype 		: 'panel', 
				//title 		: 'Group Permission Access', 
				bodyStyle	: 'padding:5px',
				layout		: 'border',
				items		: [
				{
					xtype: 'panel',
					title: 'Form Search',
					flex: 1,
					//id : 'searchanomaliform',
					region: 'west',
					bodyStyle: 'padding:5px',
					items: formsearch
				},
				{
					region: 'center',
					flex: 3,
					split: true,
					title	: 'Master Vendor',
					collapsible: false,
					split: true,
					items	: gridvendor	
				},
				{
					region: 'south',
					flex: 1,
					split: true,
					collapsible: false,
					items	:  gridpic
				}]
            }]
        });
        tabPanel.setActiveTab(name);
    }
}
