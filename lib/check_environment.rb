require 'fileutils'

class Main
  FILE_SEPARATOR = java.lang.System.getProperty "file.separator"
  CODERDOJO_DIR = '~/.coderdojo'

  def run
    prompt_for_user_name
    check_java
    check_bukkit
    check_sublime
    generate_hash
  end

  private
  def prompt_for_user_name
    name = prompt_user_name "Hello! Please enter your Minecraft user name: "
    if name.empty?
      name = prompt_user_name "Common you need to do better than that! Try entering your Minecraft user name again: "
    end
    raise "Failed to provide a valid Minecraft user name.  Please try again!" if name.empty?
    puts "Awesome!  Thanks #{name}"
  end

  def prompt_user_name request_msg
    print request_msg
    user_input = gets
    user_input.strip
  end

  def check_java
    raise "Need to install javac #{java_version}" unless javac?
    raise "Your java version and javac version do not match. [java = #{java_version} and javac = #{javac_version}]" unless java_versions_match?
  end

  def javac?
    !javac_version.nil? && !javac_version.empty?
  end

  def java_versions_match?
    java_version == javac_version
  end

  def java_version
    %x[java -version 2>&1 | head -1 | awk -F '"' '{print $2}'].strip
  end

  def javac_version
    %x[javac -version 2>&1 | awk -F ' ' '{print $2}'].strip
  end

  def check_bukkit
 #   if File.exists? "#{CODERDOJO_DIR}#{FILE_SEPARATOR}craftbukkit.jar"
 #     puts "yea buddy!"
 #   else
 #     FileUtils.mkdir "server"
 #     raise "Download latest version of Craftbukkit.jar from http://dl.bukkit.org/latest-rb/craftbukkit.jar and put into the ~/.coderdojo/server directory"
 #   end
  end

  def check_sublime
  end

  def generate_hash
    puts "hash output goes here!"
  end
end
Main.new.run

#utils
#puts "environment: #{java.lang.System.getenv}"
#puts "properties: #{java.lang.System.properties}"
