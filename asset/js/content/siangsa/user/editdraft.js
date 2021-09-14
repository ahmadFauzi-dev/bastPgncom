function apps(name, iconCls) {
	
    var pageId = Init.idmenu;
	//var form_draft = Ext.create('siangsa.user.form_editdraft');	
	
	var tabPanel = Ext.getCmp('contentcenter');
	tabPanel.items.each(function(c){
		if (c.title != 'Home') {
			tabPanel.remove(c);
		}
	});   
	
    var exist = false;
    if (!exist) {
		tabPanel.add({
            title: name,
            id: 'editdraft',
            xtype		: 'panel',
            iconCls		: iconCls,
            closable	: true,
			frame 		: true,
            layout		: 'border',
			autoWidth: true,
            defaults: {
                collapsible: false,
                split: true
            },
            items		: 
			[{
					xtype	: 'panel',
					region	: 'center',
					title	: 'Buat Konsep Baru',
					layout: 'fit',
					margins: '5,0,0,0',
					//items : form_editdraft	
			}]	
        });
       // Ext.getCmp('form_editdraft'+pageId).getForm().reset();
		tabPanel.setActiveTab('editdraft');
	}
	
}