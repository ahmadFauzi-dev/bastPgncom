Ext.define('master.view.gridarea' ,{
	extend: 'Ext.grid.Panel',
	//alias : 'widget.formco',
	initComponent	: function()
	{
	Ext.define('m1453403912grid',{
		extend	: 'Ext.data.Model',
		fields	: ["area","sbu"]
	});
	
			var s1453403912grid = Ext.create('Ext.data.JsonStore',{
				model	: 'm1453403912grid',
				proxy	: {
				type	: 'pgascomProxy',
				url		: base_url+'admin/s1453403912grid',
				reader: {
					type: 'json',
					root: 'data'
				}
				}
			});
			s1453403912grid.load();
			Ext.apply(this,{
				store		: s1453403912grid,
				id			: 'gridDaily',
				columns		: [{"dataIndex":"area","text":"area"},{"dataIndex":"sbu","text":"sbu"}]
			});
			this.callParent(arguments);
			}
		})
function apps(name,iconCls)
				{
					Ext.require([
					'Ext.grid.*',
					'Ext.data.*',
					'Ext.util.*',
					'Ext.state.*'
					]);
					
					Ext.Loader.setConfig({
						enabled : true,
						paths: {
							'master'    : ''+base_url+'asset/js/content/master/'
						}
					
					});
					
					var grid = Ext.create('master.view.sbugrid');
					
					var tabPanel = Ext.getCmp('contentcenter');
					var items = tabPanel.items.items;
					var exist = false;
					
					for(var i = 0; i < items.length; i++)
					{
						if(items[i].id == name){
								tabPanel.setActiveTab(name);
								exist = true;
						}
					}
					
					if(!exist){
							Ext.getCmp('contentcenter').add({
								title		: 'Estimasi Bulk Customer',
								id			: name,
								xtype		: 'panel',
								iconCls		: iconCls,
								closable	: true,
								overflowY	: 'scroll',
								bodyPadding: '5 5 0',
								items		: [{
									xtype 		: 'panel',
									title		: 'Jenis Station',
									bodyPadding	: 5,
									//width		: 600,
									margins		: '10',
									items		: grid
									//items		: []
								}]
							});
						tabPanel.setActiveTab(name);	
					}
				}
