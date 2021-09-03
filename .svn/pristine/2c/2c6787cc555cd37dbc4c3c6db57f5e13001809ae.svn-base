Ext.define('mapping.view.mapppelanggansource' ,{
			extend: 'Ext.grid.Panel',
			id : 'mppelanggansource',
			initComponent	: function()
			{
				var filter 		= [];
				var filtermultisource 		= [];
				var winss;
				var winimp;
				var storesbu	= Init.storeSBU;
				var storearea 	= Init.storeArea;
				var msclass 	= Ext.create('master.global.geteventmenu'); 
				
				
		Ext.define('modelMappingGHV',{
			extend	: 'Ext.data.Model',
			fields	: ['rowid','sbu','area','fyear','fmonth','selectopts',
			'd1','d2','d3','d4','d5','d6','d7','d8','d9','d10',
			'd11','d12','d13','d14','d15','d16','d17','d18','d19','d20',
			'd21','d22','d23','d24','d25','d26','d27','d28','d29','d30','d31',
			'idrefpelanggan', 'pelanggan','periode_awal','total_periode' ] });
		var storeGridMappingGHV = Ext.create('Ext.data.JsonStore',{
			model	: 'modelMappingGHV',
			storeId: 'storeMappingGHV',
			proxy: {
				type: 'pgascomProxy',
				// pageParam: false, 
				// startParam: false, 
				// limitParam: false,
				url: base_url+'admin/mapping/findmappingghv',
				reader: {
					type: 'json',				
					root: 'data'
				}			
			}
		});		
		
		// storeGridMappingGHV.load();				
				
				
				
				// var model 		= msclass.getmodel("getghvsummary_mapping('2016-12-01','2016-12-01','','')");
				//var columns     = msclass.getcolumn('v_pelangganindustri');
				// var store 		=  msclass.getstore(model,"getghvsummary_mapping('2016-12-01','2016-12-01','','')" ,filter);
				var form		= Ext.create('mapping.view.formmapping');
				var formimport 	= Ext.create('mapping.view.formimport');
				function showwinimport()
				{
					if(!winimp)
							{
								winimp = Ext.widget('window', {
									title		: "Mapping Pelanggan Source",
									closeAction	: 'hide',
									width		: 400,
									//height		: 260,
									autoScroll	:true,
									//id			: ''+Init.idmenu+'winimp',
									resizable	: true,
									modal		: true,
									bodyPadding	: 5,
									items		: formimport
								});
							}
							
							winimp.show();
				}
				
			
			var n = 0;
			var itemsarea = new Array();
			
			storearea.load(function(records){
				Ext.each(records, function(record){
					itemsarea.push(record.get('area'));
					n++;
				});
			});
			
			var editing = Ext.create('Ext.grid.plugin.RowEditing',{
			 clicksToEdit: 2,
			 listeners :
				{					
				'edit' : function (editor,e) {
						 
						 var grid 	= e.grid;
						 var record = e.record;
						 
						var recordData = record.data; 
							Ext.Ajax.request({ 
								url: base_url+'admin/insertmappingghv',
								method: 'POST',
								params: recordData,
								success: function(response,requst){
									storegridstationconfigdetail.reload();
								},
								failure:function(response,requst)
								{
									Ext.Msg.alert('Fail !','Input Data Entry Gagal');
									Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");
								}
											
							})
							
					}
				}
			});
			
			var filtersCfg = { ftype: 'filters',
				filters: [
				{
					type: 'string',
					dataIndex: 'sbu'
				},		
				{
					type		: 'date',
					dateFormat	: 'Y-m-d',
					dataIndex	: 'tanggal_mapping'
				}]			
			};

			// store.load();
			function showwin()
			{
			
			}
			Ext.apply(this,{
				fit		: true,
				split	: true,		
				store		: storeGridMappingGHV,
				selType		: 'checkboxmodel',	
				title : 'Grid Mapping GHV',
				iconCls : 'application_view_gallery',
				id			: '11gridpelindustri',
				dockedItems: [
				{
					xtype: 'toolbar',
					items	: [
					{
						text	: 'Export',
						iconCls	: 'page_white_get',
						//disabled: true,
						handler	: function()
						{
							var params = storeGridMappingGHV.proxy.extraParams;
							//console.log(params);
							
							window.location = base_url+'admin/mapping/exportrevghv?search='+params.search+"&view=v_pelangganindustri";
						}
					}, '-',
					{
						text	: 'Import',
						iconCls	: 'page_white_put',
						//disabled: true,
						handler	: function()
						{
							showwinimport();
						}
					},'-',
					{
						text	: "Save",
						iconCls	: "database_save",
						handler	: function()
						{
							//console.log("OK");
							if(!winss)
							{
								winss = Ext.widget('window', {
									id 	: 'winmanualghv',
									title		: "Mapping Pelanggan Source",
									closeAction	: 'hide',
									width		: 400,
									//height		: 260,
									autoScroll	:true,
									//id			: ''+Init.idmenu+'winmapppelsource',
									resizable	: true,
									modal		: true,
									bodyPadding	: 5,
									items		: form
								});
							}
							
							winss.show();
						}
					}]
				},
				/*
				{
					xtype: 'toolbar',
					items: [
						{
							text: 'Download'
						}, '->', 
						{
							text: 'Is Multisource'
						},
						'-',
						{
							xtype		: 'combobox',
							store		: storeismultisource,
							displayField: 'confname',
							valueField	: 'rowid',
							id			: 'multi'
						}, 
						,'-',{
							text	: 'Station'
						},'-',{
							name		: 'mstation',
							id			: 'mstation',
							xtype		: 'combobox',
							store		: storestation,
							queryMode	: 'local',
							displayField: 'stationname',
							valueField	: 'rowid'
						},'-',{
							text	: 'Tanggal'
						},'-',
						{
							xtype	: 'datefield',
							format	: 'Y-m-d',
							id		: 'tanggalfrom'
						},'-',
						{
							xtype	: 'datefield',
							format	: 'Y-m-d',
							id		: 'tanggalto'
						}, '-', 
						{
							xtype	: 'button',
							iconCls	: 'database_add',
							text: 'Save',
							handler	: function()
							{
								var items = [];
								var ismulti = Ext.getCmp('multi').getValue();
								var mstation = Ext.getCmp('mstation').getValue();
								var from = Ext.getCmp('tanggalfrom').getSubmitValue();
								var to = Ext.getCmp('tanggalto').getSubmitValue();
								
								store.each(function(record){
									if(record.data.selectopts == true)
									{
										items.push({
											stationid : mstation,
											idpel	  : record.data.idpel,
											ismultisource	: ismulti,
											delflag		: 1,
											creperson	: 'system',
											from		: from,
											to			: to
										);
									}
								});
								var dataInput = Ext.encode(items);
								Ext.Ajax.request({	 
									url: base_url+'admin/mapping/insertmapping',
									method: 'POST',
									params: {
										data	: dataInput
									},
									success: function(response,requst){
										
										//storegridstationconfigdetail.reload();
										Ext.Msg.alert('Sukses','Input Data');
									},
									failure:function(response,requst)
									{
										Ext.Msg.alert('Fail !','Input Data Entry Gagal');
										Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");
									}
											
								})
								//console.log(items);
							}
						}]
				},
				*/
				{
					xtype: 'pagingtoolbar',
					dock: 'bottom',
					store: storeGridMappingGHV,
					displayInfo: true,
					// plugins : [Ext.create('Ext.ux.PagingToolbarResizer')]
				}],
				columns		: [
				Ext.create('Ext.grid.RowNumberer',
					{
						header: 'No', 
						width: 30
					}
					),					
					{	
						dataIndex : 'sbu',
						text : 'RD',
						width: 60,
						cls   : 'header-cell',						

					},
					{
						dataIndex : 'area',
						text : 'Area',
						width: 70,
						cls   : 'header-cell'					
						
					},
					{
						dataIndex : 'fyear',
						text : 'Tahun',
						width: 60,
						cls   : 'header-cell'					
						
					},
					{
						dataIndex : 'fmonth',
						text : 'Bulan',
						width: 60,
						cls   : 'header-cell'					
						
					},
					{
						dataIndex : 'idrefpelanggan',
						text : 'ID Pelanggan',
						cls   : 'header-cell',
						width: 120,
						
					},					
					{
						dataIndex 	: 'pelanggan',
						text 		: 'Nama Pelanggan',
						cls   	: 'header-cell',
						width	: 250,
					},
					
					{
						dataIndex 	: 'd1',
						text 		: '1',
						cls   	: 'header-cell',
						width	: 50,
					},
					{
						dataIndex 	: 'd2',
						text 		: '2',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd3',
						text 		: '3',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd4',
						text 		: '4',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd5',
						text 		: '5',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd6',
						text 		: '6',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd7',
						text 		: '7',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd8',
						text 		: '8',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd9',
						text 		: '9',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd10',
						text 		: '10',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd11',
						text 		: '11',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd12',
						text 		: '12',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd13',
						text 		: '13',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd14',
						text 		: '14',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd15',
						text 		: '15',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd16',
						text 		: '16',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd17',
						text 		: '17',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd18',
						text 		: '18',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd19',
						text 		: '19',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd20',
						text 		: '20',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd21',
						text 		: '21',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd22',
						text 		: '22',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd23',
						text 		: '23',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd24',
						text 		: '24',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd25',
						text 		: '25',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd26',
						text 		: '26',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd27',
						text 		: '27',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd28',
						text 		: '28',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd29',
						text 		: '29',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd30',
						text 		: '30',
						cls   	: 'header-cell',
						width	: 50,
					},					
					{
						dataIndex 	: 'd31',
						text 		: '31',
						cls   	: 'header-cell',
						width	: 50,
					}//,					
					/* {
						dataIndex 	: 'total_periode',
						cls   : 'header-cell',
						width: 100,						
						text 		: 'Complete'
					} */
					],
					listeners	: 
					{
						beforeitemcontextmenu: function(view, record, item, index, e)
						{
							e.stopEvent();
						},
						itemclick	: function(view, record, item, index, e, eOpts)
						{
						
						},
						selectionchange: function (view, record, item, index, e, eOpts) {
							
						},
						select: function (model, record, index, eOpts) {
							record.set('selectopts',true);
						},
						deselect: function (view, record, item, index, e, eOpts) {
							record.set('selectopts',false);
						}
					}

			});
			this.callParent(arguments);
			}
		})
