import QtQuick 2.6
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0
import Sailfish.WebEngine 1.0
import QtMultimedia 5.0

WebViewPage {
    id: root
    objectName: "WebPage"

    property string url

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        PullDownMenu {
            MenuItem {
                text: qsTr("Open in browser")
                onClicked: {
                    Qt.openUrlExternally(url);
                }
            }
        }

        WebView {
            anchors.fill: parent
            width: parent.width

            url: root.url

            id: webview
            httpUserAgent: "Mozilla/5.0 (Mobile; rv:93.0) Gecko/93.0 Firefox/93.0"

            /* This will probably be required from 4.4 on. */
            Component.onCompleted: {
                //WebEngineSettings.setPreference("security.disable_cors_checks", true, WebEngineSettings.BoolPref)
                //WebEngineSettings.setPreference("security.fileuri.strict_origin_policy", false, WebEngineSettings.BoolPref)

            }
            onRecvAsyncMessage: {

                console.debug(message)
                switch (message) {
                case "embed:contentOrientationChanged":
                    break
                case "webview:action":
                    if ( data.key != val ) {
                        //if (debug) console.debug(data.src)
                    }
                    break
                }

            }

        }
    }
}
