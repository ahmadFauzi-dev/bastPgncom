Ext.define('setting.view.menu' ,{
			extend: 'Ext.tree.Panel',
			initComponent	: function()
			{
			var storemenu 	= Ext.create('setting.store.storemenu');
			storemenu.removeAll();
			storemenu.load();
			Ext.apply(this,{
				id		: 'menupriv',
				viewConfig: {
						plugins: {
							ptype: 'treeviewdragdrop',
							containerScroll: true,
							listeners	: {
								beforedrop	: function (node, data, overModel, dropPosition, dropFunction, eOpts ) {									//console.log(node);								},								drop 		: function(node, data, overModel, dropPosition, eOpts)								{									//console.log(node);								}							}						}				},
				dockedItems: [{					xtype: 'toolbar',					items: [{						text: 'Add Menu',						iconCls	: 'add',						handler	: function()						{							node 			= this.up('panel').getSelectionModel().getSelection();							var data		= node[0].data;							var addform 	= Ext.create('setting.view.formaddmenu');							Ext.getCmp('parent').setValue(data.id);							Ext.getCmp('parentName').setValue(data.text);							
							Ext.create('Ext.window.Window', {								title: 'Add Sub Menu'+data.text,								height: 200,								width: 400,								layout: 'fit',								items	: addform							}).show();							console.log(data);						}					},					{						text	: 'Save',						iconCls	: 'database_save',						handler	: function()						{							var tree = Ext.getCmp('menupriv');							var records = tree.getView().getChecked();							var items = [];							
							Ext.Array.each(records, function(rec){								var idmenupriv = rec.get('id').substring(3);								var data = {									menu_id  : idmenupriv,									group_id : Init.acc_group								};									items.push(data);							});
							
							Ext.Ajax.request({ 								url			: base_url+'admin/master/updatemenupriv',								method		: 'POST',								params:{									data	: Ext.encode(items)								},
								success: function(response,requst){									Ext.Msg.alert('Sukses','Data Telah di Approve');									//storeGridamrDaily.removeAll();																	//storeGridamrDaily.reload();								},								failure:function(response,requst)								{									Ext.Msg.alert('Fail !','Input Data Gagal');									Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");								}										});
							
							//console.log(items);						}					},					{						text	: 'Refresh',						iconCls	: 'arrow_refresh_small',						handler	: function()						{							storemenu.reload();						}					}],				}],				store: storemenu,				listeners:				{					select: function (cmb, record, index)					{							//alert("index: " + index);							eventact = record.data;							var id = eventact.id;							var val_id = id.substring(3);							var storeevent = Ext.getCmp('gridevent').getStore();							console.log(Init.acc_group);							storeevent.proxy.extraParams = {									group_id		   : Init.acc_group,									"filter[0][field]" : "menu_id",									"filter[0][data][type]" : "numeric",									"filter[0][data][comparison]" : "eq",									"filter[0][data][value]" : val_id							};
							storeevent.reload();
					}				}			});
			this.callParent(arguments);			}
		})
