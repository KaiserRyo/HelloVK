import bb.cascades 1.4
import "components";
import "controls";
import "/js/Common.js" as Common;
import "/js/FriendsService.js" as FriendsService

Page {
    
    property variant friend: {}
    property bool minimized: true
    property int avatarSize: 0
    property int nameContainerSize: 0
    
    signal dialogStarted(variant user)
    
    function cleanup() {}
    
    function updateFriendInfo() {
        if (friend) {
            if (!friend.hasOwnProperty("deactivated")) {
                phoneContainer.visible = FriendsService.isPropExists(friend, "mobile_phone");
                
                webContactsContainer.visible = friend.site || friend.skype;
                site.visible = FriendsService.isPropExists(friend, "site");
                skype.visible = FriendsService.isPropExists(friend, "skype");
                
                bdateContainer.visible = FriendsService.isPropExists(friend, "bdate");
                
                var otherInfoLabels = ["about", "interests", "music", "activities", "movies", "tv", "games", "quotes"];
                otherInfoContainer.removeAll();
                otherInfoLabels.forEach(function(label) {
                        if (FriendsService.isPropExists(friend, label)) {
                            var infoLabelTextObj = infoLabelText.createObject();
                            infoLabelTextObj.label = qsTr(label);
                            infoLabelTextObj.infoText = friend[label];
                            otherInfoContainer.add(infoLabelTextObj);
                        }
                });
            }
        }
    }
    
    function translate() {
        rootInfoContainer.translationY = minimized ? ui.px(avatarSize - nameContainerSize) : ui.du(30);
        avatar.translationY = minimized ? ui.du(5) : ui.du(-10);
    }
    
    function getSubtitle() {
        var data = [];
        data.push(FriendsService.getCurrentJob(friend) || "");
        data.push(FriendsService.getEducation(friend) || "");
        data.push(FriendsService.getCity(friend) || "");
        return data.join("\n");        
    }
    
    function getAvatar() {
        var crop = friend.crop_photo;
        if (crop) {
            if (crop.photo.photo_1280) {
                return crop.photo.photo_1280
            } else if (crop.photo.photo_807) {
                return crop.photo.photo_807;
            }
        } 
        return friend.photo_max_orig;
    }
    
    function getHTML() {
        var data = [];
        data.push('<html><head><title>');
        data.push(friend.first_name + ' ' + friend.last_name);
        data.push('</title></head>');
        data.push('<body style="background-color: black; text-align: center">'); 
        data.push('<div style="min-width: 720px; max-width: 1440px"><img src="' + getAvatar() + '" style="width: 100%"/></div>');
        data.push('</body></html>');
        return data.join("");
    }
    
    Container {
        layout: DockLayout {}
        Container {
            id: avatar
            translationY: ui.du(-10)            
            horizontalAlignment: HorizontalAlignment.Fill
            background: Color.Black
            ScrollView {
                accessibility.name: "Avatar scroll view"
                WebView {
                    accessibility.name: "Avatar"
                    id: avatarWebView
                    html: getHTML()
                    horizontalAlignment: HorizontalAlignment.Center
                    
                    attachedObjects: [
                        LayoutUpdateHandler {
                            onLayoutFrameChanged: {
                                avatarSize = layoutFrame.height;
                            }
                        }
                    ]
                    
                    gestureHandlers: [
                        TapHandler {
                            onTapped: {
                                translate();
                                minimized = !minimized;
                            }
                        }
                    ]
                }
            }
        }
        
        Container {
            id: rootInfoContainer
            translationY: ui.du(30);
            horizontalAlignment: HorizontalAlignment.Center
            
            Container {
                id: nameContainer
                
                horizontalAlignment: HorizontalAlignment.Fill
                leftPadding: ui.du(2)
                background: Color.create("#5a0d0000")
                Label {
                    text: friend.first_name + " " + friend.last_name
                    textStyle.base: SystemDefaults.TextStyles.TitleText
                    textStyle.color: Color.White
                }
                
                Subtitle { subtitle: getSubtitle(); }
                
                attachedObjects: [
                    LayoutUpdateHandler {
                        onLayoutFrameChanged: {
                            nameContainerSize = layoutFrame.height;
                        }
                    }
                ]
            }
            
            Container {
                topPadding: ui.du(2.5)
                background: Color.White
                SegmentedControl {
                    accessibility.name: "Type of friend info"
                    options: [
                        Option {
                            id: contactsInfo
                            text: qsTr("Info")
                            selected: true
                        },
                        Option {
                            id: otherInfo
                            text: qsTr("Other")
                        }
                    ]
                }
                
                Divider {}
                
                ScrollView {
                    horizontalAlignment: HorizontalAlignment.Fill
                    scrollRole: ScrollRole.Main
                    accessibility.name: "Friend info scroll view"
                    Container { 
                        id: infoContainer 
                        Container {
                            id: contactsContainer
                            visible: contactsInfo.selected
                            Container { 
                                id: phoneContainer 
                                ContactCallContainer { text: FriendsService.getMobilePhone(friend); }
                                ContactSmsContainer { text: FriendsService.getMobilePhone(friend); }
                                BigDivider {}
                            }       
                            Container { 
                                id: webContactsContainer
                                ContactSiteContainer { id: site; text: FriendsService.getSites(friend); }
                                ContactSkypeContainer { id: skype; text: FriendsService.getSkype(friend); }
                                BigDivider {}
                            }
                            Container { 
                                id: bdateContainer
                                ContactBdateContainer { text: FriendsService.getBdate(friend); }
                                BigDivider {}
                            }    
                        }
                        
                        Container {
                            id: otherInfoContainer
                            visible: otherInfo.selected
                            leftPadding: ui.du(2)
                            rightPadding: ui.du(2)
                        }
                    }
                }
            }
        }
    }
    
    onFriendChanged: {
        updateFriendInfo();
    }
    
    attachedObjects: [
        ComponentDefinition {
            id: title
            Label {
                text: friend.first_name + " " + friend.last_name
                textStyle.base: SystemDefaults.TextStyles.TitleText
                textStyle.color: Color.Black
            }
        },
        ComponentDefinition {
            id: infoLabelText
            InfoLabelText {}
        }
    ]
    
    actions: [
        ActionItem {
            title: qsTr("Write a message")
            ActionBar.placement: ActionBarPlacement.Signature
            imageSource: "asset:///img/ic_textmessage_dk.png"
            
            onTriggered: {
                dialogStarted(friend);
            }
        }
    ]
}
