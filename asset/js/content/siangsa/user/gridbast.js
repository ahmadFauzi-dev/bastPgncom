function apps(name, iconCls){
	var valuesimpan;
	Ext.define('Init', {
			valuesimpan
	});
	 
	//====================| FRAMEWORK |===============================================
	
		var msclass 						= Ext.create('master.global.geteventmenu');
		var pageId = Init.idmenu;
		var v_table = "v_bast"; 
		var winimp;
		var model_data = msclass.getmodel(v_table);
		 model_data.push('selectopts');
		var pstore = msclass.getstore(model_data,v_table,[]);
		pstore.getProxy().extraParams = {
						view :'v_bast',
						limit : 'All',
						"filter[0][field]" : "create_by", 
						"filter[0][data][type]" : "string",
						"filter[0][data][comparison]" : "eq",
						"filter[0][data][value]" : username
		};		
		pstore.load();
		
		var cgrid = msclass.getcolumngrid('idgrid_bast',v_table);	
		cgrid[1].hidden = true;
		
		
		var itemdocktop = [{
			text	: 'Buka',
			iconCls	: 'application_form_magnify',
			handler	: function()
			{
				var grid = Ext.getCmp('idgrid_bast');				
				var storegrid = grid.getStore();
				storegrid.each(function(record){ 
				  //console.log(record.data);
				});
				
				var record 	= grid.getView().getSelectionModel().getSelection()[0]; 
				var sk_id = record.get('rowid');
				//var refftujuansurat = record.get('refftujuansurat');
				//console.log(sk_id);
				
				if (sk_id){
					if(!Init.winss_formdetail)
					{
						var formdetail = Ext.create('siangsa.user.formdetail');
						Init.winss_formdetail = Ext.widget('window', {
							closeAction	: 'hide',
							width: 700,
							height	: 600,
							autoScroll	:true,
							//id			: ''+Init.idmenu+'winmapppelsource',
							resizable	: true,
							modal		: true,
							bodyPadding	: 5,
							layout		: 'fit',
							items		: formdetail
						});
						Ext.getCmp('formdetail'+pageId).getForm().reset();
						
					}
					Init.winss_formdetail.show();
					
					var myField 	= Ext.getCmp('formdetail'+pageId);
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
			text	: 'Print',
			iconCls	: 'report_go',
			handler	: function()
			{
					var grid = Ext.getCmp('idgrid_bast');
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
		
	var pgrid  = msclass.getgridpeng(cgrid,'idgrid_bast',itemdocktop,pstore);
		var f_items    = msclass.getitemsform(v_table,'idform_srcbast');
		f_items[0].id = 'reffstatussrcgsk';
        var pformsearch = msclass.getformsearchpeng1(f_items);
		
		
	   var get_toolbar =  [];
	   
		var stores = Ext.getCmp('reffdivisisrc').getStore().load();
		stores.getProxy().extraParams = {
									view :"mst_divisi",
									limit : "All"
		};
		stores.reload(); 
		var parms_pgrid = Ext.getCmp('idgrid_bast').getStore(); 
	//==================| SEARCH |======================================================
	var fsearch =  Ext.create('Ext.form.Panel',{ 
				xtype: 'form',
				title: 'Form Search', 
				flex: 1,
				collapsed : true,
				id : 'searchbast',
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
												view :'public.v_bast',
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
