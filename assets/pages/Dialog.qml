import bb.cascades 1.4

import "components"

Page {
    id: dialogPage
    
    property variant dialog: {user: 
        {first_name: "Mikhail", last_name: "Chachkouski"}, messages: [
            {id: 82066, body: "не спрячешься!", user_id: 214914887, from_id: 214914887, date: 1453543702, read_state: 0, out: 0},
            {id: 82067, body: "эээ ну", user_id: 214914887, from_id: 214914887, date: 1453543916, read_state: 0, out: 0},
            {id: 82067, body: "хрен", user_id: 214914887, from_id: 214914887, date: 1453543920, read_state: 0, out: 0}
        ]}
//    property variant dialog
    
    function cleanup() {}
    
    function fill() {
        messagesContainer.removeAll();
        var messages = [];
        var from = 0;
        var messageObj = undefined;
        dialog.messages.forEach(function(m, index) {
            if (from === 0) {
                from = m.from_id;
                messageObj = createMessageObject(from);                
            }
            if (from !== m.from_id) {
                messageObj.user = getMessageUser(from);

                messageObj.messages = messages;
                messagesContainer.add(messageObj);
                
                from = m.from_id;
                
                messageObj = createMessageObject(from);
                messages = [];
            } 
            messages.push(m);
        });
    }
    
    function createMessageObject(from) {
        return from === _app.userService.user.id ? ownMessage.createObject() : userMessage.createObject();
    }
    
    function getMessageUser(from) {
        return from === _app.userService.user.id ? _app.userService.user : dialog.user;
    }
    
    titleBar: UserTitleBar {
        user: dialog.user
    }
    
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    
    Container {
        background: Color.create("#ffc3daff")
        
        Container {
            minHeight: ui.du(1)
        }
        
        ScrollView {
            id: messagesScrollView
            scrollRole: ScrollRole.Main
            scrollViewProperties {
                scrollMode: ScrollMode.Vertical
                overScrollEffectMode: OverScrollEffectMode.None
                pinchToZoomEnabled: true
            }

            verticalAlignment: VerticalAlignment.Center
            
            Container { 
                id: messagesContainer
                
                onControlAdded: {
                    messagesScrollView.scrollToPoint(0, messagesContainer.count() * 1500);
                }
            }
        }
        
        Container {
            minHeight: ui.du(1)
        }
    }
    
    onDialogChanged: {
        fill();
    }
    
    onCreationCompleted: {
        fill();
    }
    
    attachedObjects: [
        ComponentDefinition { id: userMessage; UserMessage {} },
        ComponentDefinition { id: ownMessage; OwnMessage {} }
    ]
}
