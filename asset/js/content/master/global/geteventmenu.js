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
		   Ext.Ajax.request({ 

	getticket	: function()
	{
		var dataeent = '';
		var myValue;
		
		 Ext.Ajax.request({ 

		return myValue;	
	},
	getmodelquery	: function(view)
	{
		 Ext.Ajax.request({ 
		});
		return Init.model;
	},
	getmodel	: function(view)
	{
		Ext.Ajax.request({ 
		return Init.model;
	},
	getcolumn	: function(view,id_grid)
	{
		 Ext.Ajax.request({ 
		});
		//console.log(Init.pcolumns);
		return Init.pcolumns;
	},
	getcolumngrid	: function(id_grid,view)
	{
		 Ext.Ajax.request({ 
		});
		//console.log(Init.pcolumns);
		return Init.pcolumns;
	},
	getcolumnquerygrid	: function(id_grid,view)
	{
		 Ext.Ajax.request({ 
		});
		return Init.pcolumns;
	},
	getstorequery	: function(model,view)
	{
		var d = new Date();
		var n = d.getTime();
		
		var store = Ext.create('Ext.data.JsonStore',{
		});	
		return store;
	},
	getstore	: function(model,view,filter)
	{
		var d = new Date();
		var n = d.getTime();		
		var store = Ext.create('Ext.data.JsonStore',{
		});	
		return store;
	},
	{
		var d = new Date();
		var n = d.getTime();		
		var store = Ext.create('Ext.data.TreeStore',{
		});	
		return store;
	},
	getgrid	: function(pview,id_grid,itemdocktop)
	{
		var model_data = this.getmodel(pview);
		model_data.push('selectopts');
		var pstore = this.getstore(model_data,pview,[]).load();	
		pstore.load();
		var rgrid = Ext.create('Ext.grid.Panel',{
		});
		
		rgrid.addDocked({
	},
	submitreject		: function(url)
	{
		var storetosubmit = Init.storeGridCopy;
		var dataobj = [];
		var datasbumit;
		storetosubmit.each(function(record){
		});
		datasubmit = Ext.encode(dataobj);
		var params = {
		}
		this.savedata(params,url);
		var name = ''+Init.idmenu+'tabreject';
		var tabPanelas = Ext.getCmp('contentcenter');
		var items = tabPanelas.items.items;
		var exist = false;
		for(var i = 0; i < items.length; i++)
		{
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
                    vtype: 'email',
                    allowBlank: false
                }, 
                    xtype: 'textfield',
                    fieldLabel: 'Subject',
                    afterLabelTextTpl: Init.required,
                    allowBlank: false
                }, {
                    xtype: 'htmleditor',
                    fieldLabel: 'Message',
                    labelAlign: 'top',		
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
                        //var oksparams = findform.getValues();
                            // In a real application, this would submit the form to the configured url
                            var storetosubmit = Init.storeGridCopy;
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
		Ext.Ajax.request({	 
		});
		returnsave = false;
		return Init.returnsave;
	encodefilter : function(params,url_params = '')
		var url = base_url+"admin/master/encodeurl";
		var data;
		//console.log(params);
		//var url = base_url+'admin/mapping/exportdatadyn';
		//this.savedata(params,url);
		if(url_params == '')
		{
		}else
		{
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
		Ext.each(columns, function(data) {
		//console.log(Ext.encode(itemcolumns));
		if(typeof  view != 'undefined')
		{
		}
		extraParams.datainput = Ext.encode(itemcolumns);
		extraParams.title 	  = title;
		//console.log(extraParams);
		this.encodefilter(extraParams,url_params);
	
	{
		//console.log("oko");
		var gridhourly = Init.gridgaskomphourly;
		var storeHourlykelengkapan =  gridhourly.getStore();			
		storeHourlykelengkapan.getProxy().extraParams = {
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
		items		: [{
	},
	
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
		var d = new Date(date),

		if (month.length < 2) month = '0' + month;
		if (day.length < 2) day = '0' + day;
		return [year, month, day].join('-');
	},
	{
		Init.vgrid = id_grid;
		Init.gstore = pview;
		var field = this.getcolumn(pview);
		var store = new Ext.data.SimpleStore({
		});
		var editing = Ext.create('Ext.grid.plugin.RowEditing', {
		  clicksToEdit: 2,
		  listeners :
		});
		store.loadData(field);
		var grid = new Ext.grid.GridPanel({
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
                defaultFocus: 'Email Address',
        });
		win.show();
		return field;
	},
	getlisfieldform : function(pview,id_grid)
		//console.log(pview);
		//console.log(id_grid);
		Init.vgrid = id_grid;
		Init.gstore = pview;
		
		var field = this.getcolumn(pview);
		var store = new Ext.data.SimpleStore({
		});
		var editing = Ext.create('Ext.grid.plugin.RowEditing', {
		  clicksToEdit: 2,
		  listeners :
		});
		store.loadData(field);
		var grid = new Ext.grid.GridPanel({
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
                defaultFocus: 'Email Address',
        });
		win.show();
		return field;
	},
	getgridform : function (pview,id_grid)
	{
		Init.vgrid = id_grid;
		Init.gstore = pview;
		var field = this.getcolumn(pview);
		});
		var editing = Ext.create('Ext.grid.plugin.RowEditing', {
		  listeners :
		});
		store.loadData(field);
		var grid = new Ext.grid.GridPanel({
					});
					return grid;
	{
		var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
		var items_form = this.getcolumngrid(id_form,v_table);
		//console.log(items_form);
		var n = 0;
		for (var prop in items_form) {
		}
		var formsearc = Ext.create('Ext.form.Panel',{
		});
		var n = 0;
		for (var prop in items_form) {
					}
					formsearc.addDocked({
					});
					return formsearc;
	},
	getformcreatepeng : function(v_table,id_form,button_items,toolbar)
					var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
					var items_form = this.getcolumngrid(id_form,v_table);
					//console.log(items_form);
		var n = 0;
		
		
		for (var prop in items_form) {
		}
		var formsearc = Ext.create('Ext.form.Panel',{
		});
		var n = 0;
		for (var prop in items_form) {
	}
		formsearc.addDocked({
		});
		return formsearc;
	},
	getformsearch : function(v_table,id_form,button_items,toolbar)
	{
		var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
		var items_form = this.getcolumngrid(id_form,v_table);
		console.log(items_form);
		var n = 0;
		for (var prop in items_form) {
		}
		
		var formsearc = Ext.create('Ext.form.Panel',{
					});
					var n = 0;
					for (var prop in items_form) {
		}
		/* formsearc.addDocked({
		}); */
		return formsearc;
	},
	getformsearchpeng : function(v_table,id_form,button_items,toolbar,parid)
	{
		var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
		var items_form = this.getcolumngrid(id_form,v_table);
		console.log(items_form);
		var n = 0;
		for (var prop in items_form) {
		}
		
		var formsearc = Ext.create('Ext.form.Panel',{
		});
		var n = 0;
		for (var prop in items_form) {
		/* formsearc.addDocked({
		}); */
		return formsearc;
	},
	getitemsform : function(v_table,id_form)
		var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
		var items_form = this.getcolumngrid(id_form,v_table);
		console.log(items_form);
		var n = 0;
		
		for (var prop in items_form) {
		}
	    return items_form;
	},	
	getformsearchpeng1 : function(items_form)
		var formsearc = Ext.create('Ext.form.Panel',{
					});
					var n = 0;
					for (var prop in items_form) {
		}
		/* formsearc.addDocked({
			}); */
		return formsearc;
	},
	getformupdate : function(v_table,id_form,button_items,toolbar)
	{
		var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
		var items_form = this.getcolumngrid(id_form,v_table);
		console.log(items_form);
		var n = 0;
		
		for (var prop in items_form) {
		}
		var formsearc = Ext.create('Ext.form.Panel',{
		});
		formsearc.addDocked({
		});
		return formsearc;
	},
	getformupdatepeng : function(v_table,id_form,button_items,toolbar)
	{
		var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
		var items_form = this.getcolumngrid(id_form,v_table);
		console.log(items_form);
		var n = 0;
		
		for (var prop in items_form) {
		}
		var formsearc = Ext.create('Ext.form.Panel',{
		});
		formsearc.addDocked({
		});
		return formsearc;
	},
	gettoolbar	: function(insert,update,id_grid,tbl)
	{
		var msclass = this;
		var toolbar = [
		{ 
		{
		},'-',
		{
		},'-',
		{
		},'-',
		{
		},'-',
		{
		},'-',
		{
		}*/
		];
		return toolbar;
	},
	gettoolbarpeng	: function(insert,update,id_grid,tbl)
	{
		var msclass = this;
		var toolbar = [
		{ 
		{
		},'-',
		{
		}/*,'-',
		{
		},'-',
		{
		},'-',
		{
		}*/
		];
		return toolbar;
	},
	gettoolbarsearch	: function()
	{
		var search = [{
		return search;	
	},
	
	{
		var d = new Date();
		var n = d.getTime();
		var store = Ext.create('Ext.data.TreeStore',{
		});	
		return store;
	},
	
	{
		var tabPanel 	= Ext.getCmp('contentcenter');
		tabPanel.items.each(function(c){
		});
		var items = tabPanel.items.items;
		var exist = false;
		var msclass 	= Ext.create('master.global.geteventmenu');
	},
	getgridpeng	: function(cgrid,id_grid,itemdocktop,pstore, group = {ftype: 'summary',dock: 'bottom'})
	{		
		var groupingFeature = Ext.create('Ext.grid.feature.Grouping',{
		//console.log(group);	
		var rgrid = Ext.create('Ext.grid.Panel',{
		});
		Ext.grid.Lockable.injectLockable
	},
	getformcreatepeng1 : function(items_form,idfrm)
	{
		
					});
					var n = 0;
					for (var prop in items_form) {
		}
		/* formsearc.addDocked({
		}); */
		return formsearc;
	},
	getformupdatepeng1 : function(items_form,idfrm)
		var formsearc = Ext.create('Ext.form.Panel',{
						});
						var n = 0;
						for (var prop in items_form) {
		}
		/* formsearc.addDocked({
		}); */
		return formsearc;
	}	
});