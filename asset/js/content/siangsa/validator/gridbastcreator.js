function apps(name, iconCls){
	var valuesimpan;
	Ext.define('Init', {
			valuesimpan
	});
	 
	//====================| FRAMEWORK |===============================================
	
		var msclass 						= Ext.create('master.global.geteventmenu');
		var pageId = Init.idmenu;
		var v_table = "v_bastcreator"; 
		var winimp;
		var model_data = msclass.getmodel(v_table);
		 model_data.push('selectopts');
		var pstore = msclass.getstore(model_data,v_table,[]);
		pstore.getProxy().extraParams = {
						view :'v_bastcreator',
						limit : 'All',
						"filter[0][field]" : "user_tujuan", 
						"filter[0][data][type]" : "string",
						"filter[0][data][comparison]" : "eq",
						"filter[0][data][value]" : myuser_id
		};		
		pstore.load();
		
		var cgrid = msclass.getcolumngrid('idgrid_bastcreator',v_table);	
			cgrid[0] = {
				text	: 'Status',
				width : 100,
				align	: 'left',
				dataIndex : cgrid[0].dataIndex,
				renderer: function(val, meta, record, rowIndex){
					var reffstatus			= record.data.reffstatus;
					var nama_status			= record.data.nama_status;
					//return reffstatus;
					switch (reffstatus){
						default:
							return '<img src="'+base_url+'asset/ico/51.ico" /> '+nama_status;
						break;
						
						case 'MD419':
							return '<img src="'+base_url+'asset/ico/42.ico" /> '+nama_status;
						break;
					}
				}
		};
		cgrid[1].hidden = true;
		
		
		var itemdocktop = [{
			text	: 'Buka',
			iconCls	: 'application_form_magnify',
			handler	: function()
			{
				var grid = Ext.getCmp('idgrid_bastcreator');				
				var storegrid = grid.getStore();
				storegrid.each(function(record){ 
				  //console.log(record.data);
				});
				
				var record 	= grid.getView().getSelectionModel().getSelection()[0]; 
				var sk_id = record.get('rowid');
				//var refftujuansurat = record.get('refftujuansurat');
				//console.log(sk_id);
				
				if (sk_id){
					if(!Init.winss_formdetailcreator)
					{
						var formdetailcreator = Ext.create('siangsa.validator.formdetailcreator');
						Init.winss_formdetailcreator = Ext.widget('window', {
							closeAction	: 'hide',
							width: 1000,
							height	: 500,
							autoScroll	:true,
							resizable	: true,
							modal		: true,
							bodyPadding	: 5,
							layout		: 'fit',
							items		: formdetailcreator
						});
						Ext.getCmp('formdetailcreator'+pageId).getForm().reset();
						
					}
					Init.winss_formdetailcreator.show();
					
					var myField 	= Ext.getCmp('formdetailcreator'+pageId);
					var form_data 	= myField.getForm();
					form_data.loadRecord(record);
					
					var storead = Ext.getCmp('gridattdokumenbastdetailcreator'+pageId).getStore();
					storead.getProxy().extraParams = {
						view :'tbl_attdokumen',
						limit : 'All',
						"filter[0][field]" : "reffsurat",
						"filter[0][data][type]" : "string",
						"filter[0][data][comparison]" : "eq",
						"filter[0][data][value]" : sk_id
					};
					storead.load();					
				}
			}
		},
		{
			text	: 'Upload',
			iconCls	: 'application_form_magnify',
			handler	: function()
			{
				var grid = Ext.getCmp('idgrid_bastcreator');				
				var storegrid = grid.getStore();
				storegrid.each(function(record){ 
				  //console.log(record.data);
				});
				
				var record 	= grid.getView().getSelectionModel().getSelection()[0]; 
				var id = record.get('rowid');
				
				if (id){
					if(!Init.winss_form)
					{
						var form = Ext.create('siangsa.validator.formuploadbast');
						Init.winss_form = Ext.widget('window', {
							closeAction	: 'hide',
							width: 500,
							height	: 120,
							autoScroll	:true,
							resizable	: true,
							modal		: true,
							bodyPadding	: 5,
							layout		: 'fit',
							items		: form,
							/* close: function(){
									Ext.getCmp('formuploadbast').getForm().destroy();
							} */
						});
						Ext.getCmp('rowid'+pageId).setValue(id);
					}
					Init.winss_form.show();
				}
			}
		},
		{
			text	: 'Print Bast',
			iconCls	: 'report_go',
			menu		: [
			{
				text		: 'Generate System',
				iconCls		: 'printer',
				handler	: function()
				{
					var grid = Ext.getCmp('idgrid_bastcreator');
					var record 	= grid.getView().getSelectionModel().getSelection()[0];
					var id = record.get('rowid');
					if(record){							
						parms_pgrid.getProxy().extraParams = { 
						view :'v_bastreport',
						limit : "All",
								"filter[0][field]" : "rowid",
								"filter[0][data][type]" : 'string',
								"filter[0][data][comparison]" : "eq",
								"filter[0][data][value]" : id
						};
						msclass.exportdata('idgrid_bastcreator','v_bastreport','towordbapp');
					}
				}
			},
			{
				text		: 'File Upload',
				iconCls		: 'printer',
				handler	: function()
				{
					var grid = Ext.getCmp('idgrid_bastcreator');
					var record 	= grid.getView().getSelectionModel().getSelection()[0];
					var value = record.get('bast_url');
					//console.log(value);
					if(record){
						if(value != ''){
							var url = base_url+"document/upload/"+value;
							window.open(url); 							
						}
					}
				}
			}]
		}] 
		
	var pgrid  = msclass.getgridpeng(cgrid,'idgrid_bastcreator',itemdocktop,pstore);
		var f_items    = msclass.getitemsform(v_table,'idform_srcbastcreator');
		f_items[0].id = 'reffstatussrcgsk';
        var pformsearch = msclass.getformsearchpeng1(f_items);
		
		
	   var get_toolbar =  [];
	   
		var stores = Ext.getCmp('reffdivisisrc').getStore().load();
		stores.getProxy().extraParams = {
									view :"mst_divisi",
									limit : "All"
		};
		stores.reload(); 
		var parms_pgrid = Ext.getCmp('idgrid_bastcreator').getStore(); 
	//==================| SEARCH |======================================================
	var fsearch =  Ext.create('Ext.form.Panel',{ 
				xtype: 'form',
				title: 'Form Search', 
				flex: 1,
				collapsed : true,
				id : 'searchbastcreator',
				region: 'west',
				bodyStyle: 'padding:5px',
				layout: {
					type: 'vbox',
					align : 'stretch',
					pack  : 'start',
				},
				//tbar	:ptoolbar_search,
				items	: [{
					border	: false,
					xtype: 'panel',
					bodyStyle: 'padding:0 0 20px 0',
					items : pformsearch,
					buttons		: [{
								text	: 'Search',
								iconCls : 'magnifier',
								handler	: function()
									{
										var findform = this.up('form').getForm();
										var oksparams = findform.getValues();
										//console.log(oksparams);		
										parms_pgrid.getProxy().extraParams = {
												view :'public.v_bastcreator',
												limit : "All",
												"filter[0][field]" : 'judul_bast',
												"filter[0][data][type]" : 'string',
												"filter[0][data][comparison]" : "",
												"filter[0][data][value]" : oksparams.judul_bast,
												"filter[1][field]" : "tanggal_surat",
												"filter[1][data][type]" : "string",
												"filter[1][data][comparison]" : "eq",
												"filter[1][data][value]" : oksparams.tanggal_surat,
												"filter[2][field]" : "divisi_id",
												"filter[2][data][type]" : 'string',
												"filter[2][data][comparison]" : "eq",
												"filter[2][data][value]" : oksparams.reffdivisi
										};
										parms_pgrid.reload(); 
									}
							},
							{
								text	: 'Reset',
								iconCls : 'arrow_refresh',
								handler	: function()
								{
									this.up('form').getForm().reset();
								}
							}
					]
				}
			]
	});
	var layout = msclass.getlayout(pgrid,pformsearch,get_toolbar,iconCls,name,fsearch);		
}
