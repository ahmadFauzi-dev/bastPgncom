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
        //url: base_url+'ceklogin/change_pass',
        method	: 'POST',
        frame: false,
		items	: [{
			xtype	: 'panel',
			height	: 90,
			width	: 600,
			border	: false,
			html	: '<div style="border-bottom:solid 1px;padding:5px"><div class = "logo"><img src = "'+base_url+'asset/image/pgas.png" height="70px"></div>'
		},
		{
			xtype	: 'panel',
			border	: false,
        	bodyPadding: '10 0 0 55',
        	defaultType: 'textfield',
			items	: [{
				xtype	: 'textfield',		  
       			fieldLabel: 'Nama User :',
             	afterLabelTextTpl: required,
             	name: 'username',
             	id	: 'username',
             	allowBlank: false 	
			},
			{
				xtype	: 'textfield',
				fieldLabel: 'Alamat Email :',
				afterLabelTextTpl: required,
				name: 'email',
				vtype:'email',
             	id	: 'email',
             	allowBlank: false 
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
			 handler	: function()
			 {
				window.location.href = base_url+"login/change_pass";
			 }
		},
		{
			text	: 'Batal'
		}]
    }).show();
});