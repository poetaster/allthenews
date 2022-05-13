import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: aboutPage

    Column {
        id: column
        anchors.fill: parent
        anchors.margins: Theme.horizontalPageMargin
        spacing: Theme.paddingLarge
        PageHeader {
            title: "About"
        }
        Label {
            anchors {
                left: parent.left
                right: parent.right
            }
            color: Theme.primaryColor
            horizontalAlignment: Text.AlignJustify
            wrapMode: Text.WordWrap
            text: qsTr("Feed by") + "<a href='https://newsapi.org'> newsapi.org</a>.<br>" + qsTr("News API can provide headlines from 70 worldwide source.")
            onLinkActivated: {
                Qt.openUrlExternally(link);
            }
        }
        Label {
            anchors {
                left: parent.left
                right: parent.right
            }
            color: Theme.primaryColor
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            text: qsTr("(c) poetaster, ") + "GPLv3, <a href='https://github.com/poetaster/allthenews'> github</a>"
            onLinkActivated: {
                Qt.openUrlExternally(link);
            }
        }
        Label {
            anchors {
                left: parent.left
                right: parent.right
            }
            color: Theme.primaryColor
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            text: qsTr("Icon from") + "<a href='https://icon-icons.com'>icon-icons.com</a>, <a href='https://creativecommons.org/licenses/by/4.0/'>CC</a>"
            onLinkActivated: {
                Qt.openUrlExternally(link);
            }
        }

        Image {

            source: Qt.resolvedUrl("/usr/share/icons/hicolor/86x86/harbour-allthenews.png")
            //                       "image://theme/graphic-cover-email-background
            Component.onCompleted: {
                console.log(source.toString())
            }
             anchors.horizontalCenter: parent.horizontalCenter

        }
    }
}

