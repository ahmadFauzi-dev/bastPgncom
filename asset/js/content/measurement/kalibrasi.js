function apps(name, iconCls) {
   
    var formkalibrasi = Ext.create('measurement.view.formkalibrasi');
	var gridkalibrasi = Ext.create('measurement.view.gridkalibrasi');
	// var gridkalibrasidetail = Ext.create('dashboard.view.gridkalibrasidetail');
	
    var tabPanel = Ext.getCmp('contentcenter');
	tabPanel.items.each(function(c){
		if (c.title != 'Home') {
			tabPanel.remove(c);
		}
	});
    var items = tabPanel.items.items;
    var exist = false;
    if (!exist) {
		tabPanel.add({
            title: name,
            id: 'kalibrasi',
            xtype: 'panel',
            iconCls: iconCls,
            closable: true,
            layout: 'border',
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
				id : 'formkalibrasiok',
                region: 'west',
                // layout 		: 'fit',
                bodyStyle: 'padding:5px',
                //width			: 600,
                // margins		: '10',
                items: formkalibrasi
                //items			: []
            }, {
                xtype: 'tabpanel',
                flex: 3,
				id : 'tabbbbamr',
                collapsible: false,				
                region: 'center',
				activeTab	: 0,				
				fit		: true,							
				items	: [{
					xtype	: 'panel',
					title  : 'Kalibrasi',
					frame: true,	
					iconCls 	: 'application_view_gallery',
					layout: 'border',
					defaults: {
						collapsible: true,
						split: true,
						//bodyStyle: 'padding:5px'
					},
					items	: [{
						xtype : 'panel',
						title : 'Grid Data Asset',
						frame	: true,
						region : 'center',
						layout: 'fit',
						collapsible: false,
						flex: 2,		
						items	: gridkalibrasi,
						// autoScroll : true,
						border: false
						//items: gridkelData
						
					},
					{
					
						xtype : 'panel',					
						autoScroll : true,
						region : 'south',
						frame	: true,
						border	: false,					
						title : 'History Data Asset',					
						layout: 'fit',					
						flex: 3,
						items : []//gridkalibrasidetail
					
					}]
				}]
            }]
        });
        tabPanel.setActiveTab('kalibrasi');
    }
}