Ext.Loader.setConfig({
	enabled : true,	
	paths: {
		'Ext.ux'    : ''+base_url+'asset/ext/src/ux',
		'EM'    	: ''+base_url+'asset/js/content/',
		'analisa'	: '' + base_url + 'asset/js/content/analisa',
		'master' 	: '' + base_url + 'asset/js/content/master',
		'mapping'	: '' + base_url + 'asset/js/content/mapping',
		'setting'	: '' + base_url + 'asset/js/content/setting',
		'tools'		: '' + base_url + 'asset/js/content/tools'
	}
					
});
Ext.require([
		'Ext.window.Window',
		//'Ext.tab.*',
		'Ext.form.Panel',
		'Ext.grid.Panel',
		'Ext.layout.container.Column',
		'Ext.tab.Panel',
		'Ext.ux.grid.FiltersFeature',
		'Ext.ux.exporter.Exporter'
		
    
	]);
var abs;
var model = new Array();
var pcolumns = new Array();
var idmenu;
var acc_group;
var storeSBU;
var storeArea;

Ext.onReady(function() {
		Ext.define('Init', {
			singleton: true,
			cp: 0,
			model,
			pcolumns,
			idmenu : 0,
			acc_group,
			storeSBU,
			storeArea			
		});
		var geteventmenu 	= Ext.create('master.store.eventmenu');
		
		Init.storeSBU = Ext.create('mapping.store.sbu');
		Init.storeArea = Ext.create('mapping.store.area');

		Ext.QuickTips.init();

		Ext.state.Manager.setProvider(Ext.create('Ext.state.CookieProvider'));
		Ext.define('model_menus',{
				extend	: 'Ext.data.Model',
				fields	: ['id','text','act','parent','iconCls','path']
			});
		var datarecord;
		var taskbbar = {
			run: function(){
				Ext.getCmp("dateStatus").update(Ext.Date.format(new Date(), 'd-m-Y'));
				Ext.getCmp("timeStatus").update(Ext.Date.format(new Date(), 'G:i:s'));
				Ext.getCmp("application").update("SIPGAS EM &copy; Copyright 2016");
				Ext.getCmp("developed").update("Developed By");
				Ext.getCmp("company").update("PGN COM");

			},
			interval: 1000 //1 second
		}
		var runner = new Ext.util.TaskRunner();
		runner.start(taskbbar);
		
		var kanan_menu = new Ext.menu.Menu({
			items: [{
				text	: 'Add Menu',
				iconCls : 'table_add',
					handler: function() {
						// console.log(datarecord.id);
						}
				},/* {
					  text: 'Edit Menu',
					  iconCls : 'table_edit',
					  handler: function() {
						  alert('Edit Menu');
					  }
				}, */{
					  text: 'Delete Menu',
					  iconCls : 'table_delete',
					  handler: function() {
						  // alert(datarecord.id);					  
					  }
				  }]
			  });
	
		var storeAccordion = Ext.create('Ext.data.JsonStore',{
				model	: 'model_menus',
				storeId	: 'storeAccordion',
				proxy	: {
					type: 'pgascomProxy',
					url: base_url+'admin/showmenu?node=root',
					reader: {
						type: 'json',
						root: 'data'
					}
				}
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
	
		storeAccordion.load(function(records){
				var itemAccordions = [];
				//var storeAcc = "storeMenu";
				//console.log(records);
		
				Ext.each(records, function(record){
						//console.log(record.data.text);
			
						window['StoreMenu'+record.data.id] = Ext.create('Ext.data.TreeStore',{
								model	: 'model_menus',
								proxy: {
									type: 'pgascomProxy',
									url: base_url+'admin/showmenutree?accp='+record.data.id,
									reader: {
										type: 'json',
										root: 'data'
									},
									node: 'id',
									//expanded: true,
									folderSort: true
								}
							});
			
						window['treemenu'+record.data.id] = Ext.create('Ext.tree.Panel', {
								id				: 'tree'+record.data.id,
								ideCollapseTool	: false,
								animCollapse	: true,
								animate 		: true,
								autoScroll		: true,
								lines 			: true,
								border			: false,
								store			: window['StoreMenu'+record.data.id],
								rootVisible: false,
								//useArrows	: true,
								items : [
									{
										xtype: 'treecolumn',
										dataIndex: 'text'
									}],
								listeners	: {
									
									beforeitemcontextmenu: function(view, record, item, index, e)
									{
										//alert(record.data.id);
										datarecord = record.data;
										e.stopEvent();
										kanan_menu.showAt(e.getXY());
									},								
									itemclick	: function(s,r)
									{
										//console.log(r.data);
										var url	= ''+base_url+r.data.path+'';
										
										var iconCls = r.data.iconCls;
										var name = r.data.act;
										
										//var url = ''+base_url+''+r.data.path;
										/*
										var onload	= function()
										{
											apps(r.data.id,iconCls);
										}
										Ext.Loader.injectScriptElement(url,onload, "", "");
										*/
										
										Ext.Ajax.request({ 
											url: base_url+'admin/main',
											method: 'POST',
											params: {
												"id"	: r.data.id
											},
											success: function(response,requst){
												var data = response.responseText;
												// console.log(data);
												eval(data);
												//console.log(data);
												apps(r.data.id,iconCls);
												Init.idmenu = r.data.id;
											},
											failure:function(response,requst)
											{
												Ext.Msg.alert('Fail !','Input Data Entry Gagal');
												Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");
											}
											
														
										})
										
										//var onload	= function()
										//{
											//apps(r.data.act,r.data.iconCls);
										//}
										//Ext.Loader.injectScriptElement(url, onload, "", "");
										//window[r.data.act](r.data.iconCls);
									}
								} 

							});  
						//window['treemenu'+record.data.id].load();
						itemAccordions.push({
								title	: record.data.text,
								iconCls : record.data.iconCls,
								xtype	: 'panel',
								id		: "accordion-"+record.data.id,
								items	: [{
										xtype	: 'panel',
										id		: 'treeMenu'+record.data.id,
										//bodyPadding	: 5,
										border	: false,
										items	: window['treemenu'+record.data.id]		
									}]
							});
			
					});
				//console.log(StoreMenu1);
		
				Ext.getCmp("west-panel").add(itemAccordions);
				Ext.getCmp("west-panel").doLayout();
				//Ext.getCmp("accordionMenu").insert(itemAccordions);
			});
	
	
	 
		var accordions =  Ext.create('Ext.panel.Panel', {
				width: 230,
				id		: 'accordionMenu',
				layout:{
					type: 'accordion',
					//hideCollapseTool : false,
					//titleCollapse: false,
					animate: true,
					activeOnTop: true
				}
			});
	
		var tbar_logout = Ext.create('Ext.toolbar.Toolbar', {
				//style: 'margin: 2px 10px; color: #ff0000;',
				border : false,
				items : [
					{
						xtype: 'tbfill'
					},
					{
						iconCls : 'user_suit',
						xtype: 'tbtext',					
						text: '<div><img src = "'+base_url+'asset/icons/user.png">&nbsp;&nbsp;'+' Logged in as '+ nama_karyawan +'</div>'
					},	
					{
						xtype: 'tbseparator'
					},
					{
						xtype: 'button',
						//style : { border : 'solid 1px #ff0000'},
						text: 'Logout',						
						iconCls: 'door_out',
						handler: function(){
							document.location.href = base_url+'admin/logout';
						}
						
					}
				]

			});
	
	
		var viewport = Ext.create('Ext.Viewport', {
				id: 'border-example',
				layout: 'border',
				items: [
					// create instance immediately
					Ext.create('Ext.container.Container', {
							region: 'north',
							height: 30,
							items:[tbar_logout]
						}), 
					{
						region: 'west',
						stateId: 'navigation-panel',
						iconCls: 'sitemap_color',
						id: 'west-panel', 
						title: 'Menu Navigator',
						split: true,
						width: 200,
						minWidth: 175,
						maxWidth: 400,
						collapsible: true,
						animCollapse: true,
						margins: '0 0 0 5',
						layout: 'accordion'
						//items: [accordions]
					},				
					{	                
						region: 'south',
						border:false,
						bbar    : [
							'->',
							{
								id : 'application', 								
								disabled    : true,
								style       :'color:blue'
							},
							'-',
							{
								id : 'developed', 
								
								disabled    : true,
								style       :'color:blue'
							},
							{
								id : 'company',  
								
								disabled    : true,
								style       :'color:blue'
							},
							'-',
							{
								id          : 'dateStatus',
								text        : '01-01-1970',
								disabled    : true,
								style       :'color:blue',
				            
							},
							'-',
							{
								id          : 'timeStatus',
								disabled    : true,
								text        : 'xxxxxx',
								style       :'color:blue',
				            
							}
						],
					}, 				
					{
						region		: 'center',
						xtype		: 'tabpanel',
						id			: 'contentcenter',
						activeTab	: 0,
						fit		: true,
						split	: true,
						bodyPadding	: '5',
						items		: [{
								xtype		: 'panel',
								title		: 'Home',
								iconCls		: 'house',
								layout		: 'border',
								items		: [{
										region: 'north',
										collapsible: false,
										split: true,
										height: 300,
										minHeight: 120,
										//title: 'South',
										layout: {
											type: 'border',
											padding: 5
										},
									 items: [{
											//title: 'South Central',
											region: 'center',
											minWidth: 80,
											flex	: 1,
											contentEl : 'pageHome',
											//html: 'South Central'
										}, {
											//title: 'South Eastern',
											region: 'east',
											flex: 1,
											minWidth: 80,
											//html: 'South Eastern',
											split: true,
											title	: 'Monitoring UAG Harian',
											collapsible: false
										}]
								},
								{
									region	: 'west',
									title: 'Bulk Customer Monitoring',
									//region:'west',
									xtype: 'panel',
									margins: '5 0 0 5',
									flex		: 1,
									//width: 200,
									collapsible: false,   // make collapsible
									id: 'west-region-container',
									layout: 'fit'
								},
								{
									region	: 'center',
									title: 'AMR Customer Monitoring',
									//region:'west',
									xtype: 'panel',
									margins: '5 0 0 5',
									flex		: 1,
									collapsible: false,   // make collapsible
									id: 'center',
									layout: 'fit'
								}]
						
							}]
					}]
			});
       
	});