Ext.define('master.view.gridlibmessageanomali' ,{
	extend: 'Ext.grid.Panel',
	//alias : 'widget.formco',
	initComponent	: function()
	{
	Ext.define('m1454310608grid',{
		extend	: 'Ext.data.Model',
		fields	: ["id","code_id","Description","flaging"]
	});

	var s1454310608grid = Ext.create('Ext.data.JsonStore',{
		model	: 'm1454310608grid',
		proxy	: {
		type	: 'pgascomProxy',
		url		: base_url+'admin/s1454310608grid',
		reader: {
			type: 'json',
			root: 'data'
		}
		}
	});
	s1454310608grid.load();
	var data;
	var gridMenu = Ext.create('Ext.menu.Menu',{
		id: 'menuGrid',
		items	: [{
			text	: 'Add Role',
			handler	: function()
			{
				var idRole = data.id;
				var formadddetail = Ext.create('master.view.gridaddrole');
				
				Ext.getCmp('idrole').setValue(data.id);
				Ext.getCmp('codeId').setValue(data.code_id);
				Ext.getCmp('iddescription').setValue(data.Description);
				var griddetailrole = Ext.create('master.view.griddetailrole');
				
				win = Ext.widget('window', {
					title		: 'Role ID : '+data.code_id+' '+data.Description,
					width		: 800,
					//height		: 400,
					layout		: 'fit',
					autoScroll	:true,
					id			: "windetrole",
					resizable	: true,
					modal		: true,
					bodyPadding	: 5,
					items		: [formadddetail,griddetailrole]
				});
				win.show();
				//console.log(data.id);
			}
		},
		{
			text	: 'View Role'
		}]
	});
	
	Ext.apply(this,{
		store		: s1454310608grid,
		id			: 'gridDaily',
		columns		: [Ext.create('Ext.grid.RowNumberer'),
		{	"dataIndex":"code_id"
			,"text":"ID"
		}
		,{
			"dataIndex":"Description"
			,"text":"Description"
			,flex:1
		}
		,{
			"dataIndex":"flaging"
			,"text":"flaging"
		}]
		,listeners	: 
		{
			beforeitemcontextmenu: function(view, record, item, index, e)
			{
				e.stopEvent();
				//console.log(record.data);
				data = record.data;
				gridMenu.showAt(e.getXY());
			},
			itemclick	: function(view, record, item, index, e, eOpts)
			{
				console.log(record.data);
			}
		}		
		,bbar: Ext.create('Ext.PagingToolbar', {
	        pageSize: 10,
	        //store: storeMessage,
	        displayInfo: true
	    })		
	});
	this.callParent(arguments);
	}
})
