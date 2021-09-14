Ext.define('masterdata.view.grid_workflowjabatan' ,{
			extend: 'Ext.tree.Panel',
			initComponent	: function()
			{
			var pageId = Init.idmenu;
			var msclass = Ext.create('master.global.geteventmenu'); 
			
			Ext.define('mlistJabatan',{
				extend	: 'Ext.data.Model',
				fields	: ['id',
					'parent',
					'nama_jabatan',
					'code',
					'id_organization'],
			});
			
			var JabatanGrid = Ext.create('Ext.data.TreeStore',{
				model	: 'mlistJabatan',
					proxy: {
					type: 'ajax',
					url: base_url+'admin/listJabatan',
					reader: {
						type: 'json',
						root: 'data'
					},
					node:'id',
					//node: 'rowid',
					//expanded: true,
					//folderSort: true
				}
			});
			//JabatanGrid.load();
	
			Ext.apply(this,{
				title:'Master Jabatan',
				rootVisible : false,
				id		: 'gridworflowJabatan'+pageId,
				tools		: [
				{
					type	: 'refresh',
					handler	: function()
					{
						JabatanGrid.load({method: 'POST',params : {'node':'root'}});
					}
				}],
				store: JabatanGrid,
				columns		: [
				{
					xtype	: 'treecolumn',
					text		: 'Name',
					dataIndex	: 'nama_jabatan',
					width		: '100%'				
				}],
				listeners		: {
							itemclick: function (grid, record, item, index, e, eOpts) 
							{
								dataselect = record.data;
								
								var combobox_module = Ext.getCmp('combobox_module'+pageId);
								combobox_module.setValue('');
								var store_module = combobox_module.getStore();
								store_module.load();
								
								var store_jenisworkflow = Ext.getCmp('jenis_workflow').getStore();								
								store_jenisworkflow.removeAll();
								
								Ext.getCmp( 'jobpositionparams'+pageId).setValue(dataselect.id);
								
								var grid_workflow = Ext.getCmp( 'grid_workflow').getStore();
								grid_workflow.removeAll();
							}
				}
			});
			this.callParent(arguments);
			}
		})
