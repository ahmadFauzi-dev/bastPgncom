Ext.define('setting.view.grouppermission' ,
	{
			
			extend: 'Ext.grid.Panel',
			alias : 'widget.grouppermission',
			id : 'grouppermission',
			//width : 400,
			
			initComponent	: function()
			{
			var msclass 		= Ext.create('master.global.geteventmenu');
			var dataselect;
			var filter 			= [];
			var storegrid 	= Ext.create('setting.store.storegridgrouppermission');
			storegrid.load();
			
			var midperusahaan = msclass.getmodel("fn_getdatamastertype('TOD34')");
			var store_idperusahaan =  msclass.getstore(midperusahaan,"fn_getdatamastertype('TOD34')",filter);
			store_idperusahaan.getProxy().extraParams = {
							view :"fn_getdatamastertype('TOD34')",
							limit : "All"
						};
			store_idperusahaan.load();
			
			var editing = Ext.create('Ext.grid.plugin.RowEditing', {
			  clicksToEdit: 2,
			  listeners :
				{					
					'edit' : function (editor,e) {
							 console.log("asd");
							 var grid 	= e.grid;
							 var record = e.record;
							 
							var recordData = record.data; 
							msclass.savedata(recordData,base_url+'admin/settings/updategroup');
							Ext.getCmp('grouppermissionid').getStore().reload();
					}
				}
			});
			
			Ext.apply(this,{
				fit		: true,
				split	: true,
				selType		: 'checkboxmodel',
				id			: 'grouppermissionid',
				multiSelect	: false,
				selModel: {
					injectCheckbox: 0,
					pruneRemoved: false,
					showHeaderCheckbox: false,
					singleSelect:true
				},
				// filterable	: true,				
				store		: storegrid,
				plugins		: editing,	
				dockedItems: [
				{
					xtype: 'toolbar',
					items: [
						{
							iconCls	: 'group_gear',
							text	: 'Add Group',
							handler	: function()
							{
								
								var r = {
									group_id	: '',
									name	: ''
								}
								storegrid.insert(0, r);
								
							}
						},'-',
						{
							iconCls	: 'status_busy',
							text	: 'Delete Group',
							handler		: function()
							{
								//console.log(dataselect);
								
								var params = {
									"filter[0][field]" : "group_id",
									"filter[0][data][type]" : "string",
									"filter[0][data][comparison]" : "eq",
									"filter[0][data][value]" : dataselect.group_id,
								}
								
								var table = 'group_permission';
								params.id = 'grouppermissionid';
								msclass.deletedata(params,table);
								//storegrid.reload();
								
							}
							
						}]
				},
				{
					xtype: 'pagingtoolbar',
					dock: 'bottom',
					store: storegrid,
					displayInfo: true,
					items : [{
			            xtype: 'button',
			            text: 'Clear All',
			            tooltip  : 'Clear Filters',
						iconCls  : 'page_white_magnify',
						handler:function(){
							storegrid.clearFilters();
							// cilukba.filters.clearFilters();
						}
					}]
				}],
				columns		: [
				Ext.create('Ext.grid.RowNumberer',
					{
						header: 'No', 
						width: 40
					}
					),				
					{	
						dataIndex 	: 'name',
						text 		: 'Group',
						flex		: 1,
						width		: 70,
						editor		: {
							xtype			: 'textfield',
							name			: 'name'
						}

					},
					{
						dataIndex	: 'koordinatoruser',
						text		: 'Email',
						flex		: 1,
						editor		: 
						{
							xtype	: 'textfield',
							//vtype	: 'email',
							name	: 'koordinatoruser'
						}
					},
					{
						dataIndex	: 'id_perusahaan',
						text		: 'Perusahaan',
						flex		: 1,
						renderer: function(value, metaData, record ){				
							return record.get('nama_perusahaan');
						},
						editor		: 
						{
							xtype			: 'combobox',
							name			: 'id_perusahaan',
							//multiSelect 	: true,
							store			: store_idperusahaan,
							queryMode		: 'local',
							displayField	: 'nama',
							valueField		: 'id'
						}
					}],
				listeners	: {
					select: function (model, record, index, eOpts) {
						// console.log(record.data);
						dataselect = record.data;
						if(record.data.group_id != ''){
							//console.log(record.data);
							Init.acc_group = record.data.group_id;
							var storemenupriv = Ext.getCmp('menupriv').getStore();
							storemenupriv.getProxy().extraParams = {
								group_id	: parseInt(Init.acc_group),
								"filtersbu[1][field]" : "group_id",
								"filtersbu[1][data][type]" : "numeric",
								"filtersbu[1][data][comparison]" : "eq",
								"filtersbu[1][data][value]" : parseInt(Init.acc_group)
							};
							//storegridsbu.load();
							storemenupriv.load();
							
							var storegriduser = Ext.getCmp('griduser').getStore();
							storegriduser.getProxy().extraParams = {
								view	: 'v_revuser',
								limit : 'all',
								"filter[0][field]" : "groupid",
								"filter[0][data][type]" : "numeric",
								"filter[0][data][comparison]" : "eq",
								"filter[0][data][value]" : parseInt(Init.acc_group)
							};
							storegriduser.load();
							
							
						}
					}
				}
					//features	: [filtersCfg]		

			});
			this.callParent(arguments);
			}
			
		})
