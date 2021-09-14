Ext.define('masterdata.view.gridvendor' ,{
	extend: 'Ext.grid.Panel',
	initComponent	: function()
	{
		
		var pageId = Init.idmenu;
		var msclass = Ext.create('master.global.geteventmenu'); 
		var model = msclass.getmodel('v_vendor');
		var columns = msclass.getcolumn('v_vendor');
		var filter = [];
		var store =  msclass.getstore(model,'v_vendor',filter);
		 store.load();		 
	
		var coldisplay = columns;
			coldisplay[1].hidden = true;
			coldisplay[2] = {
					text : 'Nama',
					width:300,
					sortable:false,
					dataIndex	: columns[2].dataIndex,
					editor		: {
						xtype : 'textfield',
						name : 'nama_vendor',
						id : 'nama_vendor'+pageId,
					}
			};
			coldisplay[3] = {
					text : 'Npwp',
					width:150,
					sortable:false,
					dataIndex	: columns[3].dataIndex,
					editor		: {
						xtype : 'textfield',
						name : 'npwp',
						id : 'npwp'+pageId,
					}
				};
			
			coldisplay[4] = {
				text : 'Alamat',
				width:500,
				sortable:false,
				dataIndex	: columns[4].dataIndex,
				editor		: {
						xtype : 'textfield',
						name : 'alamat',
						id : 'alamat'+pageId
					}
			};
			coldisplay[5].hidden = true;
			coldisplay[6].hidden = true;
			coldisplay[7].hidden = true;
			coldisplay[8].hidden = true;
			coldisplay[9].hidden = true;
			coldisplay[10].hidden = true;
			
			
			var editing = Ext.create('Ext.grid.plugin.RowEditing', {
			  clicksToEdit: 2,
			  listeners :
				{					 
					'edit' : function (editor,e) {
						 // console.log("asd");
						var grid = e.grid;
						var record = e.record;					 
						var recordData = record.data;
						recordData.id = 'gridvendor'+pageId;
						msclass.savedata(recordData , base_url+'masterdata/insert_vendor');
						//console.log(Ext.getCmp('id_identitas'+pageId+'add'));
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
				height : 380,
				id			: 'gridvendor'+pageId,
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
							var r = {
								    rowid : '',
									nama_vendor : '',
									alamat : '',
									npwp : ''
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

									var table = 'tb_vendor';
									params.id = 'gridvendor'+pageId;								
									msclass.deletedata(params,table,base_url+'masterdata/deletedata');
								}
							}
					}]
				}
			],
			listeners	: {
					select: function (model, record, index, eOpts) {
							//console.log(record.get('rowid'));
							var rowid = record.get('rowid');
							if (rowid != ''){
								var storevendor = Ext.getCmp('gridpic'+pageId).getStore();
								storevendor.getProxy().extraParams = {
									view	: 'tb_vendordir',
									limit : 'all',
									"filter[0][field]" : "reffvendor",
									"filter[0][data][type]" : "numeric",
									"filter[0][data][comparison]" : "eq",
									"filter[0][data][value]" :  rowid
								};
								storevendor.load();
							}
					}
			},
			bbar: Ext.create('Ext.PagingToolbar', {
				pageSize: 10,
				store: store,
				displayInfo: true
			})
			});
			this.callParent(arguments);
	}
});