api = 2
core = 7.x

; Drush make allows a default sub directory for all contributed projects.
defaults[projects][subdir] = contrib

projects[admin_menu][version] = "3.x"
projects[devel][version] = "1.x"
projects[views][version] = "3.x"
projects[ctools][version] = "1.5"
projects[jquery_update][version] = "2.4"
projects[views_bootstrap][version] = "3.x"
projects[composer_manager][version] = "1.8"

projects[views_megarow][version] = "1.x"
projects[views_megarow][patch][] = "patches/views_megarow_nonentities.patch"

projects[advancedqueue][version] = "1.x"
projects[advancedqueue][download][type] = "git"
projects[advancedqueue][download][branch] = "7.x-1.x"
projects[advancedqueue][download][url] = "http://git.drupal.org/project/advancedqueue.git"
projects[advancedqueue][download][working-copy] = TRUE

projects[api_source][version] = "7.x-1.x"
projects[api_source][download][type] = "git"
projects[api_source][download][branch] = "7.x-1.x"
projects[api_source][download][url] = "https://github.com/Kazanir/api_source.git"
projects[api_source][download][working-copy] = "TRUE"

projects[grammar_parser_lib][download][branch] = "7.x-2.x"
projects[grammar_parser_lib][download][type] = "git"
projects[grammar_parser_lib][download][url] = "http://git.drupal.org/project/grammar_parser_lib.git"

projects[api][version] = "2.x"
projects[api][download][url] = "http://git.drupal.org/project/api.git"
projects[api][download][branch] = "7.x-2.x"
projects[api][download][type] = "git"

libraries[grammar_parser][download][type] = "file"
libraries[grammar_parser][download][url] = "http://ftp.drupal.org/files/projects/grammar_parser-7.x-2.x-dev.tar.gz"



