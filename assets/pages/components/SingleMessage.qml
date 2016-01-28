import bb.cascades 1.4

Container {
    id: root
    property string body: "Test sfdsdf sdfsdfsdf sdfsdfsdf sdf"
    property string imageSource: "asset:///img/grey_pellet.png"
    
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }
    rightPadding: ui.du(1)
    topPadding: ui.du(0.5)
    bottomPadding: ui.du(0.5)
    
    ImageView {
        imageSource: root.imageSource;
        verticalAlignment: VerticalAlignment.Top
    }
    Label {
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        text: body
        multiline: true 
        textFormat: TextFormat.Html
        verticalAlignment: VerticalAlignment.Top
    }
}
