import bb.cascades 1.4

Container {
    property string color
    
    horizontalAlignment: HorizontalAlignment.Fill
    background: Color.create(color)
    topPadding: ui.du(0.25)
}
