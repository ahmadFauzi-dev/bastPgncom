function apps(name,iconCls)
{
	//alert(iconCls);
	var tabPanel = Ext.getCmp('contentcenter');
	var items = tabPanel.items.items;
	var exist = false;
	var tb = 'tb_role_type';
	
	
	
	
	Ext.define('modelRoleTypeGrid',{
		extend	: 'Ext.data.Model',
		fields	: ['id','type_name','limit_code','detail_limit_code','is_kontrak','formula']
	});
	
	var RoleTypeGrid = Ext.create('Ext.data.JsonStore',{
		model	: 'modelRoleTypeGrid',
			proxy: {
			type: 'pgascomProxy',
			url: base_url+'admin/listRoleType1',
			reader: {
				type: 'json',
				//pageSize	: 10,
				root: 'data'
			},
			//simpleSortMode: true
		}
	});
	RoleTypeGrid.load();
	
	var gridRoleType = Ext.create('Ext.grid.Panel',{
		title		: 'List Role Type',
		multiSelect	: true,
		store		: RoleTypeGrid,
		height		: 350,
		autoScroll	: true,
		id			: 'gridRoleType',
		tools		: [
		{
			type	: 'refresh',
			handler	: function()
			{
				RoleTypeGrid.reload({method: 'POST',params : {'name':''}});
			}
		}],
        selModel: {
             selType: 'cellmodel'
			 
        },
        tbar: [{
            text    : 'Add',
			id		: 'add_doc_adm',
			icon	: ''+base_url+'asset/ico/60.ico',
			xtype   : 'button',
			disabled:false,
            handler	: function(){
								var r = Ext.create('modelRoleTypeGrid',{
									type_name: '',
									limit_code: '',
									detail_limit_code: '',
									is_kontrak: '',
									is_kontrak: '',
									formula: '',
									active: true
								});
								RoleTypeGrid.insert(0, r);
			}
        },
		{
            text    : 'Delete',
			id		: 'delete_Rt',
			icon	: ''+base_url+'asset/ico/33.ico',
			xtype   : 'button',
			disabled:true,
            handler	: 
			function(){
				var record 			 = gridRoleType.getView().getSelectionModel().getSelection()[0];
				var id 				 = record.get('id');
				var tb 				 = 'tb_role_type';
				var wr 				 = 'row_id';
				//console.log(id);
				Ext.MessageBox.confirm('Delete', 'Are you sure ?',function(btn){
						if(btn == 'yes')
						{
							Ext.Ajax.request({ 
								url: base_url+'admin/delete_entry?id='+id+'&tb='+tb+'&wr='+wr,
								success: function(response){
									//console.log(response.text);
								}
													
							})
							RoleTypeGrid.load();
						}
					});
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
									 var tb = 'tb_role_type';
									 var wr = 'row_id';
								
									
									var recordData = record.data;
									//console.log(recordData);
									recordData.Functionalidad = 'Modificar';
									
										Ext.Ajax.request({ 
											url: base_url+'admin/update_master?id='+id+'&tb='+tb+'&wr='+wr,
											method: 'POST',
											params: recordData,
											success: function(response){
												RoleTypeGrid.load();
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
			width		: 200,
			editor		: {
				xtype: 'textfield',
				name :'type_name'
			}
		},
		{
			text		: 'Limit Code',
			dataIndex	: 'limit_code',
			width		: 100,
			align		: 'center',
			editor		: {
				xtype: 'textfield',
				name : 'limit_code'
			}
		},
		{
			text		: 'Detail Limit Code',
			dataIndex	: 'detail_limit_code',
			width		: 100,
			align		: 'center',
			editor		: {
				xtype: 'textfield',
				name : 'detail_limit_code'
			}
		},
		{
			text		: 'Is Kontrak',
			dataIndex	: 'is_kontrak',
			width		: 150,
			editor		: {
				xtype: 'textfield',
				name : 'is_kontrak'
			}
		},
		{
			text		: 'Formula',
			dataIndex	: 'formula',
			width		: 500,
			editor		: {
				xtype: 'textfield',
				name : 'formula'
			}
		}],
		bbar: Ext.create('Ext.PagingToolbar', {
	        pageSize: 10,
	        //store: MasterDocumentsGrid,
	        displayInfo: true
	    }),
		listeners: {
						itemclick:function(view, record, item, index, e ) {
							Ext.getCmp('delete_Rt').setDisabled(false);
						}
		}
	});
	
	var form  = Ext.widget({
		xtype	: 'form',
		//id		: 'formMasterDocuments',
		xtype	: 'form',
		border	: false,
		url		: base_url+'admin/add_JobTitle?tb='+tb,
		frame	: false,
		method	: 'POST',
		layout	: 'fit',
		items	: [{
			xtype		: 'fieldset',
        	defaultType	: 'textfield',
        	title		: 'Filter',
            collapsible	: true,
			//id			: 'fieldsetformMasterDocuments',
			fileUpload	: true,
            layout		: 'anchor',
			defaults: {
                anchor: '40%'
            },
			items		: [{
					fieldLabel	: 'Isi Kontrak',
					name		: 'isi_kontrak',
					allowBlank: false
				},]
		}],
		buttons			: [{
			text	: "Search",
			handler	: function()
			{
					/* MasterDocumentsGrid.loadData([],false);
					var form = this.up('form').getForm();
					var masterDocuments = form.getValues();
					globalFilterParam = masterDocuments;
					MasterDocumentsGrid.proxy.extraParams = masterDocuments;
					MasterDocumentsGrid.reload({method: 'POST',params : masterDocuments}); */
			}
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
				title		: 'Role Type',
				id			: name,
				xtype		: 'panel',
				iconCls		: iconCls,
				closable	: true,
				overflowY	: 'scroll',
				bodyPadding	: 5,
				items		: [form,gridRoleType]
			});
		tabPanel.setActiveTab(name);	
	}
	
}

