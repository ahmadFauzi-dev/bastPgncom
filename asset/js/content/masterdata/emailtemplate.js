function apps(name, iconCls) {
    
	var email_template = Ext.create('masterdata.view.email_template');
	
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
            id: 'emailtemplate',
            xtype: 'panel',
            iconCls: iconCls,
			border: false,
			// frame	: true,           
            closable: true,
			layout : 'fit',
            items:[
			{
				border: false,
				xtype : 'panel',
				layout : 'fit',
				fit		: true,	
				items	: email_template
			}]			
        });
        tabPanel.setActiveTab('emailtemplate');
    }
}