function apps()
{
	Ext.define('model_parent',{
		extend	: 'Ext.data.Model',
		fields	: ['idMenu','name','act']
	});
	
	var store_parent	= Ext.create('Ext.data.JsonStore',{
			model	: 'model_parent',
			proxy: {
			type: 'pgascomProxy',
			url: base_url+'admin/listParent',
			reader: {
				type: 'json',
				root: 'data'
			}
		}
	});
	store_parent.load();
	
	var form_menu	= Ext.widget({
		id		: 'addMenu',
		xtype	: 'form',
		border	: false,
		url		: base_url+'admin/addMenu',
		frame	: false,
		method	: 'POST',
		width	: 400,
		items	: [{
			xtype		: 'fieldset',
        	defaultType	: 'textfield',
        	title		: 'Menu Add',
            collapsible	: true,
			fileUpload	: true,
            layout		: 'anchor',
			defaults: {
                anchor: '100%'
            },
			items		: [{
				fieldLabel	: 'Menu',
				name		: 'menu',
				allowBlank	: false,
			},
			{
				fieldLabel	: 'Method',
				name		: 'method'
			},
			{
				fieldLabel	: 'Parent',
				name		: 'parent',
				xtype		: 'combobox',
				store		: store_parent,
				queryMode	: 'local',
				displayField: 'name',
				valueField	: 'idMenu'
			}]
		}],
		buttons	: [{
			text	: "Simpan",
			handler	: function()
			{
				this.up('form').getForm().submit({
					waitTitle	: 'Harap Tunggu',
					waitMsg		: 'Insert data',
					success	:function()
					{
						//store_site.reload();
						Ext.Msg.alert('Sukses','Penambahan Component Sukses');
					},
					failure:function(form, action)
					{
						Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");
					}
				});
			}
		},
		{
			text	: "Cancel"
		}]
	});
	
	Ext.define('model_menu',{
		extend	: 'Ext.data.Model',
		fields	: ['id','name','act','parent']
	});
	
	var store_menu	= Ext.create('Ext.data.TreeStore',{
			model	: 'model_menu',
			proxy: {
			type: 'pgascomProxy',
			url: base_url+'admin/listMenu',
			reader: {
				type: 'json',
				root: 'data'
			},
			node: 'id',
			folderSort: true
		}
	});
	store_menu.load();
	var tree = Ext.create('Ext.tree.Panel',{	
   			title: 'Simple Tree',
			id	: 'tree_menu',
        	collapsible: true,
        	rootVisible: false,
			useArrows  : true,
			singleExpand: true,
        	store: store_menu,
        	multiSelect: true,
        	height	: 450,
        	dockedItems: [{
            xtype: 'toolbar',
            items: [{
                text:'Add Menu',
                tooltip:'Add Menu'
                //iconCls:'userAdd',
                //handler	:AddAccessLevel
				}, '-', {
					text:'Options',
					tooltip:'Set options'
					//iconCls:'option'
				}]
        	}],
        	columns		: [
        	{
        		dataIndex	: 'id',
        		hidden		: true
        	},
        	{
        		xtype: 'treecolumn',
           		 text: 'All Menu',
           		 flex: 1,
				 editor: 'textfield',
				sortable: true,
            	dataIndex: 'name'
        	},
        	{
        		text	:'Method',
        		dataIndex	: 'act',
        		flex	: 1
        	}],
			selType: 'rowmodel',
			 plugins: [
			Ext.create('Ext.grid.plugin.RowEditing', {
				clicksToEdit: 1,
				listeners	: {
        				'edit'	: function (editor, e)
        					{
        						
        					}
        			}
			})
			]	
   		});
		
	var tabPanel = Ext.getCmp('contentcenter');
	var items = tabPanel.items.items;
	var exist = false;
	
	for(var i = 0; i < items.length; i++)
	{
        if(items[i].id == 'menu'){
				tabPanel.setActiveTab('menu');
                exist = true;
        }
		
    }
	if(!exist){
			Ext.getCmp('contentcenter').add({
				title	: 'Menu',
				id		: 'menu',
				closable	: true,
				bodyPadding	: 5,
				//layout		: 'fit',
				items	: [form_menu,tree]
			});
		tabPanel.setActiveTab('menu');	
	}
}