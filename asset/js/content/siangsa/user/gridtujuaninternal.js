Ext.define('siangsa.user.gridtujuaninternal' ,{
	extend: 'Ext.grid.Panel',
	initComponent	: function()
	{
		var dataselect;
		var msclass = Ext.create('master.global.geteventmenu'); 
		var model = msclass.getmodel('tbl_tujuaninternal');
		var columns = msclass.getcolumn('tbl_tujuaninternal');
		//var winss;
		var filter = [];
		var store =  msclass.getstore(model,'tbl_tujuaninternal',filter);
		
		var dmodel = msclass.getmodel('v_griddivisi');
		var storediv =  msclass.getstore(dmodel,'v_griddivisi',filter);
		var pageId = Init.idmenu;
		
		storediv.getProxy().extraParams = {
						view :'v_griddivisi',
						limit : "All",
						"filter[0][field]" : "id_perusahaan",
						"filter[0][data][type]" : "string",
						"filter[0][data][comparison]" : "eq",
						"filter[0][data][value]" : myid_perusahaan
		};
		storediv.load();

		var coldisplay = columns;
					columns[0].hidden = true;//row_id
					columns[1].hidden = true;//row_id
					//columns[3].text = 'Nama Pemohon';//nama_pemohon
					columns[2] = { 	
											text : 'Divisi',
											width:250,
											sortable:false,
											dataIndex	: columns[2].dataIndex,
											renderer: function(value, metaData, record ){				
												var id = storediv.findRecord('rowid', value, 0 , false, false, true);
												return id != null ? id.get('name') : value;
											},
											editor		: {
												xtype			: 'combobox',
												name			: columns[2].dataIndex,
												store				: storediv,
												displayField	: 'name',
												queryMode	: 'local',
												valueField		: 'rowid',
												listeners: {
													select: function(cmb, record, index){
															//console.log(record[0].data.name_organization);
															var name = record[0].data.name;
															var reffkepala = record[0].data.reffkepala;
															var reffsekertaris = record[0].data.reffsekertaris;
															var nama_kepala = record[0].data.nama_kepala;
															var nama_sekertaris = record[0].data.nama_sekertaris;
															
															Ext.getCmp('str_satuankerjat'+pageId).setValue(name);
															Ext.getCmp('reffkepalat'+pageId).setValue(reffkepala);
															Ext.getCmp('reffsekertarist'+pageId).setValue(reffsekertaris);
															Ext.getCmp('nama_kepalat'+pageId).setValue('');
															Ext.getCmp('nama_kepalat'+pageId).setValue(nama_kepala);
															Ext.getCmp('nama_sekertarist'+pageId).setValue(nama_sekertaris);
													}
												}	
											}
					};
					coldisplay[3] = {
						text : 'str_satuankerja',
						width:100,
						hidden : true,
						sortable:false,
						dataIndex	: coldisplay[3].dataIndex,
						editor		: {
							xtype : 'textfield',
							name : coldisplay[3].dataIndex,
							id : 'str_satuankerjat'+pageId,
							readOnly : true
						}
					};
					coldisplay[4].hidden = true;
					coldisplay[5].hidden = true;
					coldisplay[6].hidden = true;
					coldisplay[7].hidden = true;
					coldisplay[8].hidden = true;
					coldisplay[9].hidden = true;
					coldisplay[10].hidden = true;
					coldisplay[11].hidden = true;
					coldisplay[12] = {
						text : 'reffkepala',
						width:100,
						hidden : true,
						sortable:false,
						dataIndex	: coldisplay[12].dataIndex,
						editor		: {
							xtype : 'textfield',
							allowBlank: false,
							name : coldisplay[12].dataIndex,
							id : 'reffkepalat'+pageId,
							readOnly : true
						}
					};
					coldisplay[13] = {
						text : 'reffsekertaris',
						width:100,
						sortable:false,
						hidden : true,
						dataIndex	: coldisplay[13].dataIndex,
						editor		: {
							xtype : 'textfield',
							name : coldisplay[13].dataIndex,
							id : 'reffsekertarist'+pageId,
							readOnly : true
						}
					};
					coldisplay[14] = {
						text : 'Pemimpin',
						width:100,
						sortable:false,
						hidden : false,
						dataIndex	: coldisplay[14].dataIndex,
						editor		: {
							xtype : 'textfield',
							name : coldisplay[14].dataIndex,
							
							id : 'nama_kepalat'+pageId,
							//readOnly : true
						}
					};
					
					coldisplay[15] = {
						text : 'Sekretaris',
						width:100,
						sortable:false,
						hidden : false,
						dataIndex	: coldisplay[15].dataIndex,
						editor		: {
							xtype : 'textfield',
							name : coldisplay[15].dataIndex,
							allowBlank: true,
							id : 'nama_sekertarist'+pageId,
							readOnly : true
						}
					};
					
				var editing = Ext.create('Ext.grid.plugin.RowEditing', {
				  clicksToEdit: 2,
				  listeners :
					{					
						'edit' : function (editor,e) {
							 console.log(editor);
							/* var grid = e.grid;
							var record = e.record;					 
							var recordData = record.data;
							recordData.id = 'gridtembusaninternal'+pageId; */
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
				id			: 'gridtujuaninternal'+pageId,
				plugins		: editing,	
				dockedItems	: [
					{
						xtype: 'toolbar',
						items	: [
						{
							text	: 'Add',
							iconCls	: 'add',
							id : 'addtujuaninternal',
							xtype	: 'button',
							handler	: function()
							{
								var r = {
										rowid : '',
										reffsatuankerja : '',
										reffkepala : '--',
										nama_kepala : ''
								}
								store.insert(0, r);								
							}
						},
						{
								text	: 'Delete',
								iconCls	: 'bin',
								id : 'deletetujuaninternal',
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