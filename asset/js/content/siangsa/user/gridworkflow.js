Ext.define('siangsa.user.gridworkflow' ,{
	extend: 'Ext.grid.Panel',
	initComponent	: function()
	{
		
		var dataselect;
		var pageId = Init.idmenu;
		var msclass = Ext.create('master.global.geteventmenu'); 
		var model = msclass.getmodel('v_workflow');
		var columns = msclass.getcolumn('v_workflow');
		var filter = [];
		var store =  msclass.getstore(model,'v_workflow',filter);
		
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
			coldisplay[1].hidden = true;//row_id
			coldisplay[2].hidden = true;
			coldisplay[3].hidden = true;
			coldisplay[4] = { 	
								text : 'Jabatan',
								flex: 1,
								sortable:false,
								dataIndex	: columns[4].dataIndex,
								renderer: function(value, metaData, record ){				
									var id = storediv.findRecord('id', value, 0 , false, false, true);
									return id != null ? id.get('name') : value;
								},
								editor		: {
									xtype			: 'combobox',
									name			: columns[4].dataIndex,
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
			coldisplay[5] = {
				text : 'Nama User',
				flex: 1,
				sortable:false,
				dataIndex	: columns[5].dataIndex,
				editor		: {
						xtype : 'textfield',
						name : columns[5].dataIndex,
						id : 'namauser'+pageId,
						readOnly : true
					}
			};
			coldisplay[6].hidden = true;
			coldisplay[7].hidden = true;
			coldisplay[8].hidden = true;
			coldisplay[9].hidden = true;
			coldisplay[10].hidden = true;
			coldisplay[11].hidden = true;
			coldisplay[12].hidden = true;
			coldisplay[14].hidden = true;
			coldisplay[15].hidden = true; 
			
			coldisplay[13].hidden = true;
			
			coldisplay[16] = {
					text : 'Jabatan',
					flex: 1,
					sortable:false,
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
				text : 'Deskripsi',
				flex: 2,
				hidden : false,
				sortable:false,
				dataIndex	: columns[17].dataIndex,
				editor		: {
						xtype : 'textfield',
						name : 'description',
						id : 'description'+pageId,
						hidden : true
					}
			};
			coldisplay[18].hidden = true;
			
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
				plugins		: editing,	
				multiSelect	: true,
				//selType		: 'checkboxmodel',
				fit		: true,
				layout : 'fit',
				height : 200,
				id			: 'gridworkflow'+pageId,
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