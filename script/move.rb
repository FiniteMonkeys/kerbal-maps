#!/usr/bin/env ruby -wKU

require 'fileutils'

DEST_ROOT = File.expand_path("~/Downloads/ksp-maps/tiles")

Dir.glob("**/*.png").each do | src_filename |
  (body, zoom, raw_style, _filename) = src_filename.split("/")
  style = case raw_style
          when "BiomeMap"
            raise "style #{raw_style} not implemented"
            # "biome"
          when "ColorMap"
            "color"
          when "SatelliteBiome"
            "biome"
          when "SatelliteMap"
            "sat"
          when "SatelliteSlope"
            "slope"
          when "SlopeMap"
            raise "style #{raw_style} not implemented"
            # "slope"
          end
  height = 2 ** (zoom.to_i)
  width = height * 2

  tile_number = File.basename(src_filename).gsub(/^Tile|\.png$/, "").to_i
  (dy, x) = tile_number.divmod(width)
  y = (height - 1) - dy

  dest_filename = File.join(DEST_ROOT, body.downcase, style, zoom, x.to_s, "#{y}.png")
  FileUtils.mkdir_p(File.dirname(dest_filename))
  FileUtils.mv(src_filename, dest_filename, verbose: true)
end
