Ext.define('setting.view.menu' ,{
			extend: 'Ext.tree.Panel',
			initComponent	: function()
			{
			var storemenu 	= Ext.create('setting.store.storemenu');
			storemenu.removeAll();
			storemenu.load();
			Ext.apply(this,{
				id		: 'menupriv',
				viewConfig: {
						plugins: {
							ptype: 'treeviewdragdrop',
							containerScroll: true,
							listeners	: {
								beforedrop	: function (node, data, overModel, dropPosition, dropFunction, eOpts ) {
				dockedItems: [{
							Ext.create('Ext.window.Window', {
							Ext.Array.each(records, function(rec){
							
							Ext.Ajax.request({ 
								success: function(response,requst){
							
							//console.log(items);
							storeevent.reload();
					}
			this.callParent(arguments);
		})