Ext.define('masterdata.view.additional_email_template' ,{
		extend: 'Ext.grid.Panel',
		initComponent: function() {
			//tbl_rekanan	
				var pageId = Init.idmenu;
				var dataselect;
				var pageId = Init.idmenu;
				var msclass = Ext.create('master.global.geteventmenu'); 
				
				vtable = "tbl_dbemail";
				var model = msclass.getmodel(vtable);
				var columns = msclass.getcolumn(vtable);
				//var winss;
				var filter = [];
				var store =  msclass.getstore(model,vtable,filter);
				store.getProxy().extraParams = {
							view :vtable,
							limit : "All"
						};
				store.load();
		
				columns[0].hidden = true;
				columns[1]	= 
				{
					xtype		: 'actioncolumn',
					width		: 50,
					items		: [{
						icon			: base_url+'/asset/ico/56.ico',
						tooltip		: 'Assign Auhorize',
						handler	: function(grid, rowIndex, colIndex)
						{
							var rec = grid.getStore().getAt(rowIndex);
							var value = '{'+rec.get('description')+'}';
							var last_value = Ext.getCmp('template_email').getValue();
							Ext.getCmp('template_email').setRawValue(last_value+value);
						}
					}]
					
				}; 
				columns[2].hidden = true;
				columns[3]	= {	
						text : 'Nama',
						width:250,
						dataIndex	: columns[3].dataIndex,
						/* renderer : function(value, metaData, record){
							//return str_replace('<<',str_replace('>>','',value));
							return value;
						}	 */			
				},
				columns[4].hidden = true;
				columns[5].hidden = true;
				columns[6].hidden = true;
				columns[7].hidden = true;
				columns[8].hidden = true;
				
				/* var editing = Ext.create('Ext.grid.plugin.RowEditing', {
				  clicksToEdit: 2,
				  listeners :
					{					
						'edit' : function (editor,e) {
							 // console.log("asd");
							var grid = e.grid;
							var record = e.record;					 
							var recordData = record.data; 
							recordData.id = 'gridadditionalemail';
							msclass.savedata(recordData , base_url+'masterdata/update_entry'); 
						}
					}
				}); */
				
				Ext.apply(this,{
						store			: store,
						title				: 'Columns',
						multiSelect	: true,
						autoScroll	: true,
						id					: 'gridadditionalemail',
						columns		: columns,
						//plugins 		: editing,
						/* dockedItems	: [
						{
							xtype: 'toolbar',
							items	: [
							{
								text	: 'Add',
								iconCls	: 'add',
								xtype	: 'button',
								handler	: function()
								{
									var rec = Ext.getCmp('grid_emailtemplate').getView().getSelectionModel().getSelection()[0];
									var table_view 	= rec.get('table_view');
									var module 	= rec.get('module');
									//console.log(table_view);
								
									var r = {
										rowid : '0',
									}
									Init.store_additionalEmal.insert(0, r);
								}
							}]
						}] */
				});
		this.callParent(arguments);
	}
});