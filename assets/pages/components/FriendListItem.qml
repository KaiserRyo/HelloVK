import bb.cascades 1.4

CustomListItem {
    
    property variant friend: {first_name: 'Mikhail', last_name: 'Chachkouski', online: 1, 
        last_seen: {time : 1452962381}};
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        Container {
            minWidth: ui.du(11.0)
            maxWidth: ui.du(11.0)
            WebView {
                url: friend.photo_100
                minWidth: ui.du(11.0)
                maxWidth: ui.du(11.0)
            }
        }
        
        Container {
            leftPadding: ui.du(1.0)
            preferredHeight: ui.du(10.0) 
            layout: DockLayout {
            
            }
            Label {
                id: title
                text: friend.first_name + " " + friend.last_name
                textStyle.base: {
                    SystemDefaults.TextStyles.TitleText
                }
                verticalAlignment: VerticalAlignment.Top
            }
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                ImageView {
                    id: image
                    imageSource: "asset:///img/yellow_pellet.png"
                    minWidth: ui.du(3.5)
                    preferredWidth: ui.du(3.5)
                    preferredHeight: ui.du(3.5)
                    verticalAlignment: VerticalAlignment.Bottom
                }
                Label {
                    id: description
                    text: friend.deactivated ? qsTr("account deactivated") : 
                        friend.online == 0 ? "" : qsTr("online")
                    textStyle.base: {
                       SystemDefaults.TextStyles.BodyText
                    }
                    textStyle.color: Color.Gray
                    verticalAlignment: VerticalAlignment.Center
                }
                verticalAlignment: VerticalAlignment.Bottom
            }
        }
    }
    
    onCreationCompleted: {
        changeImageVisibility();
    }
    
    onFriendChanged: {
        changeImageVisibility();
    }
    
    function changeImageVisibility() {
        image.visible = friend.online === 1;
    }
}