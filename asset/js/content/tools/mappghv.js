function apps(name,iconCls)
{
	Ext.QuickTips.init();
	var tabPanel = Ext.getCmp('contentcenter');
	var items = tabPanel.items.items;
	var exist = false;
	//var tb = 'tb_role_type';
	var me = this;
	
	var form = Ext.create('Ext.form.Panel',{
		frame		: false,
		border		: false,
		layout		: 'form',
		bodyPadding: '5 5 0',
			fieldDefaults: {
			labelAlign: 'left',
			anchor: '60%',
			labelWidth: 100
		},
		id			: 'formBulk',
		items		: [{
			xtype:'fieldset',
            checkboxToggle:true,
            title: 'Filter',
            defaultType: 'textfield',
            //collapsed: true,
            layout: 'anchor',
            defaults: {
                anchor: '60%'
            },
			items		:	[{
				xtype		: 'fieldcontainer',
				fieldLabel	: 'Periode',
				anchor		: '100%',
				labelAlign	: 'Top',
				items		: [{
					xtype	: 'datefield',
					fieldLabel	: 'From'
				},
				{
					xtype	: 'datefield',
					fieldLabel	: 'To'
				}]
			},
			{
				xtype		: 'fieldcontainer',
				fieldLabel	: 'Lokasi',
				anchor		: '100%',
				labelAlign	: 'Top',
				items		: [{
					xtype	: 'textfield',
					fieldLabel	: 'SBU'
				},
				{
					xtype	: 'textfield',
					fieldLabel	: 'Area'
				}]
			}]
		}]
	});
	
	for(var i = 0; i < items.length; i++)
	{
        if(items[i].id == name){
				tabPanel.setActiveTab(name);
                exist = true;
        }
    }
	
	if(!exist){
		Ext.getCmp('contentcenter').add({
			title		: 'Mapping GHV Pelanggan',
			id			: name,
			xtype		: 'panel',
			iconCls		: iconCls,
			closable	: true,
			overflowY	: 'scroll',
			bodyPadding: '5 5 0',
			items		: [{
				xtype 		: 'panel',
				title		: 'Mapping GHV Pelanggan',
				bodyPadding	: 5,
				margins		: '10',
				items		: form
			}]
		});
		tabPanel.setActiveTab(name);	
	}
}