Ext.define('mapping.view.formimport' ,{
		extend: 'Ext.form.Panel',
		alias : 'widget.formimport',
		initComponent: function() {		
			
			Ext.apply(this, {
				xtype		: 'form',
				fileUpload		: true,
				//id			: 'formimportmappel'+Init.idmenu+'',
				border		: false,
				url			: base_url+'admin/mapping/importmapelsource',
				frame		: false,
				method	: 'POST',
				items		: [{
					xtype		: 'fieldset',
					defaultType	: 'textfield',
					title		: 'Mapping Pelanggan Source',
					collapsible	: true,
					fileUpload	: true,
					layout		: 'anchor',
					defaults: {
						anchor: '100%'
					},
					items		: 
					[			
							
						{
							xtype		: 'datefield',
							fieldLabel	: 'Start Date',
							name		: 'startt',
							format		: 'Y-m-d',
							allowBlank	: false
						},
						{
							xtype			: 'datefield',
							name			: 'endd',
							fieldLabel		: 'End Date',
							format			: 'Y-m-d',
							allowBlank	: false
			
						},
						{
							fieldLabel	: 'Dokumen',
							xtype		: 'fileuploadfield',
							name		: 'dok',
							allowBlank	: false
						}					
					]
				}],
				buttons	: [{
					text		: 'Save',
					formBind: true,
					handler		: function()
					{
						
						if (this.up('form').getForm().isValid()) {							
							this.up('form').getForm().submit();						
							
                        };
						Ext.Msg.alert('Success', 'Proses Mapping Berjalan Background Proses, Proses 5 Menit!!');
						this.up('.window').close();
						
						
					}
				},
				{
					text		: 'Cancel',
					handler		: function()
					{
						this.up('.window').close();
						//winaddcompany.close();
					}			
				}]
		});

		this.callParent(arguments);
	}
	});