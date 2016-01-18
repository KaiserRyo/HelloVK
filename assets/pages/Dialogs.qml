import bb.cascades 1.4
import "components";
import "/js/FriendsService.js" as FriendsService;

Page {
    id: dialogsPage
    
    property variant dialogs: _app.dialogsService.dialogs;
    
    function cleanup() {}
        
    titleBar: defaultTitleBar
    
    Container {
        ListView {
            id: dialogsList
            dataModel: ArrayDataModel {
                id: dialogsArray
            }
            listItemComponents: [
                ListItemComponent {
                    type: ""
                    DialogListItem {
                        user: ListItemData.user ? ListItemData.user : FriendsService.findById(_app.friendsService.friends, ListItemData.message.user_id);
                        dialog: ListItemData
                    }
                }
            ]
        }
    }
    
    onCreationCompleted: {
        dialogsArray.clear();
        dialogsArray.append(dialogs);
    }   
    
    actions: [
        ActionItem {
            title: qsTr("All dialogs")
            ActionBar.placement: ActionBarPlacement.OnBar
            
            onTriggered: {
                console.debug("all dialogs chosen");
            }
        },
        ActionItem {
            title: qsTr("Search")
            ActionBar.placement: ActionBarPlacement.Signature
            imageSource: "asset:///img/ic_search.png"
            
            onTriggered: {
                dialogsPage.setTitleBar(searchTitleBar);
                searchTitleBar.setFocus();
            }
            defaultAction: true
        },
        ActionItem {
            title: qsTr("Unread dialogs")
            ActionBar.placement: ActionBarPlacement.OnBar
            
            onTriggered: {
                console.debug("unread dialogs chosen");
            }
        }
    ] 
    
    attachedObjects: [
        TitleBar {
            id: defaultTitleBar
            title: qsTr("Dialogs")
        },
        SearchTitleBar {
            id: searchTitleBar
            onSearch: {
                console.debug("start dialogs search");
            }
            
            onCancelSearch: {
                console.debug("cancel dialogs search");
                dialogsPage.setTitleBar(defaultTitleBar);
            }
        }
    ]
}
