Ext.QuickTips.init();
	store1.loadData(generateData(3, 20));
	store3.loadData(generateData(3, 20));
	store4.loadData(generateData(3, 20));
	store6.loadData(generateData(3, 20));
	store5.loadData(generateDatacl(12, 20));
	
	var menu 	 = Ext.create('Ext.Toolbar',{
		id	: 'main_menu',
		floating: false,
		border	: false,
		items	: [
		{
			xtype	: 'splitbutton',
			iconCls	: 'iChome',
			text	: 'HOME'
		},
		{
			xtype	: 'splitbutton',
			text	: 'Master',
			menu	: {
				border	: false,
				items	: [{
					text	: 'Data Pelanggan',
					handler	: function()
					{
						data_pelanggan();
					}
				},
				{
					text	: 'Produk',
					handler	: function()
					{
						master_produk();
					}
				}]
			}
		},
		{	
			xtype	: 'splitbutton',
			text	: 'Task Builder',
			menu	: {
				border	: false,
				items	: [{
					text	: 'Notifikasi',
					handler	: function()
					{
						notfifikasi();
					}
				},
				{
					text	: 'Broadcast'
				}]
			}
		},
		{
			xtype	: 'splitbutton',
			text	: 'Laporan',
			menu	: {
			border	: false,
				items	: [{
					text	: 'Area',
				},
				{
					text	: 'Jenis Pelanggan'
				},
				{
					text	: 'Status Pembayaran'
				}]
			}
		},
		{
			xtype	: 'splitbutton',
			text	: 'Administration',
			menu	: 
			{
				border	: false,
				items	: [{
					text	: 'User'
				},
				{
					text	: 'User Group'
				},
				{
					text	: 'Menu',
					handler	: function()
					{
						test_func();
					}
				}]
			}
		}]
	});
var chart = Ext.create('Ext.chart.Chart', {
            xtype: 'chart',
            animate: true,
            store: store1,
            shadow: true,
            legend: {
                position: 'right'
            },
            theme: 'Base:gradients',
            series: [{
                type: 'pie',
                field: 'data1',
                showInLegend: true,
                donut: 45,
                tips: {
                  trackMouse: true,
                  width: 140,
                  height: 28,
                  renderer: function(storeItem, item) {
                    //calculate percentage.
                    var total = 0;
                    store1.each(function(rec) {
                        total += rec.get('data1');
                    });
                    this.setTitle(storeItem.get('name') + ': ' + Math.round(storeItem.get('data1') / total * 100) + '%');
                  }
                },
                highlight: {
                  segment: {
                    margin: 20
                  }
                },
                label: {
                    field: 'name',
                    display: 'rotate',
                    contrast: true,
                    font: '11px Arial'
                }
            }]
    });
	var chart2 = Ext.create('Ext.chart.Chart', {
            xtype: 'chart',
            animate: true,
            store: store3,
            shadow: true,
            legend: {
                position: 'right'
            },
            theme: 'Base:gradients',
            series: [{
                type: 'pie',
                field: 'data1',
                showInLegend: true,
                donut: 45,
                tips: {
                  trackMouse: true,
                  width: 140,
                  height: 28,
                  renderer: function(storeItem, item) {
                    //calculate percentage.
                    var total = 0;
                    store1.each(function(rec) {
                        total += rec.get('data1');
                    });
                    this.setTitle(storeItem.get('name') + ': ' + Math.round(storeItem.get('data1') / total * 100) + '%');
                  }
                },
                highlight: {
                  segment: {
                    margin: 20
                  }
                },
                label: {
                    field: 'name',
                    display: 'rotate',
                    contrast: true,
                    font: '11px Arial'
                }
            }]
    });
	
	var chart4 = Ext.create('Ext.chart.Chart', {
            xtype: 'chart',
			id	: chart4,
            animate: true,
            store: store4,
            shadow: true,
            legend: {
                position: 'right'
            },
            theme: 'Base:gradients',
            series: [{
                type: 'pie',
                field: 'data1',
                showInLegend: true,
                donut: 45,
                tips: {
                  trackMouse: true,
                  width: 140,
                  height: 28,
                  renderer: function(storeItem, item) {
                    //calculate percentage.
                    var total = 0;
                    store1.each(function(rec) {
                        total += rec.get('data1');
                    });
                    this.setTitle(storeItem.get('name') + ': ' + Math.round(storeItem.get('data1') / total * 100) + '%');
                  }
                },
                highlight: {
                  segment: {
                    margin: 20
                  }
                },
                label: {
                    field: 'name',
                    display: 'rotate',
                    contrast: true,
                    font: '11px Arial'
                }
            }]
    });
	
	var chart5 = Ext.create('Ext.chart.Chart', {
            xtype: 'chart',
            animate: true,
            store: store6,
			id	 : chart5,
            shadow: true,
            legend: {
                position: 'right'
            },
            theme: 'Base:gradients',
            series: [{
                type: 'pie',
                field: 'data1',
                showInLegend: true,
                donut: 45,
                tips: {
                  trackMouse: true,
                  width: 140,
                  height: 28,
                  renderer: function(storeItem, item) {
                    //calculate percentage.
                    var total = 0;
                    store1.each(function(rec) {
                        total += rec.get('data1');
                    });
                    this.setTitle(storeItem.get('name') + ': ' + Math.round(storeItem.get('data1') / total * 100) + '%');
                  }
                },
                highlight: {
                  segment: {
                    margin: 20
                  }
                },
                label: {
                    field: 'name',
                    display: 'rotate',
                    contrast: true,
                    font: '11px Arial'
                }
            }]
    });
	var chart1	 = Ext.create('Ext.chart.Chart', {
		        width: 800,
		        height: 400,
		        animate: true,
		        store: store5,
				legend: {
				position: 'right'  
				},
				background: {
								//color string
								fill: '#fff'
				},
		        axes: [{
		            type: 'Numeric',
		            position: 'left',
		            fields: ['data1','data2'],
		            label: {
		                renderer: Ext.util.Format.numberRenderer('0,0')
		            },
		            minimum: 0
		        }, {
		            type: 'Category',
		            position: 'bottom',
		            fields: ['name']
		        }],
		        series: [{
		            type: 'column',
		            axis: 'left',
		            highlight: true,
		            xField: 'name',
					label: {
					display: 'insideEnd',
					'text-anchor': 'middle',
                    field: ['data1','data2'],
                    renderer: Ext.util.Format.numberRenderer('0'),
                    orientation: 'vertical',
                    color: '#333'
					},
		            yField: ['data1','data2'],
					
		        }]
	});
	
	
	var store_menus	= Ext.create('Ext.data.TreeStore',{
			model	: 'model_menus',
			proxy: {
			type: 'pgascomProxy',
			url: base_url+'admin/showmenu',
			reader: {
				type: 'json',
				root: 'data'
			},
			node: 'id',
			//expanded: true,
			folderSort: true
		}
	});
	store_menus.load();
	
	var tree = Ext.create('Ext.tree.Panel', {
		id		: 'tree',
		store: store_menus,
		rootVisible: false,
		items : [
        {
				xtype: 'treecolumn',
            	dataIndex: 'text'
        }],
		listeners	: {
			itemclick	: function(s,r)
			{
				//alert();
				window[r.data.act]();
			}
		}
	});
	
	var viewport = Ext.create('Ext.Viewport',{
		layout	: 'border',
		renderTo: Ext.getBody(),
		items	: [{
			region	: 'north',
     		xtype	: 'toolbar',
     		title	: 'north',
     		id		: 'header',
			height	: 90,
			bodyPadding: '5 5 0',
			border	: false,
			html	: '<div style="padding:5px"><div class = "logo"><img src = "'+base_url+'asset/image/pgas.png"height="70px"></div>'
		},
		{
			region	: 'north',
     		xtype	: 'toolbar',
     		id		: 'header2',
			height	: 40,
			items	: menu
		},
		{
			region	: 'west',
			xtype	: 'panel',
			title	: 'West',
			items	: tree,
			width	: 200,
			collapsible	: true,
			split	: true
		},
		{
			region		: 'center',
			xtype		: 'tabpanel',
			id			: 'contentcenter',
			activeTab	: 0,
			fit		: true,
			split	: true,
			bodyPadding	: '5',
			items	: [{
				xtype	: 'panel',
				fit		: true,
				autoScroll	: true,
				title	: 'AREA',
				id		: 'db_penj',
				items	: [
				{
							layout:'column',
							defaults: {
				                    layout: 'anchor',
				                    defaults: {
				                        anchor: '100%'
				                    }
				            },							
							 items: [{
			                    columnWidth: 1/4,
			                    baseCls:'x-plain',
			                    bodyStyle:'padding:5px 0 5px 5px',
			                    items:[{
			                        title: 'Jakarta',
			                        height	: 380,
									layout	: 'fit',
									items	: chart
			                        
			                    }]
			                },{
			                    columnWidth: 1/4,
			                    baseCls:'x-plain',
			                    bodyStyle:'padding:5px 0 5px 5px',
								layout	: 'fit',
			                    items:[{
			                        title: 'Bekasi',
			                        height	: 380,
			                        layout	: 'fit',
									items	: chart2
			                    }]
			                },{
			                    columnWidth: 1/4,
			                    baseCls:'x-plain',
			                    bodyStyle:'padding:5px 0 5px 5px',
								layout	: 'fit',
			                    items:[{
			                        title: 'Palembang',
			                        height	: 380,
			                        layout	: 'fit',
									items	: chart4
			                    }]
			                },{
			                    columnWidth: 1/4,
			                    baseCls:'x-plain',
			                    bodyStyle:'padding:5px 0 5px 5px',
								layout	: 'fit',
			                    items:[{
			                        title: 'SBU 1',
			                        height	: 380,
			                        layout	: 'fit',
									items	: chart5
			                    }]
			                }]
				}]
			},
			{
				xtype	: 'panel',
				fit		: true,
				title	: 'Status Pembayaran',
				id		: 'stok',
				items	: [{
					xtype	: 'panel',
					width	: 800,
					//items	: chart1
				}] 
			}]
		},
		{
			region	: 'east',
			xtype	: 'panel',
			title	: 'Panel East',
			collapsible	: true,
			split	: true,
			collapsed 	: true,
			width	: 200
		}]
	});