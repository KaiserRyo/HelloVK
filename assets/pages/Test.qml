import bb.cascades 1.4
import bb.data 1.0
import "/pages/components"

NavigationPane {
    
    id: navPane
    
    Page {
        titleBar: TitleBar {
            id: textTitleBar
            kind: TitleBarKind.FreeForm
            kindProperties: FreeFormTitleBarKindProperties {
                Container {
                    leftPadding: ui.du(1)
                    rightPadding: ui.du(1)
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight           
                    }
                    TextField {
                        text: ""
                        verticalAlignment: VerticalAlignment.Center
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 3
                        }
                        hintText: "Enter text"
                        inputMode: TextFieldInputMode.Text
                        input.keyLayout: KeyLayout.Text
                        maximumLength: 40
                    }
                    Button {
                        text: "Cancel"
                        verticalAlignment: VerticalAlignment.Center
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1
                        }
                    }
                }
            }
            visibility: ChromeVisibility.Overlay
        }
        
        actions: [
            ActionItem {
                title: "Privet"
                defaultAction: true
                ActionBar.placement: ActionBarPlacement.OnBar
            }
        ]
    }
}
