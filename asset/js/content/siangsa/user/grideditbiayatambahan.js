Ext.define('siangsa.user.grideditbiayatambahan' ,{
	extend: 'Ext.grid.Panel',
	initComponent	: function()
	{
		var dataselect;
		var msclass = Ext.create('master.global.geteventmenu'); 
		var pageId = Init.idmenu;
		var model = msclass.getmodel('v_biayatambahan');
		var columns = msclass.getcolumn('v_biayatambahan');
		var filter = [];
		var store =  msclass.getstore(model,'v_biayatambahan',filter);
		
		var msdmodel = msclass.getmodel('master_data');
		var msdstore =  msclass.getstore(msdmodel,'master_data',filter);
		
		var jbmodel = msclass.getmodel('v_jbiayatambahan');
		var storejbiaya =  msclass.getstore(jbmodel,'v_jbiayatambahan',filter);
				
		var coldisplay = columns;
			coldisplay[1].hidden = true;//row_id
			coldisplay[2].hidden = true;
			coldisplay[4] = {
						text : 'Nominal',
						align : 'right',
						dataIndex	: coldisplay[4].dataIndex
				}
			coldisplay[6].hidden = true;
			coldisplay[7].hidden = true;
			coldisplay[8].hidden = true;
			coldisplay[9].hidden = true;
			coldisplay[10].hidden = true;
			coldisplay[11].hidden = true;
			
		var editing = Ext.create('Ext.grid.plugin.RowEditing', { 
		  clicksToEdit: 2,
		  listeners :
			{					
				'edit' : function (editor,e) {
				}
			}
		});	
				
		Ext.apply(this, {
				//title	: 'Email Template',
				store		: store,
				plugins		: editing,	
				multiSelect	: true,
				//selType		: 'checkboxmodel',
				fit		: true,
				layout : 'fit',
				height : 200,
				id			: 'grideditbiayatambahan'+'add',
				dockedItems	: [
					{
						xtype: 'toolbar',
						items	: [
						{
							text	: 'Add',
							iconCls	: 'add',
							xtype	: 'button',
							handler	: function()
							{									
									if(!Init.winss_formgridtambahan)
									{
										var formgridedittambahan = Ext.create('siangsa.user.formeditgridtambahan');
										Init.winss_formeditgridtambahan = Ext.widget('window', {
											title		: "Form Edit Tambahan Biaya",
											closeAction	: 'hide',
											width: 500,
											height	: 300,
											//id			: ''+Init.idmenu+'winmapppelsource',
											resizable	: true,
											modal		: true,
											closable :true,
											bodyPadding	: 5,
											layout		: 'fit',
											items		: formgridedittambahan
										});
									}
									Ext.getCmp('formeditgridtambahan'+pageId).getForm().reset();
									Init.winss_formeditgridtambahan.show();		
							}
						},
						{
								text	: 'Delete',
								iconCls	: 'bin',
								xtype	: 'button',
								handler: function () {
									var grid = this.up('grid');
									if (grid) {
										var sm = grid.getSelectionModel();
										var rs = sm.getSelection();
										if (!rs.length) {
											Ext.Msg.alert('Info', 'No Records Selected');
											return;
										}
										grid.store.remove(rs[0]);
										
									}
								}
						}]
					}
				],
				columns		: columns
			});
			this.callParent(arguments);
	}
});