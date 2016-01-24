import bb.cascades 1.4

import "../controls"

Container {
    
    property variant user: {first_name: "Mikhail", last_name: "Chachkouski"}
    property variant messages: [
        {date: 1452962381, read_state: 1, body: "Privet! Privet! Privet! Privet! Privet! Privet! Privet! Privet! Privet!"}, 
        {date: 1452962400, read_state: 0, body: "Hey ho!!"}
    ]
    
    function getDate() {
        var date = new Date(messages[messages.length - 1].date * 1000);
        return Qt.formatDate(date, "ddd ") + Qt.formatTime(date, "HH:mm");
    }
    
    function fill() {
        messagesContainer.removeAll();
        messages.forEach(function(m) {
            var singleMessageObj = singleMessage.createObject();
            singleMessageObj.readState = m.read_state === 1;
            singleMessageObj.body = m.body;
            messagesContainer.add(singleMessageObj);
        });
    }
    
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }  
    
    topMargin: ui.du(1.5)
    bottomMargin: ui.du(1.5)
    
    background: Color.create("#ffc3daff")
    
    Container {
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }        
    }
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }
        layoutProperties: StackLayoutProperties {
            spaceQuota: 8
        }
        
        topPadding: ui.du(1)
        background: Color.White
        
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
                bottomPadding: ui.du(1)
                
                horizontalAlignment: HorizontalAlignment.Right
                
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                Label {
                    text: getDate()
                    textStyle.base: SystemDefaults.TextStyles.SubtitleText
                    verticalAlignment: VerticalAlignment.Center
                }
                WebView {
                    url: user.photo_100 ? user.photo_100 : ""
                    preferredWidth: ui.du(5)
                    preferredHeight: ui.du(5)
                }
            }    
        }
        
        Container {
            id: messagesContainer
        }
        
        UserMessageDivider {
            verticalAlignment: VerticalAlignment.Bottom
        }
    }
    
    onCreationCompleted: {
        fill();
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
