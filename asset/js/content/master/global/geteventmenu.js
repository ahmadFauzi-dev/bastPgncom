Ext.define('master.global.geteventmenu', {
    name	: 'geteventmenu',
    constructor: function(name) {
        if (name) {
            this.name = name;
        }
    },
    getevent: function(idmenu) {
		var dataeent = '';
		var myValue;
		   Ext.Ajax.request({ 			url			: base_url+'admin/settings/showeventmenustat',			method		: 'POST',			async		: false,			params		: {id :idmenu },			success: function(response,requst){				role_event = response.responseText;				myValue	   = Ext.decode(response.responseText);			},			failure:function(response,requst)			{
				Ext.Msg.alert('Fail !','Input Data Entry Gagal');				Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");			}							});		return myValue;	},
	getticket	: function()
	{
		var dataeent = '';
		var myValue;
		
		 Ext.Ajax.request({ 		url			: base_url+'admin/settings/getticket2',		method		: 'POST',		async		: false,		success: function(response,requst){			role_event = response.responseText;			myValue	   = response.responseText;		},		failure:function(response,requst)		{
			Ext.Msg.alert('Fail !','Input Data Entry Gagal');			Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");		}						});
		return myValue;	
	},
	getmodelquery	: function(view)
	{
		 Ext.Ajax.request({ 				url			: base_url+'admin/settings/getmodelquery',				method		: 'POST',				async		: false,				params		: {view :view },				success: function(response,requst){					Init.model = Ext.decode(response.responseText);				},				failure:function(response,requst)				{					Init.model = response.responseText;				}
		});
		return Init.model;
	},
	getmodel	: function(view)
	{
		Ext.Ajax.request({ 			url			: base_url+'admin/settings/getmodel',			method		: 'POST',			async		: false,			params		: {view :view },			success: function(response,requst){				Init.model = Ext.decode(response.responseText);			},			failure:function(response,requst)			{				Init.model = response.responseText;		}		});
		return Init.model;
	},
	getcolumn	: function(view,id_grid)
	{
		 Ext.Ajax.request({ 				url			: base_url+'admin/settings/getcolumn',				method		: 'POST',				async		: false,				params		: {view :view ,id_grid : id_grid},				success: function(response,requst){					Init.pcolumns = Ext.decode(response.responseText);				},				failure:function(response,requst)				{					Init.pcolumns = response.responseText;				}
		});
		//console.log(Init.pcolumns);
		return Init.pcolumns;
	},
	getcolumngrid	: function(id_grid,view)
	{
		 Ext.Ajax.request({ 			url			: base_url+'admin/settings/getcolumn',			method		: 'POST',			async		: false,			params		: {view :view,id_grid : id_grid },			success: function(response,requst){				Init.pcolumns = Ext.decode(response.responseText);			},			failure:function(response,requst)			{				Init.pcolumns = response.responseText;			}
		});
		//console.log(Init.pcolumns);
		return Init.pcolumns;
	},
	getcolumnquerygrid	: function(id_grid,view)
	{
		 Ext.Ajax.request({ 				url			: base_url+'admin/settings/getcolumnquery',				method		: 'POST',				async		: false,				params		: {view :view },				success: function(response,requst){					Init.pcolumns = Ext.decode(response.responseText);					//role_event = response.responseText;					//myValue	   = Ext.decode(response.responseText);					//myValue = response.responseText;				},				failure:function(response,requst)				{					Init.pcolumns = response.responseText;					//Ext.Msg.alert('Fail !','Input Data Entry Gagal');					//Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");				}
		});
		return Init.pcolumns;
	},
	getstorequery	: function(model,view)
	{
		var d = new Date();
		var n = d.getTime();
		
		var store = Ext.create('Ext.data.JsonStore',{				fields 		: model,				remoteSort  : true,				storeId		: n,				proxy: {					type: 'pgascomProxy',								url: base_url+'admin/master/getloaddataquery',					extraParams : {						view 	: view					},					reader: {						type: 'json',										root: 'data'					}							}
		});	
		return store;
	},
	getstore	: function(model,view,filter)
	{
		var d = new Date();
		var n = d.getTime();		
		var store = Ext.create('Ext.data.JsonStore',{				fields 		: model,				remoteSort  : true,				storeId		: n,				proxy: {					type: 'pgascomProxy',								url: base_url+'admin/master/getloaddata',					extraParams : {						filter  : filter,						view 	: view					},					reader: {						type: 'json',										root: 'data'					}							}
		});	
		return store;
	},		getstoretree	: function(model,view,filter)
	{
		var d = new Date();
		var n = d.getTime();		
		var store = Ext.create('Ext.data.TreeStore',{				fields 		: model,				remoteSort  : true,				storeId		: n,				proxy: {					type: 'pgascomProxy',								url: base_url+'admin/treegrid_data',					extraParams : {						filter  : filter,						view 	: view					},					reader: {						type: 'json',										root: 'data'					},					node:'id'									}
		});	
		return store;
	},
	getgrid	: function(pview,id_grid,itemdocktop)
	{
		var model_data = this.getmodel(pview);
		model_data.push('selectopts');
		var pstore = this.getstore(model_data,pview,[]).load();	
		pstore.load();		
		var rgrid = Ext.create('Ext.grid.Panel',{				store		: pstore,				multiSelect	: true,				id			: id_grid,				selType		: 'checkboxmodel',				selModel: {						injectCheckbox: 0,						pruneRemoved: false,						showHeaderCheckbox: true				},				columns		: this.getcolumngrid(id_grid,pview),				//plugins	: editing,				bbar: Ext.create('Ext.PagingToolbar', {					store: pstore,					displayInfo: true				}),				listeners	: 				{					select: function (model, record, index, eOpts) {						record.set('selectopts',true);					},					deselect: function (view, record, item, index, e, eOpts) {						record.set('selectopts',false);					}				}
		});
		
		rgrid.addDocked({			xtype: 'toolbar',			dock: 'top',			items: itemdocktop		});		return rgrid;
	},
	submitreject		: function(url)
	{
		var storetosubmit = Init.storeGridCopy;
		var dataobj = [];
		var datasbumit;
		storetosubmit.each(function(record){			//console.log();			dataobj.push(record.data)
		});
		datasubmit = Ext.encode(dataobj);
		var params = {			datagrid	: datasubmit
		}
		this.savedata(params,url);
		var name = ''+Init.idmenu+'tabreject';
		var tabPanelas = Ext.getCmp('contentcenter');
		var items = tabPanelas.items.items;
		var exist = false;
		for(var i = 0; i < items.length; i++)
		{			tabPanelas.remove(name);
		}
		//console.log(datasubmit);
	},
	showWindowEmailForm : function(url)
	{		
		/*
		if (!Init.win) {
            var form = Ext.widget('form', {
                layout: {
                    type: 'vbox',
                    align: 'stretch'
                },
                border: false,
                bodyPadding: 10,
                fieldDefaults: {
                    labelAlign: 'top',
                    labelWidth: 100,
                    labelStyle: 'font-weight:bold'
                },
                items: [{
                    xtype: 'textfield',
                    fieldLabel: 'Email Address',
                    afterLabelTextTpl: Init.required,
                    vtype: 'email',					name : 'toemail',
                    allowBlank: false
                }, 				{
                    xtype: 'textfield',
                    fieldLabel: 'Subject',					name : 'subject',
                    afterLabelTextTpl: Init.required,
                    allowBlank: false
                }, {
                    xtype: 'htmleditor',
                    fieldLabel: 'Message',
                    labelAlign: 'top',							name : 'message',
                    flex: 1,
                    margins: '0',
                    afterLabelTextTpl: Init.required,
                    allowBlank: false
                }],

                buttons: [{
                    text: 'Cancel',
                    handler: function() {
                        this.up('form').getForm().reset();
                        this.up('window').hide();
                    }
                }, {
                    text: 'Send',
                    handler: function() {
                        //var oksparams = findform.getValues();			if (this.up('form').getForm().isValid()) {
                            // In a real application, this would submit the form to the configured url
                            var storetosubmit = Init.storeGridCopy;				var dataobj = [];				var datasbumit;				storetosubmit.each(function(record){					//console.log();					dataobj.push(record.data)				});				datasubmit = Ext.encode(dataobj);				//console.log(datasubmit);								this.up('form').getForm().submit(				{					params: {						datagrid : datasubmit 					},					clientValidation	: true,									url					: url,					success: function(form, action) {						var result = action.result;						win.hide();												var name = ''+Init.idmenu+'tabreject';						var tabPanelas = Ext.getCmp('contentcenter');						var items = tabPanelas.items.items;						var exist = false;						for(var i = 0; i < items.length; i++)						{							tabPanelas.remove(name);						}						// console.log(result);					},					failure: function(form, action) {						switch (action.failureType) {							case Ext.form.action.Action.CLIENT_INVALID:							Ext.Msg.alert('Failure', 'Form fields may not be submitted with invalid values');							break;							case Ext.form.action.Action.CONNECT_FAILURE:							Ext.Msg.alert('Failure', 'Ajax communication failed');							break;							case Ext.form.action.Action.SERVER_INVALID:							Ext.Msg.alert('Failure', action.result.msg);						}					}				});														// this.up('form').getForm().reset();
                            // this.up('window').hide();
                            // Ext.MessageBox.alert('Success', 'Email Telah di kirim!');
                        }
                    }
                }]
            });

            win = Ext.widget('window', {
                title: 'Kirim Email',
                closeAction: 'hide',
                width: 400,
               height: 400,
                minWidth: 300,
                minHeight: 300,
                layout: 'fit',
                resizable: true,
                modal: true,
                items: form,
                defaultFocus: 'Email Address'
            });
        }
        win.show();
		*/		
	},
	savedata	: function(params,url)
	{
		Ext.Ajax.request({	 			url: url,			method: 'POST',			params: params,			success: function(response,requst){								Ext.Msg.alert('Success','Transaksi Sukses');				var store = Ext.getCmp(params.id).getStore();				store.reload();			},			failure:function(response,requst)			{				Ext.Msg.alert('Fail !','Input Data Entry Gagal');				Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");				return false;			}
		});
		returnsave = false;
		return Init.returnsave;	},
	encodefilter : function(params,url_params = '')	{
		var url = base_url+"admin/master/encodeurl";
		var data;
		//console.log(params);
		//var url = base_url+'admin/mapping/exportdatadyn';
		//this.savedata(params,url);
		if(url_params == '')
		{			Ext.Ajax.request({	 									url: url,			method: 'POST',			params: params,			success: function(response,requst){				Init.filterenc = response.responseText;				window.location = base_url+'admin/mapping/exportdatadyn?search='+Init.filterenc+"&datainput="+params.datainput+"&view="+params.view+"&title="+params.title;							},			failure:function(response,requst)			{				Ext.Msg.alert('Fail !','Input Data Entry Gagal');				Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");				return false;			}											});
		}else
		{			Ext.Ajax.request({	 									url: url,			method: 'POST',			params: params,			success: function(response,requst){				Init.filterenc = response.responseText;				//window.location = "https://www.google.co.id/";				window.location = base_url+'admin/mapping/'+url_params+'?search='+Init.filterenc+"&view="+params.view+"&title="+params.title;				//data = Ext.decode(Init.filterenc)				//console.log(Ext.decode(Init.filterenc));			},			failure:function(response,requst)			{				Ext.Msg.alert('Fail !','Input Data Entry Gagal');				Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");				return false;			}											});
		}
		//this.encodefilter(params);
		//console.log(Ext.decode(Init.filterenc));
	},
	exportdata	: function(idgrid,view,url_params = '')
	{
		//console.log(view);
		//console.log(idgrid);
		var grid = Ext.getCmp(idgrid);
		var store = grid.getStore();
		var columns = grid.columns;
		var title 	= grid.title;
		var itemcolumns = [];
		var extraParams = store.proxy.extraParams;
		var n = 0;
		Ext.each(columns, function(data) {			//console.log(data.text);			if(data.text == "&#160;")			{				data.text = "Status Data";			}			if(data.hidden == false)			{				var data = {					"text"	: data.text,					"hidden"	: data.hidden,					"dataIndex"	: data.dataIndex,					"pos"		: n				}				itemcolumns.push(data);				n++;			}		});
		//console.log(Ext.encode(itemcolumns));
		if(typeof  view != 'undefined')
		{			//console.log("OKOK");			extraParams.view = view;
		}
		extraParams.datainput = Ext.encode(itemcolumns);
		extraParams.title 	  = title;
		//console.log(extraParams);
		this.encodefilter(extraParams,url_params);	},
		penyaluranhourly : function(data)
	{
		//console.log("oko");
		var gridhourly = Init.gridgaskomphourly;
		var storeHourlykelengkapan =  gridhourly.getStore();			
		storeHourlykelengkapan.getProxy().extraParams = {				view	: 'v_gaskomposisihourly',				"filter[0][field]" : "tanggal_pencatatan",				"filter[0][data][type]" : "timestamp",				"filter[0][data][comparison]" : "gt",				"filter[0][data][value]" : data.tanggal_pencatatan+" 00:00:00",				"filter[1][field]" : "tanggal_pencatatan",				"filter[1][data][type]" : "timestamp",				"filter[1][data][comparison]" : "lt",				"filter[1][data][value]" : data.tanggal_pencatatan+" 23:59:59",				"filter[2][field]" : "stationid",				"filter[2][data][type]" : "string",				"filter[2][data][comparison]" : "eq",				"filter[2][data][value]" : data.stationid
		};
		storeHourlykelengkapan.load();
		var name = 'Gas Komposisi Hourly';
		var tambahadd = Ext.create("Ext.tab.Panel",{
		title		: 'Penyaluran Hourly',
		id			: name,
		//xtype		: 'panel',
		iconCls		: 'application_cascade',
		closable	: true,
		//overflowY	: 'scroll',
		bodyPadding	: '5 5 0',
		items		: [{			xtype	: 'panel',			title  : name,			frame: true,				iconCls 	: 'application_view_gallery',			layout: 'border',			defaults: {				collapsible: true,				split: true,				//bodyStyle: 'padding:5px'			},			items	: [			{				layout	: 'border',				region  : 'center',				flex		: 3,				iconCls 	: 'application_view_gallery',				items	: [{					xtype 	: 'panel',					title	: 'Automatic',					layout	: 'fit',					region  : 'center',					frame	: true,					flex	: 3,					items	: Init.gridgaskomphourly				}]			},			{								layout		: 'border',				region 		: 'east',				flex		: 1,				items		: [				{					xtype 	: 'panel',					title	: 'Dokumen Pendukung',					layout	: 'fit',					region  : 'south',					frame	: true,					flex	: 2,					//items	: dokumenpendukunghourly				},{					xtype : 'panel',											region : 'center',					frame	: true,					border	: false,										title : 'Status Anomali',										layout: 'fit',										flex	: 3,					border: false,					//items	: griddetailmessage				}				]			}]			}]		});		var tabPanelas = Ext.getCmp('contentcenter');		var items = tabPanelas.items.items;		var exist = false;		for(var i = 0; i < items.length; i++)		{			if(items[i].id == name){					tabPanelas.setActiveTab(name);					tabPanelas.remove(name);					Ext.getCmp('contentcenter').add(tambahadd);					tabPanelas.setActiveTab(name);						exist = true;			}		}		if(!exist){			Ext.getCmp('contentcenter').add(tambahadd);			tabPanelas.setActiveTab(name);			}
	},
		deletedata	: function(params,tbl)
	{
		params.tbl = tbl
		this.savedata(params,base_url+'analisa/deletedata');
		var store = Ext.getCmp(params.id).getStore();
		store.reload();
	},
	updatedata	: function(params,tbl,url)
	{
		params.tbl = tbl
		this.savedata(params,url);
		var store = Ext.getCmp(params.id).getStore();
		store.reload();
	},
	formatDate : function(date) {
		var d = new Date(date),		month = '' + (d.getMonth() + 1),		day = '' + d.getDate(),		year = d.getFullYear();

		if (month.length < 2) month = '0' + month;
		if (day.length < 2) day = '0' + day;
		return [year, month, day].join('-');
	},		getlisfield	: function(pview,id_grid)
	{
		Init.vgrid = id_grid;
		Init.gstore = pview;
		var field = this.getcolumn(pview);
		var store = new Ext.data.SimpleStore({			fields: [				{name: 'dataIndex'},				{name: 'text'},				{name: 'hide'}			]
		});
		var editing = Ext.create('Ext.grid.plugin.RowEditing', {
		  clicksToEdit: 2,
		  listeners :			{									'edit' : function (editor,e) {						 						 var grid 	= e.grid;						 var record = e.record;						var recordData = record.data; 						//msclass.savedata(recordData,base_url+'admin/insertdatamanualbulk');						console.log(recordData);											}			}
		});
		store.loadData(field);
		var grid = new Ext.grid.GridPanel({				store: store,				plugins	: editing,				tbar		: [{					text	: 'Save',					iconCls	: 'page_white_excel',					handler		: function()					{						var items = [];						var n = 0;						store.each(function(record){ 							console.log(record.data.hide);								if(record.data.hide == '')								{									var data = {									cls	: 'header-cell',									dataIndex	: record.data.dataIndex,									text		: record.data.text,									//flex		: 1,									hidden		: false,									autoSizeColumn	: true									};								}								if(parseInt(record.data.hide) == 0)								{									var data = {									cls	: 'header-cell',									dataIndex	: record.data.dataIndex,									text		: record.data.text,									//flex		: 1,									hidden		: false,									autoSizeColumn	: true,									tdCls		:'wrap-text',																		};								}else								{									var data = {										cls	: 'header-cell',										dataIndex	: record.data.dataIndex,										text		: record.data.text,										//flex		: 1,										hidden		: true,										autoSizeColumn	: true									};								};																items.push(data);														n++;													});						var data_insert = Ext.encode(items);						var url = base_url+'admin/settings/savecolumn';												var params = {							columns	: data_insert,							id		: Init.vgrid,							view 	: Init.gstore						};												Ext.Ajax.request({	 							url: url,							method: 'POST',							params: params,							success: function(response,requst){																Ext.Msg.alert('Success','Transaksi Sukses');							},							failure:function(response,requst)							{								Ext.Msg.alert('Fail !','Input Data Entry Gagal');								Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");								return false;							}																		});					}				}],				columns: [					{						header: 'dataIndex',						flex	: 1,						dataIndex: 'dataIndex'					},					{						header		: 'Text'						,flex		: 1						, dataIndex	: 'text'						,editor		: {							xtype	: 'textfield'						}					},					{						header		: 'Hide'						,flex		: 1						, dataIndex	: 'hide'						,editor		: {							xtype	: 'textfield',							valueField	: '0'						}					}				],				stripeRows: true,				height:180,				width:500
		});
		win = Ext.widget('window', {
                title: 'Kirim Email',
                closeAction: 'hide',
                width: 400,
                height: 400,
                minWidth: 300,
                minHeight: 300,
                layout: 'fit',
                resizable: true,
                modal: true,
                defaultFocus: 'Email Address',				items	: grid
        });
		win.show();
		return field;
	},
	getlisfieldform : function(pview,id_grid)	{
		//console.log(pview);
		//console.log(id_grid);
		Init.vgrid = id_grid;
		Init.gstore = pview;
		
		var field = this.getcolumn(pview);
		var store = new Ext.data.SimpleStore({		fields: [			{name: 'dataIndex'},			{name: 'text'},			{name: 'hide'},			{				name 	: 'type'			},			{				name	: 'sort'			},			{				name	: 'source'			},			{				name	: 'displayfield'			},			{				name	: 'valueField'			}		]
		});
		var editing = Ext.create('Ext.grid.plugin.RowEditing', {
		  clicksToEdit: 2,
		  listeners :			{									'edit' : function (editor,e) {						 						 var grid 	= e.grid;						 var record = e.record;						 						var recordData = record.data; 						//msclass.savedata(recordData,base_url+'admin/insertdatamanualbulk');						console.log(recordData);											}			}
		});
		store.loadData(field);
		var grid = new Ext.grid.GridPanel({		store: store,		plugins	: editing,		tbar		: [{			text	: 'Save',			iconCls	: 'page_white_excel',			handler		: function()			{				var items = [];				var store_items = [];				var n = 0;				store.each(function(record){ 					console.log(record.data.hide);												if(parseInt(record.data.hide) == 0 || record.data.hide == '')						{							switch(record.data.type) {								case 'text':									var data = {										xtype		: 'textfield',										fieldLabel	: record.data.text,										name		: record.data.dataIndex,										allowBlank	: false,										tooltip		: 'Enter your '+record.data.text									}									break;								case 'textareafield':									var data = {										xtype		: 'textareafield',										fieldLabel	: record.data.text,										name		: record.data.dataIndex,										allowBlank	: false,										tooltip		: 'Enter your '+record.data.text									}								break;									case 'date':									var data = {										xtype		: 'datefield',										format		: 'Y-m-d',										fieldLabel	: record.data.text,										name		: record.data.dataIndex,										allowBlank	: false,										tooltip		: 'Enter your '+record.data.text									}									break;								case 'number':									var data = {										xtype		: 'numberfield',										fieldLabel	: record.data.text,										name		: record.data.dataIndex,										allowBlank	: false,										tooltip		: 'Enter your '+record.data.text									}									break;									case 'email':									var data = {										xtype		: 'textfield',										vtype		:'email',										fieldLabel	: record.data.text,										name		: record.data.dataIndex,										allowBlank	: false,										tooltip		: 'Enter your '+record.data.text									}									break;									case 'combo':									 									var data = {										xtype			: 'combobox',										fieldLabel		: record.data.text,																name			: record.data.dataIndex,										displayField	: record.data.displayfield,										valueField		: record.data.valueField,										queryMode		: 'local',										v_source		: record.data.source										//store			: record.data.source,									}									//store_items									break;									case 'checkbox':									//console.log(record.data);									 var msclass 	= Ext.create('master.global.geteventmenu'); 									 var store_data;									store_data = msclass.getstore(msclass.getmodel(record.data.source),record.data.source,[]).load();									//items_form[n].store = window['store_formv_table'+n];									var j=0;									var items_data = [];																		store_data.load({									  callback: function(records, operation, success){										if(success){										  //var contact = records[0];										  for (var prop in records) 										  {											  //console.log(records[prop].data);											  items_data.push({													xtype: 'checkbox',													boxLabel: records[prop].data.satker,													name: record.data.dataIndex,													//checked: true,													inputValue: records[prop].data.satker											  });										  }										  //do something with the contact record										}									  }									});																		var data = {											xtype: 'checkboxgroup',											fieldLabel: record.data.text,											columns: 3,											allowBlank: false,											itemId: 'mySports',											items: items_data,											hidden		: true,											v_source		: record.data.source,											displayField	: record.data.displayfield,											valueField		: record.data.valueField,											name		: record.data.dataIndex,										}									break;										default:									var data = {										xtype		: 'textfield',										fieldLabel	: record.data.text,										name		: record.data.dataIndex,										allowBlank	: false,										tooltip		: 'Enter your '+record.data.text									}							}							items.push(data);						}																						n++;									});								var data_insert = Ext.encode(items);				var url = base_url+'admin/settings/savecolumn';								var params = {					columns	: data_insert,					id		: Init.vgrid,					view 	: Init.gstore				};								Ext.Ajax.request({	 					url: url,					method: 'POST',					params: params,					success: function(response,requst){												Ext.Msg.alert('Success','Transaksi Sukses');					},					failure:function(response,requst)					{						Ext.Msg.alert('Fail !','Input Data Entry Gagal');						Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");						return false;					}														});							}		}],			columns: [				{					header: 'dataIndex',					flex	: 1,					dataIndex: 'dataIndex'				},				{					header		: 'Text'					,flex		: 1					, dataIndex	: 'text'					,editor		: {						xtype	: 'textfield'					}				},				{					header		: 'Hide'					,flex		: 1					, dataIndex	: 'hide'					,editor		: {						xtype	: 'textfield',						valueField	: '0'					}				},				{					header		: 'Type',					flex		: 1,					dataIndex	: 'type',					editor		: {						xtype	: 'textfield'					}				},				{					header		: 'Sort',					flex		: 1,					dataIndex	: 'sort',					editor		: {						xtype	: 'textfield'					}				},				{					header		: 'Source',					flex		: 1,					dataIndex	: 'source',					editor		: 					{						xtype	: 'textfield'					}				},				{					header		: 'displayfield',					flex		: 1,					dataIndex	: 'displayfield',					editor		: 					{						xtype	: 'textfield'					}				},				{					header		: 'valueField',					flex		: 1,					dataIndex	: 'valueField',					editor		:					{						xtype	: 'textfield'					}				}			],			stripeRows: true,			height:180,			width:500	});
		win = Ext.widget('window', {
                title: 'Kirim Email',
                closeAction: 'hide',
                width: 400,
                height: 400,
                minWidth: 300,
                minHeight: 300,
                layout: 'fit',
                resizable: true,
                modal: true,
                defaultFocus: 'Email Address',				items	: grid
        });
		win.show();
		return field;
	},
	getgridform : function (pview,id_grid)
	{
		Init.vgrid = id_grid;
		Init.gstore = pview;
		var field = this.getcolumn(pview);		var store = new Ext.data.SimpleStore({			fields: [				{name: 'dataIndex'},				{name: 'text'},				{name: 'hide'}			]
		});
		var editing = Ext.create('Ext.grid.plugin.RowEditing', {		  clicksToEdit: 2,
		  listeners :			{									'edit' : function (editor,e) {						 						 var grid 	= e.grid;						 var record = e.record;						 						var recordData = record.data; 						//msclass.savedata(recordData,base_url+'admin/insertdatamanualbulk');						//console.log(recordData);											}			}
		});
		store.loadData(field);
		var grid = new Ext.grid.GridPanel({			store: store,			plugins	: editing,			tbar		: [{				text	: 'Save',				iconCls	: 'page_white_excel',				handler		: function()				{					var items = [];					var n = 0;					store.each(function(record){ 						console.log(record.data.hide);							if(record.data.hide == '')							{								var data = {								cls	: 'header-cell',								dataIndex	: record.data.dataIndex,								text		: record.data.text,								//flex		: 1,								hidden		: false,								autoSizeColumn	: true								};								items.push(data);							}							if(parseInt(record.data.hide) == 0)							{								var data = {									cls	: 'header-cell',									dataIndex	: record.data.dataIndex,									text		: record.data.text,									//flex		: 1,									hidden		: false,									autoSizeColumn	: true								};								items.push(data);							}else							{								var data = {									cls	: 'header-cell',									dataIndex	: record.data.dataIndex,									text		: record.data.text,									//flex		: 1,									hidden		: true,									autoSizeColumn	: true								};								items.push(data);							};													n++;											});					var data_insert = Ext.encode(items);					var url = base_url+'admin/settings/savecolumn';										var params = {						columns	: data_insert,						id		: Init.vgrid,						view 	: Init.gstore					};										Ext.Ajax.request({	 						url: url,						method: 'POST',						params: params,						success: function(response,requst){														Ext.Msg.alert('Success','Transaksi Sukses');						},						failure:function(response,requst)						{							Ext.Msg.alert('Fail !','Input Data Entry Gagal');							Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");							return false;						}																});				}			}],			columns: [				{					header: 'dataIndex',					flex	: 1,					dataIndex: 'dataIndex'				},				{					header		: 'Text'					,flex		: 1					, dataIndex	: 'text'					,editor		: {						xtype	: 'textfield'					}				},				{					header		: 'Hide'					,flex		: 1					, dataIndex	: 'hide'					,editor		: {						xtype	: 'textfield',						valueField	: '0'					}				}			],			stripeRows: true,			height:180,			width:500
					});
					return grid;	},		getformcreate : function(v_table,id_form,button_items,toolbar)
	{
		var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
		var items_form = this.getcolumngrid(id_form,v_table);
		//console.log(items_form);
		var n = 0;
		for (var prop in items_form) {			//console.log(items_form[n].xtype);			if(items_form[n].xtype == 'combobox')			{				console.log(items_form[n].v_source);				window['store_formv_table'+n] = this.getstore(this.getmodel(items_form[n].v_source),items_form[n].v_source,[]).load();				items_form[n].store = window['store_formv_table'+n];				window['store_formv_table'+n].load();			}						n++;
		}
		var formsearc = Ext.create('Ext.form.Panel',{			frame		: false,				border		: false,				layout		: 'form',				frame  		: false,				method		: 'POST',				// url			: base_url+'admin/findamr',				bodyPadding: '5 5 0',				fieldDefaults: {					labelAlign: 'left',					anchor: '60%'				},				defaultType: 'textfield',				id			: 'form_add',				items		: items_form,				//layout		: 'fit',				autoScroll	: true
		});
		var n = 0;
		for (var prop in items_form) {				//console.log(items_form[n].xtype);						if(items_form[n].xtype == 'checkboxgroup')		{			window['store_formv_table'+n] = this.getstore(this.getmodel(items_form[n].v_source),items_form[n].v_source,[]).load();			window['store_formv_table'+n].getProxy().extraParams = {					limit	 : 'All',					view	 : items_form[n].v_source					};									var items_data = [];						items_form[n].hidden = true;			var data_label = items_form[n].fieldLabel;			var name_label = items_form[n].name;			var displayField = items_form[n].displayfield;			window['store_formv_table'+n].load({			  callback: function(records, operation, success){				if(success){				  for (var prop in records) 				  {					  var datacheck = {							xtype: 'checkbox',							boxLabel:records[prop].data.satker,							name: name_label,							//checked: true,							inputValue: records[prop].data.rowid					  };					  items_data.push(datacheck);				  }					var myCheckboxgroup = new Ext.form.CheckboxGroup({						id 			: 'myGroup',						fieldLabel  : data_label,						items 		: items_data,						columns		: 3						//renderData : main					});					formsearc.add(myCheckboxgroup);					formsearc.doLayout();				  //console.log(items_form[n]);				}			  }			});					}			n++;
					}
					formsearc.addDocked({			xtype: 'toolbar',			dock: 'top',			items: toolbar
					});
					return formsearc;
	},
	getformcreatepeng : function(v_table,id_form,button_items,toolbar)	{
					var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
					var items_form = this.getcolumngrid(id_form,v_table);
					//console.log(items_form);
		var n = 0;
		
		
		for (var prop in items_form) {	//console.log(items_form[n].xtype);	if(items_form[n].xtype == 'combobox')	{		console.log(items_form[n].v_source);		window['store_formv_table'+n] = this.getstore(this.getmodel(items_form[n].v_source),items_form[n].v_source,[]).load();		items_form[n].store = window['store_formv_table'+n];		window['store_formv_table'+n].load();	}	n++;
		}
		var formsearc = Ext.create('Ext.form.Panel',{		frame		: false,			border		: false,			layout		: 'form',			frame  		: false,			method		: 'POST',			// url			: base_url+'admin/findamr',			bodyPadding: '5 5 0',			fieldDefaults: {				labelAlign: 'left',				anchor: '60%'			},			defaultType: 'textfield',			id			: 'form_add',			items		: items_form,			//layout		: 'fit',			autoScroll	: true,			defaults: {				listeners: {					change: function(field, newVal, oldVal) {						//console.log(newVal);						//console.log(field.id);						if(field.id == 'insrefffarms'){							var reffkandang = Ext.getCmp('insreffkandang')							parms_pgrid = reffkandang.getStore();							reffkandang.setValue('');							parms_pgrid.getProxy().extraParams = {									view :"public.fn_getdatamastertype('TOD3')",									limit : "All",									"filter[0][field]" : "parent",									"filter[0][data][type]" : 'numeric',									"filter[0][data][comparison]" : "eq",									"filter[0][data][value]" : newVal							};							parms_pgrid.load();						}					}				},			},
		});
		var n = 0;
		for (var prop in items_form) {	//console.log(items_form[n].xtype);		if(items_form[n].xtype == 'checkboxgroup')	{		window['store_formv_table'+n] = this.getstore(this.getmodel(items_form[n].v_source),items_form[n].v_source,[]).load();		window['store_formv_table'+n].getProxy().extraParams = {				limit	 : 'All',				view	 : items_form[n].v_source				};							var items_data = [];				items_form[n].hidden = true;		var data_label = items_form[n].fieldLabel;		var name_label = items_form[n].name;		var displayField = items_form[n].displayfield;		window['store_formv_table'+n].load({		  callback: function(records, operation, success){			if(success){			  for (var prop in records) 			  {				  var datacheck = {						xtype: 'checkbox',						boxLabel:records[prop].data.satker,						name: name_label,						//checked: true,						inputValue: records[prop].data.rowid				  };				  items_data.push(datacheck);			  }				var myCheckboxgroup = new Ext.form.CheckboxGroup({					id 			: 'myGroup',					fieldLabel  : data_label,					items 		: items_data,					columns		: 3					//renderData : main				});				formsearc.add(myCheckboxgroup);				formsearc.doLayout();			  //console.log(items_form[n]);			}		  }		});	}	n++;
	}
		formsearc.addDocked({			xtype: 'toolbar',			dock: 'top',			items: toolbar
		});
		return formsearc;
	},
	getformsearch : function(v_table,id_form,button_items,toolbar)
	{
		var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
		var items_form = this.getcolumngrid(id_form,v_table);
		console.log(items_form);
		var n = 0;
		for (var prop in items_form) {	//console.log(items_form[n].xtype);			if(items_form[n].xtype == 'combobox')			{				console.log(items_form[n].v_source);				window['store_formv_table'+n] = this.getstore(this.getmodel(items_form[n].v_source),items_form[n].v_source,[]).load();				items_form[n].store = window['store_formv_table'+n];				window['store_formv_table'+n].load();			}				n++;
		}
		
		var formsearc = Ext.create('Ext.form.Panel',{			frame		: false,				border		: false,				layout		: 'form',				frame  		: false,				method		: 'POST',				// url			: base_url+'admin/findamr',				bodyPadding: '5 5 0',				fieldDefaults: {					labelAlign: 'left',					anchor: '60%'				},				defaultType: 'textfield',				id			: 'form_search',				items		: items_form,				//layout		: 'fit',				autoScroll	: true
					});
					var n = 0;
					for (var prop in items_form) {				//console.log(items_form[n].xtype);								if(items_form[n].xtype == 'checkboxgroup')				{					window['store_formv_table'+n] = this.getstore(this.getmodel(items_form[n].v_source),items_form[n].v_source,[]).load();					window['store_formv_table'+n].getProxy().extraParams = {							limit	 : 'All',							view	 : items_form[n].v_source							};													var items_data = [];										items_form[n].hidden = true;					var data_label = items_form[n].fieldLabel;					var name_label = items_form[n].name;					var displayField = items_form[n].displayfield;					window['store_formv_table'+n].load({					  callback: function(records, operation, success){						if(success){						  for (var prop in records) 						  {							  var datacheck = {									xtype: 'checkbox',									boxLabel:records[prop].data.satker,									name: name_label,									//checked: true,									inputValue: records[prop].data.rowid							  };							  items_data.push(datacheck);						  }							var myCheckboxgroup = new Ext.form.CheckboxGroup({								id 			: 'myGroup',								fieldLabel  : data_label,								items 		: items_data,								columns		: 3								//renderData : main							});							formsearc.add(myCheckboxgroup);							formsearc.doLayout();						  //console.log(items_form[n]);						}					  }					});									}			n++;
		}
		/* formsearc.addDocked({xtype: 'toolbar',dock: 'top',items: toolbar
		}); */
		return formsearc;
	},
	getformsearchpeng : function(v_table,id_form,button_items,toolbar,parid)
	{
		var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
		var items_form = this.getcolumngrid(id_form,v_table);
		console.log(items_form);
		var n = 0;
		for (var prop in items_form) {				//console.log(items_form[n].xtype);				if(items_form[n].xtype == 'combobox')				{					console.log(items_form[n].v_source);					window['store_formv_table'+n] = this.getstore(this.getmodel(items_form[n].v_source),items_form[n].v_source,[]).load();					items_form[n].store = window['store_formv_table'+n];					window['store_formv_table'+n].load();				}							n++;
		}
		
		var formsearc = Ext.create('Ext.form.Panel',{		frame		: false,			border		: false,			layout		: 'form',			frame  		: false,			method		: 'POST',			// url			: base_url+'admin/findamr',			bodyPadding: '5 5 0',			fieldDefaults: {				labelAlign: 'left',				anchor: '60%'			},			defaultType: 'textfield',			id			: 'form_search',			items		: items_form,			//layout		: 'fit',			autoScroll	: true,			defaults: {				listeners: {					change: function(field, newVal, oldVal) {						//console.log(newVal);						//console.log(field.id);						if(field.id == 'srcrefffarms'+parid){							var srcreffkandang = Ext.getCmp('srcreffkandang'+parid)							parms_pgrid = srcreffkandang.getStore();							srcreffkandang.setValue('');							parms_pgrid.getProxy().extraParams = {									view :"public.fn_getdatamastertype('TOD3')",									limit : "All",									"filter[0][field]" : "parent",									"filter[0][data][type]" : 'numeric',									"filter[0][data][comparison]" : "eq",									"filter[0][data][value]" : newVal							};							parms_pgrid.load();						}					}				},			},
		});
		var n = 0;
		for (var prop in items_form) {	//console.log(items_form[n].xtype);		if(items_form[n].xtype == 'checkboxgroup')	{		window['store_formv_table'+n] = this.getstore(this.getmodel(items_form[n].v_source),items_form[n].v_source,[]).load();		window['store_formv_table'+n].getProxy().extraParams = {				limit	 : 'All',				view	 : items_form[n].v_source				};							var items_data = [];				items_form[n].hidden = true;		var data_label = items_form[n].fieldLabel;		var name_label = items_form[n].name;		var displayField = items_form[n].displayfield;		window['store_formv_table'+n].load({		  callback: function(records, operation, success){			if(success){			  for (var prop in records) 			  {				  var datacheck = {						xtype: 'checkbox',						boxLabel:records[prop].data.satker,						name: name_label,						//checked: true,						inputValue: records[prop].data.rowid				  };				  items_data.push(datacheck);			  }				var myCheckboxgroup = new Ext.form.CheckboxGroup({					id 			: 'myGroup',					fieldLabel  : data_label,					items 		: items_data,					columns		: 3					//renderData : main				});				formsearc.add(myCheckboxgroup);				formsearc.doLayout();			  //console.log(items_form[n]);			}		  }		});			}n++;}
		/* formsearc.addDocked({xtype: 'toolbar',dock: 'top',items: toolbar
		}); */
		return formsearc;
	},
	getitemsform : function(v_table,id_form)	{
		var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
		var items_form = this.getcolumngrid(id_form,v_table);
		console.log(items_form);
		var n = 0;
		
		for (var prop in items_form) {	//console.log(items_form[n].xtype);	if(items_form[n].xtype == 'combobox')	{		console.log(items_form[n].v_source);		window['store_formv_table'+n] = this.getstore(this.getmodel(items_form[n].v_source),items_form[n].v_source,[]);		items_form[n].store = window['store_formv_table'+n];		//window['store_formv_table'+n].load();	}	n++;
		}
	    return items_form;
	},	
	getformsearchpeng1 : function(items_form)	{
		var formsearc = Ext.create('Ext.form.Panel',{			frame		: false,				border		: false,				layout		: 'form',				frame  		: false,				method		: 'POST',				// url			: base_url+'admin/findamr',				bodyPadding: '5 5 0',				fieldDefaults: {					labelAlign: 'left',					anchor: '60%'				},				defaultType: 'textfield',				//id			: 'form_search',				items		: items_form,				//layout		: 'fit',				autoScroll	: true
					});
					var n = 0;
					for (var prop in items_form) {				//console.log(items_form[n].xtype);								if(items_form[n].xtype == 'checkboxgroup')				{					window['store_formv_table'+n] = this.getstore(this.getmodel(items_form[n].v_source),items_form[n].v_source,[]).load();					window['store_formv_table'+n].getProxy().extraParams = {							limit	 : 'All',							view	 : items_form[n].v_source							};													var items_data = [];										items_form[n].hidden = true;					var data_label = items_form[n].fieldLabel;					var name_label = items_form[n].name;					var displayField = items_form[n].displayfield;					window['store_formv_table'+n].load({					  callback: function(records, operation, success){						if(success){						  for (var prop in records) 						  {							  var datacheck = {									xtype: 'checkbox',									boxLabel:records[prop].data.satker,									name: name_label,									//checked: true,									inputValue: records[prop].data.rowid							  };							  items_data.push(datacheck);						  }							var myCheckboxgroup = new Ext.form.CheckboxGroup({								id 			: 'myGroup',								fieldLabel  : data_label,								items 		: items_data,								columns		: 3								//renderData : main							});							formsearc.add(myCheckboxgroup);							formsearc.doLayout();						  //console.log(items_form[n]);						}					  }					});									}			n++;
		}
		/* formsearc.addDocked({			xtype: 'toolbar',			dock: 'top',			items: toolbar
			}); */
		return formsearc;
	},
	getformupdate : function(v_table,id_form,button_items,toolbar)
	{
		var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
		var items_form = this.getcolumngrid(id_form,v_table);
		console.log(items_form);
		var n = 0;
		
		for (var prop in items_form) {				if(items_form[n].xtype == 'combobox')				{					console.log(items_form[n].v_source);					window['store_formv_table'+n] = this.getstore(this.getmodel(items_form[n].v_source),items_form[n].v_source,[]).load();					items_form[n].store = window['store_formv_table'+n];					window['store_formv_table'+n].load();				}			n++;
		}
		var formsearc = Ext.create('Ext.form.Panel',{				frame		: false,				border		: false,				layout		: 'form',				frame  		: false,				method		: 'POST',				// url			: base_url+'admin/findamr',				bodyPadding: '5 5 0',				fieldDefaults: {					labelAlign: 'left',					anchor: '60%'				},				defaultType: 'textfield',				id			: 'form_update',				items		: items_form,				buttons		: [						{							text	: 'Reset',							iconCls : 'arrow_refresh',							handler	: function()							{								this.up('form').getForm().reset();							}						}				]
		});
		formsearc.addDocked({			xtype: 'toolbar',			dock: 'top',			items: toolbar
		});
		return formsearc;
	},
	getformupdatepeng : function(v_table,id_form,button_items,toolbar)
	{
		var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
		var items_form = this.getcolumngrid(id_form,v_table);
		console.log(items_form);
		var n = 0;
		
		for (var prop in items_form) {			if(items_form[n].xtype == 'combobox')			{				console.log(items_form[n].v_source);				window['store_formv_table'+n] = this.getstore(this.getmodel(items_form[n].v_source),items_form[n].v_source,[]).load();				items_form[n].store = window['store_formv_table'+n];				window['store_formv_table'+n].load();			}			n++;
		}
		var formsearc = Ext.create('Ext.form.Panel',{				frame		: false,				border		: false,				layout		: 'form',				frame  		: false,				method		: 'POST',				// url			: base_url+'admin/findamr',				bodyPadding: '5 5 0',				fieldDefaults: {					labelAlign: 'left',					anchor: '60%'				},				defaultType: 'textfield',				id			: 'form_update',				items		: items_form,				buttons		: [						{							text	: 'Reset',							iconCls : 'arrow_refresh',							handler	: function()							{								this.up('form').getForm().reset();							}						}				],				defaults: {					listeners: {						change: function(field, newVal, oldVal) {							//console.log(newVal);							//console.log(field.id);							if(field.id == 'updrefffarms'){								var srcreffkandang = Ext.getCmp('updreffkandang')								parms_pgrid = srcreffkandang.getStore();								srcreffkandang.setValue('');								parms_pgrid.getProxy().extraParams = {										view :"public.fn_getdatamastertype('TOD3')",										limit : "All",										"filter[0][field]" : "parent",										"filter[0][data][type]" : 'numeric',										"filter[0][data][comparison]" : "eq",										"filter[0][data][value]" : newVal								};								parms_pgrid.load();							}						}					},				},
		});
		formsearc.addDocked({			xtype: 'toolbar',			dock: 'top',			items: toolbar
		});
		return formsearc;
	},
	gettoolbar	: function(insert,update,id_grid,tbl)
	{
		var msclass = this;
		var toolbar = [
		{ 			text	: 'Tambah',			iconCls	: 'add',			handler	: function()			{				Init.valuesimpan = 1;								var tabPanel = Ext.getCmp('tabcontentdata');				var items = tabPanel.items.items;				var exist = false;												for (var i = 0; i < items.length; i++) {					if (items[i].id == '3') {						console.log(items[i].id);						tabPanel.setActiveTab('3');						tabPanel.child('#3').tab.show();						 exist = true;					}				 } 				 				 											if (!exist){					tabPanel.add({						 title		: 'Add Form',						 xtype		: 'panel',						 closable	: false,						 iconCls	: 'application_form_add',						 id			: '3',						 items		: insert					})					tabPanel.setActiveTab('3');				}							}		},'-',
		{			text	: 'Simpan',			iconCls	: 'accept',			handler	: function()			{				var params = [];				if(Init.valuesimpan == 1)				{					var myField 	= Ext.getCmp('form_add');					var form_data 	= myField.getForm();					var url 		= base_url+'admin/main/save';					var oksparams 	= form_data.getValues();					params.data 	= oksparams;					params.id 		= id_grid;					params.tbl		= tbl;				}else				{					var grid 		= Ext.getCmp(id_grid);					var record 		= grid.getView().getSelectionModel().getSelection()[0]; 					var myField 	= Ext.getCmp('form_update');					var form_data 	= myField.getForm();					var url 		= base_url+'admin/main/update';					var oksparams 	= form_data.getValues();					console.log(oksparams);					var params 		= [];					oksparams.rowid = record.data.rowid;					params.data 	= oksparams;					params.id 		= id_grid;					params.tbl		= tbl;				}								var data_input	= {					data	: Ext.encode(oksparams),					id		: id_grid,					tbl		: tbl				};								msclass.savedata(data_input,url);				var tabPanel = Ext.getCmp('tabcontentdata');				var items = tabPanel.items.items;				tabPanel.items.each(function(c){					if (c.title != 'Data List') {						tabPanel.child('#'+c.id+'').tab.hide();						}				});				tabPanel.setActiveTab('list');			}
		},'-',
		{			text	: 'Ubah',			iconCls	: 'pencil',			handler	: function()			{				Init.valuesimpan = 2;				console.log(id_grid);				var grid = Ext.getCmp(id_grid);								var storegrid = grid.getStore();				storegrid.each(function(record){ 				  console.log(record.data);				});				var record 	= grid.getView().getSelectionModel().getSelection()[0]; 				console.log(record);				var tabPanel = Ext.getCmp('tabcontentdata');				var items = tabPanel.items.items;				var exist = false;												for (var i = 0; i < items.length; i++) {				 if (items[i].id == '4') {					tabPanel.setActiveTab('4');						tabPanel.child('#4').tab.show();							exist = true;					}				 }				if (!exist){					tabPanel.add({						 title		: 'Update Form',						 xtype		: 'panel',						 iconCls	: 'application_form_add',						 id			: '4',						 //closable	: true,						 items		: update					});					exist = false;					tabPanel.setActiveTab('4');				}								var myField 	= Ext.getCmp('form_update');				var form_data 	= myField.getForm();				form_data.loadRecord(record);							}
		},'-',
		{			text	: 'Hapus',			iconCls	: 'delete',			handler	: function()			{				var items = [];				var grid = Ext.getCmp(id_grid);				var storegrid = grid.getStore();				var params 		= [];				storegrid.each(function(record){										if (record.data.selectopts == true)					{						var url 		= base_url+'admin/main/delete_data';						params.id 		= id_grid;						var data_input	= {							data	: Ext.encode(record.data),							id		: id_grid,							tbl		: tbl						};						msclass.savedata(data_input,url);					}				});			}
		},'-',
		{			text	: 'Batal',			iconCls	: 'cross',			handler	: function()			{				var tabPanel = Ext.getCmp('tabcontentdata');				var items = tabPanel.items.items;				tabPanel.items.each(function(c){					if (c.title != 'Data List') {						tabPanel.child('#'+c.id+'').tab.hide();						}				});				tabPanel.setActiveTab('list');			}		}/*,'-',		{			text	: 'Export',			iconCls	: 'page_excel'
		},'-',
		{			text	: 'Print',			iconCls	: 'printer'
		},'-',
		{			text	: 'Message',			iconCls	: 'email'
		}*/
		];
		return toolbar;
	},
	gettoolbarpeng	: function(insert,update,id_grid,tbl)
	{
		var msclass = this;
		var toolbar = [
		{ 			text	: 'Tambah',			iconCls	: 'add',			handler	: function()			{				Init.valuesimpan = 1;								var tabPanel = Ext.getCmp('tabcontentdata');				var items = tabPanel.items.items;				var exist = false;												for (var i = 0; i < items.length; i++) {					if (items[i].id == '3') {						console.log(items[i].id);						tabPanel.setActiveTab('3');						tabPanel.child('#3').tab.show();						 exist = true;					}				 } 				 											if (!exist){					tabPanel.add({						 title		: 'Add Form',						 xtype		: 'panel',						 closable	: false,						 iconCls	: 'application_form_add',						 id			: '3',						 items		: insert					})					tabPanel.setActiveTab('3');				}							}		},'-',
		{			text	: 'Simpan',			iconCls	: 'accept',			handler	: function()			{				var params = [];				if(Init.valuesimpan == 1)				{					var myField 	= Ext.getCmp('form_add');					var form_data 	= myField.getForm();					var url 		= base_url+'admin/main/savepencatatan';					var oksparams 	= form_data.getValues();					params.data 	= oksparams;					params.id 		= id_grid;					params.tbl		= tbl;				}else				{					var grid 		= Ext.getCmp(id_grid);					var record 		= grid.getView().getSelectionModel().getSelection()[0]; 					var myField 	= Ext.getCmp('form_update');					var form_data 	= myField.getForm();					var url 		= base_url+'admin/main/savepencatatan';					var oksparams 	= form_data.getValues();					console.log(oksparams);					var params 		= [];					oksparams.rowid = record.data.rowid;					params.data 	= oksparams;					params.id 		= id_grid;					params.tbl		= tbl;				}								var data_input	= {					data	: Ext.encode(oksparams),					id		: id_grid,					tbl		: tbl				};								msclass.savedata(data_input,url);				var tabPanel = Ext.getCmp('tabcontentdata');				var items = tabPanel.items.items;				tabPanel.items.each(function(c){					if (c.title != 'Data List') {						tabPanel.child('#'+c.id+'').tab.hide();						}				});				tabPanel.setActiveTab('list');			}
		},'-',
		{			text	: 'Ubah',			iconCls	: 'pencil',			handler	: function()			{				Init.valuesimpan = 2;				console.log(id_grid);				var grid = Ext.getCmp(id_grid);								var storegrid = grid.getStore();				storegrid.each(function(record){ 				  //console.log(record.data);				});				var record 	= grid.getView().getSelectionModel().getSelection()[0]; 				console.log(record);				var tabPanel = Ext.getCmp('tabcontentdata');				var items = tabPanel.items.items;				var exist = false;												for (var i = 0; i < items.length; i++) {				 if (items[i].id == '4') {					tabPanel.setActiveTab('4');						tabPanel.child('#4').tab.show();							exist = true;					}				 }				if (!exist){					tabPanel.add({						 title		: 'Update Form',						 xtype		: 'panel',						 iconCls	: 'application_form_add',						 id			: '4',						 //closable	: true,						 items		: update					});					exist = false;					tabPanel.setActiveTab('4');				}								var myField 	= Ext.getCmp('form_update');				var form_data 	= myField.getForm();				form_data.loadRecord(record);							}		},'-',		{				text	: 'Hapus',				iconCls	: 'delete',				handler	: function()				{					var items = [];					var grid = Ext.getCmp(id_grid);					var storegrid = grid.getStore();					var params 		= [];					storegrid.each(function(record){												if (record.data.selectopts == true)						{							var url 		= base_url+'admin/main/delete_data';							params.id 		= id_grid;							var data_input	= {								data	: Ext.encode(record.data),								id		: id_grid,								tbl		: tbl							};							msclass.savedata(data_input,url);						}					});				}		},'-',		{			text	: 'Batal',			iconCls	: 'cross',			handler	: function()			{				var tabPanel = Ext.getCmp('tabcontentdata');				var items = tabPanel.items.items;				tabPanel.items.each(function(c){					if (c.title != 'Data List') {						tabPanel.child('#'+c.id+'').tab.hide();						}				});				tabPanel.setActiveTab('list');			}
		}/*,'-',
		{			text	: 'Export',			iconCls	: 'page_excel'
		},'-',
		{			text	: 'Print',			iconCls	: 'printer'
		},'-',
		{			text	: 'Message',			iconCls	: 'email'
		}*/
		];
		return toolbar;
	},
	gettoolbarsearch	: function()
	{
		var search = [{		text	: 'Cari',		iconCls	: 'magnifier'	},'-',	{		text	: 'Cari',		iconCls : 'arrow_refresh'	},'-',	{		text	: 'Link',		iconCls	: 'link'	},'-',	{		text	: 'Add Search',		iconCls	: 'magnifier_zoom_in'	}];
		return search;		
	},
		gettreestore	: function(model,view,filter)
	{
		var d = new Date();
		var n = d.getTime();
		var store = Ext.create('Ext.data.TreeStore',{				fields 		: model,				remoteSort  : true,				storeId		: n,				clearOnLoad : true,				proxy: {					type: 'ajax',								url: base_url+'admin/master/getloaddatatree',					extraParams : {						filter  : filter,						view 	: view					},					reader: {						type: 'json',						root: 'data'					},					node: 'id',					folderSort: true							}
		});	
		return store;
	},
		getlayout		: function(pgrid,get_toolbar_search,get_toolbar,iconCls,name,psearch)
	{
		var tabPanel 	= Ext.getCmp('contentcenter');
		tabPanel.items.each(function(c){			if (c.title != 'Home') {				tabPanel.remove(c.id);			}
		});
		var items = tabPanel.items.items;
		var exist = false;
		var msclass 	= Ext.create('master.global.geteventmenu');			if (!exist) {			tabPanel.add({				title 	: name, 				id 		: '20', 				xtype 	: 'panel', 				iconCls : iconCls, 				layout: 'border',				setLoading	: true,				closable: true,				defaults: {					collapsible: true,					split: true,				},				items: [				psearch,				{					xtype: 'panel',					flex: 3,					collapsible: false,									region: 'center',					activeTab	: 0,									//fit		: true,					//title	: 'Project Monitoring',					layout	: 'border',					frame	: false,					border:false,					fit		: true,					items	:[{						  xtype	: 'box',						  id	: 'header',						  //frame	: true,						  region: 'north',						  flex	: 1,						  style: {							background: '#FFFFFF',							border: 'none',						  },						  html	:'<div style="float:right;padding:0px 15px 0px 0px"><h2 style="margin:0">'+name+'</h2></div>'					},					{						xtype	: 'panel',						region	: 'center',						flex	: 21,						layout		: 'fit',						tbar	: get_toolbar,						items	: [{							xtype		: 'tabpanel',							flex		: 3,							id 			: 'tabcontentdata',							collapsible	: false,											region		: 'center',							activeTab	: 0,											fit			: true,							layout		: 'fit',							items		: [{								xtype	: 'panel',								title		: 'Data List',								id			: 'list',								iconCls		: 'application_view_columns',								fit			: true,								layout		: 'fit',								items		: pgrid							}]							}]					}]					}]			}			);			tabPanel.setActiveTab('20');			}
	},
	getgridpeng	: function(cgrid,id_grid,itemdocktop,pstore, group = {ftype: 'summary',dock: 'bottom'})
	{		
		var groupingFeature = Ext.create('Ext.grid.feature.Grouping',{			groupHeaderTpl:'{[values.rows[0].data.tanggal]} / {[values.rows[0].data.id_pel]}'		});	
		//console.log(group);	
		var rgrid = Ext.create('Ext.grid.Panel',{			store		: pstore,			//features: [groupingFeature],			//multiSelect	: true,			id			: id_grid,			viewConfig : {			listeners : {				 refresh : function (dataview) {					  Ext.each(dataview.panel.columns, function (column) {					   if (column.autoSizeColumn === true)						column.autoSize();					  })				 }			}		   },			/* selType		: 'checkboxmodel',			selModel: {					injectCheckbox: 0,					pruneRemoved: false,					showHeaderCheckbox: true			}, */			columns		: cgrid,			//plugins	: editing,			bbar: Ext.create('Ext.PagingToolbar', {				store: pstore,				displayInfo: true			}),			features: [group],			//split: true,			listeners	: 			{				select: function (model, record, index, eOpts) {					record.set('selectopts',true);				},				deselect: function (view, record, item, index, e, eOpts) {					record.set('selectopts',false);				}			}
		});		
		Ext.grid.Lockable.injectLockable		rgrid.addDocked({			xtype: 'toolbar',			dock: 'top',			items: itemdocktop		});				return rgrid;		
	},
	getformcreatepeng1 : function(items_form,idfrm)
	{
				var formsearc = Ext.create('Ext.form.Panel',{				frame		: false,				border		: false,				layout		: 'form',				frame  		: false,				method		: 'POST',				// url			: base_url+'admin/findamr',				bodyPadding: '5 5 0',				fieldDefaults: {					labelAlign: 'left',					anchor: '60%'				},				defaultType: 'textfield',				id			: 'form_add'+idfrm,				items		: items_form,				//layout		: 'fit',				autoScroll	: true
					});
					var n = 0;
					for (var prop in items_form) {				//console.log(items_form[n].xtype);								if(items_form[n].xtype == 'checkboxgroup')				{					window['store_formv_table'+n] = this.getstore(this.getmodel(items_form[n].v_source),items_form[n].v_source,[]).load();					window['store_formv_table'+n].getProxy().extraParams = {							limit	 : 'All',							view	 : items_form[n].v_source							};													var items_data = [];										items_form[n].hidden = true;					var data_label = items_form[n].fieldLabel;					var name_label = items_form[n].name;					var displayField = items_form[n].displayfield;					window['store_formv_table'+n].load({					  callback: function(records, operation, success){						if(success){						  for (var prop in records) 						  {							  var datacheck = {									xtype: 'checkbox',									boxLabel:records[prop].data.satker,									name: name_label,									//checked: true,									inputValue: records[prop].data.rowid							  };							  items_data.push(datacheck);						  }							var myCheckboxgroup = new Ext.form.CheckboxGroup({								id 			: 'myGroup',								fieldLabel  : data_label,								items 		: items_data,								columns		: 3								//renderData : main							});							formsearc.add(myCheckboxgroup);							formsearc.doLayout();						  //console.log(items_form[n]);						}					  }					});									}			n++;
		}
		/* formsearc.addDocked({xtype: 'toolbar',dock: 'top',items: toolbar
		}); */
		return formsearc;
	},
	getformupdatepeng1 : function(items_form,idfrm)	{
		var formsearc = Ext.create('Ext.form.Panel',{				frame		: false,					border		: false,					layout		: 'form',					frame  		: false,					method		: 'POST',					// url			: base_url+'admin/findamr',					bodyPadding: '5 5 0',					fieldDefaults: {						labelAlign: 'left',						anchor: '60%'					},					defaultType: 'textfield',					id			: 'form_update'+idfrm,					items		: items_form,					//layout		: 'fit',					autoScroll	: true
						});
						var n = 0;
						for (var prop in items_form) {					//console.log(items_form[n].xtype);										if(items_form[n].xtype == 'checkboxgroup')					{						window['store_formv_table'+n] = this.getstore(this.getmodel(items_form[n].v_source),items_form[n].v_source,[]).load();						window['store_formv_table'+n].getProxy().extraParams = {								limit	 : 'All',								view	 : items_form[n].v_source								};															var items_data = [];												items_form[n].hidden = true;						var data_label = items_form[n].fieldLabel;						var name_label = items_form[n].name;						var displayField = items_form[n].displayfield;						window['store_formv_table'+n].load({						  callback: function(records, operation, success){							if(success){							  for (var prop in records) 							  {								  var datacheck = {										xtype: 'checkbox',										boxLabel:records[prop].data.satker,										name: name_label,										//checked: true,										inputValue: records[prop].data.rowid								  };								  items_data.push(datacheck);							  }								var myCheckboxgroup = new Ext.form.CheckboxGroup({									id 			: 'myGroup',									fieldLabel  : data_label,									items 		: items_data,									columns		: 3									//renderData : main								});								formsearc.add(myCheckboxgroup);								formsearc.doLayout();							  //console.log(items_form[n]);							}						  }						});											}				n++;
		}
		/* formsearc.addDocked({			xtype: 'toolbar',			dock: 'top',			items: toolbar
		}); */
		return formsearc;
	}	
});
