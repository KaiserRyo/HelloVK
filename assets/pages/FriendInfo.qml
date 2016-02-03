import bb.cascades 1.4
import "components";
import "controls";
import "/js/Common.js" as Common;
import "/js/FriendsService.js" as FriendsService

Page {
    
    property variant friend: {}
    
    signal dialogStarted(variant user)
    
    function cleanup() {}
    
    function updateFriendInfo() {
        if (friend) {
            if (!friend.hasOwnProperty("deactivated")) {
                job.visible = FriendsService.getCurrentJob(friend) !== "";
                edu.visible = FriendsService.getEducation(friend) !== "";
                city.visible = FriendsService.getCity(friend) !== "";
                
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
    
    Container {
        Container {
            leftPadding: ui.du(1)
            topPadding: ui.du(1)
            rightPadding: ui.du(1)
            bottomPadding: ui.du(1)
            background: Color.create("#F0F0F0")
            
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            AnimatedWebView {
                size: 25
                webImageUrl: friend.photo_max_orig || ""
            }
            Container {
                id: mainInfo
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                leftMargin: ui.du(2)
                
                Label {
                    text: friend.first_name + " " + friend.last_name
                    textStyle.base: SystemDefaults.TextStyles.TitleText
                    textStyle.color: Color.Black
                }
                
                Subtitle { id: job; subtitle: FriendsService.getCurrentJob(friend); }
                Subtitle { id: edu; subtitle: FriendsService.getEducation(friend); }
                Subtitle { id: city; subtitle: FriendsService.getCity(friend); }
            }
        }
        MainDivider {}
        
        SegmentedControl {
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
        
        ScrollView {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
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
