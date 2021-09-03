Ext.define('master.view.formaddconfig' ,{
    extend: 'Ext.form.Panel',
    //alias : 'widget.formco',
    initComponent: function() {
		Ext.apply(this, {
		frame		: false,
		border		: false,
		layout		: 'form',
		url			: base_url+'admin/submitconfig',
		bodyPadding: '5 5 0',
			fieldDefaults: {
			labelAlign: 'left',
			anchor: '60%',
			labelWidth: 100
		},
		id			: 'formaddconfig',
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
				name		: 'id',
				hidden		: true,
				value		: idrow	
			},
			{
				xtype		: 'textfield',
				name		: 'refid',
				hidden		: true,
				value		: refid
			},
			{
				xtype		: 'textfield',
				name		: 'stationname',
				hidden		: true,
				value		: statname
			},
			{
				xtype		: 'textfield',
				labelAlign	: 'top',
				anchor		: '30%',
				name		: 'confname',
				fieldLabel	: 'Config Name',
			},
			{
				xtype		: 'numberfield',
				labelAlign	: 'top',
				anchor		: '30%',
				name		: 'value',
				fieldLabel	: 'Value',
				//value		: '5%'
			}]
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