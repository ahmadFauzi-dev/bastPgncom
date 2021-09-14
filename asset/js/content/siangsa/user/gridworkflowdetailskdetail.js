
Ext.define('siangsa.user.gridworkflowdetailskdetail' ,{
	extend: 'Ext.grid.Panel',
	initComponent	: function()
	{
	var dataselect;
	var pageId = Init.idmenu;
	
	var msclass = Ext.create('master.global.geteventmenu'); 
	var model = msclass.getmodel('v_workflowdetail');
	var columns = msclass.getcolumn('v_workflowdetail');

	var filter = [];
	var store =  msclass.getstore(model,'v_workflowdetail',filter);
	
	var dmodel = msclass.getmodel('v_karyawanjabatan');
	var storediv =  msclass.getstore(dmodel,'v_karyawanjabatan',filter);
	
	storediv.getProxy().extraParams = {
						view :'v_karyawanjabatan',
						limit : 'All',
						"filter[0][field]" : "id_perusahaan",
						"filter[0][data][type]" : "string",
						"filter[0][data][comparison]" : "eq",
						"filter[0][data][value]" : myid_perusahaan
					};
	storediv.load();

	var amodel = msclass.getmodel("fn_getdatamastertype('TOD44')");
	var storeact =  msclass.getstore(amodel,"fn_getdatamastertype('TOD44')",filter);
	storeact.load();
	
	
	var coldisplay = columns;
				//columns[0].hidden = true;//row_id
				coldisplay[1].hidden = true;//row_id
				//columns[3].text = 'Nama Pemohon';//nama_pemohon
				coldisplay[2] = { 	
								text : 'Prority',
								width:50,
								dataIndex	: columns[2].dataIndex,
								editor		: {
									xtype: 'numberfield',
									name : columns[2].dataIndex,
									maxValue: 99,
									minValue: 0
								}
				};
				
				coldisplay[3] = { 	
								text : 'Jabatan',
								width:100,
								dataIndex	: columns[3].dataIndex,
								renderer : function(value, metaData, record){
									return record.get('nama_jabatan');
								}
				};
				coldisplay[4] = {
					text : 'Event',
					width:100,
					dataIndex	: columns[4].dataIndex,
					renderer: function(value, metaData, record ){				
						var id = storeact.findRecord('id', value, 0 , false, false, true);
						return id != null ? id.get('nama') : value;
					},
					editor		: {
						xtype			: 'combobox',
						name			: columns[4].dataIndex,
						//id 				: 'reffeven'+pageId,
						store				: storeact,
						displayField	: 'nama',
						queryMode	: 'local',
						valueField		: 'id'
					}
				};
				
				coldisplay[10] = {
					text : 'Nama User',
					width:100,
					dataIndex	: columns[10].dataIndex,
					editor		: {
						xtype : 'textfield',
						name : columns[10].dataIndex,
						id : 'namauser'+pageId,
						readOnly : true
					}
				};
				
 				coldisplay[5].hidden = true;
 				coldisplay[6].hidden = true;
 				coldisplay[7].hidden = true;
				coldisplay[8].hidden = true;
				coldisplay[9].hidden = true;
				//coldisplay[10].hidden = true;
				coldisplay[11].hidden = true;
				coldisplay[12].hidden = true;
				coldisplay[13].hidden = true;
				coldisplay[14].hidden = true;
				coldisplay[15].hidden = true; 
				coldisplay[16] = {
					text : 'str_jobpos',
					width:100,
					hidden : true,
					dataIndex	: columns[16].dataIndex,
					editor		: {
						xtype : 'textfield',
						name : 'str_jobpos',
						id : 'str_jobpos'+pageId,
						hidden : true
					}
				};
				
				coldisplay[17] = {
					text : 'Status',
					width:100,
					align : 'center',
					dataIndex	: coldisplay[17].dataIndex,
					renderer: function(val, meta, record, rowIndex){
					var reffstatus			= record.data.reffstatus;
					var nama_status			= record.data.nama_status;
					//return reffstatus;
					switch (reffstatus){
						default:
								return '<img src="'+base_url+'asset/ico/51.ico" /> '+nama_status;
						break;
						
						case 'MD341':
							return '<img src="'+base_url+'asset/ico/sym_error_sqr.png" /> '+nama_status;
						break;
						
						case 'MD320':
							return '<img src="'+base_url+'asset/ico/38.ico" /> '+nama_status;
						break;
						
						case 'MD321':
							return '<img src="'+base_url+'asset/ico/59.ico" /> '+nama_status;
						break;
						
						case 'MD322':
							return '<img src="'+base_url+'asset/ico/42.ico" /> '+nama_status;
						break;
					}
				}
				};
				coldisplay[18] = {
					text : 'Deskripsi',
					width:100,
					hidden : false,
					dataIndex	: columns[18].dataIndex,
					editor		: {
						xtype : 'textfield',
						name : 'description',
						id : 'description'+pageId,
						hidden : true
					}
				};
				coldisplay[19].hidden = true; 
				coldisplay[20].hidden = true; 
				coldisplay[21].hidden = true; 
				
			var editing = Ext.create('Ext.grid.plugin.RowEditing', {
			  clicksToEdit: 2,
			  listeners :
				{					
					'edit' : function (editor,e) {
						 // console.log("asd");
						/* var grid = e.grid;
						var record = e.record;					 
						var recordData = record.data;
						recordData.id = 'gridworkflow'+pageId; */
						//msclass.savedata(recordData , base_url+'hrd/update_jabatan');
						//console.log(Ext.getCmp('id_identitas'+pageId+'add'));
					}
				}
			});	
				
	Ext.apply(this, {
			//title	: 'Email Template',
			store		: store,
			multiSelect	: true,
			//selType		: 'checkboxmodel',
			fit		: true,
			layout : 'fit',
			height : 200,
			id			: 'gridworkflowdetailskdetail'+pageId,
			plugins		: editing,	
			/* dockedItems	: [
				{
					xtype: 'toolbar',
					items	: [
					{
						text	: 'Add',
						iconCls	: 'add',
						id	: 'addworkflowdetailedit'+pageId,
						xtype	: 'button',
						handler	: function()
						{
							var r = {
								    rowid : '',
									priority : '',
									reffjabatan : '',
									reffeven : '',
									id_perusahaan : '',
									namauser : '',
									user_id : '-',
									createbyt : ''
							}
							store.insert(0, r);								
						}
					},
					{
							text	: 'Delete',
							iconCls	: 'bin',
							id	: 'deleteworkflowdetailedit'+pageId,
							xtype	: 'button',
							handler: function () {
								var grid = this.up('grid');
								if (grid) {
									var sm = grid.getSelectionModel();
									var rs = sm.getSelection();
									if (!rs.length) {
										Ext.Msg.alert('Info', 'No Records Selected');
										return;
									}
									grid.store.remove(rs[0]);
									
								}
							}
					}]
				}
			], */
			columns		: columns,
			listeners	: {
			}
		});
		this.callParent(arguments);
	}
});