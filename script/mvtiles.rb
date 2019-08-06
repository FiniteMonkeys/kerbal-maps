#!/usr/bin/env ruby -wKU

require "fileutils"
require "optparse"

class Options
  attr_accessor :from_path, :to_path

  def initialize
    self.from_path = File.expand_path(".")
    self.to_path = File.expand_path("~/Downloads/kerbal-maps/tiles")
  end

  def define_options(parser)
    parser.banner = "Usage: mvtiles.rb [options]"

    parser.separator ""
    parser.separator "Specific options:"

    set_from_path_option(parser)
    set_to_path_option(parser)

    parser.separator ""
    parser.separator "Common options:"

    parser.on_tail("-h", "--help", "Show this message") do
      puts parser
      exit
    end
  end

  def set_from_path_option(parser)
    parser.on("-i PATH", "--from=PATH", String,
              "The directory to read map tiles from",
              %q[("." by default)]) do |path|
      path = "." if path.nil?
      full_path = File.expand_path(path)
      unless File.directory?(full_path)
        puts "input path #{full_path} does not exist"
        exit
      end

      self.from_path = full_path
    end
  end

  def set_to_path_option(parser)
    parser.on("-o PATH", "--to=PATH", String,
              "The directory to write map tiles to",
              "(will be created if necessary)") do |path|
      if path.nil?
        puts "output path must be specified"
        exit
      end

      full_path = File.expand_path(path)
      FileUtils.mkdir_p(full_path)

      self.to_path = full_path
    end
  end

  def self.parse(args)
    options = Options.new

    OptionParser.new do |parser|
      options.define_options(parser)
      parser.parse!(args)
    end

    options
  end
end

options = Options.parse ARGV

## Example usage:
##   ruby script/mvtiles.rb --from=~/Applications/KSP\ 1.7.3/GameData/Sigma/Cartographer/PluginData/ --to=~/Downloads/kerbal-maps/tiles
## followed by
##   pushd ~/Downloads/kerbal-maps && aws s3 cp tiles/ s3://kerbal-maps/tiles/ --recursive --exclude ".DS_Store" --include "*.png"

FileUtils.cd(options.from_path) do
  Dir.glob("**/*.png").each do | src_filename |
    (body, zoom, raw_style, _filename) = src_filename.split("/")
    style = case raw_style
            when "ColorMap"
              "color"
            when "SatelliteBiome"
              "biome"
            when "SatelliteMap"
              "sat"
            when "SatelliteSlope"
              "slope"
            else
              # "BiomeMap" -> "biome"
              # "SlopeMap" -> "slope"
              # "NormalMap" -> ?
              # "OceanMap" -> ?
              # "SatelliteHeight" -> ?
              raise "style #{raw_style} not implemented"
            end
    height = 2 ** (zoom.to_i)
    width = height * 2

    tile_number = File.basename(src_filename).gsub(/^Tile|\.png$/, "").to_i
    (dy, x) = tile_number.divmod(width)
    y = (height - 1) - dy

    dest_filename = File.join(options.to_path, body.downcase, style, zoom, x.to_s, "#{y}.png")
    FileUtils.mkdir_p(File.dirname(dest_filename))
    FileUtils.mv(src_filename, dest_filename, verbose: true)
  end
end
