Ext.Loader.setConfig({enabled: true});
Ext.require([
	'Ext.window.Window',
    'Ext.tab.*',
	'Ext.form.*',
	'Ext.layout.container.Column',
	'Ext.tab.Panel'
    
]);
Ext.onReady(function()
{
	Ext.QuickTips.init();
	var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
	var loin_items	= Ext.create ('Ext.form.Panel',{
		xtype: 'form',
        layout: 'column',
        id: 'simpleForm',
        //url: base_url+'ceklogin/login',
        method	: 'POST',
        frame: false,
		items	: [{
			xtype	: 'panel',
			height	: 90,
			width	: 600,
			border	: false,
			html	: '<div style="border-bottom:solid 1px;padding:5px"><div class = "logo"><img src = "'+base_url+'asset/image/pgas.png"  height="70px"></div>'
		
		},
		{
			xtype	: 'panel',
			border	: false,
        	bodyPadding: '10 0 0 55',
        	defaultType: 'textfield',
			items	: [{
				xtype	: 'textfield',		  
       			fieldLabel: 'Old Password :',
             	afterLabelTextTpl: required,
             	name: 'oldpass',
             	id	: 'oldpass',
				inputType: 'password',
             	allowBlank: false 	
			},
			{
				xtype	: 'textfield',
				fieldLabel: 'New Password :',
				afterLabelTextTpl: required,
				name: 'newpass',
             	id	: 'newpass',
				inputType: 'password',
             	allowBlank: false 
			},
			{
				xtype				: 'textfield',
				fieldLabel			: 'Confirm Password',
				afterLabelTextTpl	: required,
				name				: 'pass2',
				id					: 'pass2',
				inputType			: 'password',
				allowBlank			: false,
				validator: function(value) {
					var password1 = this.previousSibling('[name=newpass]');
					return (value === password1.getValue()) ? true : 'Passwords do not match.'
				}
			}]
		}]
	})
	Ext.create('Ext.Window', {
        title: 'Login SMAP',
        width: 550,
        height: 280,
		closable: false,
        headerPosition: 'top',
        layout: 'fit',
		items	: loin_items,
		buttons	: [{
			 text: 'Set Ulang Kata Sandi',
		},
		{
			text	: 'Batal'
		}]
    }).show();
});