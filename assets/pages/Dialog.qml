import bb.cascades 1.4

import "components"
import "controls"
import "/js/VKService.js" as VKService;
import "/js/DialogsService.js" as DialogsService;

Page {
    id: dialogPage
    
    property variant dialog
    
    function cleanup() {
        _app.dialogsService.dialogUpdated.disconnect(dialogPage.messageReceived);
    }
    
    function fill() {
        "use strict";
        messagesContainer.removeAll();
        var messages = [];
        var from = 0;
        var messageObj = undefined;
        var mDate = 0;
        dialog.messages.forEach(function(m, index) {
            if (from === 0) {
                from = m.from_id;
                messageObj = createMessageObject(from);   
                messageObj.user = getMessageUser(from);             
            }
            if (from !== m.from_id || (from === m.from_id && mDate !== 0 && (m.date - mDate) > 60)) {
                messageObj.user = getMessageUser(from);
                messageObj.messages = messages;
                
                messagesContainer.add(messageObj);
                
                from = m.from_id;
                
                messageObj = createMessageObject(from);
                messages = [];
            } 
            mDate = m.date;
            messages.push(m);
        });
        if (messages.length > 0) {
            messageObj.user = getMessageUser(from);
            messageObj.messages = messages;
            messagesContainer.add(messageObj);
        }
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
    
    function messageComponents(objectName) {
        "use strict";
        var messageComponents = [];
        for (var i = 0; i < messagesContainer.controls.length; i++) {
            if (objectName) {
                var messageComponent = messagesContainer.controls[i];
                if (messageComponent.objectName === objectName) {
                    messageComponents.push(messageComponent);
                }
            } else {
                messageComponents.push(messagesContainer.controls[i]);
            }
        }
        return messageComponents;
    }
    
    function createAndAddMessageComponent(message) {
        "use strict";
        var messageComponent = createMessageObject(message.from_id);
        messageComponent.user = getMessageUser(message.from_id);
        messageComponent.messages = [message];
        messagesContainer.add(messageComponent);
        return messageComponent;
    }
    
    function updateMessageComponent(messageComponent, message) {
        "use strict";
        var newMessages = messageComponent.messages.slice();
        newMessages.push(message);
        messageComponent.messages = newMessages;
        return messageComponent;
    }
    
    function messageSent(message) {
        "use strict";
        dialog.messages.push(message);
        var singleMessage = undefined;
        var messages = messageComponents();
        if (messages.length !== 0) {
            var singleMessage = messages[messages.length - 1];
            if (singleMessage.user.id === message.from_id) {
                var lastMessage = singleMessage.messages[singleMessage.messages.length - 1];
                if ((message.date - lastMessage.date) > 60) {
                    singleMessage = createAndAddMessageComponent(message);
                } else {
                    singleMessage = updateMessageComponent(singleMessage, message);
                }
            } else {
                singleMessage = createAndAddMessageComponent(message);
            }
        } else {
            singleMessage = createAndAddMessageComponent(message);
        }
        return singleMessage;
    }
    
    function messageReceived(updatedDialog, fromCurrUser) {
        "use strict";
        if (updatedDialog.user.id === dialog.user.id && !fromCurrUser) {
            var m = updatedDialog.message;
            var newMessage = { id: m.id, body: m.body, user_id: dialogPage.dialog.user.id, from_id: dialogPage.dialog.user.id, 
                               date: m.date, read_state: m.read_state, out: m.out };
            var singleMessageComponent = messageSent(newMessage);
        }
    }
    
    function outgoingMessagesReaded(newDialog) {
        "use strict";
        if (dialog.user.id === newDialog.user.id) {
            var ownMessages = messageComponents("ownMessage");
            ownMessages.forEach(function(mComponent) {
                var newMessages = mComponent.messages.slice();
                if (newMessages.some(isUnread)) {
                    newMessages.forEach(function(m) {
                        m.read_state = 1;
                    });
                    mComponent.messages = newMessages;
                }
            });
        }
    }
    
    function isUnread(message) {
        return message.read_state === 0;
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
                id: messagesRootContainer
                                
                MessageContainerDivider {}
                
                Container {
                    id: messagesContainer
                    
                    attachedObjects: [
                        LayoutUpdateHandler {
                            onLayoutFrameChanged: {
                                messagesScrollView.scrollToPoint(0, layoutFrame.height);
                            }
                        }
                    ]
                }
                
                MessageContainerDivider {}
            }
        }
    }
    
    onDialogChanged: {
        fill();
    }
    
    onCreationCompleted: {
        _app.dialogsService.dialogUpdated.connect(dialogPage.messageReceived);
        _app.dialogsService.outgoingMessagesReaded.connect(dialogPage.outgoingMessagesReaded);
    }
            
    actions: [
        TextInputActionItem {
            id: messageText
            hintText: qsTr("Enter text")
            textFormat: TextFormat.Plain
            input {
                submitKey: SubmitKey.EnterKey
                
                onSubmitted: {
                    messagesScrollView.scrollToPoint(0, 100000000);
                    var tempID = Date.now() / 1000;
                    var text = messageText.text;
                    var newMessage = { id: tempID, body: text, user_id: dialog.user.id, from_id: _app.userService.user.id, date: tempID, read_state: 2, out: 0 };
                    
                    var singleMessageComponent = messageSent(newMessage);
                    messageText.resetText();
                    
                    VKService.initService(_app);
                    VKService.messages.send(dialog.user.id, text, function(messageId) {
                        var newMessages = singleMessageComponent.messages.slice();
                        var deliveredMessage = DialogsService.findMessageById(newMessages, tempID);
                        if (deliveredMessage) {
                            deliveredMessage.id = messageId;
                            deliveredMessage.read_state = 0;
                            singleMessageComponent.messages = newMessages;
                        }
                    });
                }
            }
        }
    ]
    
    attachedObjects: [
        ComponentDefinition { id: userMessage; UserMessage { objectName: "userMessage" }},
        ComponentDefinition { id: ownMessage; OwnMessage { objectName: "ownMessage" }}
    ]
}
