import QtQuick 2.6
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0
import Sailfish.WebEngine 1.0
import QtMultimedia 5.0

Page {
    id: root
    objectName: "WebPage"

    property string url

    allowedOrientations: Orientation.All

    Loader {
        id: loader

        anchors.fill: parent
        sourceComponent: parent.status === PageStatus.Active ? webComponent : undefined
    }

    Component {
        id: webComponent

        WebView {
            anchors.fill: parent

            id: webview
            httpUserAgent: "Mozilla/5.0 (Mobile; rv:78.0) Gecko/78.0 Firefox/78.0"

            /* This will probably be required from 4.4 on. */
            Component.onCompleted: {
                WebEngineSettings.setPreference("security.disable_cors_checks", true, WebEngineSettings.BoolPref)
                WebEngineSettings.setPreference("security.fileuri.strict_origin_policy", false, WebEngineSettings.BoolPref)
                    if (configFontScaleWebEnabled.booleanValue)
                    {
                        experimental.preferences.minimumFontSize =
                                Theme.fontSizeExtraSmall * (configFontScale.value / 100.0);
                    }

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

            //property int _backCount: 0
            //property int _previousContentY;

            url: root.url

            onLoadingChanged: {}
        }

    }
}
