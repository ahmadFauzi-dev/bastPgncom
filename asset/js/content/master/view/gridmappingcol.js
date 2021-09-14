Ext.define('master.view.gridmappingcol' ,{
    extend: 'Ext.grid.Panel',
    initComponent: function() {
	
	Ext.define('mmappingcol',{
		extend	: 'Ext.data.Model',
		fields	: ["fromtable","streamfield","variable","formula","typeperiod"]
	});
	
	var storeshowmappingcol = Ext.create('Ext.data.JsonStore',{
				model	: 'mmappingcol',
				proxy	: {
				type			: 'pgascomProxy',
				url				: base_url+'admin/showmappingcol',
				extraParams 	: {id : '24'},
				reader: {
					type: 'json',
					root: 'data'
				}
				}
	});
	
	storeshowmappingcol.load();
		Ext.apply(this, {
			store		: storeshowmappingcol,
			title		: 'Mapping Variable',
			height		: 400,
			multiSelect	: true,
			//layout		: 'fit',
			autoScroll	: true,
			id			: 'gridstationconfigdetail',
			tbar		: [{
				text	: 'Add',
				iconCls : 'add',
				handler	: function()
				{
					var r = Ext.create('mmappingcol',{
								fromtable	: '',
								streamfield	: '',
								variable	: '',
								formula		: '',
								typeperiod	: ''
							});
							
					storeshowmappingcol.insert(0, r);
					
					/*
					var formaddconfig = Ext.create('master.view.formaddconfig');
					
					win = Ext.widget('window', {
						title		: 'Detail Config',
						width		: 600,
						height		: 400,
						autoScroll	: true,
						id			: "windetrole",
						resizable	: true,
						modal		: true,
						bodyPadding	: 5,
						items		: [formaddconfig]
					});
					win.show();
					*/
					//console.log(idrow);
				}
			}],
			columns		: [
			Ext.create('Ext.grid.RowNumberer'),
			{
				"text"		: "Table Field",
				"dataIndex" : "fromtable",
				flex		: 1,
				editor		: 
				{
					xtype	: 'textfield',
					name	: 'fromtable'
				}
			},
			{
				"text"		: "Stream Field",
				"dataIndex" : "streamfield",
				flex		: 1,
				editor		: 
				{	
					xtype	: 'textfield',
					name	: 'streamfield'
				}
			},
			{
				"text"		: "Variable",
				"flex"		: 1,
				"dataIndex" : "variable",
				editor		: 
				{
					xtype	: 'textfield',
					name	: 'variable'
				}
			},
			{
				"text"		: "Periode",
				"flex"		: 1,
				"dataIndex"	: "typeperiod",
				editor		: 
				{
					xtype	: 'textfield',
					name	: 'typeperiod'
				}
			},
			{
				"text"		: "Formula",
				"flex"		: 1,
				"dataIndex"	: "formula",
				editor		: {
					xtype	: 'textfield',
					name	: 'formula'
				}
			}],
			plugins	: [
					  Ext.create('Ext.grid.plugin.RowEditing', {
					  clicksToEdit: 2,
					  listeners :
						{					
							'edit' : function (editor,e) {
									 
									 var grid 	= e.grid;
									 var record = e.record;
									 
									var recordData = record.data; 
								Ext.Ajax.request({ 
									
									url: base_url+'admin/updatemappcol',
									method: 'POST',
									params: recordData,
									success: function(response,requst){
										//workflowGrid.load();
										//console.log(response.text);
										//alert('test');
										storeshowmappingcol.reload();
									},
									failure:function(response,requst)
									{
										Ext.Msg.alert('Fail !','Input Data Entry Gagal');
										Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");
									}
												
								})	 
							}
						}
					})],
			bbar	: Ext.create('Ext.PagingToolbar', {
				pageSize: 10,
				store: storeshowmappingcol,
				displayInfo: true
			})
		});

        this.callParent(arguments);
    }
});