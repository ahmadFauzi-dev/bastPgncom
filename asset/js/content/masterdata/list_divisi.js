function apps(name, iconCls) {
    
	var gridDivisi = Ext.create('masterdata.view.grid_divisi');
	var formsearch = Ext.create('masterdata.view.form_srcdivisi');	
    var tabPanel = Ext.getCmp('contentcenter');
	tabPanel.items.each(function(c){
		if (c.title != 'Home') {
			tabPanel.remove(c);
		}
	});   
    var exist = false;
    if (!exist){
		tabPanel.add({
            title: name,
            id: 'list_divisi',
            xtype		: 'panel',
            iconCls		: iconCls,
            closable	: true,
			frame 		: true,
            layout		: 'border',
            defaults: {
                collapsible: true,
                split: true
            },
            items		: [{
                xtype: 'panel',
                title: 'Form Search',
                flex: 1,
				//id : 'searchanomaliform',
                region: 'west',
                bodyStyle: 'padding:5px',
				items: formsearch
            },
			{
					xtype: 'panel',
					flex: 3,
					collapsible: false,				
					region: 'center',
					activeTab	: 0,				
					//fit		: true,
					//title	: 'Project Monitoring',
					layout	: 'border',
					frame	: false,
					border:false,
					fit		: true,
					items	:[{
						  xtype	: 'box',
						  id	: 'header',
						  //frame	: true,
						  region: 'north',
						  flex	: 1,
						  style: {
							background: '#FFFFFF',
							border: 'none',
						  },
						  html	:'<div style="float:right;padding:0px 15px 0px 0px"><h2 style="margin:0">'+name+'</h2></div>'
					},
					{
						xtype	: 'panel',
						region	: 'center',
						flex	: 21,
						layout		: 'fit',
						//tbar	: toolbar,
						items	: [{
							xtype		: 'tabpanel',
							flex		: 3,
							id 			: 'tabcontentdata',
							collapsible	: false,				
							region		: 'center',
							activeTab	: 0,				
							fit			: true,
							layout		: 'fit',
							items		: [{
								xtype	: 'panel',
								title		: 'Data List',
								id			: 'list',
								iconCls		: 'application_view_columns',
								fit			: true,
								layout		: 'border',
								items		: [{
									xtype	: 'panel',
									items	: gridDivisi,
									flex		: 3,
									region		: 'center',
									layout	: 'fit',
									//height		: 300,
								}]
							}]	
						}]
					}]	
			}]			
        });
        tabPanel.setActiveTab('list_divisi');
    }
}