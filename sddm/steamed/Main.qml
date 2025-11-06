import "."
import QtCore
import QtQuick
import QtQuick.Controls
import SddmComponents 2.0
import "."

Rectangle {
    id: container

    property int sessionIndex: session.index
    property date dateTime: new Date()

    LayoutMirroring.enabled: Qt.locale().textDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true
    Component.onCompleted: {
        nameinput.focus = true;
        textback1.state = "nay1"; //dunno why both inputs get focused
    }

    TextConstants {
        id: textConstants
    }

    Connections {
        function onLoginSucceeded() {
            errorMessage.text = textConstants.loginSucceeded;
        }

        function onLoginFailed() {
            password.text = "";
            errorMessage.color = "#ff3333";
            errorMessage.text = textConstants.loginFailed;
        }

        target: sddm
    }

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: container.dateTime = new Date()
    }

    FontLoader {
        id: myfontNormal

        source: "./assets/WineTahomaBit.ttf"
    }

    FontLoader {
        id: myfontBold

        source: "./assets/WineTahomaBit.ttf"
    }

    Image {
        id: behind

        anchors.fill: parent
        source: config.background
        fillMode: Image.Stretch
        onStatusChanged: {
            if (config.type === "color")
                source = config.defaultBackground;

        }
    }

    Image {
        id: promptBox

        anchors.centerIn: parent
        source: "assets/promptbox.svg"
        width: 480
        height: 280

        Text {
            id: productName

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 40
            anchors.leftMargin: 129
            color: "#f1f2f0"
            text: SystemInformation.prettyProductName + ' ' + SystemInformation.kernelVersion
            font.family: myfontBold.name
            font.bold: true
            font.pointSize: 10

            Text {
                id: date

                anchors.left: parent.left
                anchors.top: parent.bottom
                anchors.topMargin: 2
                color: "#f1f2f0"
                text: Qt.formatDateTime(container.dateTime, "ddd d MMMM hh:mm:ss")
                font.pointSize: 18
                font.family: myfontBold.name
                font.bold: true
            }

        }

        Image {
            id: imageinput

            source: "assets/input.svg"
            y: parent.height / 2 + 9
            anchors.right: parent.right
            anchors.rightMargin: 38
            width: 312
            height: 28

            TextField {
                id: nameinput

                focus: true
                font.family: myfontBold.name
                font.bold: true
                anchors.fill: parent
                text: userModel.lastUser
                font.pointSize: 10
                leftPadding: 8
                color: "#f1f2f0"
                selectByMouse: true
                selectionColor: "#22476d"
                selectedTextColor: "#f4f4ff"
                KeyNavigation.tab: password
                KeyNavigation.backtab: password
                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter)
                        password.focus = true;

                }
                onActiveFocusChanged: {
                    if (activeFocus)
                        textback.state = "yay";
                    else
                        textback.state = "nay";
                }

                background: Image {
                    id: textback

                    source: "assets/inputhi.svg"
                    states: [
                        State {
                            name: "yay"

                            PropertyChanges {
                                target: textback
                                opacity: 1
                            }

                        },
                        State {
                            name: "nay"

                            PropertyChanges {
                                target: textback
                                opacity: 0
                            }

                        }
                    ]
                    transitions: [
                        Transition {
                            to: "yay"

                            NumberAnimation {
                                target: textback
                                property: "opacity"
                                from: 0
                                to: 1
                                duration: 200
                            }

                        },
                        Transition {
                            to: "nay"

                            NumberAnimation {
                                target: textback
                                property: "opacity"
                                from: 1
                                to: 0
                                duration: 200
                            }

                        }
                    ]
                }

            }
            //inputimage

        }

        Image {
            id: imagepassword

            source: "assets/input.svg"
            anchors.top: imageinput.bottom
            anchors.horizontalCenter: imageinput.horizontalCenter
            anchors.topMargin: 4
            width: 312
            height: 28

            TextField {
                id: password

                font.family: myfontNormal.name
                anchors.fill: parent
                font.pointSize: 8
                leftPadding: 8
                echoMode: TextInput.Password
                color: "#f1f2f0"
                selectionColor: "#22476d"
                selectedTextColor: "#f4f4ff"
                KeyNavigation.tab: nameinput
                KeyNavigation.backtab: nameinput
                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        sddm.login(nameinput.text, password.text, sessionIndex);
                        event.accepted = true;
                    }
                }
                onActiveFocusChanged: {
                    if (activeFocus)
                        textback1.state = "yay1";
                    else
                        textback1.state = "nay1";
                }

                background: Image {
                    id: textback1

                    source: "assets/inputhi.svg"
                    states: [
                        State {
                            name: "yay1"

                            PropertyChanges {
                                target: textback1
                                opacity: 1
                            }

                        },
                        State {
                            name: "nay1"

                            PropertyChanges {
                                target: textback1
                                opacity: 0
                            }

                        }
                    ]
                    transitions: [
                        Transition {
                            to: "yay1"

                            NumberAnimation {
                                target: textback1
                                property: "opacity"
                                from: 0
                                to: 1
                                duration: 200
                            }

                        },
                        Transition {
                            to: "nay1"

                            NumberAnimation {
                                target: textback1
                                property: "opacity"
                                from: 1
                                to: 0
                                duration: 200
                            }

                        }
                    ]
                }

            }
            //imagepassword

        }

        Text {
            id: userlabel

            anchors.left: promptBox.left
            anchors.verticalCenter: imageinput.verticalCenter
            anchors.leftMargin: 38
            font.family: myfontNormal.name
            font.pointSize: 8
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            height: 28
            text: textConstants.userName + ":"
            color: "#f1f2f0"
        }

        Text {
            id: passwordlabel

            anchors.left: promptBox.left
            anchors.bottom: imagepassword.bottom
            anchors.leftMargin: 38
            anchors.topMargin: 1
            font.family: myfontNormal.name
            font.pointSize: 8
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            height: 28
            text: textConstants.password + ":"
            color: "#f1f2f0"
        }

        Image {
            id: loginButton

            property string toolTipText3: textConstants.login

            anchors.right: promptBox.right
            anchors.bottom: promptBox.bottom
            anchors.rightMargin: 12
            anchors.bottomMargin: 10
            width: 78
            height: 26
            source: "assets/buttonup.svg"
            ToolTip.text: toolTipText3
            ToolTip.delay: 500
            ToolTip.visible: toolTipText3 ? ma3.containsMouse : false

            MouseArea {
                id: ma3

                anchors.fill: parent
                hoverEnabled: true
                onHoveredChanged: {
                    if (containsMouse)
                        parent.source = "assets/buttonhover.svg";
                    else
                        parent.source = "assets/buttonup.svg";
                }
                onPressed: parent.source = "assets/buttondown.svg"
                onReleased: sddm.login(nameinput.text, password.text, sessionIndex)
            }

            Text {
                anchors.centerIn: parent
                color: "#f1f2f0"
                font.family: myfontNormal.name
                font.pointSize: 8
                text: textConstants.login
            }

        }

        ComboBox {
            id: session

            anchors.right: loginButton.left
            anchors.bottom: promptBox.bottom
            anchors.rightMargin: 12
            anchors.bottomMargin: 10
            width: 176
            height: 26
            font.pointSize: 8
            font.family: myfontNormal.name
            model: sessionModel
            index: sessionModel.lastIndex
            borderColor: "#212121"
            color: "#f1f2f0"
            menuColor: "#3e4637"
            textColor: "#f1f2f0"
            hoverColor: "#958831"
            focusColor: "#595959"
            arrowBox: "assets/comboarrow.svg"
            backgroundNormal: "assets/cbox.svg"
            backgroundHover: "assets/cboxhover.svg"
            backgroundPressed: "assets/cbox.svg"
            KeyNavigation.backtab: password
            KeyNavigation.tab: nameinput
        }

        Image {
            id: shutdownButton

            property string toolTipText1: textConstants.shutdown

            anchors.left: promptBox.left
            anchors.bottom: promptBox.bottom
            anchors.leftMargin: 12
            anchors.bottomMargin: 10
            width: 26
            height: 26
            source: "assets/powerup.svg"
            ToolTip.text: toolTipText1
            ToolTip.delay: 500
            ToolTip.visible: toolTipText1 ? ma1.containsMouse : false

            MouseArea {
                id: ma1

                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.source = "assets/powerhover.svg";
                }
                onExited: {
                    parent.source = "assets/powerup.svg";
                }
                onPressed: {
                    parent.source = "assets/powerdown.svg";
                }
                onReleased: {
                    parent.source = "assets/powerup.svg";
                    sddm.powerOff();
                }
            }

        }

        Image {
            id: rebootButton

            property string toolTipText2: textConstants.reboot

            anchors.left: shutdownButton.right
            anchors.bottom: promptBox.bottom
            anchors.leftMargin: 12
            anchors.bottomMargin: 10
            width: 26
            height: 26
            source: "assets/rebootup.svg"
            ToolTip.text: toolTipText2
            ToolTip.delay: 500
            ToolTip.visible: toolTipText2 ? ma2.containsMouse : false

            MouseArea {
                id: ma2

                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.source = "assets/reboothover.svg";
                }
                onExited: {
                    parent.source = "assets/rebootup.svg";
                }
                onPressed: {
                    parent.source = "assets/rebootdown.svg";
                }
                onReleased: {
                    parent.source = "assets/rebootup.svg";
                    sddm.reboot();
                }
            }

        }
        //promptbox

    }

}
