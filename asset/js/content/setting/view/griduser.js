Ext.define('setting.view.griduser' ,{
	extend: 'Ext.grid.Panel',
	initComponent	: function()
	{
	
	var msclass 		= Ext.create('master.global.geteventmenu'); 
	var pageId = Init.idmenu;
	//console.log(msclass);
	var model 			= msclass.getmodel('public.v_revuser');
	var columns 		= msclass.getcolumn('public.v_revuser','griduser');
	var filter 			= [];
	
	var mreffjabatan = msclass.getmodel("mst_jabatan");
	var store_reffjabatan =  msclass.getstore(mreffjabatan,"mst_jabatan",filter);
	store_reffjabatan.getProxy().extraParams = {
								view	: 'mst_jabatan',
								limit : 'all',
								"filter[0][field]" : "id_perusahaan",
								"filter[0][data][type]" : "numeric",
								"filter[0][data][comparison]" : "eq",
								"filter[0][data][value]" : "MD298"
							};
	store_reffjabatan.load();
	
	var mgroup = msclass.getmodel("group_permission");
	var store_mgroup =  msclass.getstore(mgroup,"group_permission",filter);
	store_mgroup.getProxy().extraParams = {
								view	: 'group_permission',
								limit : 'all'
							};
	store_mgroup.load();
	
			
	var storeactive = Ext.create('Ext.data.Store', {
    fields: ['id', 'name'],
    data : [
		{"id":"Y", "name":"Y"},
        {"id":"N", "name":"N"}
    ]
	});
	
	
	//console.log(columns);
	
	var filter = [];
	//model[] = "setopts"; 
	//model.push("setopts");
	columns[1].hidden	=  true;
	columns[2]	= 
	{
		dataIndex 	: columns[2].dataIndex,
		text 		: 'Username',
		editor		: {
			xtype			: 'textfield',
			name			: columns[2].dataIndex
		}
	};
	columns[3] = {
		text 		: 'Password',
		dataIndex 	: columns[18].dataIndex,
		editor		: {
			xtype			: 'textfield',	
			name			: columns[18].dataIndex,
		}
	};
	columns[4] = 
	{
		dataIndex 	: columns[4].dataIndex,
		text 		: 'Nama',
		editor		: {
			xtype			: 'textfield',
			name			: columns[4].dataIndex
		}
	};
	
	columns[5] = 
	{
		dataIndex 	: columns[5].dataIndex,
		text 		: 'Active',
		align			: 'center',
		editor		: {
			xtype			: 'combobox',
			name			: columns[5].dataIndex,
			//multiSelect 	: true,
			store			: storeactive,
			//queryMode		: 'local',
			displayField	: 'name',
			valueField		: 'id',
		}
	};
	columns[6] = 
	{
		dataIndex 	: columns[6].dataIndex,
		text 		: 'Group',
		hidden : false,
		renderer: function(value, metaData, record ){				
			var group_id = store_mgroup.findRecord('group_id', value, 0 , false, false, true);
			return group_id != null ? group_id.get('name') : value;
		},
		editor		: {
			xtype			: 'combobox',
			name			: columns[6].dataIndex,
			//multiSelect 	: true,
			store			: store_mgroup,
			queryMode		: 'local',
			displayField	: 'name',
			valueField		: 'group_id',
		}
	};
	
	columns[7].hidden = true
	columns[8].hidden = true
	
	columns[9]	= 
	{
		dataIndex 	: columns[9].dataIndex,
		text 			: 'Email',
		width 		: 300,
		editor		: {
			xtype			: 'textfield',
			name			: columns[9].dataIndex
		}
	};
	
	columns[10].hidden = true;
	columns[11].hidden = true;
	columns[12]	= 
	{
		dataIndex 	: columns[12].dataIndex,
		text 			: 'Jabatan',
		width 		: 200,
		renderer: function(value, metaData, record ){				
			var id = store_reffjabatan.findRecord('rowid', value, 0 , false, false, true);
			return id != null ? id.get('name') : record.get('namajabatan');
		},
		editor		: {
			xtype			: 'combobox',
			name			: columns[12].dataIndex,
			//multiSelect 	: true,
			store			: store_reffjabatan,
			id			: 'idjabatan',
			queryMode		: 'local',
			displayField	: 'name',
			valueField		: 'rowid',
		}
	};
	columns[13].hidden = true;
	columns[14].hidden = true;
	columns[15] = {
		dataIndex 	: columns[15].dataIndex,
		text 			: 'Ttd'
	};
	columns[16].hidden = true;
	columns[17] = {
		dataIndex 	: columns[17].dataIndex,
		text 			: 'Divisi',
		width 		: 300,
		editor		: {
			xtype			: 'textfield',
			name			: columns[17].dataIndex,
			readOnly : true
		}
	};
	columns[18].hidden = true;
	var store =  msclass.getstore(model,'v_revuser',filter);
	store.load();
	
		var filterconfig = {ftype	: 'filters',
			filters	: [
				{
					type	: 'date',
					dateFormat	: 'Y-m-d',
					dataIndex	: 'tanggal'
				},
				{
					type		: 'list',
					dataIndex	: 'name_area',
					//options		: itemsarea,
					phpMode		: true
				},
				{
					type		: 'list',
					dataIndex	: 'name_sbu',
					//options		: itemssbu,
					phpMode		: true
				}
			]
		};
		var role = {"p_export"	: true};
		//console.log(role.p_export);
		var editing = Ext.create('Ext.grid.plugin.RowEditing', {
			  clicksToEdit: 2,
			  listeners :
				{					
					'edit' : function (editor,e){
							// console.log("asd");
							 var grid 	= e.grid;
							 var record = e.record;
							 var recordData = record.data; 
							 recordData.id = 'griduser';
							msclass.savedata(recordData,base_url+'admin/settings/updateusergroup');
							store.load();
					}
				}
			});
			
		var griduser = Ext.apply(this, {
			store		: store,
			multiSelect	: true,
			autoScroll	: true,
			plugins		: editing,
			//height		: 200,
			id			: 'griduser',
			dockedItems	: [
				{
					xtype: 'toolbar',
					items	: [
					{
						iconCls : 'group_add',
						text	: 'Add User',
						handler	: function()
						{
							var r = {
								username : '',
								nama	 : '',
								usernameldap	: '',
								groupid : Init.acc_group
							}
							store.insert(0, r);
							//console.log("POPOPOPO");
						}
					},'-',
					{
						iconCls : 'image_add',
						text	: 'Ttd',
						handler	: function()
						{
							var rec = Ext.getCmp('griduser').getView().getSelectionModel().getSelection()[0];
							var user_id 	= rec.get('user_id');
							var url_ttd 	= rec.get('url_ttd');
							var nama_ttd 	= rec.get('nama_ttd');
							
							if(user_id){				
								if(!Init.winss_uploadttd)
								{
									var form_uploadttd = Ext.create('setting.view.formttdupload');
									Init.winss_uploadttd = Ext.widget('window', {
										title		: "Upload TTD",
										closeAction	: 'hide',
										width: 400,
										height	: 300,
										autoScroll	:true,
										//id			: ''+Init.idmenu+'winmapppelsource',
										resizable	: true,
										//modal		: true,
										closable 	:true,
										bodyPadding	: 5,
										layout		: 'fit',
										items		: form_uploadttd
									});
								}
								Init.winss_uploadttd.show();
											
								if (url_ttd == null){
									var ttd = 'zonk.jpg';
								}
								else{
									var ttd = url_ttd;
								};
								var vsrc =  base_url+'signature/'+ttd;
								
								Ext.getCmp('ttduser_id'+pageId).setValue(user_id);
								Ext.getCmp('uplurl_ttd'+pageId).setSrc(vsrc);
								Ext.getCmp('nama_td'+pageId).setText(nama_ttd);
							}
						}
					},'-',
					{
						iconCls	: 'delete',
						text	: 'Delete',
						handler	: function()
						{
						
						var rec = Ext.getCmp('griduser').getView().getSelectionModel().getSelection()[0];
						var user_id 	= rec.get('user_id');		
									
							if(user_id != ''){
								
								var params = {
									"filter[0][field]" : "user_id",
									"filter[0][data][type]" : "numeric",
									"filter[0][data][comparison]" : "eq",
									"filter[0][data][value]" : user_id,
								}
								
								var table = 'public.rev_user';
								params.id = 'griduser';
								msclass.deletedata(params,table,base_url+'sppd/deletedata');
							}
							
						}
					},
					'->',
					{
						//text	: 'Pelanggan',
						xtype	: 'textfield',
						id		: 'username',
					},
					{
						xtype	: 'button',
						iconCls	: 'magnifier',
						text	: 'Search',
						handler	: function()
						{
							store.getProxy().extraParams = {
							view : "v_revuser",
								
								"filter[5][field]" : "username",
								"filter[5][data][type]" : "string",
								//"filter[3][data][comparison]" : "eq",
								"filter[5][data][value]" : Ext.getCmp('username').getValue(),
							};	
							store.load();
						}
					}
					]
				}
			],
			columns		: columns,
			features	: [filterconfig],
			bbar: Ext.create('Ext.PagingToolbar', {
				pageSize: 10,
				store: store,
				displayInfo: true
			})
			//plugins	: editing,
		});
		this.callParent(arguments);
	}
})