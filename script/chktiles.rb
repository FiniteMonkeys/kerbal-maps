#!/usr/bin/env ruby -wKU

require "fileutils"
require "open3"

## Example usage:
##   ruby script/chktiles.rb s3://kerbal-maps/tiles/

catalog = {}

Open3.popen2e("aws", "s3", "ls", ARGV[0], "--recursive") do | i, oe, t |
  oe.each do | line |
    (_date, _time, _size, name) = line.chomp.split(/\s+/, 4)
    %r{(?:.+/)?tiles/(?<body>[^/]+)/(?<style>[^/]+)/(?<zoom>[^/]+)/(?<col>[^/]+)/(?<row>[^/]+).png\z}.match(name) do | md |
      body = md["body"]
      style = md["style"]
      zoom = md["zoom"]
      col = md["col"]

      catalog[body] ||= {}
      catalog[body][style] ||= {}
      catalog[body][style][zoom] ||= {}
      catalog[body][style][zoom][col.to_i] ||= 0

      catalog[body][style][zoom][col.to_i] = catalog[body][style][zoom][col.to_i] + 1
    end
  end
end

catalog.each do | body, cat_body |
  expected_styles = 3
  actual_styles = cat_body.size
  if (actual_styles != expected_styles)
    puts "#{body}: expected #{expected_styles} styles, found #{actual_styles}"
  end

  cat_body.each do | style, cat_style |
    expected_zooms = 8
    actual_zooms = cat_style.size
    if (actual_zooms != expected_zooms)
      puts "#{body}/#{style}: expected #{expected_zooms} zoom levels, found #{actual_zooms}"
    end

    cat_style.each do | zoom, cat_zoom |
      expected_rows = 2 ** zoom.to_i
      expected_columns = expected_rows * 2
      actual_columns = cat_zoom.size
      if (actual_columns != expected_columns)
        puts "#{body}/#{style}/#{zoom}: expected #{expected_columns} columns, found #{actual_columns}"
      end

      cat_zoom.each do | col, row_count |
        actual_rows = row_count
        if (actual_rows != expected_rows)
          puts "#{body}/#{style}/#{zoom}/#{col}: expected #{expected_rows} rows, found #{actual_rows}"
        end
      end
    end
  end
end
