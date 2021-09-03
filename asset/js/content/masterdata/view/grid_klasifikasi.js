Ext.define('masterdata.view.grid_klasifikasi' ,{
			extend: 'Ext.tree.Panel',
			initComponent	: function()
			{
			var pageId = Init.idmenu;
			var msclass = Ext.create('master.global.geteventmenu'); 
			
			var gmodel 			=  msclass.getmodel('v_klasifikasi');			
			var listklasifikasiGrid 	=  msclass.gettreestore(gmodel,'v_klasifikasi',[]);
			listklasifikasiGrid.getProxy().extraParams = {
									view :'v_klasifikasi',									
									"filter[0][field]" : "id_perusahaan",
									"filter[0][data][type]" : "string",
									"filter[0][data][comparison]" : "eq",
									"filter[0][data][value]" : '0'
			};
			listklasifikasiGrid.load(); 
								
			Ext.apply(this,{
				rootVisible : false,
				//title : 'klasifikasi',
				id		: 'gridklasifikasi'+pageId,
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
								params:{'drop_id' : drop_id , 'target_id' : target_id,'wr' : 'rowid', 'tb' : 'mst_klasifikasi'},
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
							
							if (Init.perusahaan_id != '0'){
								if(!Init.winss_formklasifikasi)
								{
									var formklasifikasi = Ext.create('masterdata.view.form_klasifikasi');
									Init.winss_formklasifikasi = Ext.widget('window', {
										title		: "Add klasifikasi",
										closeAction	: 'hide',
										width		: 450,
										height		: 0,
										autoScroll	: true,
										//id			: ''+Init.idmenu+'winmapppelsource',
										resizable	: true,
										modal		: true,
										//bodyPadding	: 5,
										layout		: 'fit',
										items		: formklasifikasi
									});
								}
								Init.winss_formklasifikasi.show();
								
								Ext.getCmp('rowid'+pageId).setValue('');
								Ext.getCmp('parent'+pageId).setValue('0');
								Ext.getCmp('parent_name'+pageId).hide();
								Ext.getCmp('code1'+pageId).setValue('');
								Ext.getCmp('code2'+pageId).setValue('');
								Ext.getCmp('name'+pageId).setValue('');
								Ext.getCmp('id_perusahaan'+pageId).setValue(Init.id_perusahaan);
							}
						}
					}],
				}],
				store: listklasifikasiGrid,
				columns		: [
				{
					xtype	: 'treecolumn',
					text		: 'Nama klasifikasi',
					dataIndex	: 'name',
					width		: 300				
				},
				{
					text		: 'Code',
					align		:'left',
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
							var code1 = rec.get('code');
							var perusahaan_id = rec.get('perusahaan_id');
							
							if(!Init.winss_formklasifikasi)
								{
									var formklasifikasi = Ext.create('masterdata.view.form_klasifikasi');
									Init.winss_formklasifikasi = Ext.widget('window', {
										title		: "Add klasifikasi",
										closeAction	: 'hide',
										width		: 450,
										height		: 180,
										autoScroll	: true,
										//id			: ''+Init.idmenu+'winmapppelsource',
										resizable	: true,
										modal		: true,
										//bodyPadding	: 5,
										layout		: 'fit',
										items		: formklasifikasi
									});
								}
								Init.winss_formklasifikasi.show();
								
								Ext.getCmp('rowid'+pageId).setValue('');
								Ext.getCmp('parent'+pageId).setValue(rowid);
								Ext.getCmp('parent_name'+pageId).setValue(name);
								Ext.getCmp('parent_name'+pageId).show();
								Ext.getCmp('code1'+pageId).setValue(code1);
								Ext.getCmp('code2'+pageId).setValue('');
								Ext.getCmp('name'+pageId).setValue('');
								Ext.getCmp('id_perusahaan'+pageId).setValue(Init.id_perusahaan);
								
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
							var parent_name = rec.get('parent_name');
							var name = rec.get('name');
							var code = rec.get('code');
							arr = code.split('.'),
							code2 = arr.pop();
						    code1 = arr.join('.');
							var id_perusahaan = rec.get('id_perusahaan');
							
							if(!Init.winss_formklasifikasi)
								{
									var formklasifikasi = Ext.create('masterdata.view.form_klasifikasi');
									Init.winss_formklasifikasi = Ext.widget('window', {
										title		: "Add klasifikasi",
										closeAction	: 'hide',
										width		: 450,
										height		: 180,
										autoScroll	: true,
										//id			: ''+Init.idmenu+'winmapppelsource',
										resizable	: true,
										modal		: true,
										//bodyPadding	: 5,
										layout		: 'fit',
										items		: formklasifikasi
									});
								}
								Init.winss_formklasifikasi.show();
								
								Ext.getCmp('rowid'+pageId).setValue(rowid);
								Ext.getCmp('parent'+pageId).setValue(parent);
								Ext.getCmp('parent_name'+pageId).setValue(parent_name);
								Ext.getCmp('parent_name'+pageId).show();
								Ext.getCmp('code1'+pageId).setValue(code1);
								Ext.getCmp('code2'+pageId).setValue(code2);
								Ext.getCmp('name'+pageId).setValue(name);
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
								
								var table = 'klasifikasi';
								params.id = 'gridklasifikasi'+pageId;
								
								msclass.deletedata(params,table,base_url+'simpel/deletedata');
								Ext.getCmp('gridklasifikasi'+pageId).getStore().load({method: 'POST',params : {'node':'root'}});
						}
					}]
				}]
			});
			this.callParent(arguments);
			}
		})
