import bb.cascades 1.4

Container {
    id: root
    
    property variant text: "test"
    
    ContactContainer {
        imageSource: "asset:///img/ca_skype.png"
        imageColor: Color.White
        text: root.text        
    }
}

