#!/bin/sh
if [ "$1" = "" ]
then
  echo "Usage: $0 NewPluginName"
  exit 1
fi

PLUGIN_NAME=`echo $* | sed 's/[ ]*//g'`
LC_PLUGIN_NAME=`echo $PLUGIN_NAME | tr [A-Z] [a-z]`

mkdir $PLUGIN_NAME
mkdir $PLUGIN_NAME/src
mkdir $PLUGIN_NAME/bin
mkdir $PLUGIN_NAME/dist

cat > $PLUGIN_NAME/build.sh <<EOF
#!/bin/sh

SERVER=\$HOME/minecraft-plugins/server

# Make the build directories if they aren't there.
# Throw away any error if they are.
mkdir bin 2>/dev/null
mkdir dist 2>/dev/null

# Remove any previous build products
rm -f bin/*/*.class
rm -f dist/*.jar

# Get the name of this plugin
# from the directory it's in
HERE=\`pwd\`
NAME=\`basename \$HERE\`

# 1. Compile
echo "Compiling with javac..."
javac src/*.java -d bin -classpath \$SERVER/craftbukkit.jar -sourcepath src -target 1.6 -g:lines,vars,source -source 1.6 || exit 1

# 2. Build the jar
echo "Creating jar file..."
jar -cf dist/\$NAME.jar *.yml -C bin . || exit 1

# 3. Copy to server
echo "Deploying jar to \$SERVER/plugins..."

test ! -d "\$SERVER/plugins" && mkdir -p "\$SERVER/plugins"

cp dist/\$NAME.jar \$SERVER/plugins || exit 1

echo "Completed Successfully."
EOF

chmod +x $PLUGIN_NAME/build.sh

cat > $PLUGIN_NAME/src/$PLUGIN_NAME.java <<EOF
package $LC_PLUGIN_NAME;

import java.util.logging.Logger;
import org.bukkit.command.Command;
import org.bukkit.command.CommandSender;
import org.bukkit.entity.Player;
import org.bukkit.plugin.Plugin;
import org.bukkit.plugin.java.JavaPlugin;

public class $PLUGIN_NAME extends JavaPlugin {
  public static Logger log = Logger.getLogger("Minecraft");
  public void onEnable() {
    log.info("[$PLUGIN_NAME] Start up.");
  }
  public void onReload() {
    log.info("[$PLUGIN_NAME] Server reloaded.");
  }
  public void onDisable() {
    log.info("[$PLUGIN_NAME] Server stopping.");
  }

  public boolean onCommand(CommandSender sender, Command command,
                           String commandLabel, String[] args) {
    if (commandLabel.equalsIgnoreCase("$LC_PLUGIN_NAME")) {
      if (sender instanceof Player) {
        Player me = (Player)sender;
        // Put your code after this line:

        // ...and finish your code before this line.
        return true;
      }
    }
    return false;
  }
}
EOF

cat > $PLUGIN_NAME/plugin.yml <<EOF
name: $PLUGIN_NAME

author: yourname

main: $LC_PLUGIN_NAME.$PLUGIN_NAME

commands:
    $LC_PLUGIN_NAME:
        description: Your description goes here
    ${LC_PLUGIN_NAME}_admin:
        description: Your description goes here

version: 0.1

EOF
