import bb.cascades 1.4

Sheet {
    content: Page {
        Container {
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            background: Color.create("#0092CC")
            topPadding: ui.du(40)
            ImageView {
                imageSource: "asset:///img/hello_vk.png"
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                minWidth: ui.du(25)
                minHeight: ui.du(25)
            }
            ActivityIndicator {
                horizontalAlignment: HorizontalAlignment.Center
                running: true
            }
            Label {
                text: qsTr("Loading...")
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.color: Color.White
            }
        }
    }
}