Ext.Loader.setConfig({
	enabled : true,	
	disableCaching: true,
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
		//'dashboard'	: ''+ base_url +'asset/js/content/dashboard',
		'measurement'	: ''+ base_url +'asset/js/content/measurement',
		'msdisaster'	: ''+ base_url +'asset/js/content/disaster',
		//'simpel'			: ''+ base_url +'asset/js/content/simpel'
		'siangsa'			: ''+ base_url +'asset/js/content/siangsa'
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
                }
            } else {
            }
        },
		 beforeload: function(store, operation, options){
			
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
		'Ext.ux.exporter.Exporter',
		//'Ext.ux.exporter.RowExpander'
		//'master.global.tableau'
	]);
	
	
	var model = new Array();
	//var singleton;
	var abs;
	var model = new Array();
	var pcolumns = new Array();
	var idmenu;
	var acc_group;
/* 	var storeSBU;
	var storeArea; */
	var storeex;
	var storeComboField;
	var specialparams;
	var storeGridCopy;
	var win;
	var required;
	var gridreject;
	var returnsave;
	var filterenc;
	var gridutama;
	var gstore;
	var vgrid;
	var winss_formklasifikasi;
	var perusahaan_id;
	var tinyCfg1;
	var tinyCfg2;
	var winss_gridfklasifikasi;
	var winss_formupload;
	var winss_formuploadedit;
	var winss_formsuratkeluardetail;
	var winss_formuploadskdetail;
	var winss_uploadttd;
	var winss_adddivisi;
	var id_perusahaans;
	var winss_formtasksuratkeluardetails;
	var winss_formtaskpenerimadisposisi;
	var winss_formtasktembusan;
	var winss_formtasksuratmasukdetail;
	var winss_formtaskpenerimadisposisism;
	var winss_formtasktembusansm;
	var winss_formsuratmasukdetail;
	var winss_formpenerimadisposisism;
	var winss_formtembusansm;
	var winss_formuploadaddsm;
	var winss_gridfklasifikasiaddsm;
	var winss_formtembusan;
	var winss_formaddpesertadisposisi;
	var dispoid;
	var winss_tmpl_email;
	var winss_cancel;
	var winss_gridviewprogresdispo;
	var winss_formpermohonandetail;
	var winss_formpermohonandetailcreator;
	var winss_formrevisi;
	var winss_formgridtambahan;
	var winss_formeditgridtambahancreator;
	var winss_form;
	
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
			//singleton: true,
			abs,
			cp: 0,
			model,
			pcolumns,
			idmenu : 0,
			acc_group,
/* 			storeSBU;
			storeArea; */
			storeex,
			storeGridCopy,
			storeComboField,
			specialparams,
			win,
			required,
			returnsave,
			filterenc,
			gridutama : 0,
			gstore,
			vgrid,
			winss_formklasifikasi,
			perusahaan_id : '0',
			tinyCfg1,
			tinyCfg2,
			winss_gridfklasifikasi,
			winss_formupload,
			winss_formuploadedit,
			winss_formuploadskdetail,
			winss_formsuratkeluardetail,
			winss_uploadttd,
			winss_adddivisi,
			id_perusahaans,
			winss_formtasksuratkeluardetails,
			winss_formtaskpenerimadisposisi,
			winss_formtasktembusan,
			winss_formtasksuratmasukdetail,
			winss_formtaskpenerimadisposisism,
			winss_formtasktembusansm,
			winss_formsuratmasukdetail,
			winss_formpenerimadisposisism,
			winss_formtembusansm,
			winss_formuploadaddsm,
			winss_gridfklasifikasiaddsm,
			winss_formtembusan,
			winss_formaddpesertadisposisi,
			dispoid,
			winss_tmpl_email,
			winss_cancel,
			winss_gridviewprogresdispo,
			winss_formpermohonandetail,
			winss_formpermohonandetailcreator,
			winss_formeditgridtambahancreator,
			winss_form
		});
		Init.existtabreject = false;
		
		var data,valtaksasi;
		var geteventmenu 		= Ext.create('master.store.eventmenu');
		
		
		Init.required 		= '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
		
		//Init.storeSBU = Ext.create('mapping.store.sbu');
		//Init.storeArea = Ext.create('mapping.store.area');
		
		
		var msclass 				= Ext.create('master.global.geteventmenu');
		//var model_assettype 		= msclass.getmodel('ms_assettype');
		//var filter 		= [];
		//Init.jenis_pelanggan 		= msclass.getstore(model_assettype,'ms_assettype',filter);
		
		//var monitor_amr = Ext.create('monitoring.view.Dashgridareavalidasi');
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
				Ext.getCmp("application").update("SIANGSA - PGASCOM &copy; Copyright 2018")
				Ext.getCmp("developed").update("Developed By");
				Ext.getCmp("company").update("BUSSOL PGASCOM");

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
						}
				},{
					  text: 'Delete Menu',
					  iconCls : 'table_delete',
					  handler: function() {
									  
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
	
		
	
	
	 
		var accordions =  Ext.create('Ext.panel.Panel', {
				width: 230,
				id		: 'accordionMenu',
				layout:{
					type: 'accordion',
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
						//iconCls : 'user_suit',
						//xtype: 'tbtext',					
						text: '<div><img src = "'+base_url+'asset/icons/user.png">&nbsp;&nbsp;'+' Logged in as '+ nama_karyawan +'</div>',
						menu		: [
							{
								xtype: 'button',
								//style : { border : 'solid 1px #ff0000'},
								text: 'Change Password',						
								iconCls: 'key',
								handler: function(){
								//document.location.href = base_url+'admin/logout';
									Ext.Msg.show({
										//title:'Save Changes?',
										msg: 'Please Wait',
										wait	: true,
										buttons: Ext.Msg.INFO,
										//waitConfig: {interval:200},
										icon: Ext.Msg.QUESTION
									});
									var url	= base_url+'asset/js/content/masterdata/view/form_password.js';
									var onload	= function()
									{
										apps('My Profile','page');
									}
									Ext.Loader.injectScriptElement(url,onload,'','');
									//Ext.Msg.hide();
									setTimeout(function(){
										Ext.Msg.hide();
										//Ext.example.msg('Done', 'data saved!');
									}, 1000);
								}
							}
						]
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
							Ext.destroy(this.getEl().child('.' +this.baseCls+'-bl'));
						}						
					},
					{
						xtype: 'tbseparator'
					},
					{
						xtype: 'button',
						//style : { border : 'solid 1px #ff0000'},
						text: 'Help',						
						iconCls: 'help',
						handler	: function()
						{
									var url = base_url+"asset/manual_book/ManualBookBast.rar";
									window.open(url); 							
							
						}
					}]
			});
	
		var msclass = Ext.create('master.global.geteventmenu'); 
			//var tiketnumber2 = msclass.getticket();
			var date = new Date();
			var firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
			var lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);
			
			var day = date.getDate();
			var monthIndex = date.getMonth();
			var year = date.getFullYear();
		
		
		
		
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
								layout		: 'fit',
								items :[
								{
									xtype:'image',
									src: base_url+'asset/image/bisnis proses bast.JPG',
									width: 700,
									height: 20
								}]
						}]
					}]
			});
			
			var viz = Ext.getCmp('tableauviz');
			var me = this;
			//viz.refreshDataAsync();
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
										
									}
								} 

							});  
					
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
				
		
				Ext.getCmp("west-panel").add(itemAccordions);
				Ext.getCmp("west-panel").doLayout();
				
			});
       
	});