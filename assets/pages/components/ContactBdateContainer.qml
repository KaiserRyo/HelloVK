import bb.cascades 1.4

Container {
    id: root
    
    property variant text: "test"
    
    ContactContainer {
        imageSource: "asset:///img/cs_birthday.png"
        imageColor: Color.White
        text: root.text   
        
        onTouchEnter: {
            console.debug("ADD TO CALENDAR: " + root.text);
        }     
    }
}
