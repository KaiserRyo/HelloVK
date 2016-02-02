import bb.cascades 1.4

TitleBar {
    
    property variant user
    
    kind: TitleBarKind.FreeForm
    kindProperties: FreeFormTitleBarKindProperties {
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Container {
                minWidth: ui.du(11)
                maxWidth: ui.du(11)
                minHeight: ui.du(11)
                maxHeight: ui.du(11)
                WebView {
                    url: user.photo_100 ? user.photo_100 : ""
                    minWidth: ui.du(11)
                    maxWidth: ui.du(11)
                    minHeight: ui.du(11)
                    maxHeight: ui.du(11)
                }
            }
            Label {
                text: user.first_name + " " + user.last_name
                textStyle.base: SystemDefaults.TextStyles.TitleText
            }
        }
    }
}
