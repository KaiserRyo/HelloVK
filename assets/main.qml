/*
 * Copyright (c) 2011-2015 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.4
import bb.platform 1.3

import "js/VKService.js" as VKService;
import "js/LongPollService.js" as LongPollService;
import "js/Common.js" as Common;
import "js/FriendsService.js" as FriendsService;
import "js/DialogsService.js" as DialogsService;
import "pages";

NavigationPane {
    id: navigationPane
    
    property variant data
    
    signal vkServiceInitialized
    signal dataLoaded(variant data)
    
    function messageRecevied(dialog) {
        dialogNotification.title = "HelloVK: " + dialog.user.first_name + " " + dialog.user.last_name;
        dialogNotification.body = dialog.message.body;
        dialogNotification.notify();
    }

    Page {
        id: firstPage
        titleBar: TitleBar {
            title: qsTr("Logging in...")
        }        

        Container {
            WebView {
                id: avatar
            }
        }   
                
        actions: [
            ActionItem {
                title: qsTr("Friends")
                ActionBar.placement: ActionBarPlacement.OnBar
                imageSource: "asset:///img/ca_contacts.png"
            
                onTriggered: {
                    navigationPane.push(friendsPage.createObject());
                }
            },
            ActionItem {
                title: qsTr("Dialogs")
                ActionBar.placement: ActionBarPlacement.OnBar
                
                onTriggered: {
                    navigationPane.push(dialogsPage.createObject());
                }
            }
        ]
             
    }

    attachedObjects: [
         VKAuth {
            id: vkAuth
            onAccessTokenAndUserIdReceived: {
                _app.http.init(accessToken, userId, apiVersion);
                VKService.initService(_app);
                vkServiceInitialized();
            }
        },
        ComponentDefinition {
            id: friendsPage
            Friends {
                onFriendChosen: {
                    var page = friendInfo.createObject();
                    page.friend = chosenFriend;
                    navigationPane.push(page);
                }
            }
        },
        ComponentDefinition {
            id: friendInfo
            source: "asset:///pages/FriendInfo.qml"
        },
        ComponentDefinition {
            id: dialogsPage
            Dialogs {
                onLoadDialog: {
                    var d = dialog;
                    VKService.messages.getHistory(d.user.id, function(response) {
                        d.messages = response.items;
                        var dialogPageObj = dialogPage.createObject();
                        dialogPageObj.dialog = d;
                        navigationPane.push(dialogPageObj);
                        dialogLoaded();    
                    });
                }
            }
        },
        ComponentDefinition {
            id: dialogPage
            Dialog {
                
            }
        },
        SplashScreen {
            id: splashScreen
        },
        Notification {
            id: dialogNotification
        } 
    ]

    onPopTransitionEnded: {
        page.cleanup();
        page.destroy();
    }
    
    onCreationCompleted: {
        vkAuth.open();
        _app.dialogsService.dialogAdded.connect(messageRecevied);
        _app.dialogsService.dialogUpdated.connect(messageRecevied);
    }
    
    onVkServiceInitialized: {
        vkAuth.close();
        splashScreen.open();
        VKService.loadData(function(data) {
            firstPage.titleBar.title = data.user.first_name + ' ' + data.user.last_name;
            avatar.url = data.user.photo_400_orig;
            dataLoaded(data);
        });
    }
    
    onDataLoaded: {
        navigationPane.data = data;
        _app.friendsService.setFriends(data.friends);
        _app.dialogsService.setDialogsUsers(data.dialogs_users);
        
        var dialogs = data.dialogs.items.slice();
        dialogs.forEach(function(dialog) {
            var user = FriendsService.findUserById(_app.dialogsService.dialogsUsers, dialog.message.user_id);
            dialog.user = user;
        });
        
        _app.dialogsService.setDialogs(dialogs);
        _app.dialogsService.setCount(data.dialogs.count);
        _app.dialogsService.setUnreadDialogs(data.dialogs.unread_dialogs);
        
        splashScreen.close();
        LongPollService.init(_app);
        LongPollService.start();
    }    
}
