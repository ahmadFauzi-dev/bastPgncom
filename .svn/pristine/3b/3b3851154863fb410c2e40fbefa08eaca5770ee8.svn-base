Ext.define('estimasibulk.view.form',{
	 extend: 'Ext.form.Panel',
	 initComponent: function() {
		Ext.apply(this, {
		frame		: true,
		border		: true,
		layout		: 'form',
		url			: base_url+'admin/insertEstimate',
		bodyPadding: '5 5 0',
			fieldDefaults: {
			labelAlign: 'left',
			anchor: '60%',
			labelWidth: 100
		},
		id			: 'estimasibulkform',
		items		: [{
			xtype:'fieldset',
            //checkboxToggle:true,
            title: 'Table Config',
            defaultType: 'textfield',
            collapsed: true,
            layout: 'anchor',
            defaults: {
                anchor: '60%'
				}
			}],
			items	: [
			{
				xtype		: 'textfield',
				fieldLabel	: 'Rule Name',
				name		: 'rulename',
				value		: 'Bekasi Power'
			},
			{
				 xtype		: 'checkboxgroup',
				 fieldLabel : 'Parameter',
				 anchor		: '60%',
				 columns: 2,
					items: [
					{
						boxLabel: 'MMSCFD'
						, inputValue : 'MMSCFD'
						,name: 'parameter[]'
					},
					{
						boxLabel: 'Energy'
						, inputValue : 'Energy'
						,name: 'parameter[]'
						, checked: true
					},
					{
						boxLabel: 'Totalizer Volume'
						, inputValue : 'totalizervolume'
						, name: 'parameter[]'
					},
					{
						boxLabel: 'Totalizer Energy'
						,inputValue	: 'totalizerenergy'
						, name: 'parameter[]'
					},
					{
						boxLabel: 'Temperature'
						,inputValue	: 'Temperature'
						, name: 'parameter[]'
					},
					{
						boxLabel: 'Ghv'
						,inputValue	: 'ghv'
						, name: 'parameter[]'
					},
					{	boxLabel: 'Pressure Out'
						,inputValue	: 'pout'
						, name: 'parameter[]'
					}
				]
			},
			{
				xtype	: 'fieldcontainer',
				anchor		: '100%',
				layout		: 'hbox',
				labelAlign: 'top',
				items	: [
					{
						xtype		: 'numberfield',
						anchor		: '20%',
						name		: 'last',
						flex		: 1,
						minValue	: 1,
						maxValue	: 31,
						//labelAlign	: 'top',
						fieldLabel	: 'Last'
					},
					{
						xtype		: 'radiogroup',
						labelAlign	: 'top',
						fieldLabel	: 'Periode',
						flex		: 1,
						columns		: 1,
						items: [
							{
								boxLabel		: 'Hour',
								inputValue		: 'hour', 
								name			: 'timevalue'
							},
							{
								boxLabel	: 'Days',
								inputValue	: 'day',
								name		: 'timevalue'
							},
							{
								boxLabel	: 'Week',
								inputValue	: 'week',
								name		: 'timevalue'
							},
							{
								boxLabel	: 'Month',
								inputValue	: 'month',
								name		: 'timevalue'
							}
						]
					},
					{
						
						xtype		: 'radiogroup',
						labelAlign	: 'top',
						fieldLabel	: 'Parameter Periode',
						flex		: 1,
						columns: 1,
						items: [
							{boxLabel: 'Hourly', name: 'periodeparameter', inputValue: 'hourly'},
							{boxLabel: 'Daily', name: 'periodeparameter', inputValue: 'daily'}
							//{boxLabel: 'Item 3', name: 'rb-col', inputValue: 3}
						]
					}
					
				]
			}
			],
			buttons	: [{
				text	: 'Save',
				handler	: function()
				{
					this.up('form').getForm().submit({
					waitTitle	: 'Harap Tunggu',
					waitMsg		: 'Insert data',
					success	:function(form, action)
					{
						Ext.Msg.alert('Sukses','Approval Sukses');
					},
					failure:function(form, action)
					{
						Ext.Msg.alert('Fail !','Approval Gagal');
						Ext.Msg.alert('Warning!', 'Authentication server is unreachable : ' + action.response.responseText + "");
					}
					
					});
				}
			},
			{
				text	: 'Cancel'
			}]
		});

        this.callParent(arguments);
    }
});