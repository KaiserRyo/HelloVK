import bb.cascades 1.4

Container {
    
    property int size
    property string webImageUrl
    
    minWidth: ui.du(size)
    minHeight: ui.du(size)
    maxWidth: ui.du(size)
    maxHeight: ui.du(size)
    WebView {
        id: webImage
        url: webImageUrl || ""
        maxWidth: ui.du(size)
        maxHeight: ui.du(size)
        scaleX: 0
        scaleY: 0
        onLoadingChanged: {
            if (loadRequest.status === WebLoadStatus.Succeeded) {
                scaleWebImage.play();
            }
        }
    }
    
    animations: [
        ScaleTransition {
            id: scaleWebImage
            duration: 500
            fromX: 0
            fromY: 0
            toX: 1.0
            toY: 1.0
            easingCurve: StockCurve.QuadraticIn
            target: webImage
        }
    ]
}
