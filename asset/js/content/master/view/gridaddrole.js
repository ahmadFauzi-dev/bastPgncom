Ext.define('master.view.gridaddrole' ,{
    extend: 'Ext.form.Panel',
    //alias : 'widget.formco',
    initComponent: function() {
	var filter = [];
	
	var msclass 		= Ext.create('master.global.geteventmenu');
	var model 			= msclass.getmodel('mappingcolumn');
	var store 		  	= msclass.getstore(model,'mappingcolumn',filter);
	var columns 		= msclass.getcolumn('mappingcolumn');	
	var coldisplay		= [];
	//coldisplay = columns;
	coldisplay[0] = columns[0];
	
	coldisplay[1] = {
		xtype		: 'actioncolumn',
		width		: 30,
		items		: [{
			icon	: ''+base_url+'/asset/ico/56.ico',
			handler	: function(grid, rowIndex, colIndex)
			{
				var rec = grid.getStore().getAt(rowIndex);
				var id = rec.get(columns[3].dataIndex);
				var j = Ext.getCmp('contentextarea').getValue();
				Ext.getCmp('contentextarea').setRawValue(""+j+" "+id+"");
			}
		}]
	};
	coldisplay[2] = {
		text	: "Variable",
		dataIndex	: columns[3].dataIndex
	};
	coldisplay[3] = {
		text	: "Periode",
		dataIndex	: columns[5].dataIndex
	}
	coldisplay[4] = 
	{
		text	: "Table",
		dataIndex	: columns[1].dataIndex
	}
	var storeParameter = Ext.create("Ext.data.Store",{
		fields		: ['ID','cols'],
		data		: [{
			"ID"	: "1",
			"cols"	: "Flow_Rate"
		},
		{
			"ID"	: "2",
			"cols"	: "Rate_Energy "
		},
		{
			"ID"	: "3",
			"cols"	: "Previous_Hourly_Net_Totalizer"
		},
		{
			"ID"	: "4",
			"cols"	: "Previous_Hourly_Net_Energy "
		},
		{
			"ID"	: "5",
			"cols"	: "Pressure_Outlet"
		},
		{
			"ID"	: "6",
			"cols"	: "Temprature"
		},
		{
			"ID"	: "7",
			"cols"	: "Prev_Day_GHV"
		},
		{
			"ID"	: "8",
			"cols"	: "Diffrential_Pressure"
		},
		{
			"ID"	: "9",
			"cols"	: "Pressure_Flowing"
		},
		{
			"ID"	: "10",
			"cols"	: "Temperatur_Flowing"
		},
		{
			"ID"	: "11",
			"cols"	: "Pressure Outlet PCV"
		},
		{
			"ID"	: "12",
			"cols"	: "Volume_Daily"
		},
		{
			"ID"	: "13",
			"cols"	: "SUM_Daily"
		}]
	});
	store.load();
	var gridData = Ext.create('Ext.grid.Panel',{
		store		: store,
			multiSelect	: true,
			//height		: 300,
			autoScroll	: true,
			id			: ''+Init.idmenu+'griddetailrole',
			dockedItems	: [
				{
					xtype: 'toolbar',
					items	: [{
						iconCls	: 'page_white_excel',
						xtype	: 'exporterbutton',
						text	: 'Export',
						//hidden	: role.p_export,
						format	: 'excel'
					}]
				}
			],
			columns		: coldisplay,
			//features	: [filterconfig],
			//plugins	: editing,
			bbar: Ext.create('Ext.PagingToolbar', {
				pageSize: 10,
				store: store,
				displayInfo: true
		})
	});
	
	/*
	var gridData = Ext.create('Ext.grid.Panel',{
		store		: storeParameter,
		title		: 'Parameter',
		multiSelect	: true,
		autoScroll	: true,
		id			: 'gridDataParameterValue',
		columns		: [
		{
			xtype		: 'actioncolumn',
			width		: 30,
			items		: [{
				icon	: ''+base_url+'/asset/ico/56.ico',
				handler	: function(grid, rowIndex, colIndex)
				{
					var rec = grid.getStore().getAt(rowIndex);
					var id = rec.get('cols');
					var j = Ext.getCmp('contentextarea').getValue();
					Ext.getCmp('contentextarea').setRawValue(""+j+" "+id+"");
				}
			}]
		},{
			dataIndex	: 'cols',
			flex		: 1
		}]
	});
	*/
	
		Ext.apply(this, {
		frame		: false,
		border		: false,
		layout		: 'form',
		//height		: 200,
		//width      	: 600,
		url			: base_url+'admin/addroledetail',
		params		: {'idmsrole' : 115113},
		bodyPadding: '5 5 0',
			fieldDefaults: {
			labelAlign: 'left',
			anchor: '60%',
			labelWidth: 100
		},
		id			: 'formaddroledetail',
		items		: [
		{
			xtype		: 'textfield',
			name		: 'idrole',
			id			: 'idrole',
			hidden		: true
		},
		{
			fieldLabel	: 'Code ID',
			anchor		: '60%',
			id			: 'codeId',
			//value		: data.id,
			xtype		: 'textfield',
			disabled	: true,
			name		: 'id' 
		},
		{
			fieldLabel	: 'Description',
			anchor		: '60%',
			id			: 'iddescription',
			name		: 'desc',
			disabled	: true,
			//value		: data.Description,
			rows		: 2,
			xtype		: 'textareafield'
		},
		{
            xtype      : 'fieldcontainer',
            //fieldLabel : 'Flaging',
            //defaultType: 'radiofield',
            defaults: {
                flex: 1
            },
            layout: 'hbox',
            items: [
                {
                    fieldLabel  : 'Formula',
                    name        : 'formula',
					id			: 'contentextarea',
					labelAlign	: 'top',
					rows		: 4,
					xtype		: 'textareafield'
                },
				{
                    xtype		: 'panel',
					width		: 450,
					height		: 200,
					overflowY	: 'scroll',
					margins		: '0 0 0 5',
					items		: gridData
                } 
            ]
        }],
		buttons		: [{
			text	: 'Submit',
			handler	: function()
			{
				this.up('form').getForm().submit({
					waitTitle	: 'Harap Tunggu',
					waitMsg		: 'Insert data',
					success	:function(form, action)
					{
						//store_site.reload();
						Ext.Msg.alert('Sukses','Penambahan Content Sukses');
					},
					failure:function(form, action)
					{
						Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");
					}
				});
			}
		},
		{
			text	: 'Cancel'
		}]
		});

        this.callParent(arguments);
    }
});