function apps(name, iconCls){
    Ext.require(['Ext.ux.grid.FiltersFeature']);					
	var eventact;
	
    var menugrid 		= Ext.create('setting.view.menu');
	var grouppermission = Ext.create('setting.view.grouppermission');
	//var gridsbu 		= Ext.create('setting.view.gridsbu');
	var gridevent		= Ext.create('setting.view.gridevent');
	var griduser		= Ext.create('setting.view.griduser');
	
	

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
            title : 'Group Permission Access', 
			id : name, 
			xtype : 'panel', 
			iconCls : iconCls, 
			closable : true, 
			layout : 'fit',
			//autoScroll	: true,	
			items : [ {
                xtype 		: 'panel', 
				//title 		: 'Group Permission Access', 
				bodyStyle	: 'padding:5px',
				layout		: 'border',
				//autoScroll	: true,
				items		: [{
					region: 'center',
					flex: 3,
					split: true,
					//title	: 'Group Permission',
					collapsible: false,
					split: true,
					items	: [
					{
						xtype 		: 'panel', 
						title		: 'Group Access',
						layout		: 'fit',
						flex		: 1,
						height		: 250,
						items		: grouppermission				
					},
					{
						xtype 		: 'panel', 
						title		: 'User Access',
						layout		: 'fit',
						flex		: 1,
						height		: 250,
						items		: griduser
					}]
				},
				{
					region: 'east',
					flex: 1,
					split: true,
					collapsible: false,
					items	: [{
						xtype	: 'panel',
						title	: 'Menu',
						flex	: 3,
						layout	: 'fit',
						items	: menugrid,
						height	: 450
					}]
				}]
            }]
        }
        );
        tabPanel.setActiveTab(name);
    }
}
