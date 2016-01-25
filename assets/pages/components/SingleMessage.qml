import bb.cascades 1.4

Container {
    property bool readState: false
    property string body: "Test"
    
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }
    rightPadding: ui.du(1)
    
    ImageView {
        imageSource: readState ? "asset:///img/grey_pellet.png" : 
                                 "asset:///img/yellow_pellet.png"
    }
    Label {
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        text: body
        multiline: true 
        textFormat: TextFormat.Html
    }
}
