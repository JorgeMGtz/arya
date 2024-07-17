#!/usr/bin/env ruby
require 'json'
require_relative 'stylesheet_compiler'

base_dir = File.join(File.dirname(__FILE__), "..")

styles_dir = File.join(base_dir, "scss")
styles_path = File.join(styles_dir, "index.scss")
styles = File.read(styles_path)

manifest = File.read(File.join(base_dir, "manifest.json"))
manifest = JSON.parse(manifest)

assets = Dir.glob(File.join(base_dir, 'assets', '*.*'))
asset_variables = assets.map { |asset| File.join('assets', File.basename(asset)).gsub(/[^a-z0-9\-_]+/, '-') }
scss_variables = manifest["settings"].flat_map { |setting_group| setting_group["variables"] }.map { |variable| variable["identifier"] }
scss_variables.concat(asset_variables)

compiler = StylesheetCompiler.new([styles_dir], scss_variables)
result = compiler.compile(styles)
result_path = File.join(base_dir, "style.css")
File.open(result_path, 'w+') {|f| f.write(result) }

puts "Created /style.css file"