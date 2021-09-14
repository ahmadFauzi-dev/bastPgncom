Ext.define('simpel.surat_keluar.gridworkflowdetail' ,{
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
	
	var dmodel = msclass.getmodel('v_jabatan');
	var storediv =  msclass.getstore(dmodel,'v_jabatan',filter);
	
	storediv.getProxy().extraParams = {
						view :'v_jabatan',
						limit : 'All',
						"filter[0][field]" : "id_perusahaan",
						"filter[0][data][type]" : "string",
						"filter[0][data][comparison]" : "eq",
						"filter[0][data][value]" : 'MD298'
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
								dataIndex	: coldisplay[2].dataIndex
				};
				
				coldisplay[3] = { 	
								text : 'Jabatan',
								width:100,
								dataIndex	: coldisplay[15].dataIndex
				};
				coldisplay[4] = {
					text : 'Nama User',
					width:100,
					dataIndex	: coldisplay[10].dataIndex
				};
				
				coldisplay[5].hidden = true;
				coldisplay[6].hidden = true;
				coldisplay[7].hidden = true;
				coldisplay[8].hidden = true;
				coldisplay[9] = {
					text : 'Event',
					width:100,
					dataIndex	: coldisplay[9].dataIndex
				};
				coldisplay[10].hidden = true;
				coldisplay[11].hidden = true;
				coldisplay[12].hidden = true;
				coldisplay[13] = {
					text : 'Status',
					width:100,
					align : 'center',
					dataIndex	: coldisplay[13].dataIndex,
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
				coldisplay[14].hidden = true;
				coldisplay[15].hidden = true;
				coldisplay[16].hidden = true;
				coldisplay[17].hidden = true;
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
			id			: 'gridworkflowdetail'+pageId,
			plugins		: editing,	
			dockedItems	: [
				{
					xtype: 'toolbar',
					items	: [
					{
						text	: 'Add',
						iconCls	: 'add',
						id	: 'addworkflowdetail',
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
									user_id : '',
									createbyt : ''
							}
							store.insert(0, r);								
						}
					},
					{
							text	: 'Delete',
							iconCls	: 'bin',
							id	: 'deleteworkflowdetail',
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
			],
			columns		: columns,
			listeners	: {
				itemdblclick:function(model, record, index, eOpts)
				{
					//record.data.rowid;
					//console.log(record.data);
				}
			}
		});
		this.callParent(arguments);
	}
});