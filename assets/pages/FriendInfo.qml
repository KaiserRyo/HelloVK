import bb.cascades 1.4
import "/pages/components";
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
        mainInfo.removeAll();
        
        if (friend) {
            mainInfo.add(title.createObject());
            if (!friend.hasOwnProperty('deactivated')) {
                showCurrentJob();
                showEducation();
                showCity();
                showPhones();
                showWebContacts();
                showBirthDate();
            }
        }
    }
    
    function showCurrentJob() {
        if (friend.career && friend.career.length > 0 && friend.career[0]) {
            var jobLabel = subtitle.createObject();
            var currentJob = friend.career[friend.career.length - 1];
            if (currentJob.position) {
                jobLabel.text = currentJob.position;
            }
            if (currentJob.company) {
                jobLabel.text += " (" + currentJob.company + ") ";
            }
            mainInfo.add(jobLabel);
        }
    }
    
    function showEducation() {
        if (friend.university_name) {
            var universityLabel = subtitle.createObject();
            universityLabel.text = friend.university_name + (friend.graduation !== 0 ? qsTr(" in ") + friend.graduation : "");
            mainInfo.add(universityLabel);
        }
    }
    
    function showCity() {
        if (friend.city) {
            var cityLabel = subtitle.createObject();
            cityLabel.text = friend.city.title + (friend.country ? " (" + friend.country.title + ")" : "");
            mainInfo.add(cityLabel);
        }
    }
    
    function showPhones() {
        phoneContainer.removeAll();       
        if (friend.mobile_phone) {
            
            var call = contactCallContainer.createObject();
            call.text = friend.mobile_phone;
            
            var sms = contactSmsContainer.createObject();
            sms.text = friend.mobile_phone;
            
            phoneContainer.add(call);
            phoneContainer.add(sms);
            phoneContainer.add(bigDivider.createObject());
        }    
    }
    
    function showWebContacts() {
        webContactsContainer.removeAll();
        if (friend.site) {
            var site = contactSiteContainer.createObject();
            site.text = FriendsService.getLinks(friend.site);
            webContactsContainer.add(site);
        }
        if (friend.skype) {
            var skype = contactSkypeContainer.createObject();
            skype.text = friend.skype;
            webContactsContainer.add(skype);
        }
        webContactsContainer.add(bigDivider.createObject());
    }
    
    function showBirthDate() {
        bdateContainer.removeAll();
        if (friend.bdate) {
            var bdate = contactBdateContainer.createObject();
            bdate.text = friend.bdate;            
            bdateContainer.add(bdate);
            bdateContainer.add(bigDivider.createObject());
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
            }
        }
        MainDivider {}
        ScrollView {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            Container {
                Container { id: phoneContainer }       
                Container { id: webContactsContainer }
                Container { id: bdateContainer }    
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
            id: subtitle
            Label {
                textStyle.base: SystemDefaults.TextStyles.SmallText
                textStyle.color: Color.Black
            }
        },
        ComponentDefinition {
            id: bigDivider
            source: "asset:///pages/controls/BigDivider.qml"
        },
        ComponentDefinition {
            id: contactCallContainer
            source: "asset:///pages/components/ContactCallContainer.qml"
        },
        ComponentDefinition {
            id: contactSmsContainer
            source: "asset:///pages/components/ContactSmsContainer.qml"
        },
        ComponentDefinition {
            id: contactSiteContainer
            source: "asset:///pages/components/ContactSiteContainer.qml"
        },
        ComponentDefinition {
            id: contactSkypeContainer
            source: "asset:///pages/components/ContactSkypeContainer.qml"
        },
        ComponentDefinition {
            id: contactBdateContainer
            source: "asset:///pages/components/ContactBdateContainer.qml"
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
