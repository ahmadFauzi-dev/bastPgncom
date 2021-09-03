function apps(name,iconCls)
{
	Ext.require(['*']);
	Ext.Loader.setConfig({
    enabled : true,
    paths: {
        'EM'    : ''+base_url+'asset/js/content/'
	}
	
	});
	
	
	
	//Ext.Loader.setPath('MyApp', 'view/form.js');
	Ext.QuickTips.init();
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
	 var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';

	 var simple = Ext.widget({
        xtype: 'form',
        layout: 'form',
        collapsible: true,
        id: 'simpleForm',
        url: 'save-form.php',
        frame: true,
        title: 'Simple Form',
        bodyPadding: '5 5 0',
        width: 350,
        fieldDefaults: {
            msgTarget: 'side',
            labelWidth: 75
        },
        defaultType: 'textfield',
        items: [{
            fieldLabel: 'First Name',
            //afterLabelTextTpl: required,
            name: 'first',
            allowBlank: false,
            tooltip: 'Enter your first name'
        },{
            fieldLabel: 'Last Name',
            //afterLabelTextTpl: required,
            name: 'last',
            allowBlank: false,
            tooltip: 'Enter your last name'
        },{
            fieldLabel: 'Company',
            name: 'company',
            tooltip: "Enter your employer's name"
        }, {
            fieldLabel: 'Email',
           // afterLabelTextTpl: required,
            name: 'email',
            allowBlank: false,
            vtype:'email',
            tooltip: 'Enter your email address'
        }, {
            fieldLabel: 'DOB',
            name: 'dob',
            xtype: 'datefield',
            tooltip: 'Enter your date of birth'
        }, {
            fieldLabel: 'Age',
            name: 'age',
            xtype: 'numberfield',
            minValue: 0,
            maxValue: 100,
            tooltip: 'Enter your age'
        }, {
            xtype: 'timefield',
            fieldLabel: 'Time',
            name: 'time',
            minValue: '8:00am',
            maxValue: '6:00pm',
            tooltip: 'Enter a time',
            plugins: {
                ptype: 'datatip',
                tpl: 'Select time {date:date("G:i")}'
            }
        }],
    });
	if(!exist){
			Ext.getCmp('contentcenter').add({
				title		: 'Bulk Customer',
				id			: name,
				xtype		: 'panel',
				iconCls		: iconCls,
				closable	: true,
				overflowY	: 'scroll',
				bodyPadding: '5 5 0',
				items		: [{
					xtype 		: 'panel',
					title		: 'Bulk Customer',
					bodyPadding	: 5,
					margins		: '10',
					items		: simple
				}]
			});
		tabPanel.setActiveTab(name);	
	}
}