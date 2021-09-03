Ext.define('masterdata.view.grid_divisi' ,{
			extend: 'Ext.tree.Panel',
			initComponent	: function()
			{
			var pageId = Init.idmenu;
			var msclass = Ext.create('master.global.geteventmenu'); 
			
			var gmodel 			=  msclass.getmodel('v_divisi');			
			var listdivisiGrid 	=  msclass.gettreestore(gmodel,'v_divisi',[]);
			listdivisiGrid.getProxy().extraParams = {
									view :'v_divisi',									
									"filter[0][field]" : "id_perusahaan",
									"filter[0][data][type]" : "string",
									"filter[0][data][comparison]" : "eq",
									"filter[0][data][value]" : '0'
			};
			listdivisiGrid.load();
								
			Ext.apply(this,{
				rootVisible : false,
				//title : 'Divisi',
				id		: 'griddivisi'+pageId,
				viewConfig: {
					plugins: [{ ptype: 'treeviewdragdrop' }],
					listeners : {
						 beforedrop: function(node, data, overModel, dropPosition,  dropFunction,  eOpts){
							
							//console.log(data.records[0].internalId);
							//console.log( overModel.internalId);
							var drop_id = data.records[0].internalId;	
							var target_id = overModel.internalId;					   
							Ext.Ajax.request({ 
								url: base_url+'admin/dragdrop',
								params:{'drop_id' : drop_id , 'target_id' : target_id,'wr' : 'rowid', 'tb' : 'mst_divisi'},
								success: function(response){
									return true;
								},
								failure:function(form, action)
								{
									//Ext.Msg.alert('Fail !','Input Data Entry Fail');
									//Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");
									return false;
								}
							});
						}
					}
				}, 
				dockedItems: [{
					xtype: 'toolbar',
					items: [
					{
						xtype: 'button',
						text	: 'Add',
						icon		: ''+base_url+'asset/ico/13.ico',
						handler		: function(grid, rowIndex, colIndex)
						{
							if(!Init.winss_adddivisi)
							{
								var griddivisi = Ext.create('masterdata.view.form_add_divisi');
								Init.winss_adddivisi = Ext.widget('window', {
									title		: "Add Divisi",
									closeAction	: 'hide',
									width		: 450,
									height		: 300,
									autoScroll	: true,
									//id			: ''+Init.idmenu+'winmapppelsource',
									resizable	: true,
									modal		: true,
									bodyPadding	: 5,
									layout		: 'fit',
									items		: griddivisi
								});
							}
							Init.winss_adddivisi.show();
							Ext.getCmp('parent'+pageId).setValue('0');
							Ext.getCmp('parent_name'+pageId).hide();
							Ext.getCmp('id_perusahaan'+pageId).setValue(Init.id_perusahaans);
						}
					}],
				}],
				store: listdivisiGrid,
				columns		: [
				{
					xtype	: 'treecolumn',
					text		: 'Nama Divisi',
					dataIndex	: 'nama_divisi',
					width		: 300				
				},
				{
					text		: 'Code',
					align		:'center',
					dataIndex	: 'code',
				},
				{
					text		: 'Tipe',
					align		:'center',
					dataIndex	: 'nama_typedivisi',
				},
				{
					text		: 'Pimpinan',
					align		:'center',
					dataIndex	: 'nama_kepala',
				},
				{
					text		: 'Sekertaris',
					align		:'center',
					dataIndex	: 'nama_sekertaris',
				},
				{
					text		: 'No Surat',
					align		:'center',
					dataIndex	: 'last_numbersk',
				},
				{
					text		: 'No Disposisi',
					align		:'center',
					dataIndex	: 'last_numberdispo',
				},
				{
					xtype	: 'actioncolumn',
					text		:'Add',
					align		: 'center',
					items	: [{
						icon		: ''+base_url+'asset/ico/13.ico',
						tooltip 	: 'Add',
						width 	: 20,
						align 	: 'center',
						handler  : function(grid, rowIndex, colIndex)
						{
							var rec = grid.getStore().getAt(rowIndex);
							var rowid = rec.get('id');
							var parent = rec.get('parent');
							var nama = rec.get('nama_divisi');
							var id_perusahaan = rec.get('id_perusahaan');
							
							if(!Init.winss_adddivisi)
							{
								var griddivisi = Ext.create('masterdata.view.form_add_divisi');
								Init.winss_adddivisi = Ext.widget('window', {
									title		: "Add divisi",
									closeAction	: 'hide',
									width		: 450,
									height		: 300,
									autoScroll	: true,
									//id			: ''+Init.idmenu+'winmapppelsource',
									resizable	: true,
									modal		: true,
									bodyPadding	: 5,
									layout		: 'fit',
									items		: griddivisi
								});
							}
							Init.winss_adddivisi.show();
							Ext.getCmp('rowid'+pageId).setValue('');
							Ext.getCmp('code'+pageId).setValue('');
							Ext.getCmp('parent'+pageId).setValue(rowid);
							Ext.getCmp('name'+pageId).setValue('');
							Ext.getCmp('parent_name'+pageId).setValue(nama);
							Ext.getCmp('parent_name'+pageId).show();
							Ext.getCmp('id_perusahaan'+pageId).setValue(id_perusahaan);
							Ext.getCmp('last_numbersk'+pageId).hide();
							Ext.getCmp('last_numberdispo'+pageId).hide();
						}
					}]
				},
				{
					xtype	: 'actioncolumn',
					text	:'Update',
					align	: 'center',
					items : [{
						icon : ''+base_url+'asset/ico/2.ico',
						tooltip : 'Update',
						width : 20,
						handler : function(grid, rowIndex, colIndex)
						{
							var rec = grid.getStore().getAt(rowIndex);
							var rowid = rec.get('id');
							var parent = rec.get('parent');
							var nama = rec.get('nama_divisi');
							var id_perusahaan = rec.get('id_perusahaan');
							var id_typedivisi = rec.get('id_typedivisi');
							var reffkepala = rec.get('reffkepala');
							var reffsekertaris = rec.get('reffsekertaris');
							var code = rec.get('code');
							var last_numbersk = rec.get('last_numbersk');
							var last_numberdispo = rec.get('last_numberdispo');
							//console.log(rec);
							
							if(!Init.winss_adddivisi)
							{
								var griddivisi = Ext.create('masterdata.view.form_add_divisi');
								Init.winss_adddivisi = Ext.widget('window', {
									title			: "Update divisi",
									closeAction	: 'hide',
									width			: 450,
									height		: 300,
									autoScroll	: true,
									//id			: ''+Init.idmenu+'winmapppelsource',
									resizable	: true,
									modal		: true,
									bodyPadding	: 5,
									layout		: 'fit',
									items		: griddivisi
								});
							}
							Init.winss_adddivisi.show();
							Ext.getCmp('rowid'+pageId).setValue(rowid);
							Ext.getCmp('code'+pageId).setValue(rowid);
							Ext.getCmp('parent'+pageId).setValue(parent);
							Ext.getCmp('name'+pageId).setValue(nama);
							Ext.getCmp('id_typedivisi'+pageId).setValue(id_typedivisi);
							Ext.getCmp('id_perusahaan'+pageId).setValue(id_perusahaan);
							Ext.getCmp('code'+pageId).setValue(code);
							Ext.getCmp('parent_name'+pageId).hide();
							Ext.getCmp('reffkepala'+pageId).setValue(reffkepala);
							Ext.getCmp('reffsekertaris'+pageId).setValue(reffsekertaris);
							Ext.getCmp('last_numbersk'+pageId).setValue(last_numbersk);
							Ext.getCmp('last_numberdispo'+pageId).setValue(last_numberdispo);
							Ext.getCmp('last_numbersk'+pageId).show();
							Ext.getCmp('last_numberdispo'+pageId).show();
						}
					}]
				},
				{
					xtype	: 'actioncolumn',
					text	:'Delete',
					align	: 'center',
					items	: [{
						icon		: ''+base_url+'asset/ico/14.ico',
						tooltip		: 'Delete',
						handler		: function(grid, rowIndex, colIndex)
						{
							var rec = grid.getStore().getAt(rowIndex);
							var rowid = rec.get('id');
							
								var params = {
									"filter[0][field]" : "rowid",
									"filter[0][data][type]" : "string",
									"filter[0][data][comparison]" : "eq",
									"filter[0][data][value]" : rowid,
								}
								
								var table = 'mst_divisi';
								params.id = 'griddivisi'+pageId;
								
								msclass.deletedata(params,table,base_url+'simpel/deletedata');
								Ext.getCmp('griddivisi'+pageId).getStore().reload();
						}
					}]
				}]
			});
			this.callParent(arguments);
			}
		})
