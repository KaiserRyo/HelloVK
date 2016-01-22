import bb.cascades 1.4
import bb.system 1.2

import "components";
import "/js/FriendsService.js" as FriendsService;
import "/js/DialogsService.js" as DialogsService;
import "/js/VKService.js" as VKService;

Page {
    id: dialogsPage

    property bool sortedByUnreadMode: false
    
    function cleanup() {
        _app.dialogsService.dialogUpdated.disconnect(dialogsPage.dialogUpdated);
        _app.dialogsService.dialogAdded.disconnect(dialogsPage.dialogAdded);
    }

    function getDialogs() {
        return sortedByUnreadMode ? DialogsService.getUnread(_app.dialogsService.dialogs) : _app.dialogsService.dialogs;
    }
    
    function dialogUpdated(dialog) {
        for (var i = 0; i < dialogsArray.size(); i++) {
            var d = dialogsArray.value(i);
            if (d.message.user_id === dialog.message.user_id) {
                dialogsArray.replace(i, dialog);
            }
        }
    }
    
    function dialogAdded(dialog) {
        dialogsArray.insert(0, dialog);
    }
        
    titleBar: defaultTitleBar
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll

    ListView {
        id: dialogsList
        scrollRole: ScrollRole.Main
        scrollIndicatorMode: ScrollIndicatorMode.ProportionalBar
        
        dataModel: ArrayDataModel {
            id: dialogsArray
        }
        
        onCreationCompleted: {
            VKService.initService(_app);
        }
        
        listItemComponents: [
            ListItemComponent {
                type: ""
                DialogListItem {
                    id: dialogListItem
                    dialog: ListItemData
                    contextActions: [
                        ActionSet {
                            DeleteActionItem {
                                onTriggered: {
                                    deleteDialog.show();                                   
                                }
                                
                                attachedObjects: [
                                    SystemDialog {
                                        id: deleteDialog
                                        title: qsTr("This action cannot be undone. Continue?")
                                        
                                        onFinished: {
                                            if (value === SystemUiResult.ConfirmButtonSelection) {
                                                var dialog = ListItemData;
                                                VKService.messages.deleteDialog(dialog.user.id, function(responseCode) {
                                                    if (responseCode === 1) {
                                                        var dataModel = dialogListItem.ListItem.view.dataModel;
                                                        dataModel.removeAt(dataModel.indexOf(dialog));
                                                        _app.dialogsService.setDialogs(DialogsService.deleteDialog(_app.dialogsService.dialogs, dialog));
                                                        _app.dialogsService.setCount(--_app.dialogsService.count);
                                                    }
                                                });
                                            }
                                        }
                                    }
                                ]   
                            }
                        }
                    ]
                }
            }
        ]    
    }

    onCreationCompleted: {
        DialogsService.fillDialogsList(dialogsArray, getDialogs());
        _app.dialogsService.dialogUpdated.connect(dialogsPage.dialogUpdated);
        _app.dialogsService.dialogAdded.connect(dialogsPage.dialogAdded);
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
                dialogsPage.setTitleBar(defaultTitleBar);
                DialogsService.fillDialogsList(dialogsArray, getDialogs());
            }
        }   
    ]
}
