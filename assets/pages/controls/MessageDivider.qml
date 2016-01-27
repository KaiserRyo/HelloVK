import bb.cascades 1.4

Container {
    property string color
    
    horizontalAlignment: HorizontalAlignment.Fill
    background: Color.create(color)
    minHeight: ui.du(0.5)
    preferredHeight: ui.du(0.5)
}
