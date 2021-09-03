function apps(name, iconCls) {
    
    var formanomaliamr = Ext.create('dashboard.form.searchvalidasiprovisional');
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
	
    var items = tabPanel.items.items;
    var exist = false;
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
                //bodyStyle: 'padding:5px'
            },
            // bodyPadding: '5 5 0',
            items: [{
                xtype: 'panel',
                title: 'Form Search',
                flex: 1,
				id : 'searchanomaliform',
                region: 'west',
                // layout 		: 'fit',
                bodyStyle: 'padding:5px',
                items: formanomaliamr
            }, {
					xtype : 'panel',
					title : name,
					frame	: true,
					region : 'center',
					collapsible: false,
					flex: 3,							
					border: false,
					//layout	: 'fit',
					//height	: 800,
					//autoScroll	: true,
					id			: 'panelprovisionalvalidasi',
					layout: 'anchor',
					height	: 1000,
					autoScroll	: true,
					items	: [{
						xtype: 'tableauviz',
						height	: 1000,
						id		: 'tableauviz',
						flex	: 1,
						vizUrl	: "http://192.168.104.167:8000/trusted/"+tiketnumber+"/#/views/Dashboardvalidasipelangganprovisionalpersentase/Dashboard1?startdate="+tanggal_awal+"&endate="+tanggal_akhir+"&:refresh=yes&:toolbar=yes&:tabs=no&group_id="+group_id+"&username="+username+""
					}]	
					
				}]
        });
        tabPanel.setActiveTab('3');
    }
	//console.log("http://192.168.104.167:8000/trusted/"+tiketnumber+"/#/views/Dashboardvalidasipelangganprovisionalpersentase/Dashboard1?startdate="+tanggal_awal+"&endate="+tanggal_akhir+"&:refresh=yes&:toolbar=yes&:tabs=no&group_id="+group_id+"&username="+username+"")
	//var viz = this.down('tableauviz');
	var viz = Ext.getCmp('tableauviz');
	var me = this;
	
	viz.on('marksselected', function(cmp, marks) {
		
		//var keterangan = marks;
		console.log(marks);
		if(marks[0][1].formattedValue == "Approve")
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
							//autoScroll	: true,
							items	: [{
								xtype: 'tableauviz',
								//height	: 1000,
								flex	: 1,
								vizUrl	: "http://192.168.104.167:8000/trusted/"+tiketnumber2+"#/views/DashboardPelangganWaktuvalidasi/Dashboard1?Area="+marks[0][0].formattedValue+"&start_date=2017-08-01&end_date=2017-08-07&:tabs=no"
							}]
						}]
					});
					tabPanel.setActiveTab('3detailwaktuvalidasi');
				}
		}
	});
}