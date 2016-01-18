import bb.cascades 1.4
import "components";
import "/js/FriendsService.js" as FriendsService;
import "/js/DialogsService.js" as DialogsService;

Page {
    id: dialogsPage
    
    property bool sortedByUnreadMode: false
    
    function cleanup() {}
    
    function getDialogs() {
        return sortedByUnreadMode ? DialogsService.getUnread(_app.dialogsService.dialogs) : _app.dialogsService.dialogs;
    }
        
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
                        dialog: ListItemData
                    }
                }
            ]
        }
    }
    
    onCreationCompleted: {
        DialogsService.fillDialogsList(dialogsArray, getDialogs());
    }   
    
    actions: [
        ActionItem {
            title: qsTr("All dialogs")
            ActionBar.placement: ActionBarPlacement.OnBar
            
            onTriggered: {
                dialogsPage.sortedByUnreadMode = false;
                DialogsService.fillDialogsList(dialogsArray, getDialogs());
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
                dialogsPage.sortedByUnreadMode = true;
                DialogsService.fillDialogsList(dialogsArray, getDialogs());
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
                DialogsService.fillDialogsList(dialogsArray, DialogsService.search(getDialogs(), textParts));
            }
            
            onCancelSearch: {
                console.debug("cancel dialogs search");
                dialogsPage.setTitleBar(defaultTitleBar);
                DialogsService.fillDialogsList(dialogsArray, getDialogs());
            }
        }
    ]
}
