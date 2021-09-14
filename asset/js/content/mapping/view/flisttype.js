Ext.define('mapping.view.flisttype' ,{
    extend: 'Ext.form.Panel',
    alias : 'widget.flisttype',
    initComponent: function() {
		var stosbu = Ext.create('mapping.store.sbu');
		var stoarea = Ext.create('mapping.store.area');
		
		stosbu.load();
		stoarea.load();
		
		
		Ext.apply(this, {
		//frame		: false,
		//border	: false,
		layout		: 'form',
		url			: base_url+'mapping/pelanggan',
		bodyPadding: 5,
			fieldDefaults: {
			labelAlign: 'left',
			anchor: '100%',
			//labelWidth: 100
		},
		id			: 'formsearch',		
		
		tbar : [
		{
			text 	: 'Download Template',
			iconCls : 'download',
			xtype   : 'button'
		} ,
		{
			text 	: 'Upload',
			iconCls : 'arrow_up',
			xtype   : 'button'			
		}
		],
		items		: [{
			xtype:'fieldset',
            //checkboxToggle:true,
            title: '',
            defaultType: 'textfield',
            //collapsed: true,
            //layout: 'anchor',
            /*defaults: {
                anchor: '100%'
            },*/
			items		: [
			{
				xtype		: 'combobox',
				//labelAlign	: 'top',
				displayField	: 'description',
				valueField		: 'rowid',
				store			: stosbu,
				queryMode		: 'local',
				//pageSize : 5,
				listeners : 
				{
					select: function(combo, selection) 
						{
							var row_id = combo.getValue(); 
							stoarea.reload( { params: { area: row_id }} );
						}
				},
				anchor		: '100%',
				name		: 'sbuid',
				fieldLabel	: 'SBU',
			},
			{
				xtype		: 'combobox',
				//labelAlign	: 'top',
				displayField	: 'namearea',
				valueField		: 'rowid',
				store			: stoarea,
				queryMode		: 'local',
				listeners : 
				{
					select: function(combo, selection) 
						{
							var row_id = combo.getValue(); 
							stostation.reload( { params: { area: row_id }});
						}
				},

				anchor		: '100%',
				name		: 'areaid',
				fieldLabel	: 'Area',
				//value		: '5%'
			},
			{
				xtype		: 'textfield',
				//labelAlign	: 'top',
				name		: 'periode',
				fieldLabel	: 'Periode'
			}]
		}],
		buttons		: [{
			text	: 'Search',
			iconCls : 'magnifier',
			handler	: function()
			{
				this.up('form').getForm().submit({
					waitTitle	: 'Harap Tunggu',
					waitMsg		: 'Insert data',
					success	:function(form, action)
					{
						//store_site.reload();
						//Ext.Msg.alert('Sukses','Penambahan Content Sukses');
					},
					failure:function(form, action)
					{
						Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");
					}
				});
			}
		},
		{
			text	: 'Reset',
			iconCls : 'arrow_refresh',
			handler	: function()
			{
				this.up('form').getForm().reset();
			}
		}]
		});

        this.callParent(arguments);
    }
});