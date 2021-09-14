Ext.define('EM.tools.view.grid' ,{
	extend: 'Ext.grid.Panel',
    //alias : 'widget.formco',
	initComponent	: function()
	{
		Ext.define('modelGridDaily',{
			extend	: 'Ext.data.Model',
			fields	: ['tbl_station_id','tanggalpengukuran','volume','energy','ghv','pin','pout','temperature','counter_volume','counter_energy','tanggal','stat','stationname','error']
		});
	
		var storeGridDaily = Ext.create('Ext.data.JsonStore',{
		model	: 'modelGridDaily',
			proxy: {
			type: 'pgascomProxy',
			//extraParams:{'id':row_id},
			url: base_url+'admin/listGridDaily',
			reader: {
				type: 'json',
				//pageSize	: 10,
				root: 'data'
			}
			//simpleSortMode: true
		}
		});
		storeGridDaily.load();
		
		var gridMenu = Ext.create('Ext.menu.Menu',{
		id: 'menuGrid',
		items	: [{
			text	: 'View Detail Anomali',
			iconCls	: 'application_form_magnify',
			handler	: function()
			{
				//var idRole = data.id;
				//var formadddetail = Ext.create('master.view.gridaddrole');
				
				
				//Ext.getCmp('idrole').setValue(data.id);
				//Ext.getCmp('codeId').setValue(data.code_id);
				//Ext.getCmp('iddescription').setValue(data.Description);
				//var griddetailrole = Ext.create('master.view.griddetailrole');
				
				var storeGridDetails = Ext.create('Ext.data.Store',{
					fields	: ['id','desc','stat'],
					data	: [
						{id:'A-0001',desc:'Kelengkapan Data',stat:'error'},
						{id:'A-0002',desc:'Redudant 2 data sebelumnya (Volume & Energy )',stat:'error'},
						{id:'A-0003',desc:'Jika nilai DP = 0, Maka nilai net volume = 0  dan energy = 0',stat:'success'},
						{id:'A-0004',desc:'Temperature flowing di range 15 – 35 oC dan Pressure Flowing',stat:'success'},
						{id:'A-0005',desc:'Ada penambahan volume (FlowRate)  dan energy (Energi), tapi totalizer volume dan energy tidak berubah, Di bandingankan dengan totalizer_formula_manual',stat:'success'},
						{id:'A-0006',desc:'Tidak ada perubahan di Pb  dan  Tb',stat:'success'},
						{id:'A-0007',desc:'Selisih pressure outlet PCV dengan Pressure flowing, tidak boleh lebih dari 5% ',stat:'success'},
						{id:'A-0008',desc:'Jumlah pemakaian hourly = daily',stat:'success'},
						//{id:'A-0009',desc:'Jumlah pemakaian hourly = daily'}	
						{id:'A-0010',desc:'Hanya satu stream yang dipakai, untuk kondisi maintenance mode',stat:'success'}	,
						{id:'A-0011',desc:'Meter bermasalah (dengan membandingkan  frofile temperatur dan  flowratenya )',stat:'warnig'},
						{id:'A-0012',desc:'Pemakaian  flowrate daily drop, terhadap  range volume kontrak daily',stat:'success'},	
						{id:'A-0013',desc:'Pemakaian  flowrate daily drop, terhadap  range volume kontrak daily',stat:'success'}	
					]
				});
				
				var gridDetails = Ext.create('Ext.grid.Panel',{
					id			: 'idgridMengetahui',
					store 		: storeGridDetails,
					frame		: true,
					layout		: 'fit',
					//height		: 200,
					autoScroll	: true,
					title		: 'Details',
					columns		: [Ext.create('Ext.grid.RowNumberer'),
					{
							dataIndex	: 'stat',
							flex		: 1,
							renderer : function(value, metaData, record, rowIdx, colIdx, store, view){
								
								//metaData.tdAttr= 'data-qtip="'+message+'"';
								var color = '';
								if(record.get('stat') == "success")
								{
									 color = base_url+'asset/ico/green_indicator.ico';
								}else if(record.get('stat') == "warnig")
								{
									 color = base_url+'asset/ico/yellow_indicator.ico';
								}else
								{
									color = base_url+'asset/ico/red_indicator.ico';
								}
								return '<div><img src='+color+' width="20px" height="20px"></div>';
								
							}
					},
					{
						text		: 'id',
						flex		: 1,
						dataIndex	: 'id'
					},
					{
						text		: 'Deskripsi',
						flex		: 3,
						dataIndex	: 'desc'
						//xtype		: 'desc'
					}]
				});
				
				win = Ext.widget('window', {
					title		: 'Role ID : ',
					width		: 600,
					height		: 400,
					//layout		: 'fit',
					autoScroll	:true,
					id			: "Role Detail",
					resizable	: true,
					modal		: true,
					bodyPadding	: 5,
					items		: gridDetails
					//items		: [formadddetail,griddetailrole]
				});
				win.show();
				
				//console.log(data.id);
			}
		},
		{
			text	: 'Profile Daily',
			iconCls	: 'application_view_tile',
			handler	: function()
			{
				
				Ext.define('modelchartDaily',{
				extend	: 'Ext.data.Model',
					fields	: [
					{
						name	: 'volume'
						//type	: 'float'
					},
					{
						name	: 'energy'
						//type	: 'float'
					},'tanggals','min','max']
				});
				
				var storeChartDaily = Ext.create('Ext.data.JsonStore',{
				model	: 'modelchartDaily',
				storeId	: 'storeChartDaily',
				proxy	: {
					type: 'pgascomProxy',
						url: base_url+'admin/listChartDaily',
						reader: {
						type: 'json',
						root: 'data'
					}
				}
			});
				storeChartDaily.reload();
				var chartDaily	= Ext.create('Ext.chart.Chart',{
				style: 'background:#fff',
				animate: true,
				store: storeChartDaily,
				shadow: true,
				theme: 'Category1',
				legend: {
					position: 'right'
				},
				axes: [{
					type: 'Numeric',
					minimum: 0,
					position: 'left',
					fields: ['volume', 'energy','min','max'],
					title: 'Volume (MMSCFD)',
					minorTickSteps: 1,
					grid: {
						odd: {
							opacity: 1,
							fill: '#ddd',
							stroke: '#bbb',
							'stroke-width': 0.5
						}
					}
				}, {
					type: 'Category',
					position: 'bottom',
					itemSpacing	: 0.5,
					visible	: true,
					labelFont	: '6x Helvetica',
					label: {
					rotate: {
					  degrees: -40
					}
					},
					fields: ['tanggals'],
					title: 'Tanggal'
				}],
				series	: [{
					type: 'line',
					highlight: {
						size: 31,
						radius: 31
					},
					axis: 'left',
					xField: 'tanggals',
					yField: 'volume',
					tips	: 
					{
						trackMouse : true,
						renderer	: function(storeItem,item)
						{
							 //this.setTitle(storeItem.data.success);
							 this.update(' Tanggal : '+storeItem.data.tanggals+' <br />Volume : '+storeItem.data.volume+' MMSCFD <br /> Energy '+storeItem.data.energy+' (BBTUD)');	
							//alert("OKOKOKOOK");
						}
					},
					markerConfig: {
						type: 'cross',
						size: 2,
						radius: 2,
						'stroke-width': 0
						}   
					},
					{
						type: 'line',
					highlight: {
						size: 31,
						radius: 31
					},
					axis: 'left',
					xField: 'tanggals',
					yField: 'min',
					markerConfig: {
						type: 'cross',
						size: 2,
						radius: 2,
						'stroke-width': 0
						}   
					},
					{
						type: 'line',
					highlight: {
						size: 31,
						radius: 31
					},
					axis: 'left',
					xField: 'tanggals',
					yField: 'max',
					markerConfig: {
						type: 'cross',
						size: 2,
						radius: 2,
						'stroke-width': 0
						}   
					}]
				});
				var winDaily = Ext.widget('window',{
					width: 1200,
					height	: 400,
					layout: 'border',
					autoScroll:true,
					id		: "winNotifikasi",
					//layout: 'fit',
					resizable: true,
					modal: true,
					layout: 'fit',
					margins: '5 0 0 5',
					bodyPadding	: 5,
					items		: chartDaily
				});
				winDaily.show();
			}
		},
		{
			text	: 'Profile Hourly',
			iconCls	: 'application_view_tile'
		},
		{
			text	: 'View Hourly Consumption',
			iconCls	: 'application_view_tile'
		},
		{
			text	: 'Validate',
			iconCls	: 'application_view_tile'
		},
		{	
			text	: 'Unvalidate',
			iconCls	: 'application_view_tile'
		},
		{
			text	: 'Taksasi',
			iconCls	: 'application_add'
		}]
		});
	
		Ext.apply(this,{
		store		: storeGridDaily,
		id			: 'gridDaily',
		selType		: 'checkboxmodel',
		height		: 300,
		tbar		: [
		{
			text		: 'Validasi',
			iconCls		: 'accept',
			handler		: function()
			{
				//console.log(storeGridDaily);
			}
		},
		{
				text	: 'Taksasi',
				iconCls : 'add',
				handler	: function()
				{
					var formaddconfig = Ext.create('master.view.formaddconfig');
					
					win = Ext.widget('window', {
						title		: 'Detail Config',
						width		: 600,
						height		: 400,
						autoScroll	: true,
						id			: "windetrole",
						resizable	: true,
						modal		: true,
						bodyPadding	: 5,
						items		: [formaddconfig]
					});
					win.show();
					//console.log(idrow);
				}
		},
		{
			text	: 'Get Estimasi',
			iconCls	: 'arrow_rotate_anticlockwise'
		}],
		columns		: [
			{
				dataIndex	: 'stat',
				flex		: 5,
				renderer : function(value, metaData, record, rowIdx, colIdx, store, view){
					
					//metaData.tdAttr= 'data-qtip="'+message+'"';
					var color = '';
					if(record.get('error') == "1")
					{
						 color = base_url+'asset/ico/green_indicator.ico';
					}else if(record.get('error') == "0")
					{
						 color = base_url+'asset/ico/red_indicator.ico';
					}
					return '<div><img src='+color+' width="20px" height="20px"></div>';
					
				}
			},
			{
				text	: 'station',
				align	: 'center',
				dataIndex	: 'stationname'
			},
			{
				text	: 'Tanggal Pengukuran',
				align	: 'center',
				dataIndex	: 'tanggalpengukuran'
			},
			{
				text	: 'Volume',
				align	: 'center',
				dataIndex	: 'volume'
			},
			{
				text	: 'Energy <br /> BBTUD',
				align	: 'center',
				dataIndex	: 'energy'
			},
			{
				text	: 'Counter Volume <br /> (MMSCF)',
				align	: 'center',
				dataIndex	: 'counter_volume'
				
			},
			{
				text	: 'Counter Energy <br /> (BBTU)',
				align	: 'center',
				dataIndex	: 'counter_energy'
			},
			{
				text	: 'GHV <br /> (BTU/SCF)',
				align	: 'center',
				dataIndex	: 'ghv'
			},
			{
				text	: 'Tekanan IN <br /> (PSIG)',
				align	: 'center',
				dataIndex	: 'pin'
			},
			{
				text	: 'Tekanan OUT <br /> (PSIG)',
				align	: 'center',
				dataIndex	: 'pout'
			},
			{
				text	: 'Temperature',
				align	: 'center',
				dataIndex	: 'temperature'
			},
			{
				text	: 'Keterangan'
			}
		],
		bbar	: Ext.create('Ext.PagingToolbar', {
			pageSize	: 10,
			store		: storeGridDaily,
			displayInfo	: true
		}),
		listeners	: 
		{
			beforeitemcontextmenu: function(view, record, item, index, e)
			{
				e.stopEvent();
				gridMenu.showAt(e.getXY());
			},
			itemclick	: function(view, record, item, index, e, eOpts)
			{
				console.log(record.data);
			}
		}
		});
		this.callParent(arguments);
	}
})