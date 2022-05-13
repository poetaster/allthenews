import QtQuick 2.2
import Sailfish.Silica 1.0

import "Utils.js" as Utils

Page {
    id: sourceFeedPage

    property string source
    property string sourceTitle
    property string search

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
               }
            }

            busyIndicator.running = false
            busyIndicator.visible = false
        }
    }

    Component {
        id: feedDelegate
        ListItem {
            contentHeight: Theme.itemSizeMedium + sourceLogo.height + descriptionText.height
            height: Theme.itemSizeMedium + contentRow.height
            width: parent.width
            SectionHeader {
                id: feedTitle
                text: title
                width:parent.width
                height: contentRow.height / 2
                anchors {
                    left: parent.left
                    right: parent.right
                    topMargin: Theme.paddingLarge
                    leftMargin: Theme.paddingMedium
                    rightMargin: Theme.paddingMedium
                }
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.highlightColor
                truncationMode: TruncationMode.Fade
                maximumLineCount: 2
                wrapMode: Text.WordWrap

            }
            Item {
                id: contentRow
                height: childrenRect.height
                width:parent.width
                anchors {
                    top: feedTitle.bottom
                    bottomMargin: Theme.paddingLarge
                    topMargin: Theme.paddingLarge
                }
            Text {
                id: descriptionText
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingMedium
                    //baseline: unreadCount.baseline
                    //baselineOffset: lineCount > 1 ? -implicitHeight/2 : -(height-implicitHeight)/2

                }
                horizontalAlignment: Text.AlignLeft
                width: (parent.width / 2) - Theme.paddingMedium
                text: description
                wrapMode: "WordWrap"
                color: Theme.primaryColor
                font.family: Theme.fontFamily
                font.pointSize: Theme.fontSizeTiny
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
            Separator {
            }

            onClicked: {
                pageStack.push(Qt.resolvedUrl("NewsWebPage.qml"), {url: url})
            }
        }
    }

    Component.onCompleted: {
        if (search) {
            busyIndicator.running = true
            busyIndicator.visible = true
            var url = "https://newsapi.org/v2/everything?q=" + search + "&sortBy=publishedAt"
            Utils.sendHttpRequest("GET", url, fillData)

        } else if (source && sourceTitle) {
            busyIndicator.running = true
            busyIndicator.visible = true
            var url = "https://newsapi.org/v2/top-headlines?sources=" + source
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
                text: "Refresh"
                onClicked: {
                    if (source) {
                        feed.clear()
                        var url = "https://newsapi.org/v2/top-headlines?sources=" + source //+ "&apiKey=" + Utils.apiKey
                        Utils.sendHttpRequest("GET", url, fillData)
                    }
                }
            }
        }

        ViewPlaceholder {
            enabled: feed.count == 0 && !busyIndicator.running
            text: "Nothing to show now"
        }
    }
}

