Ext.define('siangsa.user.gridworkflowedit' ,{
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
		 //store.load();		 
	
		var dmodel = msclass.getmodel('v_karyawanjabatan');
		var storediv =  msclass.getstore(dmodel,'v_karyawanjabatan',filter);
		storediv.getProxy().extraParams = {
							view :'v_karyawanjabatan',
							limit : 'All',
							"filter[0][field]" : "id_perusahaan",
							"filter[0][data][type]" : "string",
							"filter[0][data][comparison]" : "eq",
							"filter[0][data][value]" : 'MD298',
							"filter[1][field]" : "parent",
							"filter[1][data][type]" : "string",
							"filter[1][data][comparison]" : "eq",
							"filter[1][data][value]" : '34',
						};
		storediv.load();
		
		var amodel = msclass.getmodel("fn_getdatamastertype('TOD44')");
		var storeact =  msclass.getstore(amodel,"fn_getdatamastertype('TOD44')",filter);
		storeact.load();
	
			var coldisplay = columns;
				//columns[0].hidden = true;//row_id
				coldisplay[1].hidden = true;//row_id
				//columns[3].text = 'Nama Pemohon';//nama_pemohon
				coldisplay[2].hidden = true;
				
				coldisplay[3] = { 	
								text : 'Jabatan',
								width:100,
								dataIndex	: columns[3].dataIndex,
								renderer: function(value, metaData, record ){				
									var id = storediv.findRecord('id', value, 0 , false, false, true);
									return id != null ? id.get('name') : value;
								},
								editor		: {
									xtype			: 'combobox',
									name			: columns[3].dataIndex,
									store				: storediv,
									displayField	: 'name',
									queryMode	: 'local',
									valueField		: 'id' ,
									listeners: {
										select: function(cmb, record, index){
												//console.log(record[0].data.name_organization);
												var name = record[0].data.name;
												var namakaryawan = record[0].data.namakaryawan;
												var user_id = record[0].data.user_id;
												Ext.getCmp('namauser'+pageId).setValue(namakaryawan);
												//Ext.getCmp('user_id'+pageId).setValue(user_id);
												Ext.getCmp('str_jobpos'+pageId).setValue(name); 
												
										}
									}
								}
				};
				
				coldisplay[4].hidden = true;
				
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
				
				coldisplay[17].hidden = true;
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
				coldisplay[22].hidden = true; 
				coldisplay[23].hidden = true; 
			
			var editing = Ext.create('Ext.grid.plugin.RowEditing', {
			  clicksToEdit: 2,
			  listeners :
				{					 
					'edit' : function (editor,e) {
						 // console.log("asd");
						/* var grid = e.grid;
						var record = e.record;					 
						var recordData = record.data;
						recordData.id = 'gridworkflowedit'+pageId; */
						//msclass.savedata(recordData , base_url+'hrd/update_jabatan');
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
				height : 200,
				id			: 'gridworkflowedit',
				columns		: columns,
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
			]
			});
			this.callParent(arguments);
	}
});