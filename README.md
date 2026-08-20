# NRK RSS Feed Plugin

An Omarchy plugin that displays the latest news from NRK's top stories RSS feed directly in your bar.

## Features

- Live RSS feed from NRK's top stories
- Latest headline displayed in the bar  
- Auto-refresh every 5 minutes
- Click to open NRK.no in your browser
- Hover effect on the widget
- Clean, minimal design

## Install

```bash
# Clone to your Omarchy plugins directory
git clone https://github.com/SjoenH/omarchy-nrk-rss ~/.config/omarchy/plugins/henry.nrk-rss

# Validate the plugin
omarchy plugin validate ~/.config/omarchy/plugins/henry.nrk-rss

# Enable the plugin
omarchy plugin enable no.koka.nrk-rss
```

## Usage

1. After enabling the plugin, it should appear in your bar automatically
2. The widget displays "NRK: [Latest Headline]"
3. Hover over the widget to see the hover effect (text becomes bold)
4. Click the widget to open NRK.no in your browser

## Configuration

The plugin fetches from `https://www.nrk.no/toppsaker.rss` by default. The update interval is set to 5 minutes (300000 ms).

## Requirements

- Omarchy desktop environment
- `curl` command-line tool (usually pre-installed)
- Internet connection

## Remove

```bash
# Disable the plugin
omarchy plugin disable no.koka.nrk-rss

# Remove the plugin directory
rm -rf ~/.config/omarchy/plugins/henry.nrk-rss
```

## License

MIT License - see LICENSE file

## Author

koka.no - https://koka.no
