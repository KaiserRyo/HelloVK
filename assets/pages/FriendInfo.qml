import bb.cascades 1.4
import "components";
import "controls";
import "/js/Common.js" as Common;
import "/js/FriendsService.js" as FriendsService;

Page {
    
    property variant friend: {}
    
//    property variant friend: {
//        id: 61280037,
//        first_name: "Михаил",
//        last_name: "Чачковский",
//        domain: "id61280037",
//        bdate: "23.11.1989",
//        city: {
//            id: 282,
//            title: "city"
//        },
//        country: {
//            id: 3,
//            title: "country"
//        },
//        photo_50: "https://pp.vk.me/c630528/v630528037/d2ce/KfkLx4r1CLY.jpg",
//        photo_100: "https://pp.vk.me/c630528/v630528037/d2cd/iO0eh_X3XNg.jpg",
//        photo_200: "https://pp.vk.me/c630528/v630528037/d2cb/9r6C409iM7o.jpg",
//        photo_max: "https://pp.vk.me/c630528/v630528037/d2cb/9r6C409iM7o.jpg",
//        photo_200_orig: "https://pp.vk.me/c630528/v630528037/d2cb/9r6C409iM7o.jpg",
//        photo_400_orig: "https://pp.vk.me/c630528/v630528037/d2cc/AxMK3OTZ47w.jpg",
//        photo_max_orig: "https://pp.vk.me/c630528/v630528037/d2cc/AxMK3OTZ47w.jpg",
//        photo_id: "61280037_396000480",
//        has_photo: 1,
//        has_mobile: 1,
//        online: 0,
//        verified: 0,
//        career: [{
//            company: "Lifetech",
//            country_id: 3,
//            city_id: 282,
//            from: 2012,
//            position: "Инженер-программист"
//        }, 
//        {
//            company: "company",
//            country_id: 3,
//            city_id: 282,
//            from: 2014,
//            position: "job position"
//        }],
//        university_name: "university",
//        graduation: "[year]",
//        mobile_phone: "+375 25 9092555",
//        site: "http://www.lastfm.ru/user/mrm_guitargod       http://vk.com/mrm_guitargod",
//        skype: "mikhail.mliavy"
//    }

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
            WebView {
                url: friend.photo_max_orig || ""
                maxWidth: ui.du(25)
                maxHeight: ui.du(25)
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 0.5
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
