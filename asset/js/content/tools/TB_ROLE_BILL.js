function apps(name,iconCls)
{
	//alert(iconCls);
	var tabPanel = Ext.getCmp('contentcenter');
	var items = tabPanel.items.items;
	var exist = false;
	var tb = 'tb_role_bill';
	
	
	
var s_isaktif = Ext.create('Ext.data.Store',{
    fields:['id','name'],
    data:[
        {id:'Y',name:'Y'},
        {id:'N',name:'N'}
    ]
});

	
	Ext.define('modelRoleBillGrid',{
		extend	: 'Ext.data.Model',
		fields	: ['id','rule_code','description']
	});
	
	var RoleBillGrid = Ext.create('Ext.data.JsonStore',{
		model	: 'modelRoleBillGrid',
			proxy: {
			type: 'pgascomProxy',
			url: base_url+'admin/listRoleBill',
			reader: {
				type: 'json',
				//pageSize	: 10,
				root: 'data'
			},
			//simpleSortMode: true
		}
	});
	RoleBillGrid.load();
	
	
	Ext.define('modelRoleBillTypeGrid',{
		extend	: 'Ext.data.Model',
		fields	: ['id','type_name','limit_code','detail_limit_code','is_kontrak','formula','isaktif']
	});
	
	var RoleBillTypeGrid = Ext.create('Ext.data.JsonStore',{
		model	: 'modelRoleBillTypeGrid',
			proxy: {
			type: 'pgascomProxy',
			url: base_url+'admin/listRoleBillType',
			reader: {
				type: 'json',
				//pageSize	: 10,
				root: 'data'
			},
			//simpleSortMode: true
		}
	});
	//RoleBillTypeGrid.load();
	
	
	
	var gridRoleBill = Ext.create('Ext.grid.Panel',{
		title		: 'List Role Billing',
		multiSelect	: true,
		store		: RoleBillGrid,
		height		: 350,
		autoScroll	: true,
		id			: 'gridRoleBill',
		border		: false,
		tools		: [
		{
			type	: 'refresh',
			handler	: function()
			{
				RoleBillGrid.reload({method: 'POST',params : {'name':''}});
			}
		}],
        selModel: {
             selType: 'cellmodel'
			 
        },
        tbar: [{
            text    : 'Add',
			id		: 'add_Rb',
			icon	: ''+base_url+'asset/ico/60.ico',
			xtype   : 'button',
			disabled:false,
            handler	: function(){
								var r = Ext.create('modelRoleBillGrid',{
									rule_code: '',
									description: '',
									active: true
								});
								RoleBillGrid.insert(0, r);
			}
        },
		{
            text    : 'Delete',
			id		: 'delete_Rb',
			icon	: ''+base_url+'asset/ico/33.ico',
			xtype   : 'button',
			disabled:true,
            handler	: 
			function(){
				var record 			 = gridRoleBill.getView().getSelectionModel().getSelection()[0];
				var id 				 = record.get('id');
				var tb1 				 = 'tb_role_bill';
				var wr1 				 = 'row_id';
				var tb2 				 = 'mapping_rolebill_roletype';
				var wr2 				 = 'role_id';
				//console.log(id);
				
							Ext.Ajax.request({ 
								url: base_url+'admin/delete_entry?id='+id+'&tb='+tb1+'&wr='+wr1,
								success: function(response){
									//console.log(response.text);
								}
													
							})
							
							Ext.Ajax.request({ 
								url: base_url+'admin/delete_entry?id='+id+'&tb='+tb2+'&wr='+wr2,
								success: function(response){
									//console.log(response.text);
								}
													
							})
							
							RoleBillGrid.load();
							RoleBillTypeGrid.proxy.extraParams = {'role_id':0};
							RoleBillTypeGrid.load({method: 'POST',params : {'role_id':0}});
			}
        }],
		plugins		: [
					  Ext.create('Ext.grid.plugin.RowEditing', {
					  clicksToEdit: 2,
					  listeners :
						{					
							'edit' : function (editor,e) {
									 var grid = e.grid;
									 var record = e.record;
									 var id = record.data.id;
									 var tb = 'tb_role_bill';
									 var wr = 'row_id';
								
									
									var recordData = record.data;
									//console.log(recordData);
									recordData.Functionalidad = 'Modificar';
									
										Ext.Ajax.request({ 
											url: base_url+'admin/update_master_bill?id='+id+'&tb='+tb+'&wr='+wr,
											method: 'POST',
											params: recordData,
											success: function(response){
												RoleBillGrid.load();
												//console.log(response.text);
											}
																
										})
							}
							
						}
					})],
		columns		: [
		Ext.create('Ext.grid.RowNumberer'),
		{
			text		: 'Rule Code',
			dataIndex	: 'rule_code',
			width		: 200,
			editor		: {
				xtype: 'textfield',
				name :'rule_code'
			}
		},
		{
			text		: 'Description',
			dataIndex	: 'description',
			width		: 100,
			align		: 'center',
			editor		: {
				xtype: 'textfield',
				name : 'description'
			}
		}],
		bbar: Ext.create('Ext.PagingToolbar', {
	        pageSize: 10,
	        //store: MasterDocumentsGrid,
	        displayInfo: true
	    }),
		listeners: {
			itemclick:function(view, record, item, index, e ) {
				var role_id = record.get('id');
				Ext.getCmp('delete_Rb').setDisabled(false);
				Ext.getCmp('addRoleBillType').setDisabled(false);
				Ext.getCmp('delete_BillType').setDisabled(true);
				RoleBillTypeGrid.proxy.extraParams = {'role_id':role_id};
				RoleBillTypeGrid.load({method: 'POST',params : {'role_id':role_id}});
			}
		}
	});
	
	var gridRoleBillType = Ext.create('Ext.grid.Panel',{
		title		: 'List Role Billing Type',
		multiSelect	: true,
		store		: RoleBillTypeGrid,
		height		: 350,
		autoScroll	: true,
		id			: 'gridRoleBillType',
		tools		: [
		{
			type	: 'refresh',
			handler	: function()
			{
				RoleBillTypeGrid.reload({method: 'POST',params : {'name':''}});
			}
		}],
        selModel: {
             selType: 'cellmodel'
			 
        },
        tbar: [{
            text    : 'Add',
			id		: 'addRoleBillType',
			icon	: ''+base_url+'asset/ico/60.ico',
			xtype   : 'button',
			disabled:true,
            handler	: 
			function(){
				var rec 	= gridRoleBill.getView().getSelectionModel().getSelection()[0]; 
				var id 		= rec.data.id ;
				//console.log(id);
				AddBillType(id);
			}
        },
		{
            text    : 'Delete',
			id		: 'delete_BillType',
			icon	: ''+base_url+'asset/ico/33.ico',
			xtype   : 'button',
			disabled:true,
            handler	: 
			function(){
				var record 			 = gridRoleBillType.getView().getSelectionModel().getSelection()[0];
				var id 				 = record.get('id');
				var tb 				 = 'mapping_rolebill_roletype';
				var wr 				 = 'rowid';
				
							Ext.Ajax.request({ 
								url: base_url+'admin/delete_entry?id='+id+'&tb='+tb+'&wr='+wr,
								success: function(response){
									//console.log(response.text);
								}
													
							})
							RoleBillTypeGrid.load();
						
			}
        }],
		plugins		: [
					  Ext.create('Ext.grid.plugin.RowEditing', {
					  clicksToEdit: 2,
					  listeners :
						{					
							'edit' : function (editor,e) {
									 var grid = e.grid;
									 var record = e.record;
									 var id = record.data.id;
									 var tb = 'mapping_rolebill_roletype';
									 var wr = 'rowid';
								
									
									var recordData = record.data;
									//console.log(recordData);
									recordData.Functionalidad = 'Modificar';
									
										Ext.Ajax.request({ 
											url: base_url+'admin/update_isaktif?id='+id+'&tb='+tb+'&wr='+wr,
											method: 'POST',
											params: recordData,
											success: function(response){
												RoleBillTypeGrid.load();
												//console.log(response.text);
											}
																
										})
							}
							
						}
					})],
		columns		: [
		Ext.create('Ext.grid.RowNumberer'),
		{
			text		: 'Name Type',
			dataIndex	: 'type_name',
			width		: 150
		},
		{
			text		: 'Limit Code',
			dataIndex	: 'limit_code',
			width		: 100,
			align		: 'center'
		},
		{
			text		: 'Detail Limit Code',
			dataIndex	: 'detail_limit_code',
			width		: 100,
			align		: 'center'
		},
		{
			text		: 'Is Kontrak',
			dataIndex	: 'is_kontrak',
			width		: 150
		},
		{
			text		: 'Is Aktif',
			dataIndex	: 'isaktif',
			width		: 50,
			align		: 'center',
			editor		: {
				 xtype:'combobox',
				 displayField:'name',
				 valueField:'id',
				 queryMode:'local',
				 store: s_isaktif
			}
		}],
		bbar: Ext.create('Ext.PagingToolbar', {
	        pageSize: 10,
	        //store: MasterDocumentsGrid,
	        displayInfo: true
	    }),
		listeners: {
						itemclick:function(view, record, item, index, e ) {
							Ext.getCmp('delete_BillType').setDisabled(false);
						}
		}
	});
	
	
	
	var rolebill = Ext.create('Ext.panel.Panel', {
        height: 410,
		id:'gridrolebillcentral',
        //title: 'Workflow Configuration',
        layout: 'border',
        items: [{
            // xtype: 'panel' implied by default
            region:'west',
            xtype: 'panel',
			flex:1,
            layout: 'fit',
            border:false,
			width: 500,
			margins: '5 5 0 0',
			items : [{
				collapsible	: false,
				activeItem: 0,
				border:false,
				layout: 'fit',
				items:[gridRoleBill]
			}]
        },
		{
            //title: 'Center Region',
            region: 'center',     // center region is required, no width/height specified
            xtype: 'panel',
			flex:2,
            layout: 'fit',
            border:false,
			width: 500,
			margins: '5 5 0 0',
			items:[{
					//overflowY	: 'scroll',
					collapsible	: false,
					activeItem: 0,
					border:false,
					layout: 'fit',
					items: [gridRoleBillType]
				
			}]
        }]
    });
	
	
	for(var i = 0; i < items.length; i++)
	{
        if(items[i].id == name){
				tabPanel.setActiveTab(name);
                exist = true;
        }
    }
	
	if(!exist){
			Ext.getCmp('contentcenter').add({
				title		: 'Role Billing',
				id			: name,
				xtype		: 'panel',
				iconCls		: iconCls,
				closable	: true,
				overflowY	: 'scroll',
				bodyPadding	: 5,
				items		: [rolebill]
			});
		tabPanel.setActiveTab(name);	
	}
	
}

function AddBillType(row_id){

//action store
	//----------------------------------------------------------------------------------
	Ext.define('modelRoleTypeGrid',{
		extend	: 'Ext.data.Model',
		fields	: ['id','type_name','limit_code','detail_limit_code','is_kontrak','formula']
	});
	
	var RoleTypeGridAdd = Ext.create('Ext.data.JsonStore',{
		model	: 'modelRoleTypeGrid',
			proxy: {
			type: 'pgascomProxy',
			extraParams:{'id':row_id},
			url: base_url+'admin/listRoleType',
			reader: {
				type: 'json',
				//pageSize	: 10,
				root: 'data'
			},
			//simpleSortMode: true
		}
	});
	RoleTypeGridAdd.load();
	
	var gridRoleTypeAdd = Ext.create('Ext.grid.Panel',{
		title		: 'List Role Type',
		multiSelect	: true,
		store		: RoleTypeGridAdd,
		height		: 350,
		autoScroll	: true,
		id			: 'gridRoleTypeAdd',
		tools		: [
		{
			type	: 'refresh',
			handler	: function()
			{
				RoleTypeGrid.reload({method: 'POST',params : {'name':''}});
			}
		}],
		columns		: [
		Ext.create('Ext.grid.RowNumberer'),
		{
			xtype		: 'checkcolumn',
			dataIndex	: 'id',
			width		: 30
		},
		{
			text		: 'Name Type',
			dataIndex	: 'type_name',
			width		: 200
		},
		{
			text		: 'Limit Code',
			dataIndex	: 'limit_code',
			width		: 100,
			align		: 'center'
		},
		{
			text		: 'Detail Limit Code',
			dataIndex	: 'detail_limit_code',
			width		: 100,
			align		: 'center'
		},
		{
			text		: 'Is Kontrak',
			dataIndex	: 'is_kontrak',
			width		: 150
		}],
		buttons	: [{
				text	: 'save',
				handler	: function(grid, row) {
					 //var store = Ext.data.StoreManager.lookup('setting.CommentConfig');
					 //grid.store.removeAt(row);
					 var storeGr = Ext.getCmp("gridRoleTypeAdd").getStore();
					//var id = grid.getStore();
					//console.log(storeGr);
					var store2 = new Array();
					var num = 0;
					
					storeGr.each(function(a,b){
						num = num + 1;
						if(a.data.id != false) 
						{
							store2.push(a.data.id);
						}
					});
					
					Ext.Ajax.request({
						method: 'POST',
						params: {'name':'-','description':'-'},
						url: base_url+'admin/add_role_bill',
						params: {id1:row_id,id2:Ext.encode(store2)}
					});
					
					var gridRoleBillType = Ext.getCmp('gridRoleBillType').getStore();
					gridRoleBillType.load();
					win.close();
					//console.log(store2);
				}
				}]
	});
	
	win = Ext.widget('window', {
					//title: '',
					width: 900,
					height	: 400,
					layout: 'border',
					autoScroll:true,
					id		: "winNotifikasi",
					//layout: 'fit',
					resizable: true,
					modal: true,
					layout: 'fit',
					margins: '5 0 0 5',
					bodyPadding	: 5,
					items: gridRoleTypeAdd
		});
		win.show();
//items: gridEmailActivity//,gridEmailNotivication
}
