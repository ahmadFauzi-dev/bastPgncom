Ext.define('measurement.view.gridkalibrasi' ,{
	extend: 'Ext.grid.Panel',
	initComponent	: function()
	{
				
		var d = new Date();
		var m = (d.getMonth()+1).toString();
		if (m.length < 2 ) { m = '0'+m;}
		var f = d.getFullYear()+'-'+m+'-'+d.getDate();	
		var first = d.getFullYear()+'-'+m+'-'+'01';	
		
		var queryy = " getmaintenance_asset('', '', '"+first+"', '"+f+"', '', '', '1,2', '', '')";
		var msclass 	 = Ext.create('master.global.geteventmenu');
		// var event 		 = 	Ext.decode(msclass.getevent(Init.idmenu));
		var kelnonamrmodel = msclass.getmodel(queryy);
		var columnss 	 = msclass.getcolumn(queryy);		
		var filter 		 = [];			
		var storeGridkelnonamr = msclass.getstore(kelnonamrmodel,queryy, filter);		
		
		columnss[1].text = 'RD';
		columnss[3].hidden = true;
		columnss[4].hidden = true;
		columnss[5].text = 'ID Pelanggan';
		columnss[7].text = 'Nama Pelanggan';
		columnss[9].text = 'Asset Number';
		columnss[10].text = 'Status';		
		columnss[10].renderer = function(value, metaData, record, rowIdx, colIdx, store, view){			
			var color = '';
					if(record.get('status_calibrate') == "Hijau")
					{
						color = base_url+'asset/ico/green_indicator.ico';
					}else if(record.get('status_calibrate') == "warning")
					{
						color = base_url+'asset/ico/yellow_indicator.ico';
					}else if(record.get('status_calibrate') == "Merah")
					{
						color = base_url+'asset/ico/red_indicator.ico';
					} else {
						color = base_url+'asset/ico/black_indicator.ico';
					}
					return '<div><img src='+color+' width="16px" height="16px"></div>';					
				};
		columnss[11].hidden = true;
		columnss[15].hidden = true;
		columnss[16].hidden = true;		
		
		Ext.apply(this, {
			store	: storeGridkelnonamr,
			columnLines: true, 
			id		: 'gridkalibrasi',		
			dockedItems: [					
				{
					xtype: 'pagingtoolbar',
					dock: 'bottom',
					store: storeGridkelnonamr,
					displayInfo: true,
					plugins : [Ext.create('Ext.ux.PagingToolbarResizer')]
				},
				{
					xtype: 'toolbar',
					items: [{
						iconCls	: 'arrow_refresh',												
						text	: 'Save Template',
						handler	: function() {	
							var grid = Ext.getCmp('gridkalibrasi');
							var columns_data = grid.columns;
							var itemcolumns = [];
							var n = 0;
							Ext.each(columns_data, function(data) {
								//console.log(data);
								//if(data.hidden == false)
								//{
									var data = {
										"text"	: data.text,
										"hidden"	: data.hidden,
										"dataIndex"	: data.dataIndex,
										"pos"		: n,
										"hidden"	: data.hidden,
										"stat_render"		: data.stat_render
									}
									itemcolumns.push(data);
									n++;
								//}
							});
							var data_input = Ext.encode(itemcolumns);
							//extraParams.datainput = ;
							console.log(data_input);
						}						
					}]
				}],			
			columns		: columnss,
			viewConfig : {
				listeners : {				
					refresh: function(dataview) {
						Ext.each(dataview.panel.columns, function(column) {
							if (column.autoSizeColumn === true)
								column.autoSize();
							})
					}
			
				}
			}
		});
		this.callParent(arguments);
	}
})