import bb.cascades 1.4
import "components";
import "controls";
import "/js/Common.js" as Common;
import "/js/FriendsService.js" as FriendsService

Page {
    
    property variant friend: {}
    
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
            Container {
                minWidth: ui.du(25)
                minHeight: ui.du(25)
                maxWidth: ui.du(25)
                maxHeight: ui.du(25)
                WebView {
                    url: friend.photo_max_orig || ""
                    maxWidth: ui.du(25)
                    maxHeight: ui.du(25)
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 0.5
                    }
                }
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
        
        ScrollView {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            Container {
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
        }
    ]
    
    actions: [
        ActionItem {
            title: qsTr("Write a message")
            ActionBar.placement: ActionBarPlacement.Signature
            imageSource: "asset:///img/ic_textmessage_dk.png"
            
            onTriggered: {
                console.debug("Write message to: " + friend.first_name + " " + friend.last_name);
            }
        }
    ]
}
