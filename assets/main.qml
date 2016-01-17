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
import "js/VKService.js" as VKService;
import "js/LongPollService.js" as LongPollService;
import "js/Store.js" as Store;
import "js/Common.js" as Common;
import "pages";

NavigationPane {
    id: navigationPane
    
    property variant data
    
    signal vkServiceInitialized
    signal dataLoaded(variant data)

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
            }
        ]
             
    }

    attachedObjects: [
         VKAuth {
            id: vkAuth
            onAccessTokenAndUserIdReceived: {
                Store.init(accessToken, userId, apiVersion);
                VKService.initService(Store.create());
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
            id: test
            source: "asset:///pages/Test.qml"
        },
        SplashScreen {
            id: splashScreen
        }
    ]

    onPopTransitionEnded: {
        page.cleanup();
        page.destroy();
    }
    
    onCreationCompleted: {
        vkAuth.open();
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
        
        splashScreen.close();
        LongPollService.init(Store.create(), _app);
        LongPollService.start();
    }    
}
