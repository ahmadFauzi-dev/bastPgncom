Ext.define('masterdata.view.grid_jabatan' ,{
			extend: 'Ext.tree.Panel',
			initComponent	: function()
			{
			var pageId = Init.idmenu;
			var msclass = Ext.create('master.global.geteventmenu'); 
			
			var gmodel 			=  msclass.getmodel('v_jabatan');			
			var listjabatanGrid 	=  msclass.gettreestore(gmodel,'v_jabatan',[]);
			listjabatanGrid.getProxy().extraParams = {
									view :'v_jabatan',									
									"filter[0][field]" : "id_perusahaan",
									"filter[0][data][type]" : "string",
									"filter[0][data][comparison]" : "eq",
									"filter[0][data][value]" : '0'
			};
			listjabatanGrid.load(); 
								
			Ext.apply(this,{
				rootVisible : false,
				//title : 'jabatan',
				id		: 'gridjabatan'+pageId,
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
								params:{'drop_id' : drop_id , 'target_id' : target_id,'wr' : 'rowid', 'tb' : 'mst_jabatan'},
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
							if(!Init.winss_addjabatan)
							{
								var gridjabatan = Ext.create('masterdata.view.form_add_jabatan');
								Init.winss_addjabatan = Ext.widget('window', {
									title		: "Add jabatan",
									closeAction	: 'hide',
									width		: 450,
									height		: 200,
									autoScroll	: true,
									//id			: ''+Init.idmenu+'winmapppelsource',
									resizable	: true,
									modal		: true,
									bodyPadding	: 5,
									layout		: 'fit',
									items		: gridjabatan
								});
							}
							Init.winss_addjabatan.show();
							Ext.getCmp('parent'+pageId).setValue('0');
							Ext.getCmp('parent_name'+pageId).hide();
							Ext.getCmp('divisi_id'+pageId).setValue('');
							Ext.getCmp('pangkat_id'+pageId).setValue('');
							Ext.getCmp('id_perusahaan'+pageId).setValue(Init.id_perusahaans);
						}
					}],
				}],
				store: listjabatanGrid,
				columns		: [
				{
					xtype	: 'treecolumn',
					text		: 'Nama jabatan',
					dataIndex	: 'name',
					width		: 300				
				},
				{
					text		: 'Code',
					align		:'center',
					dataIndex	: 'code',
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
							var name = rec.get('name');
							
							if(!Init.winss_addjabatan)
							{
								var gridjabatan = Ext.create('masterdata.view.form_add_jabatan');
								Init.winss_addjabatan = Ext.widget('window', {
									title		: "Add jabatan",
									closeAction	: 'hide',
									width		: 450,
									height		: 200,
									autoScroll	: true,
									//id			: ''+Init.idmenu+'winmapppelsource',
									resizable	: true,
									modal		: true,
									bodyPadding	: 5,
									layout		: 'fit',
									items		: gridjabatan
								});
							}
							Init.winss_addjabatan.show();
							
							Ext.getCmp('rowid'+pageId).setValue('');
							Ext.getCmp('parent'+pageId).setValue(rowid);
							Ext.getCmp('name'+pageId).setValue('');
							Ext.getCmp('parent_name'+pageId).setValue(name);
							Ext.getCmp('divisi_id'+pageId).setValue('');
							Ext.getCmp('pangkat_id'+pageId).setValue('');
							Ext.getCmp('id_perusahaan'+pageId).setValue(Init.id_perusahaans);
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
							var code = rec.get('code');
							var name = rec.get('name');
							var divisi_id = rec.get('divisi_id');
							var pangkat_id = rec.get('pangkat_id');
							var id_perusahaan = rec.get('id_perusahaan');
							
							if(!Init.winss_addjabatan)
							{
								var form_add_jabatan = Ext.create('masterdata.view.form_add_jabatan');
								Init.winss_addjabatan = Ext.widget('window', {
									title			: "Update jabatan",
									closeAction	: 'hide',
									width			: 450,
									height		: 200, 
									autoScroll	: true,
									//id			: ''+Init.idmenu+'winmapppelsource',
									resizable	: true,
									modal		: true,
									bodyPadding	: 5,
									layout		: 'fit',
									items		: form_add_jabatan
								});
							}
							Init.winss_addjabatan.show();
							Ext.getCmp('rowid'+pageId).setValue(rowid);
							Ext.getCmp('parent'+pageId).setValue(parent);
							Ext.getCmp('name'+pageId).setValue(name);
							Ext.getCmp('pangkat_id'+pageId).setValue(pangkat_id);
							Ext.getCmp('parent_name'+pageId).hide();
							Ext.getCmp('divisi_id'+pageId).setValue(divisi_id);
							Ext.getCmp('id_perusahaan'+pageId).setValue(id_perusahaan);
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
								
								var table = 'mst_jabatan';
								params.id = 'gridjabatan'+pageId;
								
								msclass.deletedata(params,table,base_url+'simpel/deletedata');
								Ext.getCmp('gridjabatan'+pageId).getStore().load({method: 'POST',params : {'node':'root'}});
						}
					}]
				}]
			});
			this.callParent(arguments);
			}
		})
