Ext.define('master.view.formgen' ,{
    extend: 'Ext.form.Panel',
    //alias : 'widget.formco',
    initComponent: function() {
		Ext.apply(this, {
		frame		: false,
		border		: false,
		layout		: 'form',
		url			: base_url+'admin/genGridquery',
		bodyPadding: '5 5 0',
			fieldDefaults: {
			labelAlign: 'left',
			anchor: '60%',
			labelWidth: 100
		},
		id			: 'formgengrid',
		items		: [{
			xtype:'fieldset',
            //checkboxToggle:true,
            title: 'Table Config',
            defaultType: 'textfield',
            //collapsed: true,
            layout: 'anchor',
            defaults: {
                anchor: '60%'
            },
			items		: [
			{
				xtype		: 'textfield',
				labelAlign	: 'top',
				anchor		: '30%',
				name		: 'name',
				fieldLabel	: 'Name',
			},
			{
				xtype		: 'textfield',
				labelAlign	: 'top',
				anchor		: '30%',
				name		: 'path',
				fieldLabel	: 'Path File',
				//value		: '5%'
			},
			{
				xtype		: 'textfield',
				labelAlign	: 'top',
				name		: 'contstore',
				fieldLabel	: 'controller Store'
			}]
		},
		{
			xtype			: 'textareafield',
			labelAlign		: 'top',
			name			: 'query',
			height			: 180,
			fieldLabel		: 'Query'
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