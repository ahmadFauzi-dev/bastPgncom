Ext.define('master.view.libmessageanomaligrid' ,{
    extend: 'Ext.form.Panel',
    //alias : 'widget.formco',
    initComponent: function() {
		Ext.apply(this, {
		frame		: false,
		border		: false,
		layout		: 'form',
		width      	: 600,
		url			: base_url+'admin/insertlibmessage',
		bodyPadding: '5 5 0',
			fieldDefaults: {
			labelAlign: 'left',
			anchor: '60%',
			labelWidth: 100
		},
		id			: 'formgengrid',
		items		: [{
			fieldLabel	: 'ID',
			anchor		: '60%',
			xtype		: 'textfield',
			name		: 'id' 
		},
		{
			fieldLabel	: 'Description',
			anchor		: '60%',
			name		: 'desc',
			xtype		: 'textareafield'
		},
		{
            xtype      : 'fieldcontainer',
            fieldLabel : 'Flaging',
            defaultType: 'radiofield',
            defaults: {
                flex: 1
            },
            layout: 'hbox',
            items: [
                {
                    boxLabel  : 'Error',
                    name      : 'flaging',
                    inputValue: 'error',
                    id        : 'error'
                }, {
                    boxLabel  : 'Warning',
                    name      : 'flaging',
                    inputValue: 'warning',
                    id        : 'warning'
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