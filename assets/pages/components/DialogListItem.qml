import bb.cascades 1.4

CustomListItem {
    id: listItem
    
    property variant dialog: {message: {body: 'кстати,табы-то что нужно было)) спасибО)'}, 
        unread: 52, user: {first_name: 'Denis', last_name: 'Demianov', online: 1, 
            last_seen: {time : 1452962381}}};
    
    property bool loading: false
    
    function getDate() {
        if (dialog.message.date) {
            var date = new Date(dialog.message.date * 1000);
            return Qt.formatDate(date, "dd MMM yyyy") + qsTr(" in ") + Qt.formatTime(date, "HH:mm");
        } else {
            return "";
        }
    }
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        AnimatedWebView {
            size: 11
            webImageUrl: dialog.message.chat_id ? dialog.message.photo_100 : dialog.user.photo_100
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
                        textStyle.base: SystemDefaults.TextStyles.TitleText
                        textStyle.fontWeight: FontWeight.W400
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
                    visible: dialog.hasOwnProperty("unread")
                    background: Color.create("#0092CC")

                    leftPadding: ui.du(1)
                    rightPadding: ui.du(1)
                    topPadding: ui.du(0.5)
                    bottomPadding: ui.du(0.5)
                    
                    leftMargin: ui.du(1)
                    opacity: 0.8
                    
                    verticalAlignment: VerticalAlignment.Center
                }
                Container {
                    topPadding: ui.du(0.5)
                    leftPadding: ui.du(1)
                    ActivityIndicator {
                        id: dialogLoadingIndicator
                        running: listItem.loading
                    }
                }
            }
            Container {
                layout: StackLayout {}
                bottomPadding: ui.du(2)
                Label {
                    text: listItem.getDate();
                    textStyle.base: SystemDefaults.TextStyles.SmallText
                    verticalAlignment: VerticalAlignment.Center
                    textStyle.color: Color.Gray
                }
                Label {
                    id: messageLabel
                    text: dialog.message.body
                    verticalAlignment: VerticalAlignment.Center
                    multiline: true
                    autoSize.maxLineCount: 10
                }
            }
        }
    }   
}