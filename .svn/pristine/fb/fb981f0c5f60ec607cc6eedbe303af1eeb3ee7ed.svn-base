Ext.define('analisa.nonamr.view.griddatadetailnonamr' ,{
	extend: 'Ext.grid.Panel',
	initComponent	: function()
	{
		var msclass 	 = Ext.create('master.global.geteventmenu');
		var event 		 = 	Ext.decode(msclass.getevent(Init.idmenu));
		var detnonamrmodel = msclass.getmodel('tmp_detailnonamr');
		var columnss 	 = msclass.getcolumn('tmp_detailnonamr');		
		var filter 		 = [];		
		var storeGridkelDetailnonamr = msclass.getstore(detnonamrmodel,'tmp_detailnonamr',filter);	
		
		
		Ext.apply(this, {
		loadMask: true, 
		columnLines: true, 
		store		: storeGridkelDetailnonamr,
		id			: 'gridkeldetailnonamr',		
		dockedItems: [
		{
			xtype: 'toolbar',
			items: [
				{
					text: 'Export',
					hidden	: event.p_export,
					iconCls : 'page_white_excel',
					xtype : 'button',
					handler: function (){						
						window.location.href = base_url+'analisa/kelengkapantoexcel?filter='+Ext.encode(Init.specialparams);
					}
				}			
			]
		},
		{
			xtype: 'pagingtoolbar',
			dock: 'bottom',
			store: storeGridkelDetailnonamr,
			displayInfo: true,
			plugins : [Ext.create('Ext.ux.PagingToolbarResizer')]
		}],	
		
		defaults: { 
            type: 'float'
        },
		
		columns		: columnss,
		
		viewConfig: {				
		}	
		});
		this.callParent(arguments);
	}
});