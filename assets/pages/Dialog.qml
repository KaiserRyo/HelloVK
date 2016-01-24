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
        dialog.messages.forEach(function(m) {
            if (from === 0) {
                from = m.from_id;
                
                if (from === _app.userService.user.id) {
                    messageObj = ownMessage.createObject();
                } else {
                    messageObj = userMessage.createObject();
                }
                
            }
            if (from !== m.from_id) {
                messageObj.user = from === _app.userService.user.id ? _app.userService.user : dialog.user;
                messageObj.messages = messages;
                messagesContainer.add(messageObj);
                
                from = m.from_id;
                
                if (from === _app.userService.user.id) {
                    messageObj = ownMessage.createObject();
                } else {
                    messageObj = userMessage.createObject();
                }
                
                messages = [];
            } 
            messages.push(m);                
        });
    }
    
    titleBar: UserTitleBar {
        user: dialog.user
    }
    
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    
    Container {
        background: Color.create("#ffc3daff")
        ScrollView {
            id: messagesScrollView
            scrollRole: ScrollRole.Main
            
            Container { id: messagesContainer }
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
