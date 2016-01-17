import bb.cascades 1.4

Container {
    id: root
    
    property variant text: "test"
    
    ContactContainer {
        imageSource: "asset:///img/ic_textmessage_dk.png"
        imageColor: Color.create("#DCD427")
        text: root.text
        
        onTouchEnter: {
            console.debug("SMS TO: " + root.text);
        }
    }
}
