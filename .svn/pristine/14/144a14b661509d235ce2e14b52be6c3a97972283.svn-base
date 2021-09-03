Ext.define('masterdata.view.email_template' ,{
	extend: 'Ext.grid.Panel',
	initComponent	: function()
	{
	var dataselect;
	var filter = [];
	var pageId = Init.idmenu;
	var msclass = Ext.create('master.global.geteventmenu'); 
	var model = msclass.getmodel('v_emailtemplate');
	var columns = msclass.getcolumn('v_emailtemplate');
	var store =  msclass.getstore(model,'v_emailtemplate',filter);
	store.load();
	
	v_event = "fn_getdatamastertype('TOD43')";
	var mevent = msclass.getmodel(v_event);
	var st_event =  msclass.getstore(mevent,v_event,filter);
	st_event.load();
	
	v_tipesurat = "fn_getdatamastertype('TOD33')";
	var mtipesurat = msclass.getmodel(v_tipesurat);
	var st_tipesurat =  msclass.getstore(mtipesurat,v_tipesurat,filter);
	st_tipesurat.load();
	
	v_status = "fn_getdatamastertype('TOD38')";
	var mstatus = msclass.getmodel(v_status);
	var st_status =  msclass.getstore(mstatus,v_status,filter);
	//st_status.load();
	st_status.getProxy().extraParams = {
		view :v_status,				
		limit : 'All',									
		"filter[0][field]" : "id",
		"filter[0][data][type]" : "list",
		"filter[0][data][comparison]" : "",
		"filter[0][data][value]" : 'MD319,MD320,MD321'		
	};
	st_status.load();
	
	var storeCombonyaActive = Ext.create('Ext.data.Store',{
			fields : ['idnya','name'],
			data   : [
				{ idnya: '1' , name : 'Y' },
				{ idnya: '0' , name : 'N' }
			]
	});
	storeCombonyaActive.load(); 
	
	var coldisplay = columns;
	//coldisplay[0].hidden = true;
	coldisplay[1].hidden = true;
	coldisplay[2] = {
					text : 'Nama',
					width:100,
					dataIndex	: coldisplay[2].dataIndex,
					editor		: {
						xtype : 'textfield',
						name : coldisplay[2].dataIndex,
						id : 'nama'+pageId
					}
				};
	coldisplay[3].hidden = true;
	coldisplay[4] = { 	
				text : 'Status',
				width:80,
				align:'center',
				dataIndex	: columns[4].dataIndex,
				renderer: function(value, metaData, record ){									
					if (value == '1'){
						return 'Y';
					}
					else{
						return 'N';
					}						
				},
				editor		: {
					xtype			: 'combobox',
					name			: columns[4].dataIndex,
					store				: storeCombonyaActive,
					displayField	: 'name',
					queryMode	: 'local',
					valueField		: 'idnya' 
				}					
	};
	coldisplay[5] = {
					text : 'Subject',
					width:200,
					dataIndex	: coldisplay[5].dataIndex,
					editor		: {
						xtype : 'textareafield',
						grow      : true,
						name : coldisplay[5].dataIndex,
						id : 'subject'+pageId
					}
	};
	coldisplay[6] = { 	
				text : 'Event',
				width:150,
				align:'center',
				dataIndex	: columns[6].dataIndex,
				renderer: function(value, metaData, record ){				
					return record.get('nama_event');
				},
				editor		: {
					xtype			: 'combobox',
					name			: columns[6].dataIndex,
					store				: st_event,
					displayField	: 'nama',
					queryMode	: 'local',
					valueField		: 'id' 
				}					
	};
	coldisplay[7].hidden = true;
	coldisplay[8] = { 	
				text : 'Tipe Surat',
				width:150,
				align:'center',
				dataIndex	: columns[8].dataIndex,
				renderer: function(value, metaData, record ){				
					return record.get('nama_tipesurat');
				},
				editor		: {
					xtype			: 'combobox',
					name			: columns[8].dataIndex,
					store				: st_tipesurat,
					displayField	: 'nama',
					queryMode	: 'local',
					valueField		: 'id' 
				}					
	};
	coldisplay[9].hidden = true;
	coldisplay[12].hidden = true;
	coldisplay[13].hidden = true;
	coldisplay[14] = { 	
				text : 'Status Surat',
				width:150,
				align:'center',
				dataIndex	: columns[14].dataIndex,
				renderer: function(value, metaData, record ){				
					//console.log(record.get('nama_status'));
					return record.get('nama_status');
				},
				editor		: {
					xtype			: 'combobox',
					name			: columns[14].dataIndex,
					store				: st_status,
					displayField	: 'desk',
					queryMode	: 'local',
					valueField		: 'id' 
				}
	};
	coldisplay[15].hidden = true;
		//var role = {"p_export"	: true};
		//console.log(role.p_export);
		
		var editing = Ext.create('Ext.grid.plugin.RowEditing', {
		  clicksToEdit: 2,
		  listeners :
			{					
				'edit' : function (editor,e) {
					 // console.log("asd");
					var grid = e.grid;
					var record = e.record;					 
					var recordData = record.data; 
					recordData.id = 'grid_emailtemplate'+pageId;
					msclass.savedata(recordData , base_url+'masterdata/update_email');
				}
			}
		});
		
		
		var grid_emailtemplate = Ext.apply(this, {
			title	: 'Email Template',
			store		: store,
			multiSelect	: true,
			fit		: true,
			// layout : 'fit',
			id			: 'grid_emailtemplate'+pageId,
			plugins		: editing,
			dockedItems	: [
				{
					xtype: 'toolbar',
					items	: [
					{
						text	: 'Add',
						iconCls	: 'add',
						xtype	: 'button',
						handler	: function()
						{
							var r = {
								rowid : '0',
								subject	: '',
								template	: ''
							}
							store.insert(0, r);								
						}
					},
					{
						text	: 'Delete',
						iconCls	: 'bin',
						xtype	: 'button',
							handler		: function()
							{																
									var rec = grid_emailtemplate.getView().getSelectionModel().getSelection()[0];
									var id 	= rec.get('rowid');
									
									var params = {
										"filter[0][field]" : "rowid",
										"filter[0][data][type]" : "string",
										"filter[0][data][comparison]" : "eq",
										"filter[0][data][value]" : id,
									}

									var table = 'email_template';
									params.id = 'grid_emailtemplate'+pageId;								
									msclass.deletedata(params,table,base_url+'simpel/deletedata');
							}
					},
					{
						iconCls	: 'note',
						xtype	: 'button',
						// xtype	: 'button',
						text	: 'Template',
						handler		: function(){

								var rec = grid_emailtemplate.getView().getSelectionModel().getSelection()[0];
								var id 	= rec.get('rowid');
								var template = rec.get('template');
								/* var reffevent = rec.get('reffevent');
								var refftipesurat = rec.get('refftipesurat'); */
								//console.log(template);
								//alert(id);
								
								if(rec){
									/* var myMask = new Ext.LoadMask(Ext.getBody(), {msg:"Please wait..."});
									myMask.show(); */
									
									var form_email_template = Ext.create('masterdata.view.form_email_template');
									var additional_email_template = Ext.create('masterdata.view.additional_email_template');
									Init.winss_tmpl_email = Ext.widget('window', {
											title: 'Form Email Template',
											width: 1000,
											height	: 500,
											layout: 'fit',
											closable	: false,
											autoScroll:true,
											//id		: "winNotifikasi",
											//layout: 'fit',
										
											resizable: true,
											modal: true,
											bodyPadding	: 5,
											layout: 'border',		
											items: [{
												// xtype: 'panel' implied by default
												region:'west',
												xtype: 'panel',
												margins: '5 0 0 5',
												width: 900,
												//collapsible: true,   // make collapsible
												layout: 'fit',
												items : form_email_template,
												flex:2
											},{
												//title: 'Center Region',
												region: 'center',     // center region is required, no width/height specified
												xtype: 'panel',
												layout: 'fit',
												border:false,
												margins: '5 5 0 0',
												flex :1,
												items:additional_email_template
											}]
									});
									Init.winss_tmpl_email.show();
									Ext.getCmp('template_email').setValue(template);
									Ext.getCmp('id_emails').setValue(id);
									//Init.store_additionalEmal.load();
									//myMask.hide();
								} 
						}
					}
					]
				},
				{
					xtype: 'pagingtoolbar',
					dock: 'bottom',
					store: store,
					displayInfo: true,
					plugins : [Ext.create('Ext.ux.PagingToolbarResizer')]
				}
			],
			tools		: [
			{
				type	: 'refresh',
				handler	: function()
				{
					store.load();
					/* var action_button = 
					Ext.getCmp('act_appr').enable() */
				}
			}],
			columns		: columns		
			
		});
		this.callParent(arguments);
	}
});