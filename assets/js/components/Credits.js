import React from "react"

class Credits extends React.Component {
  render() {
    return (
      <div className="credits">
        <h2>Kerbal Maps</h2>
        <p>was made possible by</p>
        <ul>
          <li>
            <a href="https://www.kerbalspaceprogram.com/">Kerbal Space Program</a>&nbsp;
            for map data, as well as being the reason for doing this in the first place
          </li>
          <li>
            <a href="https://github.com/Sigma88/Sigma-Cartographer">Sigma-Cartographer</a>&nbsp;
            for a means of extracting the map data
          </li>
          <li>
            <a href="https://leafletjs.com">Leaflet.js</a>&nbsp;
            for a means to display the map images, with the help of
            <ul>
              <li><a href="https://github.com/Leaflet/Leaflet.Graticule">Leaflet.Graticule</a></li>
              <li><a href="https://github.com/nickpeihl/leaflet-sidebar-v2">leaflet-sidebar-v2</a></li>
              <li><a href="https://github.com/Leaflet/Leaflet.Icon.Glyph">Leaflet.Icon.Glyph</a></li>
            </ul>
          </li>
          <li>
            <a href="https://fontawesome.com">Font Awesome</a>&nbsp;
            for graphics
          </li>
          <li>
            <a href="http://ksp.deringenieur.net">ksp.deringenieur.net</a>&nbsp;
            (and <a href="http://www.kerbalmaps.com">kerbalmaps.com</a> before it) for the original idea
          </li>
          <li>
            <a href="https://hexdocs.pm/distillery/">Distillery</a>&nbsp;
            for making it possible to package the app so it can be made public
          </li>
          <li>
            <a href="https://heroku.com/">Heroku</a>&nbsp;
            for hosting the app
          </li>
          <li>
            <a href="https://aws.amazon.com/">Amazon AWS</a>&nbsp;
            for hosting the map images
          </li>
          <li>
            <a href="https://github.com/WizardOfOgz">Andy Ogzewalla</a>&nbsp;
            for JS mentorship, wizardry, and general awesomeness
          </li>
        </ul>
        <p>kerbal maps is a <a href="http://finitemonkeys.org/">finitemonkeys</a> joint</p>
        <p>
          Copyright © 2018-2019 Craig S. Cottingham, and subject to
          &nbsp;
          <a href="http://www.apache.org/licenses/LICENSE-2.0">the Apache License, Version 2.0</a>
          &nbsp;
          except where stated otherwise.
        </p>
      </div>
    )
  }
}

export default Credits
