function apps(name, iconCls) {
    // Ext.require(['Ext.ux.grid.FiltersFeature']);					
    var msclass 	= Ext.create('master.global.geteventmenu'); 
    //var formvalidamr = Ext.create('analisa.view.formvalidamr');
	var v_table 	= "v_permohonanbast";
	var itemdocktop = [{
		text	: 'Export Data',
		iconCls	: 'page_white_excel',
	},
	{
		text	: 'Get List Fields',
		iconCls	: 'page_white_excel',
		handler	: function()
		{
			msclass.getlisfieldform(v_table,'idform_srcpermohonanbast');
		}	}]
	var pgrid 		= msclass.getformcreate(v_table,'idform_srcpermohonanbast','',itemdocktop);
	/* Ext.getCmp('refffarms').addListener('myevent', function () {
		console.log('test');
	}); */
/* Ext.getCmp('refffarms').listeners: { 
	 console.log('tes');
	} */

    var tabPanel = Ext.getCmp('contentcenter');
	tabPanel.items.each(function(c){
		if (c.title != 'Home') {
			tabPanel.remove(c);
		}
	});
    var items = tabPanel.items.items;
    var exist = false;
    // for (var i = 0; i < items.length; i++) {
        // if (items[i].id == '2') {			
            // tabPanel.setActiveTab('2');
            // exist = true;
        // }
    // }
    if (!exist) {
        // Ext.getCmp('contentcenter')
		tabPanel.add({
            title: name,
            id: '2',
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
				id  : 'searchvalidasiform',
                region: 'west',
                // layout 		: 'fit',
                bodyStyle: 'padding:5px',
            }, 
			{
                xtype			: 'panel',
                flex			: 3,
				title			: 'Contentsd',
				id 				: 'TabAsikAja',
                collapsible		: false,	
                region			: 'center',
				activeTab		: 0,	
				autoScroll		: true,		
				layeout			: 'fit',
				items			: pgrid
            },
			{
				xtype			: 'panel',
				flex			: 1,
				id				: 'contenteast',
				region			: 'east',
				title			: 'lookup'
			}]
        });
        tabPanel.setActiveTab('2');
    }
}