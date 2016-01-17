import bb.cascades 1.4

Container {
    id: root
    
    property variant text: "test"
    
    ContactContainer {
        imageSource: "asset:///img/ic_phone.png"
        imageColor: Color.Black
        text: root.text
        
        onTouchEnter: {
            console.debug("CALL TO: " + root.text);
        }
    }
}
