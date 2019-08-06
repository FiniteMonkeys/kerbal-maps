#!/usr/bin/env ruby -wKU

## Example usage:
##   ruby script/ldbiomes.rb -p "JNSQ" ~/Applications/KSP 1.7.3/GameData/Sigma/Cartographer/PluginData > jnsq.sql

require "find"
require "json"
require "optparse"
require "pp"

class Options
  attr_accessor :force, :output_file, :output_filename, :pack

  def initialize
    self.force = false
    self.output_file = STDOUT
    self.output_filename = nil
    self.pack = "(stock)"
  end

  def define_options(parser)
    parser.banner = "Usage: ldbiomes.rb [options]"

    parser.separator ""
    parser.separator "Specific options:"

    # set_force_option(parser)
    # set_output_filename_option(parser)
    set_pack_option(parser)

    parser.separator ""
    parser.separator "Common options:"

    parser.on_tail("-h", "--help", "Show this message") do
      puts parser
      exit
    end
  end

  def set_force_option(parser)
    parser.on("-f", "--[no-]force", "If set, overwrite any existing load_biomes.sql") do |force|
      self.force = force
    end
  end

  def set_output_filename_option(parser)
    parser.on("-o FILENAME", "--out=FILENAME", String,
              "The file to which to write the SQL script",
              "(STDOUT by default; if a directory, write to load_biomes.sql)") do |output_filename|
      return if output_filename.nil?
      full_pathname = File.expand_path(output_filename)
      full_pathname = File.join(full_pathname, "load_biomes.sql") if File.directory?(full_pathname)
      self.output_filename = full_pathname
    end
  end

  def set_pack_option(parser)
    parser.on("-p PLANET_PACK", "--pack=PLANET_PACK", String,
              "An installed planet pack to use instead of the default KSP system",
              "(if not specified, assume default)") do |pack_name|
      self.pack = if pack_name.nil?
                    :default
                  else
                    pack_name.downcase.to_sym
                  end
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

if !options.output_filename.nil?
  if File.exist?(options.output_filename) && !options.force
    puts "file #{options.output_filename} already exists"
    exit
  end
  options.output_file = File.open(options.output_filename, "w")
end

root_path = File.expand_path(ARGV[0] || ".")

biomes = {}
current_body = nil

Find.find(root_path) do |path|
  case
  when FileTest.directory?(path)
    if File.basename(path)[0] == '.'
      Find.prune
    else
      next
    end
  when FileTest.file?(path) && (File.basename(path) == "Info.txt")
    current_body = nil

    File.readlines(path).each do |item|
      case item
      when %r{^Body\s*=\s*(.+)$}
        current_body = $1.strip
        biomes[current_body] = {}
      when %r{^Biome\s*=\s*(.+)\s+RGBA\((.+)\)\s*$}
        biome_name = $1.strip
        (r, g, b, a) = $2.split(%r{,\s*}).map { |v| v.to_f }
        biomes[current_body][biome_name] = [(r * 255).floor, (g * 255).floor, (b * 255).floor, a]
      end
    end
  end
end

biomes.each do |body_name, body_biomes|
  options.output_file.puts <<-END_OF_SQL

UPDATE celestial_bodies
  SET biome_mapping = '#{JSON.generate(body_biomes)}'::jsonb
  FROM planet_packs
  WHERE celestial_bodies.planet_pack_id = planet_packs.id
  AND celestial_bodies.name = '#{body_name}'
  AND planet_packs.name = '#{options.pack}';

  END_OF_SQL
end
