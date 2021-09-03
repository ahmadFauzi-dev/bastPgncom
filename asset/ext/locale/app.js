Ext.Loader.setConfig({enabled: true});
Ext.require(['*']);
Ext.onReady(function()
	{
		Ext.QuickTips.init();
		var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
		var loin_items	= Ext.create ('Ext.form.Panel',{
				xtype: 'form',				
				layout: 'border',
				//id: 'simpleForm',
				url: base_url+'login/ceklogin',
				method	: 'POST',
				frame: false,
				items	: [
					{
						xtype	: 'panel',
						flex:3,
						//height	: 100,
						bodyPadding: '5 0 0 10',
						region  : 'north',
						border	: false,
						//flex:1,
						html	: '<div style="border-right: 1px solid #f0f0f0;margin-left:15px;margin-top:10px"><img src = "'+base_url+'asset/image/logo-wijaya.png" ></div>'
					},
					{
						xtype	: 'panel',
						border	: false,
						//flex:1,
						region  : 'center',
						flex:2,
						bodyPadding: '5 0 0 10',        	
						items	: [
							{
								xtype	: 'panel',
								border	: false,
								bodyPadding: '0 0 0 5',
								region  : 'center',
								items	: [
									{
										xtype	: 'textfield',		  
										fieldLabel: 'Nama User :',
										afterLabelTextTpl: required,
										name: 'username',
										id	: 'username',
										allowBlank: false 	
									},
									{
										xtype	: 'textfield',
										fieldLabel: 'Kata Sandi :',
										afterLabelTextTpl: required,
										name: 'pass',
										id	: 'pass',
										inputType	: 'password',
										allowBlank: false ,
										enableKeyEvents: true,
										listeners: {	
											keypress:function(textfield, e) {
												if (e.button == 12) {
													doLogin();
												}
											}
										}	
									}
								]
							}]
					}],
					
				buttons	: [{
						text: 'Login',
						iconCls : 'computer_key',
						handler	: function()
						{
							doLogin();
						}
					},
					{
						text	: 'Reset',
						iconCls : 'arrow_refresh',
						handler : function() {loin_items.getForm().reset();}
					}]
			});
	
		function doLogin() {			
			if (loin_items.getForm().isValid()) {
				loin_items.getForm().submit({	
						waitTitle: 'Harap Tunggu', 
						waitMsg: 'Sending data...',					
						success: function(){
							window.location.href = base_url+'admin';
						},
						failure: function(form, action){
							Ext.Msg.alert('Harap Tunggu...', "" + action.response.responseText + "");				
							loin_items.getForm().reset(); 
						} 
					});
			}
		}	
	
		Ext.create('Ext.Window', {
				title	: 'SYFA | WIJAYA ',
				iconCls : 'pgascom',
				width	: 430,
				height	: 300,
				closable: false,
				headerPosition: 'top',
				layout: 'fit',
				items	: loin_items
			}).show();
	});