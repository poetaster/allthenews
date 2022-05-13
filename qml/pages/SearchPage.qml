import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    property string searchString


    QtObject {
        id: internal

        property string history
        property variant historyData: ({})//({data: [{searchText: 'AAA'}, {searchText: 'BBB'}]})
    }

    Database {
        id: database
    }

    ListModel {
        id: historyModel
    }

    Component.onCompleted: {
        historyModel.clear()
        database.initDatabase()
        var searchHistory = database.getName("searchHistory")
        if (searchHistory) {
            internal.history = searchHistory
        } else {
            internal.history = '{"data": [{"searchText": ""}]}'
            database.storeData("searchHistory", 0, internal.history)
        }
        console.log(internal.history)
        console.log(JSON.stringify(internal.historyData))
        internal.historyData = JSON.parse(internal.history)
        console.log(JSON.stringify(internal.historyData))

        for (var i in internal.historyData.data) {
            historyModel.append(internal.historyData.data[i])
        }
    }

    Column {
        width: parent.width

        DialogHeader { }

        TextField {
            id: searchField

            width: parent.width
            placeholderText: "Search news"
            label: "Search text"
        }

        Separator { }

        ListView {
            contentHeight: Theme.itemSizeSmall
            width: parent.width
            height: Theme.itemSizeSmall * 6
            model: historyModel
            delegate: ListItem {
                width: parent.width
                Label {
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.horizontalPageMargin
                    text: searchText
                }

                onClicked: {
                    searchField.text = searchText
                }
            }
        }
    }

    onDone: {
        if (result == DialogResult.Accepted) {
            searchString = searchField.text
            internal.historyData.data.push({"searchText": searchString})
            var seenNames = {}

            internal.historyData.data = internal.historyData.data.filter(function(currentObject) {
                if (currentObject.searchText in seenNames) {
                    return false
                } else {
                    seenNames[currentObject.searchText] = true;
                    return true
                }
            })
            var store = JSON.stringify(internal.historyData)
            console.log(store)

            database.storeData("searchHistory", internal.historyData.data.length, store)
        }
    }
}
