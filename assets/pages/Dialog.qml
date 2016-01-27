import bb.cascades 1.4

import "components"
import "/js/VKService.js" as VKService;
import "/js/DialogsService.js" as DialogsService;

Page {
    id: dialogPage
    
    signal messageSent(variant message)
    signal messageDelivered(int messageId, int tempID)
    
//    property variant dialog: {user: 
//        {first_name: "Mikhail", last_name: "Chachkouski"}, messages: [
//            {id: 82066, body: "не спрячешься!", user_id: 214914887, from_id: 214914887, date: 1453543702, read_state: 0, out: 0},
//            {id: 82067, body: "эээ ну", user_id: 214914887, from_id: 214914887, date: 1453543916, read_state: 0, out: 0},
//            {id: 82067, body: "хрен", user_id: 214914887, from_id: 214914887, date: 1453543920, read_state: 0, out: 0}
//        ]}
    property variant dialog
    
    function cleanup() {}
    
    function fill() {
        messagesContainer.removeAll();
        messagesContainer.add(messageDivider.createObject());
        var messages = [];
        var from = 0;
        var messageObj = undefined;
        dialog.messages.forEach(function(m, index) {
            if (from === 0) {
                from = m.from_id;
                messageObj = createMessageObject(from);   
                messageObj.user = getMessageUser(from);             
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
        if (messages.length > 0) {
            messageObj.user = getMessageUser(from);
            messageObj.messages = messages;
            messagesContainer.add(messageObj);
        }
        messagesContainer.add(messageDivider.createObject());
    }
    
    function createMessageObject(from) {
        return from === _app.userService.user.id ? ownMessage.createObject() : userMessage.createObject();
    }
    
    function getMessageUser(from) {
        return from === _app.userService.user.id ? _app.userService.user : dialog.user;
    }
    
    function getUser() {
        return dialog ? dialog.user : {};
    }
    
    titleBar: UserTitleBar {
        user: getUser()
    }
    
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    
    Container {
        background: Color.create(_app.uiManager.dialogBg)
        
        ScrollView {
            id: messagesScrollView
            scrollRole: ScrollRole.Main
            scrollViewProperties {
                scrollMode: ScrollMode.Vertical
            }

            verticalAlignment: VerticalAlignment.Center
            
            Container { 
                id: messagesContainer
                
                onControlAdded: {
                    var count = messagesContainer.count();
                    messagesScrollView.scrollToPoint(0, (count === 0 ? count : count - 1) * 1500);
                }
            }
        }
    }
    
    onDialogChanged: {
        fill();
    }
    
    onMessageSent: {
        dialogPage.dialog.messages.push(message);
        
        var messageObj = createMessageObject(message.from_id);
        messageObj.user = getMessageUser(message.from_id);
        messageObj.messages = [message];
        messagesContainer.add(messageObj);
    }
    
    onMessageDelivered: {
//        var messageWithTempID = DialogsService.findMessageById(dialog.messages, tempID);
//        messageWithTempID.id = messageId;
//        
//        dialog.message = messageWithTempID;
//        _app.dialogsService.dialogUpdated(dialog);
    }
    
    actions: [
        TextInputActionItem {
            id: messageText
            hintText: qsTr("Enter text")
            textFormat: TextFormat.Plain
            input {
                submitKey: SubmitKey.EnterKey
                
                onSubmitted: {
                    console.debug(messageText.text);
                    
                    var tempID = Date.now() / 1000;
                    var text = messageText.text;
                    var newMessage = {
                        id: tempID,
                        body: text, 
                        user_id: dialog.user.id, 
                        from_id: _app.userService.user.id, 
                        date: tempID, 
                        read_state: 0, 
                    out: 0};
                    
                    messageText.resetText();
                    
                    VKService.initService(_app);
                    VKService.messages.send(dialog.user.id, text, function(messageId) {
                        messageDelivered(messageId, tempID);
                    });
                    
                    messageSent(newMessage);
                }
            }
        }
    ]
    
    attachedObjects: [
        ComponentDefinition { id: userMessage; UserMessage {} },
        ComponentDefinition { id: ownMessage; OwnMessage {} },
        ComponentDefinition { id: messageDivider; Container { minHeight: ui.du(1) }}
    ]
}
