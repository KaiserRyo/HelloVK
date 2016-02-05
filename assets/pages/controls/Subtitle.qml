import bb.cascades 1.4

Label {
    property string subtitle: "undefined"
    
    textStyle.base: SystemDefaults.TextStyles.SubtitleText
    textStyle.color: Color.White
    text: subtitle
    multiline: true
}
