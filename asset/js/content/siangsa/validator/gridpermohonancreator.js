function apps(name, iconCls){
	var valuesimpan;
	Ext.define('Init', {
			valuesimpan
	});
	 
	//====================| FRAMEWORK |===============================================
	
		var msclass 						= Ext.create('master.global.geteventmenu');
		var pageId = Init.idmenu;
		var v_table = "v_permohonanbastcreator"; 
		var winimp;
		var model_data = msclass.getmodel(v_table);
		 model_data.push('selectopts');
		var pstore = msclass.getstore(model_data,v_table,[]);
		pstore.getProxy().extraParams = {
						view :'v_permohonanbastcreator',
						limit : 'All',
						"filter[0][field]" : "user_tujuan", 
						"filter[0][data][type]" : "string",
						"filter[0][data][comparison]" : "eq",
						"filter[0][data][value]" : myuser_id
		};		
		pstore.load();
		
		var cgrid = msclass.getcolumngrid('idgrid_permohonanbastcreator',v_table);	
		cgrid[0] =  {
			xtype	: 'actioncolumn',
			//text	: 'Delete',
			align   : 'center',
			width	: 30,
			items	: [{
				icon		: ''+base_url+'asset/ico/application_go.png',
				tooltip		: 'Tindak Lanjut',
				handler		: function(grid, rowIndex, colIndex)
				{
					var record = grid.getStore().getAt(rowIndex);
					var grid = Ext.getCmp('idgrid_permohonanbastcreator');
					var sk_id = record.get('rowid');
					
					var reffph2;					
					Ext.define('Init', {
							reffph2
					});
					
					Init.reffph2 = record.get('reffph2');
					
					if(record){
						
						var myMask = new Ext.LoadMask(Ext.getBody(), {msg:"Please wait..."});
						myMask.show();
								
						var form_editdraft = Ext.create('siangsa.validator.form_editdraftcreator');	
						var tabPanel = Ext.getCmp('contentcenter');
						
						tabPanel.items.each(function(c){
								if (c.id == 'editdraft') {
									tabPanel.remove(c);
								}
						});
						
						var exist = false;
						if (!exist) {
								tabPanel.add({
									title: 'Tindak Lanjut',
									id: 'editdraft',
									xtype		: 'panel',
									autoScroll: true,
									iconCls		: iconCls,
									closable	: true,
									frame 		: true,
									layout		: 'border',
									defaults: {
										collapsible: false,
										anchor: '60%',
										split: true
									},
									items		: 
									[{
											xtype	: 'panel',
											region	: 'center',
											collapsed :false,
											layout: 'fit',
											margins: '5,0,0,0',
											title	: 'Form Pembuatan Bast',
											items : form_editdraft	
									}]	
								});
								Ext.getCmp('form_editbastcreator').getForm().reset();
								var exist = true;
							}
							
							var myField 	= Ext.getCmp('form_editbastcreator');
							var form_data 	= myField.getForm();
							form_data.loadRecord(record);
								
							var storead = Ext.getCmp('gridattdokumeneditcreator'+pageId).getStore();
							storead.getProxy().extraParams = {
								view :'tbl_attdokumen',
								limit : 'All',
								"filter[0][field]" : "reffsurat",
								"filter[0][data][type]" : "string",
								"filter[0][data][comparison]" : "eq",
								"filter[0][data][value]" : sk_id
							};
							storead.load();
							
							var storebt = Ext.getCmp('grideditbiayatambahancreator'+pageId).getStore();
							storebt.getProxy().extraParams = {
								view :'v_biayatambahan',
								limit : 'All',
								"filter[0][field]" : "refftransaction",
								"filter[0][data][type]" : "string",
								"filter[0][data][comparison]" : "eq",
								"filter[0][data][value]" : sk_id
							};
							storebt.load();
							
						myMask.hide();
						tabPanel.setActiveTab('editdraft');
						
					}
				}
			}]
		}
		cgrid[1].hidden = true;
		
		cgrid[4].hidden = true;
		
		var itemdocktop = [] 
		
	var pgrid  = msclass.getgridpeng(cgrid,'idgrid_permohonanbastcreator',itemdocktop,pstore);
		var f_items    = msclass.getitemsform(v_table,'idform_srcpermohonanbastcreator');
		f_items[0].id = 'reffstatussrcgsk';
        var pformsearch = msclass.getformsearchpeng1(f_items);
		
		
	   var get_toolbar =  [];
	   
		var stores = Ext.getCmp('reffdivisisrc').getStore().load();
		stores.getProxy().extraParams = {
									view :"mst_divisi",
									limit : "All"
		};
		stores.reload(); 
		var parms_pgrid = Ext.getCmp('idgrid_permohonanbastcreator').getStore(); 
	//==================| SEARCH |======================================================
	var fsearch =  Ext.create('Ext.form.Panel',{ 
				xtype: 'form',
				title: 'Form Search', 
				flex: 1,
				collapsed : true,
				id : 'searchpermohonanbastcreator',
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
												view :'public.v_permohonanbastcreator',
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
