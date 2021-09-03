Ext.define('setting.view.formaddmenu' ,{
		extend: 'Ext.form.Panel',
		initComponent: function() {
			Ext.apply(this, {
				frame		: false,
				border		: false,
				layout		: 'form',
				frame  		: false,
				method		: 'POST',
				url			: base_url+'admin/settings/addmenu',
				bodyPadding: '5 5 0',
				fieldDefaults: {
					labelAlign: 'left',
					anchor: '60%'
				},
				id			: 'formanalisa',
				items		: 
				[			
					{
						xtype		: 'textfield',
						fieldLabel	: 'Menu Name',						
						name		: 'name'
					},{
						xtype		: 'textfield',
						fieldLabel	: 'Icon Class',
						name		: 'iconcls'
					},
					{
						xtype		: 'textfield',
						fieldLabel	: 'Action',
						name		: 'act'
					},
					{
						xtype		: 'textfield',
						fieldLabel	: 'Parent',
						id			: 'parent',
						hidden  	: true,
						name		: 'parent'
					},
					{
						xtype		: 'textfield',
						fieldLabel	: 'Parent',
						id			: 'parentName',
						disabled	: true
					},
					{
						xtype		: 'textfield',
						fieldLabel	: 'Path',
						name		: 'path'
					}					
				],
				buttons		: [
				{
					text	: 'Save',
					iconCls : 'database_save',
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
					text	: 'Reset',
					iconCls : 'arrow_refresh',
					handler	: function()
					{
						
					}
				}
				]
		});

		this.callParent(arguments);
	}
	});