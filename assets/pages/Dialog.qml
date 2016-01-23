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
    
    titleBar: UserTitleBar {
        user: dialog.user
    }
    
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    
    Container {
        background: Color.create("#fff6ffff")
        ScrollView {
            id: messagesScrollView
            scrollRole: ScrollRole.Main
            
            Container {
                id: messagesContainer
            }
        }
    }
    
    onDialogChanged: {
        messagesContainer.removeAll();
        dialog.messages.forEach(function(m) {
            var messageObj = userMessage.createObject();
            messageObj.user = dialog.user;
            var d = dialog;
            var u = dialog.user;
            messageObj.message = m;
            messagesContainer.add(messageObj);
        });
    }
    
    onCreationCompleted: {
        messagesContainer.removeAll();
        dialog.messages.forEach(function(m) {
                var messageObj = userMessage.createObject();
                messageObj.user = dialog.user;
                messageObj.message = m;
                messagesContainer.add(messageObj);
        });
    }
    
    attachedObjects: [
        ComponentDefinition {
            id: userMessage
            UserMessage {}
        }
    ]
}
