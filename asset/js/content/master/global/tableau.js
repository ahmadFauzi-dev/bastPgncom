Ext.define('master.global.tableau', {
    extend: 'Ext.Component',
    xtype: 'tableauviz',
    viz: null,
    workbook: null,
    activeSheet: null,
    config: {
        regionFilterTxt: '',
        vizUrl: '',
        options: {
            hideTabs: false,
            hideToolbar: false
        }
    },
    onBoxReady: function(width, height) {
        this.setOptions(Ext.apply({
            width: width,
            height: height
        }, this.getOptions()));
		this.viz.refreshDataAsync();
		console.log("ok");
    },
	onFirstInteractive: function () {
                    console.log("Run this code when the viz has finished loading.");
    },
    onResize: function(width, height) {
        if (this.activeSheet) {
            this.viz.setFrameSize(width, height);
        }
    },
 
    afterRender: function() {
        var me = this;
		
        me.callParent();
 
        var placeholderDiv = me.getEl().dom;
        var url = this.getVizUrl();
 
        var options = Ext.apply({
            onFirstInteractive: function () {
                me.workbook = me.viz.getWorkbook();
                me.activeSheet = me.workbook.getActiveSheet();
            }
        }, this.getOptions());
 
        me.viz = new tableauSoftware.Viz(placeholderDiv, url, options);
		
		// setInterval(function () {me.viz.refreshDataAsync() }, 30000);		  
				  
		me.viz.addEventListener('marksselection', function(e) {
			e.getMarksAsync().then(function(marks) {
			  var retData = [];
			  for (var markIndex = 0; markIndex < marks.length; markIndex++) {
				var pairs = marks[markIndex].getPairs();
				//console.log("okokok");
				retData[markIndex] = [];
				
				for (var pairIndex = 0; pairIndex < pairs.length; pairIndex++) {
				  var pair = pairs[pairIndex];
				  retData[markIndex].push({
					fieldName: pair.fieldName,
					formattedValue: pair.formattedValue});
				}
			  }
			  me.fireEvent('marksselected', me, retData);
			});
		});		  
    }
});