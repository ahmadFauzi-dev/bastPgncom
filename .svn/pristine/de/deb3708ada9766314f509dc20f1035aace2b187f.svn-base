function apps(name, iconCls){
    
    var plgrid = Ext.create('mapping.view.mapppelanggansource');
	var formsearch = Ext.create('mapping.view.search.pellsourcesearch');
    var tabPanel = Ext.getCmp('contentcenter');
	
	Ext.define('modelGridlegend',{
			extend	: 'Ext.data.Model',
			fields	: ['kode','nm_station']
		});	

		var storeGridlegend = Ext.create('Ext.data.JsonStore',{
			model	: 'modelGridlegend',
			storeId: 'GridlegendStore',
			proxy: {
				type: 'pgascomProxy',
				pageParam: false, 
				startParam: false, 
				limitParam: false,			
				url: base_url+'admin/mapping/carilegend',
				reader: {
					type: 'json',				
					root: 'data'
				}			
			}
		});

	// storeGridlegend.load();
	
	var gridDetaillegend = Ext.create('Ext.grid.Panel',{		
		store	: storeGridlegend,
		id		: 'Gridlegend',		
		// frame	: true,
		// border	: false,					
		// layout: 'fit',					
		// text: 'Legend',					
		dockedItems: [					
				{
					xtype: 'pagingtoolbar',
					dock: 'bottom',
					store: storeGridlegend,
					displayInfo: true,
					plugins : [Ext.create('Ext.ux.PagingToolbarResizer')]
				}
				],	
		columns		: [
				{	
					dataIndex : 'kode',
					text : 'Kode',
					flex: 1,
					renderer:function(value, metaData, record, row, col, store, gridView)
					{
						metaData.tdAttr= 'data-qtip="'+value+'"';
						return value;
					}
				},
				{	
					dataIndex : 'nm_station',
					text : 'Nama Station',
					flex: 2,
					renderer:function(value, metaData, record, row, col, store, gridView)
					{
						metaData.tdAttr= 'data-qtip="'+value+'"';
						return value;
					}					
				}
		]
	});
	
    // tabPanel.removeAll(true);
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
					items	: formsearch
				},
				{
					xtype : 'panel',
					// bodyStyle: 'padding:15px 0 0 0',
					layout: 'fit',
					flex : 2,
					border	: false,
					items: gridDetaillegend
					
				}
				]
            },
			{
				xtype: 'tabpanel',
                flex: 3,
				id : 'tabamr',
                collapsible: false,				
                region: 'center',
				activeTab	: 0,				
				fit		: true,							
				items	: plgrid
			}]
        }
        );
        tabPanel.setActiveTab('20');
    }
}

