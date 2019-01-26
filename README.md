# KerbalMaps

> A Google Maps-like UI for Kerbal Space Program (KSP) celestial bodies.

[![CircleCI](https://img.shields.io/circleci/project/github/FiniteMonkeys/kerbal-maps.svg?style=flat)](https://circleci.com/gh/FiniteMonkeys/kerbal-maps)
[![Github open issues](https://img.shields.io/github/issues/FiniteMonkeys/kerbal-maps.svg?style=flat)](https://github.com/FiniteMonkeys/kerbal-maps/issues)
[![Github open PRs](https://img.shields.io/github/issues-pr/FiniteMonkeys/kerbal-maps.svg?style=flat)](https://github.com/FiniteMonkeys/kerbal-maps/pulls)
[![License](https://img.shields.io/github/license/FiniteMonkeys/kerbal-maps.svg)](https://github.com/FiniteMonkeys/kerbal-maps/blob/master/LICENSE)

## QUICK START

  1. Clone the repository.
  2. Edit `config/dev.exs` to set up the database connection appropriately.
  3. Run `mix deps.get`.
  4. Run `mix phx.server`.

Note that image tiles are not included in this repository:

  * They add up to more than 11 GB of data (at present, and that's just for Kerbin).
  * They should be pushed out to a CDN for efficiency.
  * They can be generated as needed (see below).

## DEPLOYING

### Heroku

   1. Download and install the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-command-line).
   2. Install and set up Docker.
   3. Create an app on Heroku. The following steps assume that it is named `kerbal-maps`.
   4. Add Heroku Postgres. The "Hobby - Dev" level should be sufficient for now.
   5. Define config vars:
      * `DATABASE_URL` - something like `postgres://username:password@host:port/database`
      * `ERLANG_COOKIE` - can be anything, as far as I know
      * `SECRET_KEY_BASE` - get by running `mix phx.gen.secret`
      * `TILE_CDN_URL` - base URL to where the map tiles are stored, up to but not including the body name, with no trailing slash
   6. `heroku login`
   7. `heroku git:remote -a kerbal-maps`
   8. `heroku container:login`
   9. `heroku container:push web`
  10. `heroku container:release web`

## GENERATING THE MAP TILES

The map tiles are extracted using the [Sigma-Cartographer]() mod for KSP.
When Sigma-Cartographer loads (when KSP is started), it looks for a file
somewhere in the `GameData` directory tree with the extension `.cfg` and
containing the tag `@SigmaCartographer`. It uses the configuration in this file
to determine what tiles to render and how to render them.

The file should contain one or more sections that look like this.

```
Maps
{
  body = Kerbin
  biomeMap = false
  colorMap = false
  slopeMap = false
  satelliteBiome = true
  satelliteMap = true
  satelliteSlope = true
  oceanFloor = true
  width = 512
  tile = 256
  exportFolder = 0
  leaflet = false
}
```

`body` is the name of one of the bodies of the Kerbin system, in proper case.

> Note: `Jool` is not allowed, as it has no surface, and therefore no map.

`tile` should always be `256`.

`exportFolder` is the zoom level. Its value should be between `0` and `7` inclusive.

> Higher zoom levels are not disallowed, but at level 7 there's already visible
> rendering artifacts.

`width` is correlated to the zoom level. Its value should be `512 * 2^(zoom level)`.

The rendered tiles are written to `GameData/Sigma/Cartographer/PluginData/(body)/(exportFolder)`.
They require some rearranging and renaming before they can be uploaded to the CDN.
The Ruby script in `script/move.rb` will do that.

Note that on my computer (2.9 GHz Intel Core i7 with 16 GB of memory) rendering a full
set of tiles (all three styles, zoom levels 0-7) for a single body takes in excess
of twelve hours. Plan accordingly.

## KNOWN BUGS

## CONTRIBUTING

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Unit tests were written with [ESpec](https://github.com/antonmi/espec).
Execute the specs by running `mix espec`.

## TODO

See the [open issues on Github](https://github.com/FiniteMonkeys/kerbal-maps/issues).

## ACKNOWLEDGEMENTS

Made possible in part by:

* [Kerbal Space Program](https://www.kerbalspaceprogram.com/)
* [Sigma-Cartographer](https://github.com/Sigma88/Sigma-Cartographer)
* [Waypoint Manager](https://github.com/jrossignol/WaypointManager)
* [Leaflet.js](https://leafletjs.com) and plugins:
  * [Leaflet.Graticule](https://github.com/Leaflet/Leaflet.Graticule)
  * [leaflet-sidebar-v2](https://github.com/nickpeihl/leaflet-sidebar-v2)
  * [Leaflet.Icon.Glyph](https://github.com/Leaflet/Leaflet.Icon.Glyph)
* [Bootstrap](https://getbootstrap.com)
* [Font Awesome](https://fontawesome.com)
* [RealFaviconGenerator](https://realfavicongenerator.net/)
* [Distillery](https://hexdocs.pm/distillery/)
* [Andy Ogzewalla](https://github.com/WizardOfOgz)

## COPYRIGHT

Copyright (c) 2018-2019 Craig S. Cottingham, except where stated otherwise.

## LICENSE

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions
and limitations under the License.
