Ext.define('masterdata.view.gridpic' ,{
	extend: 'Ext.grid.Panel',
	initComponent	: function()
	{
		
		var pageId = Init.idmenu;
		var msclass = Ext.create('master.global.geteventmenu'); 
		var model = msclass.getmodel('tb_vendordir');
		var columns = msclass.getcolumn('tb_vendordir');
		var filter = [];
		var store =  msclass.getstore(model,'tb_vendordir',filter);
		//store.load();		 
	
		var coldisplay = columns;
			coldisplay[1].hidden = true;
			coldisplay[2] = {
					text : 'Nama PIC',
					width:300,
					sortable:false,
					dataIndex	: columns[2].dataIndex,
					editor		: {
						xtype : 'textfield',
						name : 'nama',
						id : 'nama'+pageId
					}
			};
			coldisplay[3] = {
					text : 'Jabatan',
					width:400,
					sortable:false,
					dataIndex	: columns[3].dataIndex,
					editor		: {
						xtype : 'textfield',
						name : 'jabatan',
						id : 'jabatan'+pageId
					}
				};
			
			coldisplay[4].hidden = true;
			coldisplay[5].hidden = true;
			coldisplay[6].hidden = true;
			coldisplay[7].hidden = true;
			coldisplay[8].hidden = true;
			
			
			var editing = Ext.create('Ext.grid.plugin.RowEditing', {
			  clicksToEdit: 2,
			  listeners :
				{					 
					'edit' : function (editor,e) {
						var grid = e.grid;
						var record = e.record;					 
						var recordData = record.data;
						recordData.id = 'gridpic'+pageId;
						msclass.savedata(recordData , base_url+'masterdata/insert_pic');
					}
				}
			});	
			
			Ext.apply(this, {
				//title	: 'Email Template',
				store		: store,
				plugins		: editing,	
				multiSelect	: true,
				//selType		: 'checkboxmodel',
				fit		: true,
				layout : 'fit',
				height : 130,
				id			: 'gridpic'+pageId,
				columns		: coldisplay,
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
							var grid = Ext.getCmp('gridvendor'+pageId);
							var rec = grid.getView().getSelectionModel().getSelection()[0];
							var id 	= rec.get('rowid');
							var r = {
								    rowid : '',
									nama : '',
									jabatan : '',
									reffvendor : id
							}
							store.insert(0, r);								
						}
					},
					{
							text	: 'Delete',
							iconCls	: 'bin',
							xtype	: 'button',
							handler: function () {
								var grid = this.up('grid');
								if (grid) {
								var rec = grid.getView().getSelectionModel().getSelection()[0];
									var id 	= rec.get('rowid');
									
									var params = {
										"filter[0][field]" : "rowid",
										"filter[0][data][type]" : "string",
										"filter[0][data][comparison]" : "eq",
										"filter[0][data][value]" : id,
									}

									var table = 'tb_vendordir';
									params.id = 'gridpic'+pageId;								
									msclass.deletedata(params,table,base_url+'masterdata/deletedata');
								}
							}
					}]
				}
			]
			});
			this.callParent(arguments);
	}
});