function apps(name, iconCls) {
    
    var formanomaliamr = Ext.create('dashboard.form.searchvalidasiparetoanomali');
	//var gridanomaliamr = Ext.create('analisa.view.gridanomaliamr');
	//var gridanomalistatus = Ext.create('analisa.view.gridanomalistatus');
	//var gridvolumehourly = Ext.create('analisa.view.gridvolumehourly');
	
	// var griddetaildata = Ext.create('analisa.view.griddatadetail');
	// var griddetaildata;
    //var gridkelamr = Ext.create('analisa.view.gridkelamr');	
	var msclass = Ext.create('master.global.geteventmenu'); 
	var tiketnumber = msclass.getticket();
    var tabPanel = Ext.getCmp('contentcenter');
	tabPanel.items.each(function(c){
		if (c.title != 'Home') {
			tabPanel.remove(c);
		}
	});
	var d = new Date();
	month = '' + (d.getMonth() + 1);
	day = '' + d.getDate();
	year = d.getFullYear();
	
	if	(parseInt(month) < 10)
	{
		month = '0' + (d.getMonth() + 1);
	}
	if (parseInt(d.getDate()) < 10) 
	{
		day = '0' + d.getDate();
	}
	
	var tanggal_awal = year+'-'+month+'- 01';
	var tanggal_akhir = msclass.formatDate(Date());
    var items = tabPanel.items.items;
    var exist = false;
    // for (var i = 0; i < items.length; i++) {
        // if (items[i].id == '3') {
            // tabPanel.setActiveTab('3');
            // exist = true;
        // }
    // }
    if (!exist) {
        // Ext.getCmp('contentcenter')
		tabPanel.add({
            title: name,
            id: '3',
            xtype: 'panel',
            iconCls: iconCls,
            closable: true,
            layout: 'border',
            // overflowY	: 'scroll',
            defaults: {
                collapsible: true,
                split: true,
              
            },
            items: [{
                xtype: 'panel',
                title: 'Form Search',
                flex: 1,
				id : 'searchanomaliform',
                region: 'west',
                bodyStyle: 'padding:5px',
                items: formanomaliamr
            }, {
                xtype: 'tabpanel',
                flex: 3,
				id : 'TabAsikAja',
                collapsible: false,				
                region: 'center',
				activeTab	: 0,				
				fit		: true,							
				items	: [{
					xtype	: 'panel',
					title  : name,
					frame: true,	
					iconCls 	: 'application_view_gallery',
					layout: 'border',
					defaults: {
						collapsible: true,
						split: true,
					},
					items	: [			
					{
						xtype : 'panel',
						title : name,
						frame	: true,
						region : 'center',
						collapsible: false,
						flex: 3,		
						border: false,
						layout	: 'fit',
						//height	: 1000,
						//autoScroll	: true,
						id		: 'panelprovisionalvalidasi',
						//layout: 'anchor',
						//height	: 1000,
						items	: [{
							xtype: 'tableauviz',
							//height	: 1000,
							id		: 'tableauviz',
							flex	: 1,
							vizUrl	: "http://192.168.104.167:8000/trusted/"+tiketnumber+"/#/views/ParetoAnomali_0/ParetoAnomaliDashboard?start_date="+tanggal_awal+"&end_date="+tanggal_akhir+"&:refresh=yes&:toolbar=no&:tabs=no&group_id="+group_id+"&username="+username+""
						}]						
					}]
				}]
            }]
        });
        tabPanel.setActiveTab('3');
    }
	var viz = Ext.getCmp('tableauviz');
	var me = this;
	console.log("http://192.168.104.167:8000/trusted/"+tiketnumber+"/#/views/ParetoAnomali/ParetoAnomaliDashboard?start_date="+tanggal_awal+"&end_date="+tanggal_akhir+"&:refresh=yes&:toolbar=no&group_id="+group_id+"&username="+username+"");
	/*
	viz.on('marksselected', function(cmp, marks) {
		console.log(marks[0][3].formattedValue);
		var id_pel = marks[0][3].formattedValue;
		if (id_pel != '')
		{
			
			//console.log("Masuk");
			var msclass = Ext.create('master.global.geteventmenu'); 
			var tiketnumber2 = msclass.getticket();
			 var tabPanel = Ext.getCmp('contentcenter');
				tabPanel.items.each(function(c){
					if (c.id == '3detailwaktuvalidasi') {
						tabPanel.remove(c);
					}
				});
				
				var items = tabPanel.items.items;
				var exist = false;
				
				if (!exist) {
					// Ext.getCmp('contentcenter')
					tabPanel.add({
						title: name,
						id: '3detailwaktuvalidasi',
						xtype: 'panel',
						iconCls: iconCls,
						closable: true,
						layout: 'border',
						// overflowY	: 'scroll',
						defaults: {
							collapsible: true,
							split: true,
							//bodyStyle: 'padding:5px'
						},
						// bodyPadding: '5 5 0',
						items: [
						{
							xtype : 'panel',
							title : name+" Area "+marks[0][0].formattedValue,
							frame	: true,
							region : 'center',
							layout: 'fit',
							collapsible: false,
							flex: 3,		
							//items	: gridanomaliamr,
							// autoScroll : true,
							border: false,
							//height	: 1000,
							autoScroll	: true,
							items	: [{
								xtype: 'tableauviz',
								//height	: 1000,
								flex	: 1,
								vizUrl	: "http://192.168.104.167:8000/trusted/"+tiketnumber2+"#/views/Detailalertanomali/Dashboard1?idreff="+id_pel+""
							}]
						}]
					});
					tabPanel.setActiveTab('3detailwaktuvalidasi');
				}
		}
	});*/
}