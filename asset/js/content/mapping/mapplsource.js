function apps(name, iconCls){
    
    var plgrid = Ext.create('mapping.view.gridpelanggan');
	var formsearch = Ext.create('mapping.view.search.ghvref');
    
	var tabPanel = Ext.getCmp('contentcenter');
	tabPanel.removeAll(true);
	tabPanel.items.each(function(c){
		if (c.title != 'Home') {
			tabPanel.remove(c.id);
		}
	});
    var items = tabPanel.items.items;
    var exist = false;
    
    if (!exist) {
        Ext.getCmp('contentcenter').add({
            title : name, 
			id : Init.idmenu, 
			xtype : 'panel', 
			iconCls : iconCls, 
			layout: 'border',
			setLoading	: true,
            // overflowY	: 'scroll',
            defaults: {
                collapsible: true,
                split: true,
                //bodyStyle: 'padding:5px'
            },
            // bodyPadding: '5 5 0',
            items: [{
                xtype: 'panel',
                title: 'Form Search',
                flex: 1,
				id : 'searchanomaliform',
                region: 'west',
                bodyStyle: 'padding:5px',
				items	: [{
					xtype	: 'ghvrefsearch'
				}]
            },
			{
				xtype		: 'panel',
				title		: 'GHV References',
				flex		: 4,
				region		: 'center',
				bodyStyle	: 'padding:5px',
				layout		: 'fit',
				items		: plgrid,
				border: false
			} 
			]
        }
        );
        tabPanel.setActiveTab(Init.idmenu);
    }
}
