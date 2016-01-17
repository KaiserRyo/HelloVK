import bb.cascades 1.4

Container {
    id: root
    
    property string imageSource
    property variant imageColor
    property string text

    Container {
        leftPadding: ui.du(1)
        topPadding: ui.du(1)
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        ImageView {
            imageSource: root.imageSource
            filterColor: root.imageColor
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }
        Label {
            text: root.text
            verticalAlignment: VerticalAlignment.Center
            textStyle.base: SystemDefaults.TextStyles.BodyText
            multiline: true
            autoSize.maxLineCount: -1
            textFormat: TextFormat.Html
            layoutProperties: StackLayoutProperties {
                spaceQuota: 8
            }
        }
    }
    Divider {}
}
