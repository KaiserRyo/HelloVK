import bb.cascades 1.4

Container {
    
    property string label
    property string infoText
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        Container {
            Label {
                text: label + ": "
                textStyle.fontWeight: FontWeight.Bold
            }
        }
        Container {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            Label {
                multiline: enabled
                text: infoText
            }
        }
    }
    Divider {}
}
