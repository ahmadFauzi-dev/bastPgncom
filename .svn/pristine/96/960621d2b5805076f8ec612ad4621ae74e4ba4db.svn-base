function apps(name, iconCls){
    var tabPanel 	= Ext.getCmp('contentcenter');	var msclass 	= Ext.create('master.global.geteventmenu');	//var v_table 	= "fn_getdatamastertype('TOD2')";	var v_table 	= "v_permohonanbastcreator";	var itemdocktop = [{		text	: 'Export Data',		iconCls	: 'page_white_excel',	},	{		text	: 'Get List Field',		iconCls	: 'page_white_excel',		handler	: function()		{			msclass.getlisfield(v_table,"idgrid_permohonanbastcreator");		}	}]	var pgrid 		= msclass.getgrid(v_table,'idgrid_permohonanbastcreator',itemdocktop);	//var par_pgrid = Ext.getCmp('idgrid_vmasterdata').getStore();
	//console.log(pgrid);
	/* par_pgrid.getProxy().extraParams = {
			view :'public.v_rekanan',
			limit : "All",
			"filter[0][field]" : "type_id",
			"filter[0][data][type]" : 'numeric',
			"filter[0][data][comparison]" : "eq",
			"filter[0][data][value]" : 'TOD26'
	}; */
	//par_pgrid.load();
	
	tabPanel.items.each(function(c){
		if (c.title != 'Home') {
			tabPanel.remove(c.id);
		}
	});
	
	var items = tabPanel.items.items;
    var exist = false;
   
    if (!exist) {
        tabPanel.add({
            title 	: name, 
			id 		: '20', 
			xtype 	: 'panel', 
			iconCls : iconCls, 
			layout: 'border',
			setLoading	: true,
			closable: true,
            defaults: {
                collapsible: true,
                split: true,
            },
            items: [{
                xtype: 'panel',
                title: 'Form Search',
                // flex: 1,
				width	: 250,
				id : 'searchmapp',
                region: 'west',
                bodyStyle: 'padding:5px',
				layout: {
					type: 'vbox',
					align : 'stretch',
					pack  : 'start',
				},
				items	: [{
					border	: false,
					xtype: 'panel',
					bodyStyle: 'padding:0 0 20px 0',
					// xtype	: 'pellsourcesearch'
				}]			},
			{
				xtype: 'tabpanel',
                flex: 3,
				id : 'tabtest',
                collapsible: false,				
                region: 'center',
				activeTab	: 0,				
				fit		: true,
				items	: pgrid				
			}]
        }
        );
        tabPanel.setActiveTab('20');
    }
}

