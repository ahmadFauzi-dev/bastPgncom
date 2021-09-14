function apps(name, iconCls) {
	
    var pageId = Init.idmenu;
	var form_draft = Ext.create('siangsa.user.form_draft');
	
	
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
            id: 'fdraft',
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
					collapsed :false,
					title	: 'Buat Konsep Baru',
					layout: 'fit',
					margins: '5,0,0,0',
					items : form_draft	
			}]	
        });
        Ext.getCmp('form_draft'+pageId).getForm().reset();
		tabPanel.setActiveTab('fdraft');
	}
	
}