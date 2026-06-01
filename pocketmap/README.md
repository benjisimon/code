# pocketmap

`pocketmap` takes a plain-text `.pois` route file and generates a two-page printable PDF:

- **Page 1** — a map of the route, scaled to fit the page, with UTM coordinates along the edges (e.g. `1 cm = 1 km`)
- **Page 2** — a navigation reference: a waypoint table with cumulative and per-segment distances, plus a cm → km/mi conversion chart for measuring directly on the printed map

The consistent cm scale means you can use any GPS device that displays UTM coordinates to locate yourself on the map — no data connection required.

## Usage

```
pocketmap day1.pois > day1.pdf
pocketmap day1.pois day1.pdf
```

## Requirements

- Python 3
- `matplotlib` (`pip install matplotlib`)

## File Format

Uses the same `.pois` format as [geoassist](../geoassist):

```
X address_or_lat,lng # Waypoint label
V address_or_lat,lng # Routing hint (on route, not shown as waypoint)
@ address_or_lat,lng # Point of interest (off route)
# comment
```
