Ext.define('EM.tools.view.form' ,{
    extend: 'Ext.form.Panel',
    alias : 'widget.formco',
    initComponent: function() {
		Ext.apply(this, {
		frame		: false,
		border		: false,
		layout		: 'form',
		url			: base_url+'admin/addVoucher',
		bodyPadding: '5 5 0',
			fieldDefaults: {
			labelAlign: 'left',
			anchor: '60%',
			labelWidth: 100
		},
		id			: 'formBulk',
		items		: [
		{	
			xtype		: 'fieldset',
			defaultType	: 'textfield',
			title		: 'Bulk Customer',
			collapsible	: true,
			fileUpload	: true,
			layout		: 'anchor',
				defaults: {
				anchor: '60%'
			},
			items		: [{
				xtype		: 'combobox',
				fieldLabel	: 'SBU'
				//value		: 'Bekasi Power'
			},
			{
				xtype		: 'combobox',
				fieldLabel	: 'Area'
			},
			{
				xtype		: 'fieldcontainer',
				anchor		: '100%',
				layout		: 'hbox',
				items		: [{
					xtype		: 'datefield',
					//flex		: 2,
					fieldLabel	: 'Pressure Base'
				},
				{
					xtype			: 'datefield',
					margins			: '0 0 0 5',
					//flex			: 2,
					labelWidth		: 150,
					fieldLabel		: 'Temperature Base'
					
				}]
				
			}]
		}],
		buttons		: [{
			text		: 'Search'
		},
		{
			text		: 'Reset'
		}]
		});

        this.callParent(arguments);
    }
});