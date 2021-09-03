function apps(name, iconCls){
	var valuesimpan;
	Ext.define('Init', {
			valuesimpan
	});
	 
	//====================| FRAMEWORK |===============================================
	
		var msclass 						= Ext.create('master.global.geteventmenu');
		var pageId = Init.idmenu;
		var v_table = "v_permohonanbast"; 
		var winimp;
		var model_data = msclass.getmodel(v_table);
		 model_data.push('selectopts');
		var pstore = msclass.getstore(model_data,v_table,[]);
		pstore.getProxy().extraParams = {
						view :'v_permohonanbast',
						limit : 'All',
						"filter[0][field]" : "create_by", 
						"filter[0][data][type]" : "string",
						"filter[0][data][comparison]" : "eq",
						"filter[0][data][value]" : username
		};		
		pstore.load();
		
		var cgrid = msclass.getcolumngrid('idgrid_permohonanbast',v_table);	
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
		cgrid[4].hidden = true;
		
		var itemdocktop = [{
			text	: 'Buka',
			iconCls	: 'application_form_magnify',
			handler	: function()
			{
				var grid = Ext.getCmp('idgrid_permohonanbast');				
				var storegrid = grid.getStore();
				storegrid.each(function(record){ 
				  //console.log(record.data);
				});
				
				var record 	= grid.getView().getSelectionModel().getSelection()[0]; 
				var sk_id = record.get('rowid');
				//var refftujuansurat = record.get('refftujuansurat');
				//console.log(sk_id);
				
				if (sk_id){
					if(!Init.winss_formpermohonandetail)
					{
						var formpermohonandetail = Ext.create('siangsa.user.formpermohonandetail');
						Init.winss_formpermohonandetail = Ext.widget('window', {
							closeAction	: 'hide',
							width: 1000,
							height	: 500,
							title		: "Bapp Detail",
							autoScroll	:true,
							//id			: ''+Init.idmenu+'winmapppelsource',
							resizable	: true,
							modal		: true,
							bodyPadding	: 5,
							layout		: 'fit',
							items		: formpermohonandetail
						});
						Ext.getCmp('formpermohonandetail'+pageId).getForm().reset();
					}
					Init.winss_formpermohonandetail.show();
					
					var myField 	= Ext.getCmp('formpermohonandetail'+pageId);
					var form_data 	= myField.getForm();
					form_data.loadRecord(record);
					
					var storead = Ext.getCmp('gridattdokumenskdetail'+pageId).getStore();
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
			text	: 'Description',
			iconCls	: 'application_form_magnify',
			handler	: function()
			{
				var grid = Ext.getCmp('idgrid_permohonanbast');				
				var storegrid = grid.getStore();
				storegrid.each(function(record){ 
				  //console.log(record.data);
				});
				
				var record 	= grid.getView().getSelectionModel().getSelection()[0]; 
				var sk_id = record.get('rowid');
				var reffstatus = record.get('reffstatus');
				
				if (reffstatus == 'MD419'){
					if(!Init.winss_desc)
					{
						var form_descripition = Ext.create('siangsa.user.form_description');
						Init.winss_desc = Ext.widget('window', {
							closeAction	: 'hide',
							width: 400,
							height	: 300,
							frame : false,
							layout : 'fit',
							title: 'Description', 
							margins: '5,5,5,5',
							autoScroll	:true,
							//id			: ''+Init.idmenu+'winmapppelsource',
							resizable	: true,
							modal		: true,
							bodyPadding	: 5,
							layout		: 'fit',
							items		: form_descripition
						});
						Ext.getCmp('form_description'+pageId).getForm().reset();
					}
					Init.winss_desc.show();
					
					var myField 	= Ext.getCmp('form_description'+pageId);
					var form_data 	= myField.getForm();
					form_data.loadRecord(record);
				}
			}
		},
		{
			text	: 'Edit',
			iconCls	: 'application_edit',
			handler	: function()
			{
					var grid = Ext.getCmp('idgrid_permohonanbast');
					var record 	= grid.getView().getSelectionModel().getSelection()[0];
					var sk_id = record.get('rowid');					
					var reffph2 = record.get('reffph2');					
					
					if(record){
						var myMask = new Ext.LoadMask(Ext.getBody(), {msg:"Please wait..."});
						myMask.show();
								
						var form_editdraft = Ext.create('siangsa.user.form_editdraft');	
						var tabPanel = Ext.getCmp('contentcenter');
						
						tabPanel.items.each(function(c){
								if (c.id == 'editdraft'){
									tabPanel.remove(c);
								}
						});
						
						
						var exist = false;
						if (!exist) {
							tabPanel.add({
								title: 'Form Edit Draft',
								id: 'editdraft',
								xtype		: 'panel',
								iconCls		: iconCls,
								closable	: true,
								frame 		: true,
								layout		: 'border',
								autoWidth: true,
								defaults: {
									collapsible: false,
									split: true
								},
								items		: 
								[{
										xtype	: 'panel',
										region	: 'center',
										collapsed :false,
										title	: 'Edit Konsep',
										layout: 'fit',
										margins: '5,0,0,0',
										items : form_editdraft	
								}]	
							});
							Ext.getCmp('form_editdraft').getForm().reset();
							
												
							var myField 	= Ext.getCmp('form_editdraft');
							var form_data 	= myField.getForm();
							form_data.loadRecord(record);
							
							//Ext.getCmp('contentcenter').setDisabled(true);
							
							var storewf = Ext.getCmp('gridworkflowedit').getStore();
							storewf.getProxy().extraParams = {
								view :'v_workflowdetail',
								limit : 'All',
								"filter[0][field]" : "refftransaction",
								"filter[0][data][type]" : "string",
								"filter[0][data][comparison]" : "eq",
								"filter[0][data][value]" : sk_id			
							};
							storewf.reload();
							
							var storewf = Ext.getCmp('grideditbiayatambahan'+'add').getStore();
							storewf.getProxy().extraParams = {
								view :'v_biayatambahan',
								limit : 'All',
								"filter[0][field]" : "refftransaction",
								"filter[0][data][type]" : "string",
								"filter[0][data][comparison]" : "eq",
								"filter[0][data][value]" : sk_id			
							};
							storewf.reload();
							
							var storead = Ext.getCmp('gridattdokumenedit').getStore();
							storead.getProxy().extraParams = {
								view :'tbl_attdokumen',
								limit : 'All',
								"filter[0][field]" : "reffsurat",
								"filter[0][data][type]" : "string",
								"filter[0][data][comparison]" : "eq",
								"filter[0][data][value]" : sk_id
							};
							storead.reload(); 
							
							var storead = Ext.getCmp('reffapprovalph2'+pageId).getStore();
							storead.getProxy().extraParams = {
											view :"tb_vendordir",
											limit : "All",
											"filter[0][field]" : "reffvendor",
											"filter[0][data][type]" : 'string',
											"filter[0][data][comparison]" : "eq",
											"filter[0][data][value]" : reffph2																
										};
							storead.load();
							
							//Ext.getCmp("reffapprovalph2"+pageId).setValue(reffapprovalph2);
												
						}
						myMask.hide();
						tabPanel.setActiveTab('editdraft');
				}
			}
		}] 
		
	var pgrid  = msclass.getgridpeng(cgrid,'idgrid_permohonanbast',itemdocktop,pstore);
		var f_items    = msclass.getitemsform(v_table,'idform_srcpermohonanbast');
		f_items[0].id = 'reffstatussrcgsk';
        var pformsearch = msclass.getformsearchpeng1(f_items);
		
		
	   var get_toolbar =  [];
	   
		var stores = Ext.getCmp('reffdivisisrc').getStore().load();
		stores.getProxy().extraParams = {
									view :"mst_divisi",
									limit : "All"
		};
		stores.reload(); 
		var parms_pgrid = Ext.getCmp('idgrid_permohonanbast').getStore(); 
	//==================| SEARCH |======================================================
	var fsearch =  Ext.create('Ext.form.Panel',{ 
				xtype: 'form',
				title: 'Form Search', 
				flex: 1,
				collapsed : true,
				//width	: 250,
				id : 'searchlaporanstokitems',
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
												view :'public.v_permohonanbast',
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
