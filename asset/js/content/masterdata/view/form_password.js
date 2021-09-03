function apps(name, iconCls) {
	
    var tabPanel = Ext.getCmp('contentcenter');
	tabPanel.items.each(function(c){
		if (c.title != 'Home') {
			tabPanel.remove(c);
		}
	});
	

    var exist = false;
    if (!exist) {
		tabPanel.add({
				id				: 'panel_password',
				title			: 'Form Change Password',
				icon			: base_url+'asset/icons/user_edit.png',
				xtype		: 'panel',
				closable	: true,
				border:false,
				overflowY	: 'scroll',
				bodyPadding	: 5,
				items	: [
				{
					xtype: 'panel',
					id: 'notif',
					flex:3,
					//height	: 100,
					bodyPadding: '5 0 0 10',
					region  : 'north',
					border	: false,
					//flex	:1,
					html	: ''
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
						xtype	: 'form',
						url: base_url+'admin/changepassword',
						labelSeparator : "",
						border	: false,
						bodyPadding: '0 0 0 5',
						region  : 'center',
						items	: [
							{
								xtype	: 'textfield',
								fieldLabel: 'Kata Sandi Lama:',
								afterLabelTextTpl: required,
								name: 'pass',
								//id	: 'pass',
								inputType	: 'password',
								allowBlank: false ,
								enableKeyEvents: true,
								listeners: {	
									
								} 	
							},
							{
								xtype	: 'textfield',
								fieldLabel: 'Kata Sandi Baru:',
								afterLabelTextTpl: required,
								name: 'pass1',
								//vtype : password,
								id	: 'pass1',
								inputType	: 'password',
								allowBlank: false ,
								//enableKeyEvents: true,
								minLength: 8,
								maxLength: 32,
								listeners: {	
									
								}	
							},
							{
								xtype	: 'textfield',
								fieldLabel: 'Ulangi Kata Sandi Baru:',
								afterLabelTextTpl: required,
								//vtype : password,
								name: 'pass2',
								id	: 'pass2',
								inputType	: 'password',
								allowBlank: false ,
								//enableKeyEvents: true,
								minLength: 8,
								maxLength: 32,
								listeners: {	
								
								}
							}],
							buttonAlign: 'left',
							buttons	: [
							{
								text	: 'Save',
								iconCls : 'disk',
								handler : function() {
										var pass1 = Ext.getCmp('pass1').getValue();
										var pass2 = Ext.getCmp('pass2').getValue();
										
										if (pass1 != pass2){
												Ext.getCmp('notif').update('<div style="border-right: 1px solid #f0f0f0;margin-left:5px;margin-top:10px";><p style="color:red">Ulang Sandi Baru Tidak Sama Dengan Sandi Baru!!</a></div>');
										}
										else{
													//if(this.up('form').getForm().isValid()){
															this.up('form').getForm().submit({
																waitTitle	: 'Harap Tunggu',
																waitMsg		: 'Update data',
																//scope:this,
																params:{
																	karyawan_id : myuser_id
																},
																success	:function(form, action)
																{
																	Ext.getCmp('notif').update('<div style="border-right: 1px solid #f0f0f0;margin-left:5px;margin-top:10px";><p style="color:red">Ganti Sandi Baru Berhasil</a></div>');
																},
																failure:function(form, action)
																{
																	Ext.getCmp('notif').update('<div style="border-right: 1px solid #f0f0f0;margin-left:5px;margin-top:10px";><p style="color:red">Input Password Lama Salah</a></div>'); 
																}
														});
													//}
										}
								}
							}]
					}]
				}],
        });
        tabPanel.setActiveTab('panel_password');
    }
}