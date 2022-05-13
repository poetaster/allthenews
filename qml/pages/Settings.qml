import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    property var settings: ({})
    Database {
        id: database
    }

    Component.onCompleted: {
        database.initDatabase()

        var langIndex = database.getValue("language")
        if (langIndex) {
            lang.currentIndex = langIndex
        } else {
            database.storeData("language", 0, "All")
        }
        var countryIndex = database.getValue("country")
        if (countryIndex) {
            country.currentIndex = countryIndex
        } else {
            database.storeData("country", 0, "All")
        }
        var categoryIndex = database.getValue("category")
        if (categoryIndex) {
            category.currentIndex = categoryIndex
        } else {
            database.storeData("category", 0, "All")
        }
        var apiKeyText = database.getValue("apiKey")
        if (apiKeyText !== "") {
            apiKey.text =  apiKeyText
        } else {
            database.storeData("apiKey", 0, "0")
        }
    }

    Column {
        width: parent.width

        DialogHeader { }

        SectionHeader {
            text: "apiKey"
            horizontalAlignment: Text.AlignLeft
        }

        TextField {
            id: apiKey
            label: qsTr("newsapi.org API key")
            width: parent.width
            onTextChanged: {
                database.storeData("apiKey", apiKey.text, apiKey.text)
            }
        }
//ar en cn de es fr he it nl no pt ru sv ud
        SectionHeader {
            text: "Language"
            horizontalAlignment: Text.AlignLeft
        }
        ComboBox {
            id: lang
            width: parent.width
            anchors {
                left: parent.left
                leftMargin: Theme.paddingMedium
            }

            label: "Select language"

            menu: ContextMenu {
                MenuItem { text: "All" }
                MenuItem { text: "ar" }
                MenuItem { text: "en" }
                MenuItem { text: "cn" }
                MenuItem { text: "de" }
                MenuItem { text: "es" }
                MenuItem { text: "fr" }
                MenuItem { text: "he" }
                MenuItem { text: "it" }
                MenuItem { text: "nl" }
                MenuItem { text: "no" }
                MenuItem { text: "pt" }
                MenuItem { text: "ru" }
                MenuItem { text: "sv" }
                MenuItem { text: "ud" }
            }
        }
        SectionHeader {
            text: "Country"
            horizontalAlignment: Text.AlignLeft
        }
        ComboBox {
            id: country
            width: parent.width
            anchors {
                left: parent.left
                leftMargin: Theme.paddingMedium
            }

            label: "Select country"
            //ar au br ca cn de es fr gb hk ie in is it nl no pk ru sa sv us za
            menu: ContextMenu {
                MenuItem { text: "All" }
                MenuItem { text: "ar" }
                MenuItem { text: "au" }
                MenuItem { text: "br" }
                MenuItem { text: "ca" }
                MenuItem { text: "de" }
                MenuItem { text: "es" }
                MenuItem { text: "fr" }
                MenuItem { text: "gb" }
                MenuItem { text: "hk" }
                MenuItem { text: "ie" }
                MenuItem { text: "in" }
                MenuItem { text: "is" }
                MenuItem { text: "it" }
                MenuItem { text: "nl" }
                MenuItem { text: "no" }
                MenuItem { text: "pk" }
                MenuItem { text: "ru" }
                MenuItem { text: "sa" }
                MenuItem { text: "sv" }
                MenuItem { text: "us" }
                MenuItem { text: "za" }
            }
            onCurrentIndexChanged: {
                console.log("Index", currentIndex)
            }
        }
        SectionHeader {
            text: "Category"
            horizontalAlignment: Text.AlignLeft
        }
        //business, entertainment, gaming, general, music, science-and-nature, sport, technology
        ComboBox {
            id: category
            width: parent.width
            anchors {
                left: parent.left
                leftMargin: Theme.paddingMedium
            }

            label: "Select category"

            menu: ContextMenu {
                MenuItem { text: "All" }
                MenuItem { text: "business" }
                MenuItem { text: "entertainment" }
                MenuItem { text: "gaming" }
                MenuItem { text: "general" }
                MenuItem { text: "science-and-nature" }
                MenuItem { text: "sport" }
                MenuItem { text: "health-and-medical" }
                MenuItem { text: "music" }
                MenuItem { text: "technology" }
            }
        }
    }

    onDone: {
        if (result === DialogResult.Accepted) {

            settings = {"language": lang.value, "country": country.value, "category": category.value, "apiKey": apiKey.text}
            console.log("language", lang.value, "country", country.value, "category", category.value, "apiKey", apiKey.text)

            console.log(apiKey.text)

            database.storeData("apiKey", apiKey.text, apiKey.text)
            database.storeData("language", lang.currentIndex, lang.value)
            database.storeData("country", country.currentIndex, country.value)
            database.storeData("category", category.currentIndex, category.value)
        }
    }
}

