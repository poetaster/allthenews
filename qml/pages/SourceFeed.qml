import QtQuick 2.2
import Sailfish.Silica 1.0

import "Utils.js" as Utils

Page {
    id: sourceFeedPage

    property string source
    property string sourceTitle
    property string search
    property string url
    property bool debug: false

    Database {
        id: database
    }


    ListModel {
        id: feed
    }

    BusyIndicator {
        id: busyIndicator
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: true
    }

    function fillData(data) {
        if (data !== "error") {
            var parsed = JSON.parse(data)
            if (parsed.status === "ok") {
                for (var i in parsed.articles) {
                    feed.append(parsed.articles[i])

                    if (debug) console.debug(parsed.articles[i].author)
                }
            }

            busyIndicator.running = false
            busyIndicator.visible = false
        }
    }

    Component {

        id: feedDelegate
        ListItem {
            //contentHeight: Theme.itemSizeMedium + sourceLogo.height + descriptionText.height
            height: Theme.itemSizeMedium + contentRow.height + feedTitle.height + metaRow.height
            width: parent.width

            Label {
                id: feedTitle
                anchors {
                    left: contentRow.left
                    leftMargin : Theme.paddingMedium
                }
                text: title
                width:parent.width - (2 * Theme.paddingLarge)
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.highlightColor
                truncationMode: TruncationMode.Elide
                maximumLineCount: 2
                wrapMode: Text.WordWrap

            }
            Item {
                id: metaRow
                height: childrenRect.height
                width:parent.width - (2 * Theme.paddingLarge)
                anchors {
                    top: feedTitle.bottom
                    left: feedTitle.left
                    bottomMargin: Theme.paddingLarge
                    topMargin: Theme.paddingLarge
                }
                Label {
                    id: publishedAtField
                    width:parent.width / 2 - Theme.paddingLarge
                    anchors {
                        leftMargin : Theme.paddingMedium
                    }
                    text: publishedAt
                    font.pixelSize: Theme.fontSizeExtraSmall
                }
            }
            Item {
                id: contentRow
                height: childrenRect.height
                width:parent.width
                anchors {
                    top: metaRow.bottom
                    bottomMargin: Theme.paddingSmall
                    topMargin: Theme.paddingSmall
                }
                Label {
                    id: authorField
                    width: (parent.width / 2) - Theme.paddingMedium
                    anchors {
                        top: parent.top
                        left:parent.left
                        leftMargin: Theme.paddingMedium
                        bottomMargin : Theme.paddingLarge
                    }
                    text: qsTr("By - ") + author
                    font.pixelSize: Theme.fontSizeExtraSmall
                    wrapMode: "WordWrap"
                }
                Text {
                    id: descriptionText
                    anchors {
                        top:authorField.bottom
                        left: parent.left
                        leftMargin: Theme.paddingMedium
                        topMargin : Theme.paddingLarge
                        //baseline: unreadCount.baseline
                        //baselineOffset: lineCount > 1 ? -implicitHeight/2 : -(height-implicitHeight)/2

                    }
                    horizontalAlignment: Text.AlignLeft
                    width: (parent.width / 2) - Theme.paddingMedium
                    text: description
                    wrapMode: "WordWrap"
                    color: Theme.primaryColor
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                }
                Image {
                    id: sourceLogo
                    anchors {
                        right: parent.right
                        left: descriptionText.right
                        leftMargin: Theme.paddingMedium
                    }
                    horizontalAlignment: Text.AlignRight
                    source: decodeURI(urlToImage)
                    width: parent.width / 3 //- Theme.paddingMedium
                    fillMode: Image.PreserveAspectFit
                }
            }
            onClicked: {
                pageStack.push(Qt.resolvedUrl("NewsWebPage.qml"), {url: url})
            }
        }
    }

    Component.onCompleted: {
        database.initDatabase()

        if (search) {
            busyIndicator.running = true
            busyIndicator.visible = true
            var apiKey = database.getValue("apiKey")
            url = "https://newsapi.org/v2/everything?apiKey=" + apiKey + "&q=" + search + "&sortBy=publishedAt"
            Utils.sendHttpRequest("GET", url, fillData)

        } else if (source && sourceTitle) {
            busyIndicator.running = true
            busyIndicator.visible = true
            var apiKey = database.getValue("apiKey")

            if (debug) console.debug(database.getValue("apiKey"))

            url = "https://newsapi.org/v2/top-headlines?apiKey=" + apiKey + "&sources=" + source
            Utils.sendHttpRequest("GET", url, fillData)
        }
    }

    ListView {
        id: feedListView
        anchors.fill: parent
        header: PageHeader { id: viewHeader; title: sourceTitle }
        focus: true
        clip: true
        spacing: Theme.paddingSmall
        model: feed
        delegate: feedDelegate
        ScrollDecorator { flickable: feedListView }

        PullDownMenu {
            MenuItem {
                text: qsTr("Refresh")
                onClicked: {
                    if (source) {
                        feed.clear()
                        var apiKey = database.getValue("apiKey")
                        url = "https://newsapi.org/v2/top-headlines?apiKey=" + apiKey + "&sources=" + source //+ "&apiKey=" + Utils.apiKey
                        Utils.sendHttpRequest("GET", url, fillData)
                    }
                }
            }
        }

        ViewPlaceholder {
            enabled: feed.count == 0 && !busyIndicator.running
            text: qsTr("Nothing to show now")
        }
    }
}

