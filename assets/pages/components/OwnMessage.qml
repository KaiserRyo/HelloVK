import bb.cascades 1.4

import "../controls"

Container {
    id: root
    
    property variant user: {}
    property variant messages: []

    function getDate() {
        if (messages.length !== 0) {
            var date = new Date(messages[messages.length - 1].date * 1000);
            return Qt.formatDate(date, "dd MMM yyyy ") + Qt.formatTime(date, "HH:mm");
        }
    }
    
    function statesImages() {
        return {0: "asset:///img/delivered.png", 
                1: "asset:///img/read.png", 
                2: "asset:///img/sent.png"};
    }
    
    function fill() {
        messagesContainer.removeAll();
        var images = statesImages();
        messages.forEach(function(m) {
            var singleMessageObj = singleMessage.createObject();
            singleMessageObj.imageSource = images[m.read_state];
            singleMessageObj.body = m.body;
            messagesContainer.add(singleMessageObj);
        });
    }
    
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }  
    
    topMargin: ui.du(1.5)
    bottomMargin: ui.du(1.5)
    
    background: Color.create(_app.uiManager.dialogBg)
    
    Container {
        minWidth: ui.du(1)
    }
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }
        layoutProperties: StackLayoutProperties {
            spaceQuota: 8
        }
        
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            
            leftPadding: ui.du(1)
            topPadding: ui.du(1)
            background: Color.White
            
            AnimatedWebView {
                size: 5
                webImageUrl: user.photo_100 || ""
            }
            
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom
                }
                
                Container {
                    leftPadding: ui.du(1)
                    rightPadding: ui.du(1)
                    
                    layout: DockLayout {}
                    horizontalAlignment: HorizontalAlignment.Fill
                    Label {
                        horizontalAlignment: HorizontalAlignment.Left
                        text: user.first_name + " " + user.last_name
                        textStyle.fontWeight: FontWeight.Bold
                    }
                    Container {
                        background: Color.White
                        topPadding: ui.du(0.8)
                        
                        horizontalAlignment: HorizontalAlignment.Right
                        
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        Label {
                            text: getDate()
                            textStyle.base: SystemDefaults.TextStyles.SmallText
                        }
                    }    
                }
                
                Container {
                    id: messagesContainer
                }            
            }        
        }
        
        OwnMessageDivider {
            verticalAlignment: VerticalAlignment.Bottom
        }
    }

    Container {
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }        
    }
    
    onMessagesChanged: {
        fill();
    }
    
    attachedObjects: [
        ComponentDefinition {
            id: singleMessage
            SingleMessage {}
        }
    ]    
}
