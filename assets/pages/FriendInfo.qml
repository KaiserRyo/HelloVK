import bb.cascades 1.4
import "components";
import "controls";
import "/js/Common.js" as Common;
import "/js/FriendsService.js" as FriendsService

Page {
    
    property variant friend: { about: "Музыка, разные стили, концерты, рок звёзды. Романтика, ночной город, " +
                                      "путешествия. Ударные инструменты, барабаны, железо, перкуссия, ритмы, " + 
                                      "игра в группе. Индастриал, заводы, заброшенные строения.Стимпанк. " + 
                                      "Странные механизмы. Киберпанк. Искусственный интеллект. Слава роботам! " + 
                                      "Музыка, фильмы со смыслом, экзотическая кухня, интересные люди, " + 
                                      "психология, сверхъестесвенное.",
                               interests: "Музыка, литература, кино, история, компьютеры, люди, МОЗГ, " + 
                                          "самосовершенствование",
                               music: "Skillet, Papa Roach, Dead By April, Слот, Three Days Grace, " + 
                                      "Breaking Benjamin, Red, Ill Nino, The Birthday Massacre, Deftones, " + 
                                      "Good Charlotte, Yellowcard.",
                               activities: "the_turbo_lovers",
                               movies: "Фильмы Тима Бартона, аниме, киберпанк, триллеры, фантастика",
                               tv: "Дэвид Блейн - уличная магия!", books: "Алиса в стране чудес",
                               games: "American McGee's Alice, Fallout, Diablo, Серии Gothic, Heroes, Мор.Утопия, " +
                               "S.T.A.L.K.E.R",
                               quotes: '" А мы продолжаем смотреть 135 серию "Моей прекрасной няни" ни о чем не догадываясь..."' + 
                               
                               '"Если мир по обе стороны зеркала одинаковый, как понять, какой из них настоящий?"' +
                               
                               '"Свет в конце тоннеля отключён по техническим причинам."' + 
                               
                               '"— Ты веришь в судьбу, Нео?' + 
                               '— Нет.' + 
                               '— Почему?' +
                               '— Неприятно думать, что тобой манипулируют."' +
                               
                               '"Это не глупость. Глупость это то, что Чарли Чаплин занял второе место в конкурсе клонов Чарли Чаплина в Германии. (Револьвер)"'}
    
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
                    
                    InfoLabelText {
                        visible: FriendsService.isPropExists(friend, "about")
                        label: qsTr("About")
                        infoText: friend.about || ""
                    }
                    InfoLabelText {
                        visible: FriendsService.isPropExists(friend, "activities")
                        label: qsTr("Activities")
                        infoText: friend.activities || ""
                    }
                    InfoLabelText {
                        visible: FriendsService.isPropExists(friend, "interests")
                        label: qsTr("Interests")
                        infoText: friend.interests || ""
                    }
                    InfoLabelText {
                        visible: FriendsService.isPropExists(friend, "music")
                        label: qsTr("Music")
                        infoText: friend.music || ""
                    }
                    InfoLabelText {
                        visible: FriendsService.isPropExists(friend, "movies")
                        label: qsTr("Movies")
                        infoText: friend.movies || ""
                    }
                    InfoLabelText {
                        visible: FriendsService.isPropExists(friend, "tv")
                        label: qsTr("TV")
                        infoText: friend.tv || ""
                    }
                    InfoLabelText {
                        visible: FriendsService.isPropExists(friend, "books")
                        label: qsTr("Books")
                        infoText: friend.books || ""
                    }
                    InfoLabelText {
                        visible: FriendsService.isPropExists(friend, "games")
                        label: qsTr("Games")
                        infoText: friend.games || ""
                    }
                    InfoLabelText {
                        visible: FriendsService.isPropExists(friend, "quotes")
                        label: qsTr("Quotes")
                        infoText: friend.quotes || ""
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
