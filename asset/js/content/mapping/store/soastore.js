 Ext.define('Book',{
        extend: 'Ext.data.Model',
        fields: [{name: 'Author', mapping: 'm|ItemAttributes > m|Author'},'Title', 'Manufacturer', 'ProductGroup']
    });

    // create the Data Store
    var store = Ext.create('Ext.data.Store', {
        model: 'Book',
        autoLoad: true,
        proxy: {
            type: 'soap',
            url: 'sheldon-soap.xml',
            api: {
                read: 'ItemSearch'
            },
            soapAction: {
                read: 'http://webservices.amazon.com/ItemSearch'
            },
            operationParam: 'operation',
            extraParams: {
                'Author': 'Sheldon'
            },
            targetNamespace: 'http://webservices.amazon.com/',
            reader: {
                type: 'soap',
                record: 'm|Item',
                idProperty: 'ASIN',
                namespace: 'm'
            }
        }
    });