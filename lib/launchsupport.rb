require "launchsupport/version"

module Kernel

  def on_launching file, param={}, &b
    LaunchSupport::launching_my_file_process(file, param, &b) if $0 == file
  end

  def not_on_launching file, param={}, &b
    LaunchSupport::launching_my_file_process(file, param, &b) unless $0 == file
  end

end

module LaunchSupport

  def self.launching_my_file_process file, param={}
    unless param.empty?
      paths = param[:load]
      paths = [paths] if paths.is_a? String
      param[:project] ||= file.split("/")[file.split("/").rindex{|x|paths.include?(x)}-1]
      parts = "/#{param[:project]}/"
      paths.each do |path|
        $:.unshift file[0,file.index(parts)+parts.size-1]+"/#{path}"
      end
      [param[:require]].flatten.each{|r|require r} if param[:require]
    end
    yield if block_given?
  end

end
