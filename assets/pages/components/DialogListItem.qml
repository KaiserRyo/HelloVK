import bb.cascades 1.4

CustomListItem {
    id: listItem
    
    property variant dialog: {message: {body: 'кстати,табы-то что нужно было)) спасибО)'}, 
        unread: 52, user: {first_name: 'Denis', last_name: 'Demianov', online: 1, 
            last_seen: {time : 1452962381}}};
    
    property string date: "16 янв 2016 в 21:30"
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        Container {
            WebView {
                url: dialog.message.chat_id ? dialog.message.photo_100 : dialog.user.photo_100
                preferredWidth: ui.du(11.0)
                minWidth: ui.du(11.0)
            }
        }
        Container {
            leftPadding: ui.du(1.0)
            layout: StackLayout {}
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                Container {
                    Label {
                        id: title
                        text: dialog.message.chat_id ? dialog.message.title : dialog.user.first_name + " " + dialog.user.last_name
                        textStyle.base: {
                            SystemDefaults.TextStyles.TitleText
                        }
                    }                    
                    verticalAlignment: VerticalAlignment.Center
                }
                Container {
                    Label {
                        text: "+" + dialog.unread
                        textStyle.base: {
                            SystemDefaults.TextStyles.SubtitleText
                        }
                        textStyle.color: Color.White
                    }
                    visible: dialog.hasOwnProperty("unread");
                    background: Color.create("#0092CC");
                    
                    leftPadding: ui.du(1)
                    rightPadding: ui.du(1)
                    topPadding: ui.du(0.5)
                    bottomPadding: ui.du(0.5)
                    
                    leftMargin: ui.du(1)
                    opacity: 0.8
                    
                    verticalAlignment: VerticalAlignment.Center
                }
            }
            Container {
                layout: StackLayout {}
                Label {
                    text: date
                    textStyle.base: SystemDefaults.TextStyles.SmallText
                    verticalAlignment: VerticalAlignment.Center
                    textStyle.color: Color.Gray
                }
                Label {
                    id: messageLabel
                    text: dialog.message.body
                    textStyle.base: SystemDefaults.TextStyles.BodyText
                    textStyle.color: Color.Gray
                    verticalAlignment: VerticalAlignment.Center
                    multiline: true
                    autoSize.maxLineCount: 10
                }
            }
        }
    }   
}