import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui
import qs.Commons

BarWidget {
    id: root
    moduleName: "no.koka.nrk-rss"
    
    property string latestHeadline: "Loading..."
    property string latestLink: "https://www.nrk.no/"
    property bool hasError: false
    
    implicitWidth: contentItem.width
    implicitHeight: 20
    
    Item {
        id: contentItem
        width: 150
        height: parent.height
        clip: true
        
        Text {
            id: textItem
            anchors.verticalCenter: parent.verticalCenter
            x: scrollAnimation.running ? -scrollAnimation.progress : 0
            text: root.hasError ? "NRK: Error" : "NRK: " + root.latestHeadline
            color: root.bar.foreground
            font.pixelSize: 12
            font.family: root.bar.fontFamily
            
            property real textWidth: textItem.contentWidth
        }
        
        Timer {
            id: scrollAnimation
            interval: 50
            running: textItem.textWidth > 150
            repeat: true
            
            property real progress: 0
            property real maxScroll: textItem.textWidth - 150 + 20
            
            onTriggered: {
                progress += 1
                if (progress > maxScroll) {
                    progress = -100
                }
            }
        }
        
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            
            onClicked: {
                Qt.openUrlExternally(root.latestLink)
            }
            
            onEntered: {
                textItem.font.bold = true
            }
            
            onExited: {
                textItem.font.bold = false
            }
        }
    }
    
    Process {
        id: rssProcess
        command: ["curl", "-s", "https://www.nrk.no/nyheter/siste.rss"]
        running: true
        
        stdout: StdioCollector {
            id: stdoutCollector
        }
        
        onExited: function(exitCode, exitStatus) {
            if (exitCode === 0 && stdoutCollector.data) {
                root.parseRss(String(stdoutCollector.data))
            } else {
                root.hasError = true
                console.log("RSS fetch failed with exit code:", exitCode)
            }
        }
    }
    
    Timer {
        interval: 300000
        running: true
        repeat: true
        
        onTriggered: {
            rssProcess.running = true
        }
    }
    
    function parseRss(xmlData) {
        try {
            // Extract first item with both title and link
            var firstItemMatch = xmlData.match(/<item>([\s\S]*?)<\/item>/)
            if (firstItemMatch && firstItemMatch[1]) {
                var itemXml = firstItemMatch[1]
                
                // Extract title
                var titleMatch = itemXml.match(/<title>(.*?)<\/title>/)
                if (titleMatch && titleMatch[1]) {
                    var title = decodeHtml(titleMatch[1])
                    // Don't truncate - let it scroll
                    root.latestHeadline = title
                }
                
                // Extract link
                var linkMatch = itemXml.match(/<link>(.*?)<\/link>/)
                if (linkMatch && linkMatch[1]) {
                    root.latestLink = linkMatch[1].trim()
                    console.log("NRK RSS: Extracted link:", root.latestLink)
                } else {
                    console.log("NRK RSS: Failed to extract link from item")
                }
                
                root.hasError = false
            } else {
                root.hasError = true
            }
        } catch (e) {
            root.hasError = true
            console.log("RSS parse error:", e)
        }
    }
    
    function decodeHtml(text) {
        return text
            .replace(/&amp;/g, '&')
            .replace(/&lt;/g, '<')
            .replace(/&gt;/g, '>')
            .replace(/&quot;/g, '"')
            .replace(/&#39;/g, "'")
            .replace(/<[^>]*>/g, '')
    }
}
