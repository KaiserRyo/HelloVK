import bb.cascades 1.4

TitleBar {
    
    signal search(variant textParts)
    signal cancelSearch
    
    kind: TitleBarKind.FreeForm
    kindProperties: FreeFormTitleBarKindProperties {
        Container {
            leftPadding: ui.du(1)
            rightPadding: ui.du(1)
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight           
            }
            TextField {
                id: textField
                
                verticalAlignment: VerticalAlignment.Center
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 3
                }
                
                hintText: qsTr("Enter text")
                inputMode: TextFieldInputMode.Text
                input.keyLayout: KeyLayout.Text
                maximumLength: 40
                
                onTextChanging: {
                    search(text.split(" ", 2));
                }
            }
            Button {
                text: qsTr("Cancel")
                verticalAlignment: VerticalAlignment.Center
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                
                onClicked: {
                    cancelSearch();
                }
            }            
        }
    }
}