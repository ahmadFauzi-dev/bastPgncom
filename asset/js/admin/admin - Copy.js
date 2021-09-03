Ext.Loader.setConfig({
	enabled : true,	
	paths: {
		'Ext.ux'    : ''+base_url+'asset/ext/src/ux',
		'EM'    	: ''+base_url+'asset/js/content/',
		'analisa'	: '' + base_url + 'asset/js/content/analisa',
		'master' 	: '' + base_url + 'asset/js/content/master',
		'masterdata' 	: '' + base_url + 'asset/js/content/masterdata',
		'mapping'	: '' + base_url + 'asset/js/content/mapping',
		'setting'	: '' + base_url + 'asset/js/content/setting',
		'tools'		: '' + base_url + 'asset/js/content/tools',
		'monitoring' : '' + base_url + 'asset/js/content/monitoring',
		
	}

});

	Ext.define('Ext.form.field.Month', {
        extend: 'Ext.form.field.Date',
        alias: 'widget.monthfield',
        requires: ['Ext.picker.Month'],
        alternateClassName: ['Ext.form.MonthField', 'Ext.form.Month'],
        selectMonth: null,
        createPicker: function () {
            var me = this,
                format = Ext.String.format;
            return Ext.create('Ext.picker.Month', {
                pickerField: me,
                ownerCt: me.ownerCt,
                renderTo: document.body,
                floating: true,
                hidden: true,
                focusOnShow: true,
                minDate: me.minValue,
                maxDate: me.maxValue,
                disabledDatesRE: me.disabledDatesRE,
                disabledDatesText: me.disabledDatesText,
                disabledDays: me.disabledDays,
                disabledDaysText: me.disabledDaysText,
                format: me.format,
                showToday: me.showToday,
                startDay: me.startDay,
                minText: format(me.minText, me.formatDate(me.minValue)),
                maxText: format(me.maxText, me.formatDate(me.maxValue)),
                listeners: {
                    select: { scope: me, fn: me.onSelect },
                    monthdblclick: { scope: me, fn: me.onOKClick },
                    yeardblclick: { scope: me, fn: me.onOKClick },
                    OkClick: { scope: me, fn: me.onOKClick },
                    CancelClick: { scope: me, fn: me.onCancelClick }
                },
                keyNavConfig: {
                    esc: function () {
                        me.collapse();
                    }
                }
            });
        },
        onCancelClick: function () {
            var me = this;
            me.selectMonth = null;
            me.collapse();
        },
        onOKClick: function () {
            var me = this;
            if (me.selectMonth) {
                me.setValue(me.selectMonth);
                me.fireEvent('select', me, me.selectMonth);
            }
            me.collapse();
        },
        onSelect: function (m, d) {
            var me = this;
            me.selectMonth = new Date((d[0] + 1) + '/1/' + d[1]);
        }
    });	

Ext.define('EM.data.proxy', {
    extend: 'Ext.data.proxy.Ajax',
    alias: 'proxy.pgascomProxy',
	loadMask : true,
    listeners: {
        exception: function (proxy, request) {
            if (request.responseText != undefined) {
                responseObj = Ext.decode(request.responseText,true);
                if (responseObj != null && responseObj.message != undefined) {
					Ext.Msg.show({
						title: 'Error (' + responseObj.code + ')',
						msg: responseObj.message,
						buttons: Ext.Msg.OK,
						icon: Ext.Msg.ERROR,
						fn: function() {          
							if (responseObj.code == 401) document.location.href = 'admin/logout';
						}
					});
                } else {
                    // Ext.Msg.alert('Error', 'Unknown error: The server did not send any information about the error.');
                }
            } else {
                // Ext.Msg.alert('Error', 'Unknown error: Unable to understand the response from the server');
            }
        },
		 beforeload: function(store, operation, options){
			console.log("OK");
			/*
			console.log( 'manual load ' + operation.params );
			console.log( operation.params );
			console.log( 'proxy defined params ' + store.proxy.extraParams );
			console.log( store.proxy.extraParams )
			*/
		}
    }
});

Ext.require([
		'Ext.window.Window',
		'Ext.LoadMask',	
		//'Ext.window.MessageBox',
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
var storeex;
var storeComboField;
var specialparams;
var storeGridCopy;
var win;
var required;
var gridreject;
var returnsave;
var filterenc;
var gridgaskomphourly;
var gridrejectgaskomp;
var gridgaskomp;
var griddetailmessage;
var gridutama;
var gridunapprove;
var gstore;
var taksasi;
var koreksi;
var existtabreject;
Ext.onReady(function() {
	var myMask = new Ext.LoadMask(Ext.getBody(), {msg:"Please wait..."});
		
	Ext.Ajax.on("beforerequest", function(){
       Ext.Msg.show({
											//title:'Save Changes?',
											msg: 'Please Wait',
											wait	: true,
											buttons: Ext.Msg.INFO,
											//waitConfig: {interval:200},
											icon: Ext.Msg.INFO
		});
	});	
	Ext.Ajax.on("requestcomplete", function(){
        Ext.Msg.hide();
		//Ext.Msg.alert('Success','Transaksi Sukses');
    });
	
	
	
	Ext.Ajax.timeout = 300000 ;
	Ext.override(Ext.form.Basic, {     timeout: Ext.Ajax.timeout / 1000 });
	Ext.override(Ext.data.proxy.Server, {     timeout: Ext.Ajax.timeout });
	Ext.override(Ext.data.Connection, {     timeout: Ext.Ajax.timeout });
	
		Ext.define('Init', {
			singleton: true,
			cp: 0,
			model,
			pcolumns,
			idmenu : 0,
			acc_group,
			storeSBU,
			storeArea,
			storeex,
			storeGridCopy,
			storeComboField,
			specialparams,
			win,
			required,
			gridreject,
			returnsave,
			filterenc,
			gridgaskomphourly,
			gridrejectgaskomp,
			gridgaskomp,
			griddetailmessage,
			gridutama : 0,
			gridunapprove,
			gstore,
			taksasi,
			koreksi,
			existtabreject
		});
		Init.existtabreject = false;
		var url = base_url+"admin/master/cekvalidasi";
		var data,valtaksasi;
		//var taksasi, koreksi,valtaksasi;
		//console.log(params);
		//var url = base_url+'admin/mapping/exportdatadyn';
		//this.savedata(params,url);
		
		
		
		var geteventmenu 		= Ext.create('master.store.eventmenu');
		Init.gridreject 		= Ext.create('analisa.bulk.view.gridrejectanomali');
		Init.gridunapprove 		= Ext.create('analisa.bulk.view.rejectbulk');
		Init.gridgaskomphourly 	= Ext.create('analisa.offtake.view_gaskomp.gridhourly');
		Init.gridrejectgaskomp  = Ext.create('analisa.offtake.view_gaskomp.gridrejectgaskomp');
		Init.gridgaskomp		= Ext.create('analisa.offtake.view_gaskomp.grid');
		Init.griddetailmessage	= Ext.create('analisa.offtake.view.griddetailmessage');
		
		
		Init.required 		= '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
		
		Init.storeSBU = Ext.create('mapping.store.sbu');
		Init.storeArea = Ext.create('mapping.store.area');
		

		var monitor_amr = Ext.create('monitoring.view.Dashgridareavalidasi');
		Ext.QuickTips.init();

		Ext.state.Manager.setProvider(Ext.create('Ext.state.CookieProvider'));
		Ext.define('model_menus',{
				extend	: 'Ext.data.Model',
				fields	: ['id','text','act','parent','iconCls','path']
			});
		var datarecord;
		var taskbbar = {
			run: function(){
				var lari = 				
				Ext.getCmp("dateStatus").update(Ext.Date.format(new Date(), 'd-m-Y'));
				Ext.getCmp("timeStatus").update(Ext.Date.format(new Date(), 'G:i'));
				Ext.getCmp("application").update("SIPGAS EM &copy; Copyright 2016");
				Ext.getCmp("developed").update("Developed By");
				Ext.getCmp("company").update("PGN COM");

			},
			interval: 10000 //1 menit
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
										//console.log(r.data);
										
										var iconCls = r.data.iconCls;
										var name = r.data.text;
										delete Init.idmenu;
										
										Init.idmenu = r.data.id;
										//var url = ''+base_url+''+r.data.path;
										//var myMask = new Ext.LoadMask(Ext.getCmp('contentcenter'), {msg:"Please wait..."});
										//myMask.show();
										
										Ext.Msg.show({
											//title:'Save Changes?',
											msg: 'Please Wait',
											wait	: true,
											buttons: Ext.Msg.INFO,
											//waitConfig: {interval:200},
											icon: Ext.Msg.QUESTION
										});
										
										var onload	= function()
										{
											apps(name,iconCls);
										}
										Ext.Loader.injectScriptElement(url,onload, "", "");
										//Ext.Msg.hide();
										setTimeout(function(){
											Ext.Msg.hide();
											//Ext.example.msg('Done', 'data saved!');
										}, 1000);
										
										//Ext.Msg.close();
										/*
										Ext.Ajax.request({ 
											url: base_url+'admin/main',
											method: 'POST',
											params: {
												"id"	: r.data.id
											},
											success: function(response,requst){
												var data = response.responseText;
												Init.idmenu = r.data.id;
												// console.log(data);
												eval(data);
												//console.log(data);
												apps(r.data.text,iconCls);
												
											},
											failure:function(response,requst)
											{
												Ext.Msg.alert('Fail !','Input Data Entry Gagal');
												Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");
											}
											
														
										})
										*/
										
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
					'->',
					{
						xtype	: 'button',
						iconCls	: 'exclamation',
						id		: 'taksasibutton',
						text	: Init.taksasi,
						tooltip : 'Taksasi dan Koreksi',     
						menu	: {
							items	: [{
								text	: 'Taksasi AMR',
								iconCls	: 'information',
								id		: 'taksbutton',
								handler	: function()
								{
									var url 	= 'asset/js/content/analisa/taksasiamr.js';
									var iconCls = 'application_view_gallery';
									var name 	= 'Taksasi';
									
									var onload	= function()
									{
										apps(name,iconCls);
									}
									Ext.Loader.injectScriptElement(url,onload, "", "");
									//Ext.Msg.hide();
									setTimeout(function(){
										Ext.Msg.hide();
										//Ext.example.msg('Done', 'data saved!');
									}, 1000);
								}
							},{
								text	: 'Koreksi',
								iconCls	: 'information',
								id		: 'korbutton',
								handler	: function()
								{
									
									var url 	= 'asset/js/content/analisa/koreksiamr.js';
									var iconCls = 'application_view_gallery';
									var name 	= 'koreksi';
									var onload	= function()
									{
										apps(name,iconCls);
									}
									Ext.Loader.injectScriptElement(url,onload, "", "");
									//Ext.Msg.hide();
									setTimeout(function(){
										Ext.Msg.hide();
										//Ext.example.msg('Done', 'data saved!');
									}, 1000);
								}
							}]
						}
					},
					{
						xtype		: 'button',
						iconCls 	: 'help',											
						text		: 'Help',
						tooltip     : 'Manual Book', 
						menu 	: {
							items	: [{
								text	: 'BULK CUSTOMER',
								iconCls : 'help',
								handler	: function()
								{
									window.open(base_url+"manual/BULK CUSTOMER.pdf","_blank");
								}
							},
							{
								text	: 'MAPPING DATA',
								iconCls : 'help',
								handler	: function()
								{
									window.open(base_url+"manual/MAPPING DATA.pdf","_blank");
								}
							},
							{
								text	: 'MASTER DATA',
								iconCls : 'help',
								handler	: function()
								{
									window.open(base_url+"manual/MASTER DATA.pdf","_blank");
								}
							},
							{
								text	: 'PENYALURAN STATION',
								iconCls : 'help',
								handler	: function()
								{
									window.open(base_url+"manual/PENYALURAN STATION.pdf","_blank");
								}
							},
							{
								text	: 'RETAIL CUSTOMER', 
								iconCls : 'help',
								handler	: function()
								{
									window.open(base_url+"manual/RETAIL CUSTOMER.pdf","_blank");
								}
							},
							{
								text	: 'SETTING CONFIGURATION',
								iconCls : 'help',
								handler	: function()
								{
									window.open(base_url+"manual/SETTING CONFIGURATION'.pdf","_blank");
								}
							}						
							]
						}
					},					
										
					{
						xtype: 'tbseparator'
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
			
		var runtaksi = {
			run: function(){
				
				Ext.define('myAjax', {
					extend: 'Ext.data.Connection',
					singleton: true,
					constructor : function(config){
						this.callParent([config]);
						this.on("beforerequest", function(){
							//console.info("beforerequest");
						});
						this.on("requestcomplete", function(){
							//console.info("requestcomplete");
						});
					}
				});
				myAjax.request({
					url: url,
					method: 'POST',
					before	: function()
					{
						console.log("OKOK");
						Ext.Msg.hide();
					},
					//params: params,
					success: function(response,requst){
						//console.log(Ext.decode(response.responseText));
						valtaksasi = Ext.decode(response.responseText);
						//Ext.Msg.hide();
						Ext.getCmp('taksasibutton').setText(parseInt(valtaksasi[0].total) + parseInt(valtaksasi[1].total));
						Ext.getCmp('taksbutton').setText("Taksasi <b>"+parseInt(valtaksasi[1].total));
						Ext.getCmp('korbutton').setText("Koreksi <b>"+parseInt(valtaksasi[0].total));
					},
					failure:function(response,requst)
					{
						//Ext.Msg.alert('Fail !','Input Data Entry Gagal');
						Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + response.responseText + "");
						return false;
					}
				});
				
			},
			interval: 1000*60*30 //1 menit
		}
		var runners = new Ext.util.TaskRunner();
		runners.start(runtaksi);	
	
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
									layout: 'fit',
									items : monitor_amr
								}]
						
							}]
					}]
			});
       
	});