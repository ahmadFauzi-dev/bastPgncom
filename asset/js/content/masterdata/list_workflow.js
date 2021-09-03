function apps(name, iconCls) {
    
	var gridworkflowjabatan = Ext.create('masterdata.view.grid_workflowjabatan');
	var jenis_workflow = Ext.create('masterdata.view.jenis_workflow');
	var gridworkflow = Ext.create('masterdata.view.grid_workflow');
	
	var tabPanel = Ext.getCmp('contentcenter');
	tabPanel.items.each(function(c){
		if (c.title != 'Home'){
			tabPanel.remove(c);
		}
	});
	
    //var items = tabPanel.items.items;
    var exist = false;
  
    if (!exist){
        
		// Ext.getCmp('contentcenter')
		tabPanel.add({
			height: 500,
			id:'workflow',
			title: 'Workflow',
			layout: 'border',
			items: [{
				// xtype: 'panel' implied by default
				region:'west',
				xtype		: 'panel',
				margins	: '5 0 0 5',
				width 	: 500,
				border	: false,
				//collapsible: true,   // make collapsible
			   // id: 'west-region-container',
				layout	: 'fit',
				items 	: [{
						layout: {
						type: 'vbox',
						pack: 'start',
						align: 'stretch',
						border:false,
						scroll:true
						},
						items:[
						{
							flex:1,
							layout: 'fit',
							items: gridworkflowjabatan
						}]
				}]
			},
			{
				//title: 'Center Region',
				region: 'center',
				xtype: 'panel',
				layout: 'fit',
				border:true,
				margins: '5 5 0 0',
				items:[{
						//overflowY	: 'scroll',
						collapsible	: false,
						activeItem: 0,
						fit		: true,
						split	: true,
						type:'hbox',
						border:false,
						items: [
						{	
							flex:1,
							layout: 'fit',
							border:false,
							items:jenis_workflow
						},
						{
							flex:2,
							layout: 'fit',
							items:gridworkflow
						}]
					
				}]
			}]
        });
        tabPanel.setActiveTab('workflow');
    }
}