function apps(name, iconCls) {
    
   // var formsearchanomali = Ext.create('analisa.offtake.view.formanomali');
	//var gridanomali		  = Ext.create('analisa.offtake.view.gridanomali');
	//var griddetailmessage = Ext.create('analisa.offtake.view.griddetailmessage');
	//var griddokumenpendukungs = Ext.create('analisa.bulk.view.griddokref');
    
	
	
	var formsearch = Ext.create('master.view.searchstation');
	var grid = Ext.create('master.view.gridjenisstation');
	
	var tabPanel = Ext.getCmp('contentcenter');
	
	tabPanel.items.each(function(c){
		if (c.title != 'Home') {
			tabPanel.remove(c.id);
		}
	});
	
    var items = tabPanel.items.items;
    var exist = false;
    
    if (!exist) {
		tabPanel.add({
            title: name,
            id: 'ms01',
            xtype: 'panel',
            iconCls: iconCls,
            closable: true,
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
				xtype	: 'panel',
                title	: 'Form Search',
                flex	: 1,
				id 		: 'mssearch',
                region	: 'west',
				items	: formsearch
			},
			{
				xtype	: 'panel',
				title	: 'Station',
				flex	: 3,
				region	: 'center',
				id		: 'msgrid',
				layout	: 'fit',
				items	: grid
			}]
        });
        tabPanel.setActiveTab("ms01");
		//Ext.Msg.hide();
    }
}