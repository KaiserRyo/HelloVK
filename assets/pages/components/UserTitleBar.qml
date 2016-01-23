import bb.cascades 1.4

TitleBar {
    
    property variant user
    
    kind: TitleBarKind.FreeForm
    kindProperties: FreeFormTitleBarKindProperties {
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            WebView {
                url: user.photo_100 ? user.photo_100 : ""
                preferredWidth: ui.du(11)
                preferredHeight: ui.du(11)
            }
            Label {
                text: user.first_name + " " + user.last_name
                textStyle.base: SystemDefaults.TextStyles.TitleText
            }
        }
    }
}
