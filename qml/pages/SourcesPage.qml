import QtQuick 2.2
import Sailfish.Silica 1.0

import "Utils.js" as Utils

Page {
    property bool debug: false
    property string apiKey
    property bool showHint

    id: sourcesPage

    Database {
        id: database
    }

    ListModel {
        id: sources
    }

    BusyIndicator {
        id: busyIndicator
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: true
        visible: true
    }


    Component.onCompleted: {
        busyIndicator.running = true
        busyIndicator.visible = true
        database.initDatabase()
        apiKey = database.getValue("apiKey")

        if (debug) console.debug(apiKey )

        if (apiKey) {
            showHint = false
        } else {
            showHint = true
        }

        getSources()
    }

    function fillData(data) {
        if (data !== "error") {
            var parsed = JSON.parse(data)
            if (parsed.status === "ok") {
                for (var i in parsed.sources) {
                    sources.append(parsed.sources[i])
                }
            }
            busyIndicator.running = false
            busyIndicator.visible = false
        }
    }

    function getSources(/*lang, country, category*/) {

        apiKey = database.getValue("apiKey")
        if (apiKey)  {
            showHint = false
            sources.clear()
            var options
            var lang = database.getName("language")
            if (!lang) {
                lang = "All"
            }
            var country = database.getName("country")
            if (!country) {
                country = "All"
            }
            var category = database.getName("category")
            if (!category) {
                category = "All"
            }
            if (lang && lang !== "All") {
                options = "language=" + lang
            }
            if (country && country !== "All") {
                if (options) {
                    options += "&country=" + country
                } else {
                    options = "country=" + country
                }
            }
            if (category && category !== "All") {
                if (options) {
                    options += "&category=" + category
                } else {
                    options = "category=" + category
                }
            }

            var url
            if (options) {
                url = "https://newsapi.org/v2/sources?apikey=" + apiKey + "&" + options
            } else {
                url = "https://newsapi.org/v2/sources?apikey=" + apiKey
            }
            Utils.sendHttpRequest("GET", url, fillData)
        }
    }

    function searchPage(value) {
        if (debug) console.log(value)
        app.feedTitle = value
//        pageStack.pop()
        pageStack.replace(Qt.resolvedUrl("SourceFeed.qml"), {search: value})
    }

    Component {
        id: sourcesListDelegate
        ListItem {
            contentHeight: feedName.height + descriptionText.height
            height: childrenRect.height
            //Theme.itemSizeSmall + feedName.height + descriptionText.height
            width: parent.width

            SectionHeader {
                id: feedName
                anchors {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                }
                text: name
            }
            Text {
                id: descriptionText
                anchors {
                    top: feedName.bottom
                    topMargin: Theme.paddingSmall
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                }
                text: description
                wrapMode: Text.WordWrap
                color: Theme.primaryColor
                font.family: Theme.fontFamily
                font.pointSize: Theme.fontSizeTiny
                horizontalAlignment: Text.AlignLeft
            }
            onClicked: {
                app.feedTitle = name
                pageStack.push(Qt.resolvedUrl("SourceFeed.qml"), {source: id, sourceTitle: name})
            }
        }
    }

    SilicaListView {
        id: sourcesListView
        anchors.fill: parent
        header: PageHeader { id: viewHeader; title: "newsapi.org feeds" }
        focus: true
        clip: true
        spacing: Theme.paddingSmall
        currentIndex: -1
        highlight: Rectangle {
            color: "#b1b1b1"
            opacity: 0.3
        }

        model: sources
        delegate: sourcesListDelegate
        ScrollDecorator { flickable: sourcesListView }

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("About.qml"))
                }
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("Settings.qml"))
                    dialog.accepted.connect(function() {
                        getSources(dialog.settings.language, dialog.settings.country, dialog.settings.category)
                    })
                }
            }
            MenuItem {
                text: qsTr("Search news")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("SearchPage.qml"))
                    dialog.accepted.connect(function() {
//                        result = dialog.searchString
                        searchPage(dialog.searchString)
                    })
                }
            }
        }

        ViewPlaceholder {
            enabled: !busyIndicator.running && sources.count === 0
            text: qsTr("Nothing to show now")
        }
    }

              HintLoader {
                  hint: apiKeyHint
                  when: showHint

              }
              Hint {
                  id: apiKeyHint
                  title: qsTr("apiKey")
                  items: [qsTr("- Select settings to enter an apiKey for newsapi.org")]
              }


}

