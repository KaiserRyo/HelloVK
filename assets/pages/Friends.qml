import bb.cascades 1.4
import "components"
import "/js/FriendsService.js" as FriendsService

Page {
    id: friendsPage

    property bool sortedByOnlineMode: false

    signal friendChosen(variant chosenFriend)

    function getFriendsList() {
        return friendsPage.sortedByOnlineMode ? FriendsService.getOnline(_app.friendsService.friends) : _app.friendsService.friends;
    }

    function friendOnlineChanged(friend) {
        console.debug(friend.first_name + " " + friend.last_name + " from C++" + " online: " + friend.online);
        var indexPath = friendsArray.find(friend);
        if (friendsPage.sortedByOnlineMode) {
            if (friend.online === 1) {
                friendsArray.insert(friend);
            } else {
                friendsArray.removeAt(indexPath);
            }
        } else {
            friendsArray.updateItem(indexPath, friend);
        }
    }

    function cleanup() {
        _app.friendsService.friendOnlineChanged.disconnect(friendsPage.friendOnlineChanged);
    }

    titleBar: defaultTitleBar
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll

    ListView {
        id: friendsList
        dataModel: GroupDataModel {
            id: friendsArray
            sortingKeys: [ "first_name", "last_name" ]
        }
        listItemComponents: [
            ListItemComponent {
                type: "item"
                FriendListItem {
                    friend: ListItemData
                }
            }
        ]
        onTriggered: {
            friendsList.clearSelection();
            friendsList.toggleSelection(indexPath);
            if (indexPath.length > 1) {
                friendChosen(friendsArray.data(indexPath));
            }
        }
        scrollIndicatorMode: ScrollIndicatorMode.ProportionalBar
        scrollRole: ScrollRole.Main
        layout: StackListLayout {
            headerMode: ListHeaderMode.Sticky
        }
    }

    onCreationCompleted: {
        FriendsService.fillFriendsList(friendsArray, getFriendsList());
        _app.friendsService.friendOnlineChanged.connect(friendsPage.friendOnlineChanged);
    }

    actions: [
        ActionItem {
            title: qsTr("All friends")
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///img/friends_all.png"

            onTriggered: {
                friendsPage.sortedByOnlineMode = false;
                FriendsService.fillFriendsList(friendsArray, getFriendsList());
            }
        },
        ActionItem {
            title: qsTr("Search")
            ActionBar.placement: ActionBarPlacement.Signature
            imageSource: "asset:///img/ic_search.png"

            onTriggered: {
                friendsPage.setTitleBar(friendsSearchTitleBar);
                friendsSearchTitleBar.setFocus();
            }
            defaultAction: true
        },
        ActionItem {
            title: qsTr("Friends online")
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///img/friends_online.png"

            onTriggered: {
                friendsPage.sortedByOnlineMode = true;
                FriendsService.fillFriendsList(friendsArray, getFriendsList());
            }
        }
    ]

    attachedObjects: [
        TitleBar {
            id: defaultTitleBar
            title: qsTr("Friends")
        },
        SearchTitleBar {
            id: friendsSearchTitleBar
            onSearch: {
                FriendsService.fillFriendsList(friendsArray, FriendsService.search(getFriendsList(), textParts));
            }

            onCancelSearch: {
                friendsPage.setTitleBar(defaultTitleBar);
                FriendsService.fillFriendsList(friendsArray, getFriendsList());
            }
        }
    ]
    actionBarFollowKeyboardPolicy: ActionBarFollowKeyboardPolicy.Never
}
