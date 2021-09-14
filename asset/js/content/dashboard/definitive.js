function apps(name, iconCls) {
    
    var formanomaliamr = Ext.create('analisa.view.formanomaliamr');
	//var gridanomaliamr = Ext.create('analisa.view.gridanomaliamr');
	//var gridanomalistatus = Ext.create('analisa.view.gridanomalistatus');
	//var gridvolumehourly = Ext.create('analisa.view.gridvolumehourly');
	
	// var griddetaildata = Ext.create('analisa.view.griddatadetail');
	// var griddetaildata;
    //var gridkelamr = Ext.create('analisa.view.gridkelamr');	
	var msclass = Ext.create('master.global.geteventmenu'); 
	var tiketnumber = msclass.getticket();
    var tabPanel = Ext.getCmp('contentcenter');
	tabPanel.items.each(function(c){
		if (c.title != 'Home') {
			tabPanel.remove(c);
		}
	});
	
    var items = tabPanel.items.items;
    var exist = false;
    // for (var i = 0; i < items.length; i++) {
        // if (items[i].id == '3') {
            // tabPanel.setActiveTab('3');
            // exist = true;
        // }
    // }
    if (!exist) {
        // Ext.getCmp('contentcenter')
		tabPanel.add({
            title: name,
            id: '3',
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
				id : 'searchanomaliform',
                region: 'west',
                // layout 		: 'fit',
                bodyStyle: 'padding:5px',
                //width			: 600,
                // margins		: '10',
                items: formanomaliamr
                //items			: []
            }, {
                xtype: 'tabpanel',
                flex: 3,
				id : 'TabAsikAja',
                collapsible: false,				
                region: 'center',
				activeTab	: 0,				
				fit		: true,							
				items	: [{
					xtype	: 'panel',
					title  : name,
					frame: true,	
					iconCls 	: 'application_view_gallery',
					layout: 'border',
					defaults: {
						collapsible: true,
						split: true,
						//bodyStyle: 'padding:5px'
					},
					items	: [			
					{
						xtype : 'panel',
						title : name,
						frame	: true,
						region : 'center',
						layout: 'fit',
						collapsible: false,
						flex: 3,		
						//items	: gridanomaliamr,
						// autoScroll : true,
						border: false,
						layout: 'anchor',
						height	: 1000,
						//height	: 1000,
						//autoScroll	: true,
						items	: [{
							xtype: 'tableauviz',
							height	: 1000,
							id		: 'tableauviz',
							flex	: 1,
							vizUrl	: "http://192.168.104.167:8000/trusted/"+tiketnumber+"/#/views/Dashboardvalidasipelangganprovisionalpersentase/Dashboard1?:refresh=yes&:toolbar=top:tabs=no"
						}]
						//items: gridkelData						
					}]
				}]
                //items: [ gridkelamr ]
            }]
        });
        tabPanel.setActiveTab('3');
    }
}