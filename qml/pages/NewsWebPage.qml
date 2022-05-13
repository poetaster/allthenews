import QtQuick 2.2
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0

Page {

    property alias url: webView.url

    BusyIndicator {
        id: busyIndicator
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: webView.loading
        visible: webView.loading
    }

    WebView {
        id: webView
        width: parent.width
        height: parent.height

        url: "http://sailfishos.org"
        // keeping these here from web examples for future ref:
        /*onViewInitialized: {
            webview.loadFrameScript(Qt.resolvedUrl("framescript.js"));
            webview.addMessageListener("webview:action")
        }*/

        /*onRecvAsyncMessage: {
            switch (message) {
            case "webview:action":
                label.text = {"four": "4", "five": "5", "six": "6"}[data.topic]
                console.debug(data.topic)
                break
            }
        }*/
    }

}

