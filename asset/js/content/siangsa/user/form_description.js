Ext.define('siangsa.user.form_description' ,{	
		extend: 'Ext.form.Panel',
		initComponent: function() {	
			var pageId = Init.idmenu;

		Ext.apply(this, {
				xtype		: 'form',
				frame		: false,
				collapsed :false,
				//url			: base_url+'siangsa/form_action',
				border		: false,
				//title		: "Form Revise",
				autoScroll	:true,
				fileUpload	: true,
				frame  		: false,
				method		: 'POST',
				//bodyPadding: '5 5 0',
				layout : 'fit',
				fieldDefaults: {
					labelAlign: 'left',
					anchor: '60%'
				},
				id					: 'form_description'+pageId,
				flex 				: 1,
				defaultType	: 'textfield',				
				items		: [
				{
					xtype: 'label',
					labelClsExtra:'text-align-center',  
					//height: 20,
				},
				{
					xtype: 'displayfield',
					id 		  :'log_desc',
					//height	  : 200,
					//fieldLabel: 'Keterangan',
					fieldStyle: 'background:none'								
				}]
		});												
		this.callParent(arguments);
	}
});